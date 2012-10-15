Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36724 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2JOMDV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 08:03:21 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so4864588pbb.19
        for <linux-media@vger.kernel.org>; Mon, 15 Oct 2012 05:03:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7805846.LU2Ezfa4XS@avalon>
References: <090701cd8c4e$be38bea0$3aaa3be0$@gmail.com>
	<CAFqH_50RKWJ_G1rs-v3MOF1+X=7DuRu01WwuOsLNtsQ1M+=E1A@mail.gmail.com>
	<CAFqH_53x9wvJRoL0J3b-SLwjOB9cQWbuS_zfoPUBJZgBq-BC8Q@mail.gmail.com>
	<7805846.LU2Ezfa4XS@avalon>
Date: Mon, 15 Oct 2012 14:03:20 +0200
Message-ID: <CAFqH_50FiyMiQHiTwhu82shJVb-boZ+KSu8sTwaFQxsPGA=sfA@mail.gmail.com>
Subject: Re: Using omap3-isp-live example application on beagleboard with DVI
From: Enric Balletbo Serra <eballetbo@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: John Weber <rjohnweber@gmail.com>, linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d042f9318dd504904cc17d202
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--f46d042f9318dd504904cc17d202
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

2012/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Enric,
>
> On Thursday 11 October 2012 10:14:26 Enric Balletb=C3=B2 i Serra wrote:
>> 2012/10/10 Enric Balletb=C3=B2 i Serra <eballetbo@gmail.com>:
>> > 2012/9/6 John Weber <rjohnweber@gmail.com>:
>> >> Hello,
>> >>
>> >> My goal is to better understand how to write an application that make=
s
>> >> use of the omap3isp and media controller frameworks and v4l2.  I'm
>> >> attempting to make use of Laurent's omap3-isp-live example applicatio=
n as
>> >> a starting point and play with the AEC/WB capability.
>> >>
>> >> My problem is that when I start the live application, the display tur=
ns
>> >> blue (it seems when the chromakey fill is done), but no video appears=
 on
>> >> the display.  I do think that I'm getting good (or at least statistic=
s)
>> >> from the ISP because I can change the view in front of the camera (by
>> >> putting my hand in front of the lens) and the gain settings change.
>> >>
>> >> root@beagleboard:~# live
>> >> Device /dev/video6 opened: OMAP3 ISP resizer output (media).
>> >> viewfinder configured for 2011 1024x768
>> >> AEWB: #win 10x7 start 16x74 size 256x256 inc 30x30
>> >> Device /dev/video7 opened: omap_vout ().
>> >> 3 buffers requested.
>> >> Buffer 0 mapped at address 0x40279000.
>> >> Buffer 1 mapped at address 0x40402000.
>> >> Buffer 2 mapped at address 0x4059e000.
>> >> 3 buffers requested.
>> >> Buffer 0 valid.
>> >> Buffer 1 valid.
>> >> Buffer 2 valid.
>> >> AE: factor 3.1250 exposure 2000 sensor gain 12
>> >> AE: factor 1.6018 exposure 2000 sensor gain 19
>> >> AE: factor 1.1346 exposure 2000 sensor gain 21
>> >> AE: factor 1.0446 exposure 2000 sensor gain 21
>> >> AE: factor 1.0448 exposure 2000 sensor gain 21
>> >> AE: factor 1.0444 exposure 2000 sensor gain 21
>> >> AE: factor 1.0443 exposure 2000 sensor gain 21
>> >> AE: factor 1.0445 exposure 2000 sensor gain 21
>> >> AE: factor 1.0438 exposure 2000 sensor gain 21
>> >> AE: factor 1.0448 exposure 2000 sensor gain 21
>> >> AE: factor 1.0461 exposure 2000 sensor gain 21
>> >> AE: factor 1.0897 exposure 2000 sensor gain 22
>> >> AE: factor 2.6543 exposure 2000 sensor gain 58       <   Me obstructi=
ng
>> >> the camera FOV using my hand causes the factor and gain to rise
>> >> AE: factor 1.2345 exposure 2000 sensor gain 71       <
>> >> AE: factor 1.1631 exposure 2000 sensor gain 82       <
>> >> AE: factor 0.9797 exposure 2000 sensor gain 80       <
>> >> AE: factor 0.9709 exposure 2000 sensor gain 77       <
>> >> frame rate: 6.597745 fps
>> >> AE: factor 0.9633 exposure 2000 sensor gain 74       <
>> >> AE: factor 0.6130 exposure 2000 sensor gain 45       <
>> >> AE: factor 0.9271 exposure 2000 sensor gain 41       <
>> >> AE: factor 1.0130 exposure 2000 sensor gain 41       <
>> >> AE: factor 1.0504 exposure 2000 sensor gain 43       <
>> >> AE: factor 1.0411 exposure 2000 sensor gain 44       <
>> >> AE: factor 1.0271 exposure 2000 sensor gain 45       <
>> >> AE: factor 1.0602 exposure 2000 sensor gain 47       <
>> >> AE: factor 1.1278 exposure 2000 sensor gain 53       <
>> >> AE: factor 1.1870 exposure 2000 sensor gain 62       <
>> >> AE: factor 1.1074 exposure 2000 sensor gain 68       <
>> >> AE: factor 1.0716 exposure 2000 sensor gain 72       <
>> >> AE: factor 0.4074 exposure 2000 sensor gain 29       <
>> >> AE: factor 0.8033 exposure 2000 sensor gain 23
>> >> AE: factor 0.9741 exposure 2000 sensor gain 22
>> >> AE: factor 1.0115 exposure 2000 sensor gain 22
>> >>
>> >> I did have to change the omap_vout driver slightly to increase the bu=
ffer
>> >> size.  I was getting errors in the application attempted to allocate
>> >> USERPTR buffers for 1024x768 frames:
>> >>
>> >> root@beagleboard:~# live
>> >> Device /dev/video6 opened: OMAP3 ISP resizer output (media).
>> >> viewfinder configured for 2011 1024x768
>> >> AEWB: #win 10x7 start 16x74 size 256x256 inc 30x30
>> >> Device /dev/video7 opened: omap_vout ().
>> >> 3 buffers requested.
>> >> Buffer 0 mapped at address 0x40302000.
>> >> Buffer 1 mapped at address 0x404df000.
>> >> Buffer 2 mapped at address 0x4066e000.
>> >> 3 buffers requested.
>> >> Buffer 0 too small (1572864 bytes required, 1474560 bytes available.)
>> >>
>> >> So, I changed drivers/media/video/omap/omap_voutdef.h to increase the
>> >> buffer size slightly.
>> >>
>> >> /* Max Resolution supported by the driver */
>> >> #define VID_MAX_WIDTH           1280    /* Largest width */
>> >> #define VID_MAX_HEIGHT          768     /* Largest height */ <-- Was =
720
>> >>
>> >> I'm pretty sure that wasn't the only way to solve the problem, but it=
 did
