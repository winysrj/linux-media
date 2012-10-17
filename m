Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48749 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354Ab2JQJfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 05:35:37 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so6909279pad.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 02:35:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4949132.OD6tNZX2Jk@avalon>
References: <090701cd8c4e$be38bea0$3aaa3be0$@gmail.com>
	<7805846.LU2Ezfa4XS@avalon>
	<CAFqH_50FiyMiQHiTwhu82shJVb-boZ+KSu8sTwaFQxsPGA=sfA@mail.gmail.com>
	<4949132.OD6tNZX2Jk@avalon>
Date: Wed, 17 Oct 2012 11:35:37 +0200
Message-ID: <CAFqH_53G_jt1LdTiHtqnGKkqK8mmCOgt-ypQzpzjwpdytpsgzQ@mail.gmail.com>
Subject: Re: Using omap3-isp-live example application on beagleboard with DVI
From: Enric Balletbo Serra <eballetbo@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: John Weber <rjohnweber@gmail.com>, linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d042e00d13f285b04cc3dfe84
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--f46d042e00d13f285b04cc3dfe84
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

2012/10/17 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Enric,
>
> On Monday 15 October 2012 14:03:20 Enric Balletbo Serra wrote:
>> 2012/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> > On Thursday 11 October 2012 10:14:26 Enric Balletb=C3=B2 i Serra wrote=
:
>> >> 2012/10/10 Enric Balletb=C3=B2 i Serra <eballetbo@gmail.com>:
>> >> > 2012/9/6 John Weber <rjohnweber@gmail.com>:
>> >> >> Hello,
>> >> >>
>> >> >> My goal is to better understand how to write an application that m=
akes
>> >> >> use of the omap3isp and media controller frameworks and v4l2.  I'm
>> >> >> attempting to make use of Laurent's omap3-isp-live example applica=
tion
>> >> >> as a starting point and play with the AEC/WB capability.
>> >> >>
>> >> >> My problem is that when I start the live application, the display
>> >> >> turns blue (it seems when the chromakey fill is done), but no vide=
o
>> >> >> appears on the display.  I do think that I'm getting good (or at l=
east
>> >> >> statistics) from the ISP because I can change the view in front of=
 the
>> >> >> camera (by putting my hand in front of the lens) and the gain sett=
ings
>> >> >> change.
>
> [snip]
>
>> >> > I've exactly the same problem. Before try to debug the problem I wo=
uld
>> >> > like to know if you solved the problem. Did you solved ?
>> >>
>> >> The first change I made and worked (just luck). I made the following
>> >> change:
>> >>
>> >> -       vo_enable_colorkey(vo, 0x123456);
>> >> +       // vo_enable_colorkey(vo, 0x123456);
>> >>
>> >> And now the live application works like a charm. Seems this function
>> >> enables a chromakey and the live application can't paint over the
>> >> chromakey. Laurent, just to understand what I did, can you explain
>> >> this ? Thanks.
>> >
>> > My guess is that the live application fails to paint the frame buffer =
with
>> > the color key. If fb_init() failed the live application would stop, so
>> > the function succeeds. My guess is thus that the application either
>> > paints the wrong frame buffer (how many /dev/fb* devices do you have o=
n
>> > your system ?),
>>
>> I checked again and no, it opens the correct framebuffer.
>>
>> > or paints it with the wrong color. The code assumes that the frame buf=
fer
>> > is configured in 32 bit, maybe that's not the case on your system ?
>>
>> This was my problem, and I suspect it's the John problem. My system was
>> configured in 16 bit instead of 32 bit.
>>
>> FYI, I made a patch that adds this check to the live application. I did =
not
>> know where send the patch so I attached to this email.
>
> Thank you for the patch.
>
> Instead of failing what would be more interesting would be to get the
> application to work in 16bpp mode as well. For that you will need to pain=
t the
> frame buffer with a 16bpp color, and set the colorkey to the same value. =
Would
> you be able to try that ?
>

New patch attached, comments are welcome as I'm newbie with video devices.

Regards,
    Enric

--f46d042e00d13f285b04cc3dfe84
Content-Type: application/octet-stream;
	name="0001-live-Get-the-application-to-work-in-16bpp-mode.patch"
Content-Disposition: attachment;
	filename="0001-live-Get-the-application-to-work-in-16bpp-mode.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8e8w2r40

