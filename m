Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:35939 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab0BJDJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 22:09:06 -0500
Received: by bwz23 with SMTP id 23so869105bwz.1
        for <linux-media@vger.kernel.org>; Tue, 09 Feb 2010 19:09:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265768091.3064.109.camel@palomino.walls.org>
References: <4B70E7DB.7060101@cooptel.qc.ca>
	 <1265768091.3064.109.camel@palomino.walls.org>
Date: Tue, 9 Feb 2010 22:09:01 -0500
Message-ID: <829197381002091909j7f95bfbfl3cd234393a08caeb@mail.gmail.com>
Subject: Re: Driver crash on kernel 2.6.32.7. Interaction between cx8800
	(DVB-S) and USB HVR Hauppauge 950q
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: Richard Lemieux <rlemieu@cooptel.qc.ca>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 9, 2010 at 9:14 PM, Andy Walls <awalls@radix.net> wrote:
> Both Ooops below are related to userspace loading of firmware for the
> HVR-950Q.

Very strange.  The xc5000 function doesn't appear to really do
anything unusual.  It calls request_firmware(), pushes the code into
the chip, and then call release_firmware() [see
xc5000.c:xc5000_fwupload() ]

One thing that does jump out at me which could be problematic is the
function will call release_firmware() even if request_firmware()
fails.  I doubt that is the correct behavior.  And combined with the
fact that his dmesg shows the error "run_program:
'/lib/udev/firmware.sh' abnormal exit" makes me wonder if the
subsequent to release_firmware() despite the error condition is what
is causing the problem.

The other thing that is a bit unusual about the xc5000 in this
particular case is the time to load the firmware is exceptionally long
(around 7 seconds) due to a hardware bug in the au0828 which requires
us to run the i2c bus at a very slow rate.  Hence, it's possible that
the unusually long time between request_firmware() and
release_firmware() has exposed some sort of race in the firmware
loading core.

It would be useful if we could get the full dmesg output so we can get
some more context leading up to the oops.  Also, it would be helpful
if the user could enable the "debug=1" in the xc5000 modprobe options.

One more question: is the user doing any suspend/resume operations?
For example, is this a laptop in which he is closing the lid and this
is the first attempt to use the device after resume?

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
