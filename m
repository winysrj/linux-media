Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:37900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab1ELBg7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 21:36:59 -0400
Message-ID: <4DCB39AF.2000807@redhat.com>
Date: Thu, 12 May 2011 03:36:47 +0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Anssi Hannula <anssi.hannula@iki.fi>
CC: Peter Hutterer <peter.hutterer@who-t.net>,
	linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: Re: IR remote control autorepeat / evdev
References: <4DC61E28.4090301@iki.fi> <20110510041107.GA32552@barra.redhat.com> <4DC8C9B6.5000501@iki.fi> <20110510053038.GA5808@barra.redhat.com> <4DC940E5.2070902@iki.fi> <4DCA1496.20304@redhat.com> <4DCABA42.30505@iki.fi> <4DCABEAE.4080607@redhat.com> <4DCACE74.6050601@iki.fi> <4DCB213A.8040306@redhat.com> <4DCB2BD9.6090105@iki.fi> <4DCB336B.2090303@redhat.com>
In-Reply-To: <4DCB336B.2090303@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 12-05-2011 03:10, Mauro Carvalho Chehab escreveu:
> Em 12-05-2011 02:37, Anssi Hannula escreveu:

>> I don't see any other places:
>> $ git grep 'REP_PERIOD' .
>> dvb/dvb-usb/dvb-usb-remote.c:   input_dev->rep[REP_PERIOD] =
>> d->props.rc.legacy.rc_interval;
> 
> Indeed, the REP_PERIOD is not adjusted on other drivers. I agree that we
> should change it to something like 125ms, for example, as 33ms is too 
> short, as it takes up to 114ms for a repeat event to arrive.
> 
IMO, the enclosed patch should do a better job with repeat events, without
needing to change rc-core/input/event logic.

-

Subject: Use a more consistent value for RC repeat period
From: Mauro Carvalho Chehab <mchehab@redhat.com>

The default REP_PERIOD is 33 ms. This doesn't make sense for IR's,
as, in general, an IR repeat scancode is provided at every 110/115ms,
depending on the RC protocol. So, increase its default, to do a
better job avoiding ghost repeat events.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f53f9c6..ee67169 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1044,6 +1044,13 @@ int rc_register_device(struct rc_dev *dev)
 	 */
 	dev->input_dev->rep[REP_DELAY] = 500;
 
+	/*
+	 * As a repeat event on protocols like RC-5 and NEC take as long as
+	 * 110/114ms, using 33ms as a repeat period is not the right thing
+	 * to do.
+	 */
+	dev->input_dev->rep[REP_PERIOD] = 125;
+
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	printk(KERN_INFO "%s: %s as %s\n",
 		dev_name(&dev->dev),
