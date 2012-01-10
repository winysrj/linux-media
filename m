Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab2AJWBF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 17:01:05 -0500
Message-ID: <4F0CB512.7010501@redhat.com>
Date: Tue, 10 Jan 2012 20:00:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] DVBv5 tools version 0.0.1
References: <4F08385E.7050602@redhat.com> <4F0CAF53.3090802@iki.fi>
In-Reply-To: <4F0CAF53.3090802@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10-01-2012 19:36, Antti Palosaari wrote:
> Behaviour of new FE is strange for my eyes. Could you look and explain if it is intentional?
> 
> [crope@localhost dvb]$ ./dvb-fe-tool
> Device Sony CXD2820R (DVB-T/T2) (/dev/dvb/adapter0/frontend0) capabilities:
>     CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_64 CAN_QAM_256 CAN_QAM_AUTO CAN_QPSK CAN_TRANSMISSION_MODE_AUTO
> DVB API Version 5.5, Current v5 delivery system: DVBT
> Supported delivery systems: [DVBT] DVBT2 DVBC/ANNEX_A
> [crope@localhost dvb]$ czap "MTV3 "
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/home/crope/.czap/channels.conf'
>  11 MTV3 :330000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_128:305:561:3
>  11 MTV3 : f 330000000, s 6875000, i 2, fec 0, qam 4, v 0x131, a 0x231, s 0x3
> ERROR: frontend device is not a QAM (DVB-C) device

The selected delivery system is DVB-T. As czap doesn't have any code to
force it to DVB-C, this is expected.

Basically, czap needs a patch like this one:
	http://linuxtv.org/hg/dvb-apps/rev/0c9932885287

(I've made the patch for scan just as an example, but I'll hardly have 
enough time to fix it everything inside dvb-apps)

> [crope@localhost dvb]$ ./dvb-fe-tool --set-delsys=DVBC/ANNEX_A
> Device Sony CXD2820R (DVB-T/T2) (/dev/dvb/adapter0/frontend0) capabilities:
>     CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_64 CAN_QAM_256 CAN_QAM_AUTO CAN_QPSK CAN_TRANSMISSION_MODE_AUTO
> DVB API Version 5.5, Current v5 delivery system: DVBT
> Supported delivery systems: [DVBT] DVBT2 DVBC/ANNEX_A
> Changing delivery system to: DVBC/ANNEX_A
> [crope@localhost dvb]$ ./dvb-fe-tool
> Device Sony CXD2820R (DVB-T/T2) (/dev/dvb/adapter0/frontend0) capabilities:
>     CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_64 CAN_QAM_256 CAN_QAM_AUTO CAN_QPSK CAN_TRANSMISSION_MODE_AUTO
> DVB API Version 5.5, Current v5 delivery system: DVBC/ANNEX_A
> Supported delivery systems: DVBT DVBT2 [DVBC/ANNEX_A]
> [crope@localhost dvb]$ czap "MTV3 "
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/home/crope/.czap/channels.conf'
>  11 MTV3 :330000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_128:305:561:3
>  11 MTV3 : f 330000000, s 6875000, i 2, fec 0, qam 4, v 0x131, a 0x231, s 0x3
> status 00 | signal ffff | snr 00c6 | ber 00000000 | unc 00000000 |

Ok, it worked.

> [crope@localhost dvb]$ ./dvb-fe-tool
> Device Sony CXD2820R (DVB-T/T2) (/dev/dvb/adapter0/frontend0) capabilities:
>     CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_64 CAN_QAM_256 CAN_QAM_AUTO CAN_QPSK CAN_TRANSMISSION_MODE_AUTO
> DVB API Version 5.5, Current v5 delivery system: DVBT
> Supported delivery systems: [DVBT] DVBT2 DVBC/ANNEX_A

That's weird. The dvb_frontend_clear_cache() returns the delivery
system to its original state.

The enclosed patch will likely fix this issue.

-
[PATCH] don't reset the delivery system on DTV_CLEAR

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index a904793..4ff4b43 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -909,7 +909,6 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 
 	c->state = DTV_CLEAR;
 
-	c->delivery_system = fe->ops.delsys[0];
 	dprintk("%s() Clearing cache for delivery system %d\n", __func__,
 		c->delivery_system);
 
@@ -2377,6 +2376,8 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 	 * Initialize the cache to the proper values according with the
 	 * first supported delivery system (ops->delsys[0])
 	 */
+
+	c->delivery_system = fe->ops.delsys[0];
 	dvb_frontend_clear_cache(fe);
 
 	mutex_unlock(&frontend_mutex);

