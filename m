Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:49308 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbZLROoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 09:44:44 -0500
Received: by fxm21 with SMTP id 21so2865024fxm.21
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2009 06:44:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <59cf47a80912180605o41708efao769d09d46b20a87e@mail.gmail.com>
References: <59cf47a80912180605o41708efao769d09d46b20a87e@mail.gmail.com>
Date: Fri, 18 Dec 2009 09:44:42 -0500
Message-ID: <829197380912180644y31f520fawee04a66ab28666e7@mail.gmail.com>
Subject: Re: Adaptec VideOh! DVD Media Center
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Paulo Assis <pj.assis@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 18, 2009 at 9:05 AM, Paulo Assis <pj.assis@gmail.com> wrote:
> Hi,
> I'm currently porting the GPL linux-avc2210k driver (
> http://www.freelists.org/archive/linux-avc2210k/ ) to V4L2.
> The current version has it's own API that makes it incompatible with
> any software except for specific user space apps (avcctrl, avctune)
> bundled with the driver.
> Since development seems to have halted for some time now, I had no
> other choice than get my hands dirty :(
> For the most part this task seems quite straight forward it's mostly a
> matter of changing ioctls to V4L2 and add some missing support, there
> are however a few points that I need some advice on:
> For the box to function it needs a firmware upload. Currently this is
> managed by a udev script that in turn calls an application (multiload)
> that provides for the upload.
> What I would like to know is, if this the best way to handle it?
> The problem with this process is that it will always require
> installing and configuring additional software (multiload and udev
> script), besides the firmware.
> Is there any simpler/standard way of handling these firmware uploads ?
>
> Regards,
> Paulo

Hi Paulo,

I would start by looking at the request_firmware() function, which is
used by a variety of other v4l cards.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
