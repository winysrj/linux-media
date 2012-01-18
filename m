Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397Ab2ARNkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 08:40:15 -0500
Message-ID: <4F16CBB9.7030801@redhat.com>
Date: Wed, 18 Jan 2012 11:40:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [RFC] dib8000: return an error if the TMCC is not locked
References: <1326825928-29894-1-git-send-email-mchehab@redhat.com> <201201181349.57722.pboettcher@kernellabs.com>
In-Reply-To: <201201181349.57722.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-01-2012 10:49, Patrick Boettcher escreveu:
> On Tuesday 17 January 2012 19:45:28 you wrote:
>> On ISDB-T, a few carriers are reserved for TMCC decoding
>> (1 to 20 carriers, depending on the mode). Those carriers
>> use the DBPSK modulation, and contain the information about
>> each of the three layers of carriers (modulation, partial
>> reception, inner code, interleaving, and number of segments).
>>
>> If the TMCC carrier was not locked and decoded, no information
>> would be provided by get_frontend(). So, instead of returning
>> false values, return -EAGAIN.
>>
>> Another alternative for this patch would be to add a flag to
>> fe_status (FE_HAS_GET_FRONTEND?), to indicate that the ISDB-T
>> TMCC carriers (and DVB-T TPS?), required for get_frontend
>> to work, are locked.
>>
>> Comments?
> 
> I think it changes the behaviour of get_frontend too much and in fact 
> transmission parameter signaling (TPS for DVB-T, TMCC for ISDB-T) locks 
> are already or should be if not integrated to the status locks.
> 
> Also those parameters can change over time and signal a 
> "reconfiguration" of the transmission.
> 
> So, for me I would vote against this kind of implementation in favor a 
> better one. Unfortunately I don't have a much better idea at hand right 
> now.

The current status are:

typedef enum fe_status {
        FE_HAS_SIGNAL   = 0x01,   /* found something above the noise level */
        FE_HAS_CARRIER  = 0x02,   /* found a DVB signal  */
        FE_HAS_VITERBI  = 0x04,   /* FEC is stable  */
        FE_HAS_SYNC     = 0x08,   /* found sync bytes  */
        FE_HAS_LOCK     = 0x10,   /* everything's working... */
        FE_TIMEDOUT     = 0x20,   /* no lock within the last ~2 seconds */
        FE_REINIT	= 0x40    /* frontend was reinitialized,  */
} fe_status_t;                    /* application is recommended to reset */

There are a few options that can be done:

1) only rise FE_HAS_LOCK if TPS/TMCC demod were locked. The "description"
for FE_HAS_LOCK ("everything's working") seems to indicate that TMCC
lock/TPS lock is also part of "everything".

2) create a new status for it.

In any case, I'm in favor of explicitly telling about that at the specs.

It seems that the dynamic reconfiguration, if detected by the frontend,
could be indicated via FE_REINIT. This is not clear, as no driver uses
this flag (btw, FE_TIMEDOUT is barely used - only 4 drivers use it).

I'm not sure if it is a frontend's task to monitor the TMCC 
Indicator of transmission-parameter switching, in order to warn the
userspace that a transmission reconfiguration will happen (via FE_REINIT?),
or if some userspace-driven mechanism for that is needed.

With regards to dvb-core get_frontend() call, it only makes sense if
the TPS/TMCC is locked. So, I think that such call needs to be limited
to happen only when the lock were archived, like the enclosed patch.

-

[PATCH] dvb: only calls get_frontend() if the frontend is locked

While the device is not locked, calling get_frontend() shouldn't
return anything useful, as there are not locks there yet. So,
the frontend wouldn't return anything useful. Also, on most cases,
it will generate uneeded hardware register access, in general
via slow I2C transfers, in order to read the register contents of
the previous state.

