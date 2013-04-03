Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:55178 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760856Ab3DCI0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 04:26:55 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so649561bkc.2
        for <linux-media@vger.kernel.org>; Wed, 03 Apr 2013 01:26:53 -0700 (PDT)
Date: Wed, 3 Apr 2013 11:27:50 +0300
From: Timo Teras <timo.teras@iki.fi>
To: Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130403112750.0bc79874@vostro>
In-Reply-To: <515B09BD.2040104@googlemail.com>
References: <20130325190846.3250fe98@vostro>
	<20130325143647.3da1360f@redhat.com>
	<20130325194820.7c122834@vostro>
	<20130325153220.3e6dbfe5@redhat.com>
	<20130325211238.7c325d5e@vostro>
	<20130326102056.63b55916@vostro>
	<20130327161049.683483f8@vostro>
	<20130328105201.7bcc7388@vostro>
	<20130328094052.26b7f3f5@redhat.com>
	<20130328153556.0b58d1aa@vostro>
	<20130328122252.19769614@redhat.com>
	<20130330115455.56c34b5f@vostro>
	<5159C35D.7080901@googlemail.com>
	<20130402084305.0f623e6e@vostro>
	<515B09BD.2040104@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 02 Apr 2013 18:39:25 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> wrote:

> Am 02.04.2013 07:43, schrieb Timo Teras:
> > On Mon, 01 Apr 2013 19:26:53 +0200
> > Frank Schäfer <fschaefer.oss@googlemail.com> wrote:
> >
> >> Am 30.03.2013 10:54, schrieb Timo Teras:
> >>> On Thu, 28 Mar 2013 12:22:52 -0300
> >>> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> >>>
> >>>>> On the W7 driver, I don't get any of the above mentioned
> >>>>> problems.
> >>>>>
> >>>>> I looked at the saa7113 register init sequence, and copied that
> >>>>> over to linux saa7113 init, but that did not remove the
> >>>>> problems. There were only few changes.
> >>>> So, maybe it does a different crop setup at em28xx.
> >>> I did an analysis of the register setups of em28xx and found the
> >>> following differences:
> >>>
> >>> 1. Different crop settings
> >>>
> >>> EM28XX_R1D_VSTART, EM28XX_R1F_CHEIGHT and EM28XX_R2B_YMAX set by
> >>> W7 driver were divided by two compared to the linux driver. Seems
> >>> that linux driver did just this before commit c2a6b54.  I also
> >>> found the patch https://patchwork.kernel.org/patch/1272051/ to
> >>> restore the original behaviour, but somehow it was disregarded
> >>> and commit 0bc9c89 was done instead. The mentioned patch though
> >>> does not fix R1D setting though.
> >> Can you post the settings the Windows driver uses for these
> >> registers ? Don't worry about registers 0x28-0x2B, different values
> >> shouldn' matter. See
> >> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/57039.
> > Yes, it would seem registers 0x28-0x2B do not have great
> > significance in the video we get out of it.
> >
> > The full sequence the W7 driver does for PAL video is:
> >
> > EM28XX_R20_YGAIN        0x00
> > EM28XX_R22_UVGAIN       0x00
> > EM28XX_R06_I2C_CLK      0x40
> > EM28XX_R15_RGAIN        0x20
> > EM28XX_R16_GGAIN        0x20
> > EM28XX_R17_BGAIN        0x20
> > EM28XX_R18_ROFFSET      0x00
> > EM28XX_R19_GOFFSET      0x00
> > EM28XX_R1A_BOFFSET      0x00
> > EM28XX_R23_UOFFSET      0x00
> > EM28XX_R24_VOFFSET      0x00
> > EM28XX_R26_COMPR        0x00
> > EM28XX_R13_???          0x08 (Note: we do not set this at all)
> 
> I've seen this write to reg 0x13 with my webcams, too.
> Unfortunately, we don't know what it means. But according to my tests,
> it is not needed.

Right, it is not strictly needed.

