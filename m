Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42474 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760092AbbBIKZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2015 05:25:48 -0500
Received: by mail-wg0-f45.google.com with SMTP id x12so25721273wgg.4
        for <linux-media@vger.kernel.org>; Mon, 09 Feb 2015 02:25:47 -0800 (PST)
Date: Mon, 9 Feb 2015 10:23:48 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Fwd: divide error: 0000 in the gspca_topro
Message-ID: <20150209102348.GB28420@biggie>
References: <54D7E0B8.30503@reflexion.tv>
 <CA+55aFxB4Wq-Bob_+q0c3oS1hUf_BLGqqyoepGRDvm9-X2Y+og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxB4Wq-Bob_+q0c3oS1hUf_BLGqqyoepGRDvm9-X2Y+og@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 08, 2015 at 06:07:45PM -0800, Linus Torvalds wrote:
> I got this, and it certainly seems relevant,.
> 
> It would seem that that whole 'quality' thing needs some range
> checking, it should presumably be in the range [1..100] in order to
> avoid negative 'sc' values or the divide-by-zero.
> 
> Hans, Mauro?
> 
>                       Linus

Hello Linus,

The case of quality being set to 0 is correctly handled in
drivers/media/usb/gspca/jpeg.h [0], so I have sent a patch to do the same
in topro.c.

Thanks,
Luis

[0] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/media/usb/gspca/jpeg.h#n157

> 
> ---------- Forwarded message ----------
> From: Peter Kovář <peter.kovar@reflexion.tv>
> Date: Sun, Feb 8, 2015 at 2:18 PM
> Subject: divide error: 0000 in the gspca_topro
> To: Linus Torvalds <torvalds@linux-foundation.org>
> 
> 
> Hi++ Linus!
> 
> There is a trivial bug in the gspca_topro webcam driver.
> 
> /* set the JPEG quality for sensor soi763a */
> static void jpeg_set_qual(u8 *jpeg_hdr,
>                           int quality)
> {
>         int i, sc;
> 
>         if (quality < 50)
>                 sc = 5000 / quality;
>         else
>                 sc = 200 - quality * 2;
> 
> 
> 
> Crash can be reproduced by setting JPEG quality to zero in the guvcview
> application.
> 
> Cheers,
> 
> Peter Kovář
> 50 65 74 65 72 20 4B 6F 76 C3 A1 C5 99
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
