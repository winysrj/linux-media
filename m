Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:54700 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab2AFTQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 14:16:41 -0500
Received: by obcwo16 with SMTP id wo16so2241991obc.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 11:16:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfixxiG+nxTRpLbvcy5CsktOtKk9k_3qwV4WUUhBHLaGPLQ@mail.gmail.com>
References: <CAHVY3enRbcw-xKthuog5LXGMc_2tUAa0+owqbDm+C00mdWhV7w@mail.gmail.com>
 <CAHVY3emdMwEg9GPg1FMwVat3Xzn5AsoKZgveLvwHDxOFJiVtLA@mail.gmail.com> <CAGoCfixxiG+nxTRpLbvcy5CsktOtKk9k_3qwV4WUUhBHLaGPLQ@mail.gmail.com>
From: Mario Ceresa <mrceresa@gmail.com>
Date: Fri, 6 Jan 2012 20:16:19 +0100
Message-ID: <CAHVY3emdOaxQbCaZ1uRHTmVzfJ16aKq9yQedkDRXXowfcZYXCw@mail.gmail.com>
Subject: Re: em28xx: no sound on board 1b80:e309 (sveon stv40)
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=14dae9340a59734dc304b5e0e360
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--14dae9340a59734dc304b5e0e360
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Devin, you're right: here it goes!

Best,

Mario

On 6 January 2012 19:33, Devin Heitmueller <dheitmueller@kernellabs.com> wr=
ote:
> On Fri, Jan 6, 2012 at 1:29 PM, Mario Ceresa <mrceresa@gmail.com> wrote:
>> Ok boys: just to let you know that everything works now.
>>
>> thinking that the problem was with the audio input, I noticed that
>> card=3D64 had an amux while card=3D19 no.
>>
>> .amux =A0 =A0 =3D EM28XX_AMUX_LINE_IN,
>>
>> So I tried this card and modified the mplayer options accordingly:
>>
>> mplayer -tv device=3D/dev/video0:input=3D0:norm=3DPAL:forceaudio:alsa:im=
mediatemode=3D0:audiorate=3D48000:amode=3D1:adevice=3Dhw.2
>> tv://
>>
>> notice the forceaudio parameter that reads the audio even if no source
>> is reported from v4l (The same approach with card=3D19 does not work)
>>
>> The output was a bit slugglish so I switched off pulse audio control
>> of the board (https://bbs.archlinux.org/viewtopic.php?id=3D114228) and
>> now everything is ok!
>>
>> I hope this will help some lonenly googlers in the future :)
>>
>> Regards,
>>
>> Mario
>
> Hi Mario,
>
> Since you've spent the time to figure out the details of your
> particular hardware, you should really consider submitting a patch to
> the em28xx driver which adds your device's USB ID. =A0That would allow
> others who have that hardware to have it work "out of the box" with no
> need for figuring out the correct "cardid" value through
> experimentation as you had to.
>
> Cheers,
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

--14dae9340a59734dc304b5e0e360
Content-Type: text/x-patch; charset=US-ASCII; name="0001-Added-model-Sveon-STV40.patch"
Content-Disposition: attachment;
	filename="0001-Added-model-Sveon-STV40.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx3l36u30

RnJvbSBkZDMzNDY2M2IyMDJlYjA1NjliNTA2MjczYzc1ZjNhMGVkZTZiODAzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJpbyBDZXJlc2EgPG1yY2VyZXNhQGdtYWlsLmNvbT4KRGF0
ZTogRnJpLCA2IEphbiAyMDEyIDIwOjAwOjEyICswMTAwClN1YmplY3Q6IFtQQVRDSF0gQWRkZWQg
bW9kZWwgU3Zlb24gU1RWNDAKCi0tLQogbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9lbTI4eHgv
ZW0yOHh4LWNhcmRzLmMgfCAgICAyICsrCiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L2VtMjh4eC9lbTI4eHgtY2FyZHMuYyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZW0yOHh4
L2VtMjh4eC1jYXJkcy5jCmluZGV4IDZjYWIyMmQuLmQ3OWM1ZDEgMTAwNjQ0Ci0tLSBhL2xpbnV4
L2RyaXZlcnMvbWVkaWEvdmlkZW8vZW0yOHh4L2VtMjh4eC1jYXJkcy5jCisrKyBiL2xpbnV4L2Ry
aXZlcnMvbWVkaWEvdmlkZW8vZW0yOHh4L2VtMjh4eC1jYXJkcy5jCkBAIC0yMDMzLDYgKzIwMzMs
OCBAQCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBlbTI4eHhfaWRfdGFibGVbXSA9IHsKIAkJCS5kcml2
ZXJfaW5mbyA9IEVNMjgxNzRfQk9BUkRfUENUVl80NjBFIH0sCiAJeyBVU0JfREVWSUNFKDB4MjA0
MCwgMHgxNjA1KSwKIAkJCS5kcml2ZXJfaW5mbyA9IEVNMjg4NF9CT0FSRF9IQVVQUEFVR0VfV0lO
VFZfSFZSXzkzMEMgfSwKKwl7IFVTQl9ERVZJQ0UoMHgxYjgwLCAweGUzMDkpLCAvKiBTdmVvbiBT
VFY0MCAqLworCQkJLmRyaXZlcl9pbmZvID0gRU0yODYwX0JPQVJEX0VBU1lDQVAgfSwgCiAJeyB9
LAogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUodXNiLCBlbTI4eHhfaWRfdGFibGUpOwotLSAKMS43
LjcuNQoK
--14dae9340a59734dc304b5e0e360--