> 
> > EM28XX_R27_OUTFMT       0x34
> > EM28XX_R10_VINMODE      0x00
> 
> We set vinmode to 0x10 (see em28xx_init_dev() in em28xx-cards.c).
> No idea what the values mean. Might be worth testing with 0x00.

Did not try, but seems it did not make any great difference either.

> > EM28XX_R28_XMIN         0x01
> > EM28XX_R29_XMAX         0xB3
> > EM28XX_R2A_YMIN         0x01
> > EM28XX_R2B_YMAX         0x47 (We set 0x8e, i think)
> 
> Yes, we set to EM28XX_R2B_YMAX to 0x8f, the other values are the same
> as used by the driver.
> 0x47 is 0x8f / 2, so what the Windows driver seems to do here is to
> use the field height instead of the image height (interlaced mode)
> which is the same what we did in the past in our driver.
> 
> Anyway, some other device like the MSI DigiVox ATSC (PAL or NTSC ?,
> interlaced), Silvercrest webcam 1.3MPix (640x480, progressive) use the
> following values: 0x01, 0xFF, 0x01, 0xFF.
> And the Speedlink VAD Laplace webcam for example uses the following
> values: 0x1B, 0x83, 0x13, 0x63    (320x240, 640x480, progressive)
>     0x6B, 0xD3, 0x57, 0xA7    (1280x1024, progressive)
>     0x93, 0xFB, 0x6D, 0xBD    (1600x1200, progressive)
> 
> So which formula should we use ? Suggestions ? ;)

Not really. And yes, seems it does not matter much. I took the below
referred image grabs with unmodified em28xx, and they look pretty much
the same compared to the results of em28xx patched as described before.

> As said before, we didn't notice any difference in the device behavior
> when changing the values so far. So let's stay with the current
> formula.

Yeah.

> > EM28XX_R1C_HSTART       0x00
> > EM28XX_R1D_VSTART       0x01 (We set 0x02)
> 
> In VBI mode, yes, without VBI we use 0x00.
> I don't know if a 1 Pixel offset makes a big difference.
> But looking at the comment in em28xx_resolution_set(), an offset of 2
> pixels seems to make a bigger difference for VBI devices, which makes
> my alert bells ringing...

I did not test VBI, so I'm unsure if it works or not.

>[snip]
> > Oh, would it then make sense to disable all the non-16bpp formats
> > for the time being?
> 
> Maybe.
> But in practice, nearly all TV/DVB application (or libv4l2) are
> selecting a 16 bit format, so this doesn't cause too much trouble.
> ffmpeg however seems to be the exception ;) The other exception might
> be webcam applications.

Seems the exception is applications using libv4l2 and requesting
primarly a format that is not native to the device.

> I'm also getting a "usable" image with the 8 bit formats, so it's not
> completely broken.
> 
> Anyway, sooner or later we will have to fix the 8 bit formats, because
> for webcams with higher resolutions (e.g. >= 1280x1024) 16 bit formats
> cannot be used anymore... ;)
> 
> > Basically, I got mostly OK picture, but areas with all-black and
> > all-white next to each other got distorted (e.g. subtitles).
> 
> Could you send us a screenshot ?
> Looks different with my devices...

Seems ffmpeg by default wants yuv420p, and libv4l2 does some
conversions automatically to get there. The relevant grab is:
http://dev.alpinelinux.org/~tteras/image-yuv420p.jpg
You can see the red/blue pixels with subtitles. There's also some
quality loss on other sharp edges, like the edge of the white shirt.

Using --pix_fmt rgb24 seems to result in similar issues.

This is the same (paused image from DVD player) grabbed again with
--pix_fmt yuyv422: http://dev.alpinelinux.org/~tteras/image-yuyv422.jpg
which nice.

When comparing these two picture, you see that the frame is offset with
one or two pixels in x-direction. Perhaps this is a byte offset, and in
RGB format causes color values to be connected to wrong pixel.

As final note, now I hooked the device on faster machine, and the AC97
detection seems random. It seemed to work with the slower machine
reliably after I had it do the saa7113 initialization. So sounds like
some sort of timing issue.

- Timo
