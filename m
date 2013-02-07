Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:37016 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab3BGPUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 10:20:23 -0500
Received: by mail-qc0-f171.google.com with SMTP id d1so1008682qca.2
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 07:20:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302071608.15848.hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
	<CAGoCfizYMTrfExhT4oeevmhUuysG6MY_CUNkzL7mY51Xjz51LQ@mail.gmail.com>
	<201302071608.15848.hverkuil@xs4all.nl>
Date: Thu, 7 Feb 2013 10:20:21 -0500
Message-ID: <CAGoCfizSDWU2Rxn8m=1Teyw3VZ8_hMt8hm9rz+p8owa+MLzegQ@mail.gmail.com>
Subject: Re: [RFCv1 PATCH 00/20] cx231xx: v4l2-compliance fixes
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Feb 7, 2013 at 10:08 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tue January 29 2013 17:41:29 Devin Heitmueller wrote:
>> On Tue, Jan 29, 2013 at 11:32 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > I will take a closer look at the vbi support, though.. It would be nice to get
>> > that working.
>>
>> FYI:  I had the VBI support working when I submitted the driver
>> upstream (at least for NTSC CC).  If it doesn't work, then somebody
>> broke it.
>
> OK, I did some more tests and it turned out to be related to the no_alt_vanc
> setting in the board definitions. If it is 1, then usb_set_interface() is
> never called and the endpoint is never created.
>
> It's unclear to me if this means that if no_alt_vanc is set, then the vbi node
> should be disabled. It seems that way.
>
> Unfortunately, of the three cx231xx devices I have no_alt_vanc is set on two
> and the third (Hauppauge EXETER) is the one where the tda18271 tuner has
> issues: it always gets errors when writing to it. It used to load correctly
> about 10% of the time in the past, but now I can't get it to work at all.
>
> Devin, I think you said once that you knew what is going on. Do you have
> any code that I can try to make it work again?

The following will cause the tuner to initialize properly.
Unfortunately it's only half a fix because it results in the digital
demod driving the AGC, which will conflict the AGC being driven by the
Polaris when in analog mode.

Still, it should be enough to allow you to play with the VBI support
assuming you test with the baseband inputs.

Devin

--- cx231xx-avcore.c.orig	2013-01-17 11:47:40.000000000 -0500
+++ cx231xx-avcore.c	2013-01-24 09:02:25.833076332 -0500
@@ -2207,6 +2207,7 @@
 	u8 value[4] = { 0, 0, 0, 0 };
 	u32 tmp = 0;
 	int status = 0;
+	int demod_reset_high = 0;

 	if (dev->power_mode != mode)
 		dev->power_mode = mode;
@@ -2406,9 +2407,25 @@

 	msleep(PWR_SLEEP_INTERVAL);

+	/* For Hauppauge devices based on the ldgt3305, the 3305 will hold SDA
+	   low from powerup until 10ms after the device is brought out of reset.
+	   As a result, we need to *always* bring the device out of reset if
+	   PWR_TUNER_EN is enabled (since we have a shared power plane for both
+	   the tuner and demod).  If you fail to bring the chip out of reset
+	   *and* wait 10ms, the i2c bus will get jammed.  This is a vendor
+	   documented limitation of the lgdt3305 demodulator */
+	if ((tmp & PWR_TUNER_EN) &&
+	    (dev->model == CX231XX_BOARD_HAUPPAUGE_EXETER)) {
+		demod_reset_high = 1;
+	}
+
 	/* For power saving, only enable Pwr_resetout_n
 	   when digital TV is selected. */
 	if (mode == POLARIS_AVMODE_DIGITAL) {
+		demod_reset_high = 1;
+	}
+
+	if (demod_reset_high) {
 		tmp |= PWR_RESETOUT_EN;
 		value[0] = (u8) tmp;
 		value[1] = (u8) (tmp >> 8);




-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
