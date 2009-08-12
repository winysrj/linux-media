Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:63245 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbZHLIn1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 04:43:27 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1052190fga.17
        for <linux-media@vger.kernel.org>; Wed, 12 Aug 2009 01:43:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A827C70.4090500@gmail.com>
References: <4A827C70.4090500@gmail.com>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Wed, 12 Aug 2009 17:43:07 +0900
Message-ID: <5e9665e10908120143h268a7210kb6bfa215cbfbe6de@mail.gmail.com>
Subject: Re: framebuffer overlay
To: Ryan Raasch <ryan.raasch@gmail.com>
Cc: video4linux-list@redhat.com,
	v4l2_linux <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 12, 2009 at 5:25 PM, Ryan Raasch<ryan.raasch@gmail.com> wrote:
> Hello,
>
> I am trying to write a driver for a camera using the new soc_camera in the
> mainline kernel the output is the overlay framebuffer (pxa270) and i would
> like to use the overlay output feature of v4l2 framework, but the
> framebuffer does not expose itself as a output device (not yet).
>
Hi Ryan,

As far as I know the framebuffer of PXA2 even PXA3 can't be
categorized in a overlay device.
To be able to get used as overlay device by camera interface, I think
there should be a direct FIFO between camera and framebuffer which
means there is no need to copy memory from camera to fb. But
unfortunately PXA architecture is not supporting this kind of feature.
Cheers,

Nate

> Are there any fb that i can use as an example for this?
>
> From looking at the driver code, it seems like the generic code of fbmem.c
> needs a v4l2 device. Is this in the right ballpark?
>
> Thanks,
> Ryan
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
