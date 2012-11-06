Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48782 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2KFVeY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2012 16:34:24 -0500
MIME-Version: 1.0
In-Reply-To: <50983CFD.2030104@gmail.com>
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com>
	<5096C561.5000108@gmail.com>
	<CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com>
	<5096E8D7.4070304@gmail.com>
	<CAA11ShDinm7oU4azQYPMrNDsqWPqw+vJNFPpBDNzV=dTeUdZzw@mail.gmail.com>
	<50979998.8090809@gmail.com>
	<CAA11ShD6Qug_=t8vGE5LwSpfXW2FsceTonxnF8aO6i2b=inibw@mail.gmail.com>
	<50983CFD.2030104@gmail.com>
Date: Wed, 7 Nov 2012 00:34:24 +0300
Message-ID: <CAA11ShDAscm8snYzjnC3Fe1MaVXc-FJqhWM677iJwgbgu2_J1Q@mail.gmail.com>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
From: Andrey Gusakov <dron0gus@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	=?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

> Does the sensor still hang after 0x2f is written to REG_GRCOM instead ?
Work!
I'm looking at drivers/media/usb/gspca/m5602/m5602_ov9650.h
It use significantly different init sequence. Some of settings
described in Application note for ov9650, some look like magic.

> Do you have CONFIG_PM_RUNTIME enabled ? Can you try and see it works
> if you enable it, without additional changes to the clock handling ?
Work. With CONFIG_PM_RUNTIME and without enabling CLK_GATE at probe.

> I hope to eventually prepare the ov9650 sensor driver for mainline. Your
> help in making it ready for VER=0x52 would be very much appreciated. :-)
I'll try to helpful.


>> Next step is to make ov2460 work.
> For now I can only recommend you to make the ov2460 driver more similar
> to the ov9650 one.
Thanks, I'll try.

P.S. I add support of image effects just for fun. And found in DS that
s3c2450 also support effects. It's FIMC in-between of 2440 and
6400/6410. Does anyone have s3c2450 hardware to test it?