RnJvbSA2ZTIyNzRiOTRjZWM5YzFkMDNmNTgyMTQ4MzkyMGRlNjllNWFiYThlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFbnJpYyBCYWxsZXRibyBpIFNlcnJhIDxlYmFsbGV0Ym9AaXNl
ZWJjbi5jb20+CkRhdGU6IFdlZCwgMTcgT2N0IDIwMTIgMTE6MjI6NTkgKzAyMDAKU3ViamVjdDog
W1BBVENIXSBsaXZlOiBHZXQgdGhlIGFwcGxpY2F0aW9uIHRvIHdvcmsgaW4gMTZicHAgbW9kZS4K
ClNldCB0aGUgZnJhbWVidWZmZXIgd2l0aCBhIDE2YnBwIGNvbG9yIGFuZCBzZXQgdGhlIGNvbG9y
a2V5IHRvIHRoZSBzYW1lCnZhbHVlIHdoZW4gZnJhbWUgYnVmZmVyIGlzIGNvbmZpZ3VyZWQgaW4g
MTYgYml0LiBXaXRoIHRoaXMgcGF0Y2ggd2UKc3VwcG9ydCAxNiBhbmQgMzIgYml0LCBpZiB0aGlz
IGlzIG5vdCB0aGUgY2FzZSB0aGUgYXBwbGljYXRpb24gZmFpbHMuCgpTaWduZWQtb2ZmLWJ5OiBF
bnJpYyBCYWxsZXRibyBpIFNlcnJhIDxlYmFsbGV0Ym9AaXNlZWJjbi5jb20+Ci0tLQogbGl2ZS5j
IHwgICA1NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgNDkgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9saXZlLmMgYi9saXZlLmMKaW5kZXggNTEyYzUyOS4uNzYyYzlmMyAxMDA2
NDQKLS0tIGEvbGl2ZS5jCisrKyBiL2xpdmUuYwpAQCAtMjU5LDcgKzI1OSwzMiBAQCBzdGF0aWMg
Y29uc3QgY2hhciAqdmlkZW9fb3V0X2ZpbmQodm9pZCkKICAqIEZyYW1lIGJ1ZmZlcgogICovCiAK
LXN0YXRpYyBpbnQgZmJfaW5pdChzdHJ1Y3QgdjRsMl9yZWN0ICpyZWN0KQorc3RhdGljIGludCBm
Yl9nZXRfY29sb3JfZGVwdGgodm9pZCkKK3sKKwlpbnQgcmV0LCBicHA7CisJRklMRSAqZmlsZTsK
KworCS8qIFJlYWQgdGhlIGZyYW1lYnVmZmVyIGJpdC1wZXItcGl4ZWwgZnJvbSBzeXNmcy4gKi8K
KwlmaWxlID0gZm9wZW4oIi9zeXMvY2xhc3MvZ3JhcGhpY3MvZmIwL2JpdHNfcGVyX3BpeGVsIiwg
InIiKTsKKwlpZiAoZmlsZSA9PSBOVUxMKSB7CisJCXBlcnJvcigiRmFpbGVkIHRvIG9wZW4gYml0
c19wZXJfcGl4ZWwgZm9yIGZiMFxuIik7CisJCXJldHVybiAtMTsKKwl9CisKKwlyZXQgPSBmc2Nh
bmYoZmlsZSwgIiVkIiwgJmJwcCk7CisJaWYgKHJldCA9PSBFT0YpIHsKKwkJaWYgKGZlcnJvcihm
aWxlKSkKKwkJCXBlcnJvcigiZnNjYW5mIik7CisJCWVsc2UKKwkJCXByaW50ZigiZXJyb3I6IGZz
Y2FuZiBtYXRjaGluZyBmYWlsdXJlXG4iKTsKKwkJcmV0dXJuIC0xOworCX0KKwlmY2xvc2UoZmls
ZSk7CisKKwlyZXR1cm4gYnBwOworfQorCitzdGF0aWMgaW50IGZiX2luaXQoc3RydWN0IHY0bDJf
cmVjdCAqcmVjdCwgaW50IGJwcCkKIHsKIAlzdHJ1Y3QgZmJfZml4X3NjcmVlbmluZm8gZml4Owog
CXN0cnVjdCBmYl92YXJfc2NyZWVuaW5mbyB2YXI7CkBAIC0yOTMsOCArMzE4LDE3IEBAIHN0YXRp
YyBpbnQgZmJfaW5pdChzdHJ1Y3QgdjRsMl9yZWN0ICpyZWN0KQogCX0KIAogCS8qIEZpbGwgdGhl
IGZyYW1lIGJ1ZmZlciB3aXRoIHRoZSBiYWNrZ3JvdW5kIGNvbG9yLiAqLwotCWZvciAoaSA9IDA7
IGkgPCBmaXguc21lbV9sZW47IGkgKz0gNCkKLQkJKih1aW50MzJfdCAqKShtZW0gKyBpKSA9IDB4
MDAxMjM0NTY7CisJaWYgKGJwcCA9PSAxNikKKwkJZm9yIChpID0gMDsgaSA8IGZpeC5zbWVtX2xl
bjsgaSArPSAyKQorCQkJKih1aW50MTZfdCAqKShtZW0gKyBpKSA9IDB4MTIzNDsKKwllbHNlIGlm
IChicHAgPT0gMzIpCisJCWZvciAoaSA9IDA7IGkgPCBmaXguc21lbV9sZW47IGkgKz0gNCkKKwkJ
CSoodWludDMyX3QgKikobWVtICsgaSkgPSAweDAwMTIzNDU2OworCWVsc2UgeworCQlwcmludGYo
ImVycm9yOiBkb2Vzbid0IHdvcmsgaW4gJWRiaXQgY29sb3VyIGRlcHRoXG4iLCBicHApOworCQly
ZXQgPSAtMTsKKwkJZ290byBkb25lOworCX0KIAogCS8qIFJldHVybiB0aGUgZnJhbWUgYnVmZmVy
IHNpemUuICovCiAJcmVjdC0+bGVmdCA9IHZhci54b2Zmc2V0OwpAQCAtMzY4LDYgKzQwMiw3IEBA
IGludCBtYWluKGludCBhcmdjIF9fYXR0cmlidXRlX18oKF9fdW51c2VkX18pKSwgY2hhciAqYXJn
dltdIF9fYXR0cmlidXRlX18oKF9fdW51CiAJZmxvYXQgZnBzOwogCWludCByZXQ7CiAJaW50IGM7
CisJaW50IGJwcDsKIAogCWlxX3BhcmFtc19pbml0KCZpcV9wYXJhbXMpOwogCkBAIC00MDMsOCAr
NDM4LDE0IEBAIGludCBtYWluKGludCBhcmdjIF9fYXR0cmlidXRlX18oKF9fdW51c2VkX18pKSwg
Y2hhciAqYXJndltdIF9fYXR0cmlidXRlX18oKF9fdW51CiAKIAlldmVudHNfaW5pdCgmZXZlbnRz
KTsKIAorCWJwcCA9IGZiX2dldF9jb2xvcl9kZXB0aCgpOworCWlmIChicHAgPCAwKSB7CisJCXBy
aW50ZigiZXJyb3I6IGRvZXNuJ3Qgd29yayBpbiAlZGJpdCBjb2xvdXIgZGVwdGhcbiIsIGJwcCk7
CisJCWdvdG8gY2xlYW51cDsKKwl9CisKIAltZW1zZXQoJnJlY3QsIDAsIHNpemVvZiByZWN0KTsK
LQlyZXQgPSBmYl9pbml0KCZyZWN0KTsKKwlyZXQgPSBmYl9pbml0KCZyZWN0LCBicHApOwogCWlm
IChyZXQgPCAwKSB7CiAJCXByaW50ZigiZXJyb3I6IHVuYWJsZSB0byBpbml0aWFsaXplIGZyYW1l
IGJ1ZmZlclxuIik7CiAJCWdvdG8gY2xlYW51cDsKQEAgLTQ2MCw3ICs1MDEsMTAgQEAgaW50IG1h
aW4oaW50IGFyZ2MgX19hdHRyaWJ1dGVfXygoX191bnVzZWRfXykpLCBjaGFyICphcmd2W10gX19h
dHRyaWJ1dGVfXygoX191bnUKIAkJZ290byBjbGVhbnVwOwogCX0KIAotCXZvX2VuYWJsZV9jb2xv
cmtleSh2bywgMHgxMjM0NTYpOworCWlmIChicHAgPT0gMzIpCisJCXZvX2VuYWJsZV9jb2xvcmtl
eSh2bywgMHgxMjM0NTYpOworCWVsc2UKKwkJdm9fZW5hYmxlX2NvbG9ya2V5KHZvLCAweDEyMzQp
OwogCiAJLyogQWxsb2NhdGUgYSBidWZmZXJzIHBvb2wgYW5kIHVzZSBpdCBmb3IgdGhlIHZpZXdm
aW5kZXIuICovCiAJcG9vbCA9IHZvX2dldF9wb29sKHZvKTsKLS0gCjEuNy41LjQKCg==
--f46d042e00d13f285b04cc3dfe84--
