Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39249 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030443Ab2AFUJA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 15:09:00 -0500
Received: by iaeh11 with SMTP id h11so3091241iae.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 12:09:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0749B1.7030504@redhat.com>
References: <CAHVY3enRbcw-xKthuog5LXGMc_2tUAa0+owqbDm+C00mdWhV7w@mail.gmail.com>
 <CAHVY3emdMwEg9GPg1FMwVat3Xzn5AsoKZgveLvwHDxOFJiVtLA@mail.gmail.com>
 <CAGoCfixxiG+nxTRpLbvcy5CsktOtKk9k_3qwV4WUUhBHLaGPLQ@mail.gmail.com>
 <CAHVY3emdOaxQbCaZ1uRHTmVzfJ16aKq9yQedkDRXXowfcZYXCw@mail.gmail.com> <4F0749B1.7030504@redhat.com>
From: Mario Ceresa <mrceresa@gmail.com>
Date: Fri, 6 Jan 2012 21:08:39 +0100
Message-ID: <CAHVY3e=sFT3H0kp_HmJyibVYVpzPVJt+s_12atMS3u05-b5amg@mail.gmail.com>
Subject: Re: em28xx: no sound on board 1b80:e309 (sveon stv40)
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=14dae9340dd39d27cf04b5e19e6c
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--14dae9340dd39d27cf04b5e19e6c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mauro,
Here it is. Does the "Signed-off-by:" go in the changelog, right?

Many thanks to all the developers for the hard work: it is a joy to
see the card working :)

Best,

Mario

On 6 January 2012 20:21, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> On 06-01-2012 17:16, Mario Ceresa wrote:
>> Hello Devin, you're right: here it goes!
>
> Hi Mario,
>
> Plese send it with your Signed-off-by:
>
> It is a requirement for merging the patches upstream.
>>
>> Best,
>>
>> Mario
>>
>> On 6 January 2012 19:33, Devin Heitmueller <dheitmueller@kernellabs.com>=
 wrote:
>>> On Fri, Jan 6, 2012 at 1:29 PM, Mario Ceresa <mrceresa@gmail.com> wrote=
:
>>>> Ok boys: just to let you know that everything works now.
>>>>
>>>> thinking that the problem was with the audio input, I noticed that
>>>> card=3D64 had an amux while card=3D19 no.
>>>>
>>>> .amux =A0 =A0 =3D EM28XX_AMUX_LINE_IN,
>>>>
>>>> So I tried this card and modified the mplayer options accordingly:
>>>>
>>>> mplayer -tv device=3D/dev/video0:input=3D0:norm=3DPAL:forceaudio:alsa:=
immediatemode=3D0:audiorate=3D48000:amode=3D1:adevice=3Dhw.2
>>>> tv://
>>>>
>>>> notice the forceaudio parameter that reads the audio even if no source
>>>> is reported from v4l (The same approach with card=3D19 does not work)
>>>>
>>>> The output was a bit slugglish so I switched off pulse audio control
>>>> of the board (https://bbs.archlinux.org/viewtopic.php?id=3D114228) and
>>>> now everything is ok!
>>>>
>>>> I hope this will help some lonenly googlers in the future :)
>>>>
>>>> Regards,
>>>>
>>>> Mario
>>>
>>> Hi Mario,
>>>
>>> Since you've spent the time to figure out the details of your
>>> particular hardware, you should really consider submitting a patch to
>>> the em28xx driver which adds your device's USB ID. =A0That would allow
>>> others who have that hardware to have it work "out of the box" with no
>>> need for figuring out the correct "cardid" value through
>>> experimentation as you had to.
>>>
>>> Cheers,
>>>
>>> Devin
>>>
>>> --
>>> Devin J. Heitmueller - Kernel Labs
>>> http://www.kernellabs.com
>

--14dae9340dd39d27cf04b5e19e6c
Content-Type: text/x-patch; charset=US-ASCII; name="0001-Added-model-Sveon-STV40.patch"
Content-Disposition: attachment;
	filename="0001-Added-model-Sveon-STV40.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx3mn03g0

RnJvbSA0NTk5YzU2ZGVkYzgwZWMzNDVlZDg3YmJiYWUzNmVhYTAyMTg0MjM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJpbyBDZXJlc2EgPG1yY2VyZXNhQGdtYWlsLmNvbT4KRGF0
ZTogRnJpLCA2IEphbiAyMDEyIDIwOjAwOjEyICswMTAwClN1YmplY3Q6IFtQQVRDSF0gQWRkZWQg
bW9kZWwgU3Zlb24gU1RWNDAKClNpZ25lZC1vZmYtYnk6IE1hcmlvIENlcmVzYSA8bXJjZXJlc2FA
Z21haWwuY29tPgotLS0KIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZW0yOHh4L2VtMjh4eC1j
YXJkcy5jIHwgICAgMiArKwogMSBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDAgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9lbTI4eHgv
ZW0yOHh4LWNhcmRzLmMgYi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2VtMjh4eC9lbTI4eHgt
Y2FyZHMuYwppbmRleCA2Y2FiMjJkLi5kNzljNWQxIDEwMDY0NAotLS0gYS9saW51eC9kcml2ZXJz
L21lZGlhL3ZpZGVvL2VtMjh4eC9lbTI4eHgtY2FyZHMuYworKysgYi9saW51eC9kcml2ZXJzL21l
ZGlhL3ZpZGVvL2VtMjh4eC9lbTI4eHgtY2FyZHMuYwpAQCAtMjAzMyw2ICsyMDMzLDggQEAgc3Ry
dWN0IHVzYl9kZXZpY2VfaWQgZW0yOHh4X2lkX3RhYmxlW10gPSB7CiAJCQkuZHJpdmVyX2luZm8g
PSBFTTI4MTc0X0JPQVJEX1BDVFZfNDYwRSB9LAogCXsgVVNCX0RFVklDRSgweDIwNDAsIDB4MTYw
NSksCiAJCQkuZHJpdmVyX2luZm8gPSBFTTI4ODRfQk9BUkRfSEFVUFBBVUdFX1dJTlRWX0hWUl85
MzBDIH0sCisJeyBVU0JfREVWSUNFKDB4MWI4MCwgMHhlMzA5KSwgLyogU3Zlb24gU1RWNDAgKi8K
KwkJCS5kcml2ZXJfaW5mbyA9IEVNMjg2MF9CT0FSRF9FQVNZQ0FQIH0sIAogCXsgfSwKIH07CiBN
T0RVTEVfREVWSUNFX1RBQkxFKHVzYiwgZW0yOHh4X2lkX3RhYmxlKTsKLS0gCjEuNy43LjUKCg==
--14dae9340dd39d27cf04b5e19e6c--
