Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab0ALKCz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2010 05:02:55 -0500
Message-ID: <4B4BA01D.80005@redhat.com>
Date: Mon, 11 Jan 2010 23:03:09 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org
Subject: Re: Problem with gspca and zc3xx
References: <201001090015.31357.jareguero@telefonica.net>	<20100110093730.14be3d7c@tele>	<4B4AE349.4000707@redhat.com> <20100111105524.157ebdbe@tele>
In-Reply-To: <20100111105524.157ebdbe@tele>
Content-Type: multipart/mixed;
 boundary="------------000005050902030004070908"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000005050902030004070908
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

On 01/11/2010 10:55 AM, Jean-Francois Moine wrote:
> On Mon, 11 Jan 2010 09:37:29 +0100
> Hans de Goede<hdegoede@redhat.com>  wrote:
>
>> This is the infamous zc3xx bottom of the image is missing in 320x240
>> problem, with several sensors the register settings we took from the
>> windows driver will only give you 320x232 (iirc), we tried changing
>> them to get 320x240, but then the camera would not stream. Most
>> likely some timing issue between bridge and sensor.
>>
>> I once had a patch fixing this by actually reporting the broken modes
>> as 320x232, but that never got applied as it breaks app which are
>> hardcoded to ask for 320x240. libv4l has had the ability to extend
>> the 320x232 image to 320x240 for a while now (by adding a few black
>> lines at the top + bottom), fixing the hardcoded apps problem.
>>
>> So I think such a patch can and should be applied now. This will get
>> rid of the jpeg decompression errors reported by libv4l and in case
>> if yuv mode the ugly green bar with some random noise in it at the
>> bottom.
>>
>> I'm afraid my patch is most likely lost, but I can create a new one
>> if you want, I have access to quite a few zc3xx camera's, and more
>> over what resolution they are actually streaming at can be deducted
>> from the register settings in the driver.
>
> Hi Hans,
>
> As you may see in Jose Alberto's message, the problem occurs with
> 640x480 and, yes, the image bottom is lacking, but also the right side.
>

Hmm, the right side missing would indicate some timing issue between sensor
and bridge, but it seems this is an intermittent problem, as in Jose's
last message only the last 8 lines are missing.

As for this happening also at 640x480, I re-checked things and that is the
same problem, here is a table of the resolutions per sensor, derived
from the register settings in zc3xx.c, iow this are the resolutions we
are telling the bridge to send us!

adcm2700        640x472         320x232
cs2102          640x480         320x240
cs2102k         640x480         320x240
gc0305          640x480         320x240
hdcs2020xb      640x480         320x240
hv7131bxx       640x480         320x240
hv7131cxx       640x480         320x240
icm105axx       640x480         320x240
MC501CB         640x472         320x232
OV7620          640x472         320x232
ov7630c         640x480         320x240
pas202b         640x480         320x232
mi0360soc       640x480         320x240
pb0330          640x480         320x240
PO2030          640x480         320x240
tas5130CK       640x480         320x240
tas5130cxx      640x480         320x240
tas5130c_vf0250 640x480         320x240

> I did not lose your patch, but I did not apply it because most of the
> time, the webcams work in the best resolution (VGA) and the associated
> problem has not found yet a good resolution...

It turns out I was wrong, and the problem happens for 3 of the 4 affected
sensors at both VGA and QVGA. What we are currently doing is telling the
bridge to send us these resolutions, and then telling userspace it is
getting something different. This is just plain wrong, no but ..., it
is just *wrong*.

This makes for users getting an image out of the cam like Jose is getting
with the last 8 lines garbled. And when they start their webcam application
from a terminal the terminal fills with:
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffec
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffd9
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff
libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff

Which is because libv4l expects there to be more data then it actually
is getting, as we are *lying* to it.

I know ideally we would change the register settings to actually get
640x480 and 320x240, but that won't work when you do that the camera's
with the affected sensors won't stream at all, that is I've tried
fiddling with the register settings for a pas202b equipped cam
for hours to fix 320x240 and I got no where at all.

I've done a new version of my patch, which also fixes the affected cams
at 640x480, please apply this, as said I know this isn't ideal, but it
is better then what we currently have. If we ever find register settings
to make these cams work at normal resolutions, we can always revert this.

