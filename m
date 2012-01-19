Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab2ASLeG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 06:34:06 -0500
Message-ID: <4F17FFA3.4040103@redhat.com>
Date: Thu, 19 Jan 2012 09:33:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: DVBv5 test report
References: <4F17422E.1030408@iki.fi>
In-Reply-To: <4F17422E.1030408@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-01-2012 20:05, Antti Palosaari escreveu:
> I tested almost all DVB-T/T2/C devices I have and all seems to be working, excluding Anysee models when using legacy zap.
> 
> Anysee  anysee_streaming_ctrl() will fail because mutex_lock_interruptible() returns -EINTR in anysee_ctrl_msg() function when zap is killed using ctrl+c. This will led error returned to DVB-USB-core and log writing "dvb-usb: error while stopping stream."
> 
> http://git.linuxtv.org/media_tree.git/blob/refs/heads/master:/drivers/media/dvb/dvb-usb/anysee.c
> 
> http://git.linuxtv.org/media_tree.git/blob/refs/heads/master:/drivers/media/dvb/dvb-usb/dvb-usb-urb.c
> 
> If I change mutex_lock_interruptible() => mutex_lock() it will work. I think it gets SIGINT (ctrl+c) from userland, but how this haven't been issue earlier?
> 
> Anyone have idea what's wrong/reason here?

No idea. That part of the code wasn't changed recently, AFAIK, and
for sure it weren't affected by the frontend changes.

I suspect that the bug was already there, but it weren't noticed
before.

The fix seems to be as simple as:

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
index ddf282f..6e707b5 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
@@ -32,7 +32,8 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
 		if (adap->props.fe[adap->active_fe].streaming_ctrl != NULL) {
 			ret = adap->props.fe[adap->active_fe].streaming_ctrl(adap, 0);
 			if (ret < 0) {
-				err("error while stopping stream.");
+				if (ret != -EAGAIN)
+					err("error while stopping stream.");
 				return ret;
 			}
 		}

And make sure to remap -EINTR as -EAGAIN, leaving to the
userspace to retry it. Alternatively, the dvb frontend core 
or the anysee could retry it after a while for streaming
stop.

Another alternative that would likely work better would
be to just use mutex_lock() for streaming stop, but this
would require the review of all implementations for
streaming_ctrl

> 
> 
> here are tested drivers, working fine:
> dvb_usb_ec168,ec100,mxl5005s
> dvb_usb_au6610,zl10353,qt101
> dvb_usb_af9015,af9013,tda18218
> dvb_usb_af9015,af9013,tda18218
> dvb_usb_af9015,af9013,qt1010
> dvb_usb_af9015,af9013,mxl5005s
> dvb_usb_af9015,af9013,mxl5007t
> dvb_usb_gl861,zl10353,qt1010
> dvb_usb_ce6230,zl10353,mxl5005s
> em28xx_dvb,tda10023,tuner_simple
> dvb_ttusb_budget,stv0297
> dvb_usb_mxl111sf
> em28xx_dvb,cxd2820r,tda18271

Thanks for testing it!

Regards,
Mauro.
> 
> 
> Antti