Instead of doing that, the DVB frontend thread keeps the status
of the frontend lock, and knows when the frontend is locked. So,
relies on that, in order to allow calling the frontend's logic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index fbbe545..548aace 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -144,11 +144,6 @@ static void dvb_frontend_wakeup(struct dvb_frontend *fe);
 static int dtv_get_frontend(struct dvb_frontend *fe,
 			    struct dvb_frontend_parameters *p_out);
 
-static bool has_get_frontend(struct dvb_frontend *fe)
-{
-	return fe->ops.get_frontend;
-}
-
 /*
  * Due to DVBv3 API calls, a delivery system should be mapped into one of
  * the 4 DVBv3 delivery systems (FE_QPSK, FE_QAM, FE_OFDM or FE_ATSC),
@@ -207,8 +202,8 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 
 	dprintk ("%s\n", __func__);
 
-	if ((status & FE_HAS_LOCK) && has_get_frontend(fe))
-		dtv_get_frontend(fe, &fepriv->parameters_out);
+	fepriv->status = status;
+	dtv_get_frontend(fe, &fepriv->parameters_out);
 
 	mutex_lock(&events->mtx);
 
@@ -465,7 +460,6 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 			fe->ops.read_status(fe, &s);
 		if (s != fepriv->status) {
 			dvb_frontend_add_event(fe, s);
-			fepriv->status = s;
 		}
 	}
 
@@ -663,7 +657,6 @@ restart:
 				if (s != fepriv->status && !(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT)) {
 					dprintk("%s: state changed, adding current state\n", __func__);
 					dvb_frontend_add_event(fe, s);
-					fepriv->status = s;
 				}
 				break;
 			case DVBFE_ALGO_SW:
@@ -698,7 +691,6 @@ restart:
 				fe->ops.read_status(fe, &s);
 				if (s != fepriv->status) {
 					dvb_frontend_add_event(fe, s); /* update event list */
-					fepriv->status = s;
 					if (!(s & FE_HAS_LOCK)) {
 						fepriv->delay = HZ / 10;
 						fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
@@ -1213,18 +1205,26 @@ static int dtv_property_legacy_params_sync(struct dvb_frontend *fe,
 static int dtv_get_frontend(struct dvb_frontend *fe,
 			    struct dvb_frontend_parameters *p_out)
 {
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int r;
 
-	if (fe->ops.get_frontend) {
-		r = fe->ops.get_frontend(fe);
-		if (unlikely(r < 0))
-			return r;
-		if (p_out)
-			dtv_property_legacy_params_sync(fe, p_out);
-		return 0;
+	/*
+	 * If the frontend is not locked, the transmission information
+	 * is not available. So, there's no sense on calling the frontend
+	 * to get anything, as all it has is what is already inside the
+	 * cache.
+	 */
+	if (fepriv->status & FE_HAS_LOCK) {
+		if (fe->ops.get_frontend) {
+			r = fe->ops.get_frontend(fe);
+			if (unlikely(r < 0))
+				return r;
+		}
 	}
+	if (p_out)
+		dtv_property_legacy_params_sync(fe, p_out);
 
-	/* As everything is in cache, get_frontend fops are always supported */
+	/* As everything is in cache, get_frontend is always supported */
 	return 0;
 }
 
@@ -1725,7 +1725,6 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int err = 0;
 
@@ -1795,11 +1794,9 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		 * the data retrieved from get_frontend, if the frontend
 		 * is not idle. Otherwise, returns the cached content
 		 */
-		if (fepriv->state != FESTATE_IDLE) {
-			err = dtv_get_frontend(fe, NULL);
-			if (err < 0)
-				goto out;
-		}
+		err = dtv_get_frontend(fe, NULL);
+		if (err < 0)
+			goto out;
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_get(fe, c, tvp + i, file);
 			if (err < 0)
@@ -1922,7 +1919,6 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 	dvb_frontend_clear_events(fe);
 	dvb_frontend_add_event(fe, 0);
 	dvb_frontend_wakeup(fe);
-	fepriv->status = 0;
 
 	return 0;
 }

