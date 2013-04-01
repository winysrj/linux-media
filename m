Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45098 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab3DARZx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Apr 2013 13:25:53 -0400
Received: by mail-ee0-f50.google.com with SMTP id e53so1150203eek.23
        for <linux-media@vger.kernel.org>; Mon, 01 Apr 2013 10:25:52 -0700 (PDT)
Message-ID: <5159C35D.7080901@googlemail.com>
Date: Mon, 01 Apr 2013 19:26:53 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Timo Teras <timo.teras@iki.fi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Grabby hwrev 2
References: <20130325190846.3250fe98@vostro> <20130325143647.3da1360f@redhat.com> <20130325194820.7c122834@vostro> <20130325153220.3e6dbfe5@redhat.com> <20130325211238.7c325d5e@vostro> <20130326102056.63b55916@vostro> <20130327161049.683483f8@vostro> <20130328105201.7bcc7388@vostro> <20130328094052.26b7f3f5@redhat.com> <20130328153556.0b58d1aa@vostro> <20130328122252.19769614@redhat.com> <20130330115455.56c34b5f@vostro>
In-Reply-To: <20130330115455.56c34b5f@vostro>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 30.03.2013 10:54, schrieb Timo Teras:
> On Thu, 28 Mar 2013 12:22:52 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>
>>> On the W7 driver, I don't get any of the above mentioned problems.
>>>
>>> I looked at the saa7113 register init sequence, and copied that
>>> over to linux saa7113 init, but that did not remove the problems.
>>> There were only few changes.
>> So, maybe it does a different crop setup at em28xx.
> I did an analysis of the register setups of em28xx and found the
> following differences:
>
> 1. Different crop settings
>
> EM28XX_R1D_VSTART, EM28XX_R1F_CHEIGHT and EM28XX_R2B_YMAX set by W7
> driver were divided by two compared to the linux driver. Seems that
> linux driver did just this before commit c2a6b54.  I also found the
> patch https://patchwork.kernel.org/patch/1272051/ to restore the
> original behaviour, but somehow it was disregarded and commit 0bc9c89
> was done instead. The mentioned patch though does not fix R1D setting
> though.

Can you post the settings the Windows driver uses for these registers ?
Don't worry about registers 0x28-0x2B, different values shouldn' matter.
See
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/57039.

> 2. Different outfmt used
>
> It seems that ffmpeg defaults to v4l default, which somehow apparently
> resulted in EM28XX_OUTFMT_RGB_8_RGRG set. When forcing ffmpeg to set
> yuyv422 or EM28XX_OUTFMT_YUV422_Y0UY1V the color distortions vanished.
> I'm unsure if the distiortion comes from ffmpeg doing some automatic
> conversions, or from v4l kernel driver.

The easiest way to test the drivers output formats is to use qv4l2 with
the device opened in raw mode (command line option '-r' or 'Open raw
device' from the 'File' menu).
In raw mode, you can be sure that the selected format is always the
actually used format (otherwise libv4l2 is used which selects what it
thinks is the best source format for the conversion into the selected
format.

I hate to say that, but currently you shouldn't expect anything else
than the 16 bit formats to work properly. :(
The code assumes 16 bit pixel width in several places (initially YUV422
was the only supported format).
Some of these bugs are easy to find (e.g. in em28xx_copy_video() ), some
are hidden...
I didn't have enough time yet to track them all down and all my attempts
to fix parts of the code resulted in an even worse picture so far.


> Though, it might be an idea to set the default outfmt to something that
> is known to work. So I'm wondering if this could be fixed easily?
> YUYV422 should have also better quality, so it would make sense to
> select it instead of the other one.

The driver selects EM28XX_OUTFMT_YUV422_Y0UY1V as default format, so it
must be ffmpeg that selects EM28XX_OUTFMT_RGB_8_RGRG.

> --
>
> So seems that now the device is working properly. Basically we need the
> following changes:
>  1. saa7113 id ignore (or autodetect, and fallback to forced type)
>  2. saa7113 not writing to the registers 14-17 in case it's not the
>     original chip (id not present)

You should talk to the saa7115 maintainer about that.

>  3. em28xx crop height/vstart to divided by 2 in interlaced mode
>  4. (optionally) em28xx outfmt should default to YUYV422

Both isn't necessary (as explained above).
What definitely needs to be fixed in the em28xx driver are the
non-16bit-formats.

Regards,
Frank

> I can post a patch for 3, but for others I'm not fully certain about
> implementation details. With few pointers, I could probably produce
> patches, though. But I would be also happy to just test what ever you
> come up with.
>
> Thanks,
>  Timo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