I've tested the attached patch with the following cams:
Philips SPC 200NC               0471:0325       zc3xx   PAS106
Logitech QuickCam IM/Connect    046d:08d9       zc3xx   HV7131R
Logitech QuickCam E2500         046d:089d       zc3xx   MC501CB
Creative WebCam NX Pro          041e:401e       zc3xx   HV7131B
No brand                        0ac8:307b       zc3xx   ADCM2700
Labtec notebook cam             046d:08aa       zc3xx   PAS202B
Creative WebCam Notebook        041e:401f       zc3xx   TAS5130C
Creative Live! Cam Video IM     041e:4053       zc3xx   TAS5130-VF250

And for the 3 affected models it fixes the garbled bottom of the
image and the libv4lconvert error messages (which people keep
submitting bugs about).

Jose,

Can you please test the attached patch, do:
install mercurial (on Fedora yum install mercurial)
hg clone http://linuxtv.org/hg/~jfrancois/gspca/
cd gscpa
patch -p1 < [path-to]/gspca_zc3xx-8lines-missing.patch
make menuconfig
[choose exit]
make
sudo make install
[reboot]

Thanks & Regards,

Hans

--------------000005050902030004070908
Content-Type: text/plain;
 name="gspca_zc3xx-8lines-missing.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="gspca_zc3xx-8lines-missing.patch"