>> >> allow the live application to run without errors.
>> >>
>> >> I am using a patched variant of the current Angstrom mainline (3.2.16=
)
>> >> with the MT9P031 sensor and a DVI display on Beagleboard-xM and am ab=
le
>> >> to run the following commands and see a live video stream on the disp=
lay.
>> >> I suspect that this indicates that hardware setup works:
>> >>
>> >> media-ctl -v -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3=
 ISP
>> >> CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3 ISP
>> >> resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]=
'
>> >>
>> >> media-ctl -v -f '"mt9p031 2-0048":0 [SGRBG12 1024x768], "OMAP3 ISP
>> >> CCDC":2
>> >> [SGRBG10 1024x768], "OMAP3 ISP preview":1 [UYVY 10006x760], "OMAP3 IS=
P
>> >> resizer":1 [UYVY 1024x768]'
>> >>
>> >> yavta -f UYVY -s 1024x768 -n 8 --skip 3 --capture=3D1000 --stdout
>> >> /dev/video6
>> >>
>> >> | mplayer - -demuxer rawvideo -rawvideo w=3D1024:h=3D768:format=3Duyv=
y -vo
>> >> fbdev
>> >>
>> >> Thanks for any tips or assistance!
>> >
>> > I've exactly the same problem. Before try to debug the problem I would
>> > like to know if you solved the problem. Did you solved ?
>>
>> The first change I made and worked (just luck). I made the following cha=
nge:
>>
>> -       vo_enable_colorkey(vo, 0x123456);
>> +       // vo_enable_colorkey(vo, 0x123456);
>>
>> And now the live application works like a charm. Seems this function
>> enables a chromakey and the live application can't paint over the
>> chromakey. Laurent, just to understand what I did, can you explain
>> this ? Thanks.
>
> My guess is that the live application fails to paint the frame buffer wit=
h the
> color key. If fb_init() failed the live application would stop, so the
> function succeeds. My guess is thus that the application either paints th=
e
> wrong frame buffer (how many /dev/fb* devices do you have on your system =
?),

I checked again and no, it opens the correct framebuffer.

> or paints it with the wrong color. The code assumes that the frame buffer=
 is
> configured in 32 bit, maybe that's not the case on your system ?

This was my problem, and I suspect it's the John problem. My system
was configured in 16 bit instead of 32 bit.

FYI, I made a patch that adds this check to the live application. I
did not know where send the patch so I attached to this email.

Thank you very much for your support.

Regards,
    Enric

--f46d042f9318dd504904cc17d202
Content-Type: application/octet-stream;
	name="0001-live-Fail-if-the-frame-buffer-is-not-configured-in-3.patch"
Content-Disposition: attachment;
	filename="0001-live-Fail-if-the-frame-buffer-is-not-configured-in-3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8bioyed0

