Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3081 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab0IOP7i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 11:59:38 -0400
Message-ID: <74bab26c7582158ca76426c5e211f4d7.squirrel@webmail.xs4all.nl>
In-Reply-To: <AANLkTinAjJ2_qxFVJuJ=TRr7+OJPtHnESKW7yHpoXev7@mail.gmail.com>
References: <AANLkTinAjJ2_qxFVJuJ=TRr7+OJPtHnESKW7yHpoXev7@mail.gmail.com>
Date: Wed, 15 Sep 2010 17:59:36 +0200
Subject: Re: pwc driver breakage in recent(ish) kernels (for old hardware)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Christopher Friedt" <chrisfriedt@gmail.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> Hi everyone,
>
> I've been using a Logitech Sphere for years on various projects. This
> model is probably from the first batch ever made. In lsusb it shows up
> as
>
> 046d:08b5 Logitech, Inc. QuickCam Sphere
>
> It's a bit troublesome, because on older kernel versions (~2.4.x,
> ~2.6.2x) I never had a single issue with this hardware at all, on
> several different platforms ranging from x86 to x86_64, to arm
> (ep93xx), etc. However, somewhere between then and now, the pwc driver
> underwent some changes rendering this device unusable in any recent
> kernel. All of my old apps and new apps (including cheese, mplayer,
> etc) simply hang indefinitely waiting to read a single frame (using
> the v4l2 mmap api). The v4l2 read api also hangs indefinitely (using
> pwcgrab). A few of the very old apps that I have also use the v4l1
> api, with a 2.4.26 kernel, and that actually works.
>
> I can verify that the hardware itself is fine on windows (also using
> very old drivers from Logitech).
>
> Who has been working on this driver? What were the major changes that
> have been applied? I'm guessing that the bridge / sensor init sequence
> has been messed up somehow. Any ideas?

You're in luck. I fixed this last weekend. It turns out that the
/dev/videoX device is created too soon and the HAL daemon starts to use it
immediately causing some initialization to go wrong or something like
that. Moving the creation of /dev/videoX to the end fixed this issue.

This bug has been there probably for a long time, but it is only triggered
if some other process opens the device node immediately.

Check out the pwc patch I posted last weekend.

Regards,

          Hans

>
> Cheers,
>
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

