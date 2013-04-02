Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:35317 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027Ab3DBQiZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 12:38:25 -0400
Received: by mail-ee0-f47.google.com with SMTP id t10so325434eei.34
        for <linux-media@vger.kernel.org>; Tue, 02 Apr 2013 09:38:23 -0700 (PDT)
Message-ID: <515B09BD.2040104@googlemail.com>
Date: Tue, 02 Apr 2013 18:39:25 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Timo Teras <timo.teras@iki.fi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Grabby hwrev 2
References: <20130325190846.3250fe98@vostro> <20130325143647.3da1360f@redhat.com> <20130325194820.7c122834@vostro> <20130325153220.3e6dbfe5@redhat.com> <20130325211238.7c325d5e@vostro> <20130326102056.63b55916@vostro> <20130327161049.683483f8@vostro> <20130328105201.7bcc7388@vostro> <20130328094052.26b7f3f5@redhat.com> <20130328153556.0b58d1aa@vostro> <20130328122252.19769614@redhat.com> <20130330115455.56c34b5f@vostro> <5159C35D.7080901@googlemail.com> <20130402084305.0f623e6e@vostro>
In-Reply-To: <20130402084305.0f623e6e@vostro>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 02.04.2013 07:43, schrieb Timo Teras:
> On Mon, 01 Apr 2013 19:26:53 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> wrote:
>
>> Am 30.03.2013 10:54, schrieb Timo Teras:
>>> On Thu, 28 Mar 2013 12:22:52 -0300
>>> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>>
>>>>> On the W7 driver, I don't get any of the above mentioned problems.
>>>>>
>>>>> I looked at the saa7113 register init sequence, and copied that
>>>>> over to linux saa7113 init, but that did not remove the problems.
>>>>> There were only few changes.
>>>> So, maybe it does a different crop setup at em28xx.
>>> I did an analysis of the register setups of em28xx and found the
>>> following differences:
>>>
>>> 1. Different crop settings
>>>
>>> EM28XX_R1D_VSTART, EM28XX_R1F_CHEIGHT and EM28XX_R2B_YMAX set by W7
>>> driver were divided by two compared to the linux driver. Seems that
>>> linux driver did just this before commit c2a6b54.  I also found the
>>> patch https://patchwork.kernel.org/patch/1272051/ to restore the
>>> original behaviour, but somehow it was disregarded and commit
>>> 0bc9c89 was done instead. The mentioned patch though does not fix
>>> R1D setting though.
>> Can you post the settings the Windows driver uses for these
>> registers ? Don't worry about registers 0x28-0x2B, different values
>> shouldn' matter. See
>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/57039.
> Yes, it would seem registers 0x28-0x2B do not have great significance
> in the video we get out of it.
>
> The full sequence the W7 driver does for PAL video is:
>
> EM28XX_R20_YGAIN        0x00
> EM28XX_R22_UVGAIN       0x00
> EM28XX_R06_I2C_CLK      0x40
> EM28XX_R15_RGAIN        0x20
> EM28XX_R16_GGAIN        0x20
> EM28XX_R17_BGAIN        0x20
> EM28XX_R18_ROFFSET      0x00
> EM28XX_R19_GOFFSET      0x00
> EM28XX_R1A_BOFFSET      0x00
> EM28XX_R23_UOFFSET      0x00
> EM28XX_R24_VOFFSET      0x00
> EM28XX_R26_COMPR        0x00
> EM28XX_R13_???          0x08 (Note: we do not set this at all)

I've seen this write to reg 0x13 with my webcams, too.
Unfortunately, we don't know what it means. But according to my tests,
it is not needed.

> EM28XX_R27_OUTFMT       0x34
> EM28XX_R10_VINMODE      0x00

We set vinmode to 0x10 (see em28xx_init_dev() in em28xx-cards.c).
No idea what the values mean. Might be worth testing with 0x00.

> EM28XX_R28_XMIN         0x01
> EM28XX_R29_XMAX         0xB3
> EM28XX_R2A_YMIN         0x01
> EM28XX_R2B_YMAX         0x47 (We set 0x8e, i think)

Yes, we set to EM28XX_R2B_YMAX to 0x8f, the other values are the same as
used by the driver.
0x47 is 0x8f / 2, so what the Windows driver seems to do here is to use
the field height instead of the image height (interlaced mode) which is
the same what we did in the past in our driver.

Anyway, some other device like the MSI DigiVox ATSC (PAL or NTSC ?,
interlaced), Silvercrest webcam 1.3MPix (640x480, progressive) use the
following values: 0x01, 0xFF, 0x01, 0xFF.
And the Speedlink VAD Laplace webcam for example uses the following values:
    0x1B, 0x83, 0x13, 0x63    (320x240, 640x480, progressive)
    0x6B, 0xD3, 0x57, 0xA7    (1280x1024, progressive)
    0x93, 0xFB, 0x6D, 0xBD    (1600x1200, progressive)

So which formula should we use ? Suggestions ? ;)

As said before, we didn't notice any difference in the device behavior
when changing the values so far. So let's stay with the current formula.

> EM28XX_R1C_HSTART       0x00
> EM28XX_R1D_VSTART       0x01 (We set 0x02)