RnJvbSA5MWE5MzNmOTE1ZDM0NWU0MjBmYTZiNGUwMTIzMmRkODRlYTNmZWQ3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFbnJpYyBCYWxsZXRibyBpIFNlcnJhIDxlYmFsbGV0Ym9AaXNl
ZWJjbi5jb20+CkRhdGU6IE1vbiwgMTUgT2N0IDIwMTIgMTM6MjI6NDQgKzAyMDAKU3ViamVjdDog
W1BBVENIXSBsaXZlOiBGYWlsIGlmIHRoZSBmcmFtZSBidWZmZXIgaXMgbm90IGNvbmZpZ3VyZWQg
aW4gMzIgYml0cy4KClRoZSBjb2RlIGFzc3VtZXMgdGhhdCB0aGUgZnJhbWUgYnVmZmVyIGlzIGNv
bmZpZ3VyZWQgaW4gMzIgYml0LiBJZiB0aGlzCmlzIG5vdCB0aGUgY2FzZSBvZiB5b3VyIHN5c3Rl
bSB0aGUgZmJfaW5pdCgpIGRvZXNuJ3QgZmFpbCBhbmQgdGhlIGxpdmUKYXBwbGljYXRpb24gZG9l
c24ndCBzdG9wLiBXaGVuIHRoaXMgaGFwcGVucyB0aGUgZGlzcGxheSB0dXJucyBibHVlIGJ1dApu
byB2aWRlbyBhcHBlYXJzIG9uIHRoZSBkaXNwbGF5LgoKU2lnbmVkLW9mZi1ieTogRW5yaWMgQmFs
bGV0Ym8gaSBTZXJyYSA8ZWJhbGxldGJvQGlzZWViY24uY29tPgotLS0KIGxpdmUuYyB8ICAgMjYg
KysrKysrKysrKysrKysrKysrKysrKysrKy0KIDEgZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9saXZlLmMgYi9saXZlLmMKaW5kZXgg
NTEyYzUyOS4uOTAzMmUwMSAxMDA2NDQKLS0tIGEvbGl2ZS5jCisrKyBiL2xpdmUuYwpAQCAtMjY1
LDggKzI2NSwzMiBAQCBzdGF0aWMgaW50IGZiX2luaXQoc3RydWN0IHY0bDJfcmVjdCAqcmVjdCkK
IAlzdHJ1Y3QgZmJfdmFyX3NjcmVlbmluZm8gdmFyOwogCXVuc2lnbmVkIGludCBpOwogCXZvaWQg
Km1lbSA9IE5VTEw7Ci0JaW50IHJldDsKKwlpbnQgcmV0LCB2YWw7CiAJaW50IGZkOworCUZJTEUq
IGZpbGU7CisKKwkvKiBSZWFkIHRoZSBmcmFtZWJ1ZmZlciBiaXQtcGVyLXBpeGVsIGZyb20gc3lz
ZnMuICovCisJZmlsZSA9IGZvcGVuKCIvc3lzL2NsYXNzL2dyYXBoaWNzL2ZiMC9iaXRzX3Blcl9w
aXhlbCIsICJyIik7CisJaWYgKGZpbGUgPT0gTlVMTCkgeworCQlwZXJyb3IoIkZhaWxlZCB0byBv
cGVuIGJpdHNfcGVyX3BpeGVsIGZvciBmYjBcbiIpOworCQlyZXR1cm4gLTE7CisJfQorCisJcmV0
ID0gZnNjYW5mKGZpbGUsICIlZCIsICZ2YWwpOworCWlmIChyZXQgPT0gRU9GKSB7CisJCWlmIChm
ZXJyb3IoZmlsZSkpCisJCQlwZXJyb3IoImZzY2FuZiIpOworCQllbHNlCisJCQlwcmludGYoImVy
cm9yOiBmc2NhbmYgbWF0Y2hpbmcgZmFpbHVyZVxuIik7CisJCXJldHVybiAtMTsKKwl9CisJaWYg
KHZhbCAhPSAzMikgeworCQlwcmludGYoImVycm9yOiBkb2Vzbid0IHdvcmsgaW4gJWRiaXQgY29s
b3VyIGRlcHRoXG4iLCB2YWwpOworCQlwcmludGYoIlRoZSBjb2RlIGFzc3VtZXMgdGhhdCB0aGUg
ZnJhbWUgYnVmZmVyIGlzIGNvbmZpZ3VyZWQgIgorCQkJImluIDMyIGJpdCwgdGhhdCdzIG5vdCB0
aGUgY2FzZSBvbiB5b3VyIHN5c3RlbS5cbiIpOworCQlyZXR1cm4gLTE7CisJfQorCWZjbG9zZShm
aWxlKTsKIAogCWZkID0gb3BlbigiL2Rldi9mYjAiLCBPX1JEV1IpOwogCWlmIChmZCA9PSAtMSkK
LS0gCjEuNy41LjQKCg==
--f46d042f9318dd504904cc17d202--
