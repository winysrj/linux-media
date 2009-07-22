Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.210.202]:41572 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbZGVBm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 21:42:56 -0400
Received: by yxe40 with SMTP id 40so985451yxe.33
        for <linux-media@vger.kernel.org>; Tue, 21 Jul 2009 18:42:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A6666CC.7020008@eyemagnet.com>
References: <4A6666CC.7020008@eyemagnet.com>
Date: Tue, 21 Jul 2009 21:42:54 -0400
Message-ID: <829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>
Subject: Re: offering bounty for GPL'd dual em28xx support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Castellotti <sc@eyemagnet.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 21, 2009 at 9:09 PM, Steve Castellotti<sc@eyemagnet.com> wrote:
> Hello everyone-
>
>    Apologies in advance for spamming the list, but we're after adding dual
> device support for the existing, GPL'd em28xx tuner driver currently in the
> mainline Linux kernel. We do not have this development resource in house and
> had hoped perhaps someone on the list might be capable and interested (or
> able to point us in the appropriate direction).
>
>
>    By way of more detail, it seems that multiple times in the past, other
> users have also requested this feature, but it is still not currently
> available in the current GPL'd driver. For some time support may have been
> present in the "em28xx-new" driver, provided by Markus Rechberger, but I
> have since been told it is "discontinued, and does not compile anymore with
> the latest kernels."
>
>
>    This message thread as recently as April 9th, 2009, seems to indicate
> interest is still present at the community level, but no resolution was
> reached by the tail of the conversation:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg04245.html
>
>
>    Going further back, it does seem that the em28xx-new driver at one point
> successfully addressed this issue, so supporting multiple devices should be
> possible with driver modification:
>
> http://mcentral.de/pipermail/em28xx/2008-November/002111.html
>
>
>    We can confirm that a development system running Fedora 11 with the
> latest stable kernel (2.6.29.5-191.fc11.i686.PAE), with identical em28xx
> devices connected still exhibits the error message "v4l2: ioctl queue buffer
> failed: No space left on device" when attempting to display video input on
> two identical em28xx devices simultaneously.
>
>    On the other hand, display is successful through either device when
> trying to display individually (with both still connected).
>
>
>    We are a small company, which relies on the Linux platform for the core
> of our products and services. Occasionally a situation presents itself for
> us to contribute back to the Open Source community (in however small a
> fashion), either by releasing existing code or contracting a small amount of
> work to be performed and subsequently released under the GPL. This is one
> such instance.
>
>
>    If anyone is interested in contributing such work and is prepared to
> quote for what they feel their time would be worth, please do not hesitate
> to contact me.
>
>    Again, apologies if this message appears to be a misuse of the mailing
> list, hopefully our intentions are understandable!
>
>
> Cheers
>
>
> --
>
> Steve Castellotti
> sc@eyemagnet.com
> Technical Director
> Eyemagnet Limited
> http://www.eyemagnet.com

Hello Steve,

The issue occurs with various different drivers.  Basically the issue
is the device attempts to reserve a certain amount of bandwidth on the
USB bus for the isoc stream, and in the case of analog video at
640x480 this adds up to about 200Mbps.  As a result, connecting
multiple devices can result in exceeding the available bandwidth on
the USB bus.

Depending on your how many devices you are trying to connect, what
your target capture resolution is, and whether you can put each device
on its own USB bus will dictate what solution you can go with.

I've done a considerable amount of work with the mainline em28xx
driver, so if you would like to discuss your desired configuration
further and what we might be able to do to accommodate those
requirements (including possibly optimizing the driver to better
support more devices), feel free to email me off-list.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