ZGlmZiAtciA3MGIxZDYzNmEzOWEgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9nc3BjYS96
YzN4eC5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZ3NwY2EvemMzeHguYwlT
dW4gSmFuIDEwIDIzOjM0OjU3IDIwMTAgKzAxMDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRp
YS92aWRlby9nc3BjYS96YzN4eC5jCU1vbiBKYW4gMTEgMjI6NDQ6NDUgMjAxMCArMDEwMApA
QCAtMTk0LDYgKzE5NCwzNCBAQAogCQkucHJpdiA9IDB9LAogfTsKIAorLyogVkdBIHdpdGgg
bGFzdCA4IGxpbmVzIG1pc3NpbmcgKi8KK3N0YXRpYyBjb25zdCBzdHJ1Y3QgdjRsMl9waXhf
Zm9ybWF0IGJyb2tlbl92Z2FfbW9kZVtdID0geworCXszMjAsIDIzMiwgVjRMMl9QSVhfRk1U
X0pQRUcsIFY0TDJfRklFTERfTk9ORSwKKwkJLmJ5dGVzcGVybGluZSA9IDMyMCwKKwkJLnNp
emVpbWFnZSA9IDMyMCAqIDIzMiAqIDMgLyA4ICsgNTkwLAorCQkuY29sb3JzcGFjZSA9IFY0
TDJfQ09MT1JTUEFDRV9KUEVHLAorCQkucHJpdiA9IDF9LAorCXs2NDAsIDQ3MiwgVjRMMl9Q
SVhfRk1UX0pQRUcsIFY0TDJfRklFTERfTk9ORSwKKwkJLmJ5dGVzcGVybGluZSA9IDY0MCwK
KwkJLnNpemVpbWFnZSA9IDY0MCAqIDQ3MiAqIDMgLyA4ICsgNTkwLAorCQkuY29sb3JzcGFj
ZSA9IFY0TDJfQ09MT1JTUEFDRV9KUEVHLAorCQkucHJpdiA9IDB9LAorfTsKKworLyogVkdB
IHdpdGggbGFzdCA4IGxpbmVzIG1pc3NpbmcgaW4gMzIweDI0MCBtb2RlICovCitzdGF0aWMg
Y29uc3Qgc3RydWN0IHY0bDJfcGl4X2Zvcm1hdCBwYXMyMDJiX3ZnYV9tb2RlW10gPSB7CisJ
ezMyMCwgMjMyLCBWNEwyX1BJWF9GTVRfSlBFRywgVjRMMl9GSUVMRF9OT05FLAorCQkuYnl0
ZXNwZXJsaW5lID0gMzIwLAorCQkuc2l6ZWltYWdlID0gMzIwICogMjMyICogMyAvIDggKyA1
OTAsCisJCS5jb2xvcnNwYWNlID0gVjRMMl9DT0xPUlNQQUNFX0pQRUcsCisJCS5wcml2ID0g
MX0sCisJezY0MCwgNDgwLCBWNEwyX1BJWF9GTVRfSlBFRywgVjRMMl9GSUVMRF9OT05FLAor
CQkuYnl0ZXNwZXJsaW5lID0gNjQwLAorCQkuc2l6ZWltYWdlID0gNjQwICogNDgwICogMyAv
IDggKyA1OTAsCisJCS5jb2xvcnNwYWNlID0gVjRMMl9DT0xPUlNQQUNFX0pQRUcsCisJCS5w
cml2ID0gMH0sCit9OworCiBzdGF0aWMgY29uc3Qgc3RydWN0IHY0bDJfcGl4X2Zvcm1hdCBz
aWZfbW9kZVtdID0gewogCXsxNzYsIDE0NCwgVjRMMl9QSVhfRk1UX0pQRUcsIFY0TDJfRklF
TERfTk9ORSwKIAkJLmJ5dGVzcGVybGluZSA9IDE3NiwKQEAgLTY2NTEsNyArNjY3OSw4IEBA
CiAJc3RydWN0IHNkICpzZCA9IChzdHJ1Y3Qgc2QgKikgZ3NwY2FfZGV2OwogCXN0cnVjdCBj
YW0gKmNhbTsKIAlpbnQgc2Vuc29yOwotCWludCB2Z2EgPSAxOwkJLyogMTogdmdhLCAwOiBz
aWYgKi8KKwkvKiAwOiBzaWYsIDE6IHZnYSwgMjogNjQweDQ3MiwgMzIweDIzMiwgMzogNjQw
eDQ4MCwgMzIweDIzMiAqLworCWludCB2Z2EgPSAxOwogCXN0YXRpYyBjb25zdCBfX3U4IGdh
bW1hW1NFTlNPUl9NQVhdID0gewogCQk0LAkvKiBTRU5TT1JfQURDTTI3MDAgMCAqLwogCQk0
LAkvKiBTRU5TT1JfQ1MyMTAyIDEgKi8KQEAgLTY2ODksNiArNjcxOCw3IEBACiAJCQlzd2l0
Y2ggKHNkLT5zZW5zb3IpIHsKIAkJCWNhc2UgU0VOU09SX01DNTAxQ0I6CiAJCQkJUERFQlVH
KERfUFJPQkUsICJTZW5zb3IgTUM1MDFDQiIpOworCQkJCXZnYSA9IDI7IC8qIGxhc3QgOCBs
aW5lcyBtaXNzaW5nICovCiAJCQkJYnJlYWs7CiAJCQljYXNlIFNFTlNPUl9UQVM1MTMwQ19W
RjAyNTA6CiAJCQkJUERFQlVHKERfUFJPQkUsICJTZW5zb3IgVGFzNTEzMCAoVkYwMjUwKSIp
OwpAQCAtNjcyOSw2ICs2NzU5LDcgQEAKIAkJCVBERUJVRyhEX1BST0JFLCAiRmluZCBTZW5z
b3IgUEFTMjAyQiIpOwogCQkJc2QtPnNlbnNvciA9IFNFTlNPUl9QQVMyMDJCOwogCQkJc2Qt
PnNoYXJwbmVzcyA9IDE7CisJCQl2Z2EgPSAzOyAvKiBicm9rZW4gMzIweDI0MCAoY2FuIG9u
bHkgZG8gMzIweDIzMikgKi8KIAkJCWJyZWFrOwogCQljYXNlIDB4MGY6CiAJCQlQREVCVUco
RF9QUk9CRSwgIkZpbmQgU2Vuc29yIFBBUzEwNiIpOwpAQCAtNjc2NSw2ICs2Nzk2LDcgQEAK
IAkJY2FzZSAweDE2OgogCQkJUERFQlVHKERfUFJPQkUsICJGaW5kIFNlbnNvciBBRENNMjcw
MCIpOwogCQkJc2QtPnNlbnNvciA9IFNFTlNPUl9BRENNMjcwMDsKKwkJCXZnYSA9IDI7IC8q
IGxhc3QgOCBsaW5lcyBtaXNzaW5nICovCiAJCQlicmVhazsKIAkJY2FzZSAweDI5OgogCQkJ
UERFQlVHKERfUFJPQkUsICJGaW5kIFNlbnNvciBHQzAzMDUiKTsKQEAgLTY3ODIsNiArNjgx
NCw3IEBACiAJCWNhc2UgMHg3NjIwOgogCQkJUERFQlVHKERfUFJPQkUsICJGaW5kIFNlbnNv
ciBPVjc2MjAiKTsKIAkJCXNkLT5zZW5zb3IgPSBTRU5TT1JfT1Y3NjIwOworCQkJdmdhID0g
MjsgLyogbGFzdCA4IGxpbmVzIG1pc3NpbmcgKi8KIAkJCWJyZWFrOwogCQljYXNlIDB4NzYz
MToKIAkJCVBERUJVRyhEX1BST0JFLCAiRmluZCBTZW5zb3IgT1Y3NjMwQyIpOwpAQCAtNjc5
MCw2ICs2ODIzLDcgQEAKIAkJY2FzZSAweDc2NDg6CiAJCQlQREVCVUcoRF9QUk9CRSwgIkZp
bmQgU2Vuc29yIE9WNzY0OCIpOwogCQkJc2QtPnNlbnNvciA9IFNFTlNPUl9PVjc2MjA7CS8q
IHNhbWUgc2Vuc29yICg/KSAqLworCQkJdmdhID0gMjsgLyogbGFzdCA4IGxpbmVzIG1pc3Np
bmcgKi8KIAkJCWJyZWFrOwogCQlkZWZhdWx0OgogCQkJUERFQlVHKERfRVJSfERfUFJPQkUs
ICJVbmtub3duIHNlbnNvciAlMDR4Iiwgc2Vuc29yKTsKQEAgLTY4MDcsMTIgKzY4NDEsMjMg
QEAKIAljYW0gPSAmZ3NwY2FfZGV2LT5jYW07CiAvKmZpeG1lOnRlc3QqLwogCWdzcGNhX2Rl
di0+bmJhbHQtLTsKLQlpZiAodmdhKSB7CisJc3dpdGNoICh2Z2EpIHsKKwljYXNlIDA6CisJ
CWNhbS0+Y2FtX21vZGUgPSBzaWZfbW9kZTsKKwkJY2FtLT5ubW9kZXMgPSBBUlJBWV9TSVpF
KHNpZl9tb2RlKTsKKwkJYnJlYWs7CisJY2FzZSAxOgogCQljYW0tPmNhbV9tb2RlID0gdmdh
X21vZGU7CiAJCWNhbS0+bm1vZGVzID0gQVJSQVlfU0laRSh2Z2FfbW9kZSk7Ci0JfSBlbHNl
IHsKLQkJY2FtLT5jYW1fbW9kZSA9IHNpZl9tb2RlOwotCQljYW0tPm5tb2RlcyA9IEFSUkFZ
X1NJWkUoc2lmX21vZGUpOworCQlicmVhazsKKwljYXNlIDI6CisJCWNhbS0+Y2FtX21vZGUg
PSBicm9rZW5fdmdhX21vZGU7CisJCWNhbS0+bm1vZGVzID0gQVJSQVlfU0laRShicm9rZW5f
dmdhX21vZGUpOworCQlicmVhazsKKwljYXNlIDM6CisJCWNhbS0+Y2FtX21vZGUgPSBwYXMy
MDJiX3ZnYV9tb2RlOworCQljYW0tPm5tb2RlcyA9IEFSUkFZX1NJWkUocGFzMjAyYl92Z2Ff
bW9kZSk7CisJCWJyZWFrOwogCX0KIAlzZC0+YnJpZ2h0bmVzcyA9IHNkX2N0cmxzW1NEX0JS
SUdIVE5FU1NdLnFjdHJsLmRlZmF1bHRfdmFsdWU7CiAJc2QtPmNvbnRyYXN0ID0gc2RfY3Ry
bHNbU0RfQ09OVFJBU1RdLnFjdHJsLmRlZmF1bHRfdmFsdWU7Cg==
--------------000005050902030004070908--