In VBI mode, yes, without VBI we use 0x00.
I don't know if a 1 Pixel offset makes a big difference.
But looking at the comment in em28xx_resolution_set(), an offset of 2
pixels seems to make a bigger difference for VBI devices, which makes my
alert bells ringing...

> EM28XX_R1E_CWIDTH       0xB4
> EM28XX_R1F_CHEIGHT      0x48 (We set 0x8f, or 0x90)

Are you sure that 0x48 is used for PAL ? Which resolution does the
Windows driver claim too use ?
All USB-logs from the various devices I've seen so far match what we do
in the driver (0x90).

> EM28XX_R1B_OFLOW        0x00
>
> (Tuner and AC97 config takes place here)
>
> EM28XX_R0E_AUDIOSRC     0x8f
> EM28XX_R21_YOFFSET      0x08 (We set 0x10)

This is the "brightness" value...

> EM28XX_R20_YGAIN        0x10
> EM28XX_R22_UVGAIN       0x10
> EM28XX_R14_GAMMA        0x32 (We set 0x20)
> EM28XX_R25_SHARPNESS    0x02 (We set 0x00)

... and these are the "Gamma" and "Sharpness" values.

The Windows driver uses different image quality settings for different
devices, while our em28xx driver uses a single (common) set of values.

> EM28XX_R26_COMPR        0x00
> EM28XX_R27_OUTFMT       0x34
> EM28XX_R11_VINCTRL      0x11
> EM28XX_R1B_OFLOW        0x00
> EM28XX_R12_VINENABLE    0x67
> EM28XX_R22_UVGAIN       0x10
> EM28XX_R20_YGAIN        0x10
> EM28XX_R0E_AUDIOSRC     0x8f
>
>
>>> 2. Different outfmt used
>>>
>>> It seems that ffmpeg defaults to v4l default, which somehow
>>> apparently resulted in EM28XX_OUTFMT_RGB_8_RGRG set. When forcing
>>> ffmpeg to set yuyv422 or EM28XX_OUTFMT_YUV422_Y0UY1V the color
>>> distortions vanished. I'm unsure if the distiortion comes from
>>> ffmpeg doing some automatic conversions, or from v4l kernel driver.
>> The easiest way to test the drivers output formats is to use qv4l2
>> with the device opened in raw mode (command line option '-r' or 'Open
>> raw device' from the 'File' menu).
>> In raw mode, you can be sure that the selected format is always the
>> actually used format (otherwise libv4l2 is used which selects what it
>> thinks is the best source format for the conversion into the selected
>> format.
> Ah, ok. So libv4l2 can be doing stuff underneath also. I think in
> my setup yuv420p is the preferred one (encoding to h264 with baseline
> profile). Now that I figured what goes wrong, this is not a big issue.
>
>> I hate to say that, but currently you shouldn't expect anything else
>> than the 16 bit formats to work properly. :(
>> The code assumes 16 bit pixel width in several places (initially
>> YUV422 was the only supported format).
>> Some of these bugs are easy to find (e.g. in em28xx_copy_video() ),
>> some are hidden...
>> I didn't have enough time yet to track them all down and all my
>> attempts to fix parts of the code resulted in an even worse picture
>> so far.
> Oh, would it then make sense to disable all the non-16bpp formats for
> the time being?

Maybe.
But in practice, nearly all TV/DVB application (or libv4l2) are
selecting a 16 bit format, so this doesn't cause too much trouble.
ffmpeg however seems to be the exception ;) The other exception might be
webcam applications.
I'm also getting a "usable" image with the 8 bit formats, so it's not
completely broken.

Anyway, sooner or later we will have to fix the 8 bit formats, because
for webcams with higher resolutions (e.g. >= 1280x1024) 16 bit formats
cannot be used anymore... ;)

> Basically, I got mostly OK picture, but areas with all-black and
> all-white next to each other got distorted (e.g. subtitles).

Could you send us a screenshot ?
Looks different with my devices...

>>> Though, it might be an idea to set the default outfmt to something
>>> that is known to work. So I'm wondering if this could be fixed
>>> easily? YUYV422 should have also better quality, so it would make
>>> sense to select it instead of the other one.
>> The driver selects EM28XX_OUTFMT_YUV422_Y0UY1V as default format, so
>> it must be ffmpeg that selects EM28XX_OUTFMT_RGB_8_RGRG.
> Yes, starting to sound like that.
>
>>> So seems that now the device is working properly. Basically we need
>>> the following changes:
>>>  1. saa7113 id ignore (or autodetect, and fallback to forced type)
>>>  2. saa7113 not writing to the registers 14-17 in case it's not the
>>>     original chip (id not present)
>> You should talk to the saa7115 maintainer about that.
> get_maintainers.pl says that Mauro and this list is the place to talk
> to. So here I am doing it :)

:)

Regards,
Frank

>
>>>  3. em28xx crop height/vstart to divided by 2 in interlaced mode
>>>  4. (optionally) em28xx outfmt should default to YUYV422
>> Both isn't necessary (as explained above).
>> What definitely needs to be fixed in the em28xx driver are the
>> non-16bit-formats.
> Yeah, seems to be the case.
>
> - Timo

