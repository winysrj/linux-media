Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43221 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754340AbdFWJW4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 05:22:56 -0400
Subject: Re: [PATCH] [media] em28xx TerraTec Cinergy Hybrid T USB XS with
 demodulator MT352 is not detect by em28xx
To: juvann@caramail.fr, linux-media@vger.kernel.org
References: <trinity-3ccfe6a4-860f-4c5c-a2cc-d3027dbb4777-1497078814431@3capp-mailcom-bs10>
From: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <0c26e44d-c317-771e-0faa-2ae637b9ecfe@xs4all.nl>
Date: Fri, 23 Jun 2017 11:22:50 +0200
MIME-Version: 1.0
In-Reply-To: <trinity-3ccfe6a4-860f-4c5c-a2cc-d3027dbb4777-1497078814431@3capp-mailcom-bs10>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Giovanni,

On 06/10/17 09:13, juvann@caramail.fr wrote:
> TerraTec Cinergy Hybrid T USB XS with demodulator MT352 stop working with kernel 3.xx and newer.
> I have already sent this patch without a success reply, I hope this time you can accept it.
> 
> --- /usr/src/linux-3.14.3/drivers/media/usb/em28xx/em28xx-cards.c.orig   2014-05-06 16:59:58.000000000 +0200
> +++ /usr/src/linux-3.14.3/drivers/media/usb/em28xx/em28xx-cards.c   2014-05-07 15:18:31.719524453 +0200
> @@ -2233,7 +2233,7 @@
>         { USB_DEVICE(0x0ccd, 0x005e),
>                         .driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
>         { USB_DEVICE(0x0ccd, 0x0042),
> -                       .driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
> +                       .driver_info = EM2880_BOARD_TERRATEC_HYBRID_XS },
>         { USB_DEVICE(0x0ccd, 0x0043),
>                         .driver_info = EM2870_BOARD_TERRATEC_XS },
>         { USB_DEVICE(0x0ccd, 0x008e),   /* Cinergy HTC USB XS Rev. 1 */
> 
> This patch is working also on kernel 4.xx I have tested kernel 4.3 and 4.9

I checked the commit that changed the original EM2880_BOARD_TERRATEC_HYBRID_XS
to EM2882_BOARD_TERRATEC_HYBRID_XS and it says this:

commit 9124544320bd36d5aa21769d17a5781ba729aebf
Author: Philippe Bourdin <richel@AngieBecker.ch>
Date:   Sun Oct 31 09:57:58 2010 -0300

    [media] Terratec Cinergy Hybrid T USB XS

    I found that the problems people have reported with the USB-TV-stick
    "Terratec Cinergy Hybrid T USB XS" (USB-ID: 0ccd:0042)
    are coming from a wrong header file in the v4l-sources.

    Attached is a diff, which fixes the problem (tested successfully here).
    Obviously the USB-ID has been associated with a wrong chip: EM2880
    instead of EM2882, which would be correct.

    Reported-by: Philippe Bourdin <richel@AngieBecker.ch>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

So it looks like there are two variants with the same USB ID: one uses
the EM2880, one uses the EM2882. Since nobody else complained I expect
that most devices with this USB ID are in fact using the EM2882.

I won't apply this patch, since that would break it for others.

The best solution for you is to explicitly set the card using the
'card=11' em28xx module option.

I've CC-ed Mauro in case he knows a better solution.

Regards,

	Hans
