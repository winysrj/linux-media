Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab2APC5W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 21:57:22 -0500
Message-ID: <4F139205.8000303@redhat.com>
Date: Mon, 16 Jan 2012 00:57:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] DVBv5 tools version 0.0.1
References: <4F08385E.7050602@redhat.com> <4F0CAF53.3090802@iki.fi> <4F0CB512.7010501@redhat.com> <4F131CD8.2060602@iki.fi> <4F13312B.8060005@iki.fi> <4F13404D.2020001@redhat.com> <4F13495E.8030106@iki.fi> <4F136C5E.6020806@redhat.com>
In-Reply-To: <4F136C5E.6020806@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-01-2012 22:16, Mauro Carvalho Chehab escreveu:
> Em 15-01-2012 19:47, Antti Palosaari escreveu:
>> On 01/15/2012 11:08 PM, Mauro Carvalho Chehab wrote:
>>> There was a bug at the error code handling on dvb-fe-tool: basically, if it can't open
>>> a device, it were using a NULL pointer. It was likely fixed by this commit:
>>>
>>> http://git.linuxtv.org/v4l-utils.git/commit/1f669eed5433d17df4d8fb1fa43d2886f99d3991
>>
>> That bug was fixed as I tested.
>>
>> But could you tell why dvb-fe-tool --set-delsys=DVBC/ANNEX_A calls get_frontent() ?
> 
> That's what happens here, at the application level:
> 
> $ strace dvb-fe-tool -d DVBC/ANNEX_A
> 
> open("/dev/dvb/adapter0/frontend0", O_RDWR) = 3
> ioctl(3, FE_GET_INFO, 0xb070c4)         = 0
> fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 2), ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f37922be000
> write(1, "Device DRXK DVB-C DVB-T (/dev/dv"..., 68Device DRXK DVB-C DVB-T (/dev/dvb/adapter0/frontend0) capabilities:
> ) = 68
> write(1, "\tCAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC"..., 245	CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_32 CAN_QAM_64 CAN_QAM_128 CAN_QAM_256 CAN_RECOVER CAN_TRANSMISSION_MODE_AUTO 
> ) = 245
> ioctl(3, FE_GET_PROPERTY, 0x7fff326ce310) = 0
> write(1, "DVB API Version 5.5, Current v5 "..., 54DVB API Version 5.5, Current v5 delivery system: DVBT
> ) = 54
> ioctl(3, FE_GET_PROPERTY, 0x7fff326ce310) = 0
> write(1, "Supported delivery systems: DVBC"..., 62Supported delivery systems: DVBC/ANNEX_A DVBC/ANNEX_C [DVBT] 
> ) = 62
> write(1, "Changing delivery system to: DVB"..., 42Changing delivery system to: DVBC/ANNEX_A
> ) = 42
> ioctl(3, FE_SET_PROPERTY, 0x7fff326ce340) = 0
> close(3)                                = 0
> exit_group(0)                           = ?
> 
> 
> The first FE_GET_PROPERTY reads the DVB API version and the current delivery
> system:
> 
> 	parms->dvb_prop[0].cmd = DTV_API_VERSION;
> 	parms->dvb_prop[1].cmd = DTV_DELIVERY_SYSTEM;
> 
> 	dtv_prop.num = 2;
> 	dtv_prop.props = parms->dvb_prop;
> 
> 	/* Detect a DVBv3 device */
> 	if (ioctl(fd, FE_GET_PROPERTY, &dtv_prop) == -1) {
> 		parms->dvb_prop[0].u.data = 0x300;
> 		parms->dvb_prop[1].u.data = SYS_UNDEFINED;
> 	}
> 	parms->version = parms->dvb_prop[0].u.data;
> 	parms->current_sys = parms->dvb_prop[1].u.data;
> 
> The second FE_GET_PROPERTY is used only if DVB API v5.5 or upper is detected,
> and does:
> 
> 		parms->dvb_prop[0].cmd = DTV_ENUM_DELSYS;
> 		parms->n_props = 1;
> 		dtv_prop.num = 1;
> 		dtv_prop.props = parms->dvb_prop;
> 		if (ioctl(fd, FE_GET_PROPERTY, &dtv_prop) == -1) {
> 			perror("FE_GET_PROPERTY");
> 			dvb_v5_free(parms);
> 			close(fd);
> 			return NULL;
> 		}
> 
> Both were called inside dvb_fe_open().
> 
> The FE_SET_PROPERTY changes the property inside the DVBv5 cache,
> at dvb_set_sys():
> 
> 		dvb_prop[0].cmd = DTV_DELIVERY_SYSTEM;
> 		dvb_prop[0].u.data = sys;
> 		prop.num = 1;
> 		prop.props = dvb_prop;
> 
> 		if (ioctl(parms->fd, FE_SET_PROPERTY, &prop) == -1) {
> 			perror("Set delivery system");
> 			return errno;
> 		}
> 
> The FE_SET_PROPERTY doesn't call a DTV_TUNE, so it shouldn't be calling the
> set frontend methods inside the driver.
> 
> So, from the userspace applications standpoint, I'm not seeing anything wrong.
> 
>> That will cause this kind of calls in demod driver:
>> init()
>> get_frontend()
>> get_frontend()
>> sleep()
>>
>> My guess is that it resolves current delivery system. But as demod is usually sleeping (not tuned) at that phase it does not know frontend settings asked, like modulation etc. In case of cxd2820r those are available after set_frontend() call. I think I will add check and return -EINVAL in that case.
> 
> 
> What seems to be happening at dvb-core/dvb_frontend.h is due to this code:
> 
> if(cmd == FE_GET_PROPERTY) {
> ...
>                 /*
>                  * Fills the cache out struct with the cache contents, plus
>                  * the data retrieved from get_frontend.
>                  */
>                 dtv_get_frontend(fe, NULL);
>                 for (i = 0; i < tvps->num; i++) {
>                         err = dtv_property_process_get(fe, c, tvp + i, file);
>                         if (err < 0)
>                                 goto out;
>                         (tvp + i)->result = err;
>                 }
> 
> E. g. even if the FE_GET_PROPERTY is only reading the DVB version and calling
> DTV_ENUM_DELSYS, it is calling the dtv_get_frontend() to retrieve more data.
> 
> What it can be done is to do something like:
> 
> static bool need_get_frontend()
> {
> ...
> 	for (i = 0; i < tvps->num; i++)
> ...
> }
> 
> 		if (need_get_frontend(tvps))
> 	                dtv_get_frontend(fe, NULL);
>                 for (i = 0; i < tvps->num; i++) {
>                         err = dtv_property_process_get(fe, c, tvp + i, file);
>                         if (err < 0)
>                                 goto out;
>                         (tvp + i)->result = err;
>                 }
> 
> And add some logic inside need_get_frontend() to return false if the
> FE_GET_PROPERTY only wants static info, like DTV_ENUM_DELSYS, DTV_VERSION
> and DTV_DELIVERY_SYSTEM.

The enclosed patch should do the trick

-
[PATCH RFC] Don't call get_frontend() if not needed

If the frontend is in idle state, or a FE_GET_PROPERTY is called
for reading the enumsys, api version or delivery system, don't
call the frontend, as it is not needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

PS.: There's one extra printk here for test purposes. Of course, this should
be removed at the final version.

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index f5fa7aa..3c80c92 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1234,6 +1234,8 @@ static int dtv_get_frontend(struct dvb_frontend *fe,
 {
 	int r;
 
+printk("%s()\n", __func__);
+
 	if (fe->ops.get_frontend) {
 		r = fe->ops.get_frontend(fe);
 		if (unlikely(r < 0))
@@ -1739,12 +1741,35 @@ static int dvb_frontend_ioctl(struct file *file,
 	return err;
 }
 
+static bool need_get_frontend_call(struct dtv_properties *tvps,
+				   struct dtv_property *tvp)
+{
+	int i;
+
+	/*
+	 * If the DTV command is just informational or cache read,
+	 * don't bother to call the frontend to handle.
+	 */
+	for (i = 0; i < tvps->num; i++) {
+		switch(tvp->cmd) {
+		case DTV_ENUM_DELSYS:
+	        case DTV_DELIVERY_SYSTEM:
+		case DTV_API_VERSION:
+			break;
+		default:
+			return true;
+		}
+	}
+	return false;
+}
+
 static int dvb_frontend_ioctl_properties(struct file *file,
 			unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err = 0;
 
 	struct dtv_properties *tvps = NULL;
@@ -1812,7 +1837,8 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		 * Fills the cache out struct with the cache contents, plus
 		 * the data retrieved from get_frontend.
 		 */
-		dtv_get_frontend(fe, NULL);
+		if (need_get_frontend_call(tvps, tvp) && fepriv->state != FESTATE_IDLE)
+			dtv_get_frontend(fe, NULL);
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_get(fe, c, tvp + i, file);
 			if (err < 0)
