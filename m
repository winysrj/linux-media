Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:23038 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZL3J4F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 04:56:05 -0500
Received: by ey-out-2122.google.com with SMTP id 25so1678098eya.19
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2009 01:56:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c2fe070d0912181352j7c8a8085sf14d8ea68fe63ddb@mail.gmail.com>
References: <20091218184604.GA24444@pathfinder.pcs.usp.br>
	 <20091218201349.69ca27a5@tele>
	 <c2fe070d0912181352j7c8a8085sf14d8ea68fe63ddb@mail.gmail.com>
Date: Wed, 30 Dec 2009 04:56:03 -0500
Message-ID: <c2fe070d0912300156o28c34842g43b5c90bcb48f765@mail.gmail.com>
Subject: Re: patch to support for 0x0802 sensor in t613.c
From: leandro Costantino <lcostantino@gmail.com>
To: Nicolau Werneck <nwerneck@gmail.com>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary=0016e6d7e0a97e7347047bef2512
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0016e6d7e0a97e7347047bef2512
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Nicoulau,
could you try the attached patch and add the Signed-Off by  so we can
merge it???
It's your patch, just removed some lines.

Best Regards


On Fri, Dec 18, 2009 at 4:52 PM, leandro Costantino
<lcostantino@gmail.com> wrote:
> Nicolau, if you need help, let me know.
> I also, sent you some mails asking for the patch for review some weeks
> ago, i thougth you were missing :)
> good woork
> best regards
>
> On Fri, Dec 18, 2009 at 8:13 PM, Jean-Francois Moine <moinejf@free.fr> wr=
ote:
>> On Fri, 18 Dec 2009 16:46:04 -0200
>> Nicolau Werneck <nwerneck@gmail.com> wrote:
>>
>>> Hello. I am a clueless n00b, and I can't make patches or use any
>>> proper development tools. But I made this modification to t613.c to
>>> support this new sensor. It is working fine with me. I just cleaned
>>> the code up a bit and compiled and tested with the 2.6.32 kernel, and
>>> it seems to be working fine.
>>>
>>> If somebody could help me creating a proper patch to submit to the
>>> source tree, I would be most grateful. The code is attached.
>>
>> Hello Nicolau,
>>
>> Your code seems fine. To create a patch, just go to the linux tree
>> root, make a 'diff -u' from the original file to your new t613.c, edit
>> it, at the head, add a comment and a 'Signed-off-by: <your email>', and
>> submit to the mailing-list with subject '[PATCH] gspca - t613: Add new
>> sensor lt168g'.
>>
>> BTW, as you know the name of your sensor, do you know the real name of
>> the sensor '0x803' ('other')? (it should be in some xxx.ini file in a
>> ms-win driver, but I could not find it - the table n4_other of t613.c
>> should be a table 'Regxxx' in the xx.ini)
>>
>> Best regards.
>>
>> --
>> Ken ar c'henta=C5=84 | =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ** Brei=
zh ha Linux atav! **
>> Jef =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 http://moinejf.free.fr/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" i=
n
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>>
>

--0016e6d7e0a97e7347047bef2512
Content-Type: text/x-patch; charset=US-ASCII; name="gspca-t613-lt168g-sensor.patch"
Content-Disposition: attachment; filename="gspca-t613-lt168g-sensor.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3uag3ku0

ZGlmZiAtTnJ1IGdzcGNhLTU0YTU3Yjc1Zjk4Yy9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2dz
cGNhL3Q2MTMuYyBnc3BjYS01NGE1N2I3NWY5OGMtZGV2L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlk
ZW8vZ3NwY2EvdDYxMy5jCi0tLSBnc3BjYS01NGE1N2I3NWY5OGMvbGludXgvZHJpdmVycy9tZWRp
YS92aWRlby9nc3BjYS90NjEzLmMJMjAwOS0xMi0zMCAwMjo1MzowNy4wMDAwMDAwMDAgLTA1MDAK
KysrIGdzcGNhLTU0YTU3Yjc1Zjk4Yy1kZXYvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9nc3Bj
YS90NjEzLmMJMjAwOS0xMi0zMCAxMDo1Mjo0Ny4wMDAwMDAwMDAgLTA1MDAKQEAgLTUyLDYgKzUy
LDcgQEAKICNkZWZpbmUgU0VOU09SX09NNjgwMiAwCiAjZGVmaW5lIFNFTlNPUl9PVEhFUiAxCiAj
ZGVmaW5lIFNFTlNPUl9UQVM1MTMwQSAyCisjZGVmaW5lIFNFTlNPUl9MVDE2OEcgMyAgICAgLyog
bXVzdCB2ZXJpZnkgaWYgdGhpcyBpcyB0aGUgYWN0dWFsIG1vZGVsICovCiB9OwogCiAvKiBWNEwy
IGNvbnRyb2xzIHN1cHBvcnRlZCBieSB0aGUgZHJpdmVyICovCkBAIC0zMDYsNiArMzA3LDE3IEBA
CiAJMHhiZSwgMHgzNiwgMHhiZiwgMHhmZiwgMHhjMiwgMHg4OCwgMHhjNSwgMHhjOCwKIAkweGM2
LCAweGRhCiB9Oworc3RhdGljIGNvbnN0IHU4IG40X2x0MTY4Z1tdID0geworCTB4NjYsIDB4MDEs
IDB4N2YsIDB4MDAsIDB4ODAsIDB4N2MsIDB4ODEsIDB4MjgsCisJMHg4MywgMHg0NCwgMHg4NCwg
MHgyMCwgMHg4NiwgMHgyMCwgMHg4YSwgMHg3MCwKKwkweDhiLCAweDU4LCAweDhjLCAweDg4LCAw
eDhkLCAweGEwLCAweDhlLCAweGIzLAorCTB4OGYsIDB4MjQsIDB4YTEsIDB4YjAsIDB4YTIsIDB4
MzgsIDB4YTUsIDB4MjAsCisJMHhhNiwgMHg0YSwgMHhhOCwgMHhlOCwgMHhhZiwgMHgzOCwgMHhi
MCwgMHg2OCwKKwkweGIxLCAweDQ0LCAweGIyLCAweDg4LCAweGJiLCAweDg2LCAweGJkLCAweDQw
LAorCTB4YmUsIDB4MjYsIDB4YzEsIDB4MDUsIDB4YzIsIDB4ODgsIDB4YzUsIDB4YzAsCisJMHhk
YSwgMHg4ZSwgMHhkYiwgMHhjYSwgMHhkYywgMHhhOCwgMHhkZCwgMHg4YywKKwkweGRlLCAweDQ0
LCAweGRmLCAweDBjLCAweGU5LCAweDgwCit9OwogCiBzdGF0aWMgY29uc3Qgc3RydWN0IGFkZGl0
aW9uYWxfc2Vuc29yX2RhdGEgc2Vuc29yX2RhdGFbXSA9IHsKICAgICB7CQkJCS8qIDA6IE9NNjgw
MiAqLwpAQCAtNDIyLDYgKzQzNCwyMyBAQAogCS5zdHJlYW0gPQogCQl7MHgwYiwgMHgwNCwgMHgw
YSwgMHg0MH0sCiAgICAgfSwKKyAgICB7CQkJCS8qIDM6IExUMTY4RyAqLworCS5uMyA9IHsweDYx
LCAweGMyLCAweDY1LCAweDY4LCAweDYwLCAweDAwfSwKKwkubjQgPSBuNF9sdDE2OGcsCisJLm40
c3ogPSBzaXplb2YgbjRfbHQxNjhnLAorCS5yZWc4MCA9IDB4N2MsCisJLnJlZzhlID0gMHhiMywK
KwkubnNldDggPSB7MHhhOCwgMHhmMCwgMHhjNiwgMHhiYSwgMHhjMCwgMHgwMH0sCisJLmRhdGEx
ID0gezB4YzAsIDB4MzgsIDB4MDgsIDB4MTAsIDB4YzAsIDB4MzAsIDB4MTAsIDB4NDAsCisJCSAw
eGIwLCAweGY0fSwKKwkuZGF0YTIgPSB7MHg0MCwgMHg4MCwgMHhjMCwgMHg1MCwgMHhhMCwgMHhm
MCwgMHg1MywgMHhhNiwKKwkJIDB4ZmZ9LAorCS5kYXRhMyA9IHsweDQwLCAweDgwLCAweGMwLCAw
eDUwLCAweGEwLCAweGYwLCAweDUzLCAweGE2LAorCQkgMHhmZn0sCisJLmRhdGE0ID0gezB4NjYs
IDB4NDEsIDB4YTgsIDB4ZjB9LAorCS5kYXRhNSA9IHsweDBjLCAweDAzLCAweGFiLCAweDRiLCAw
eDgxLCAweDJifSwKKwkuc3RyZWFtID0gezB4MGIsIDB4MDQsIDB4MGEsIDB4Mjh9LAorICAgIH0s
CiB9OwogCiAjZGVmaW5lIE1BWF9FRkZFQ1RTIDcKQEAgLTc1OCw2ICs3ODcsMTAgQEAKIAkJUERF
QlVHKERfUFJPQkUsICJzZW5zb3IgdGFzNTEzMGEiKTsKIAkJc2QtPnNlbnNvciA9IFNFTlNPUl9U
QVM1MTMwQTsKIAkJYnJlYWs7CisJY2FzZSAweDA4MDI6CisJCVBERUJVRyhEX1BST0JFLCAic2Vu
c29yIGx0MTY4ZyIpOworCQlzZC0+c2Vuc29yID0gU0VOU09SX0xUMTY4RzsKKwkJYnJlYWs7CiAJ
Y2FzZSAweDA4MDM6CiAJCVBERUJVRyhEX1BST0JFLCAic2Vuc29yICdvdGhlciciKTsKIAkJc2Qt
PnNlbnNvciA9IFNFTlNPUl9PVEhFUjsKQEAgLTgwMCw2ICs4MzMsMTMgQEAKIAlyZWdfd19idWYo
Z3NwY2FfZGV2LCBzZW5zb3ItPm4zLCBzaXplb2Ygc2Vuc29yLT5uMyk7CiAJcmVnX3dfYnVmKGdz
cGNhX2Rldiwgc2Vuc29yLT5uNCwgc2Vuc29yLT5uNHN6KTsKIAorCWlmIChzZC0+c2Vuc29yID09
IFNFTlNPUl9MVDE2OEcpIHsKKwkJdGVzdF9ieXRlID0gcmVnX3IoZ3NwY2FfZGV2LCAweDgwKTsK
KwkJUERFQlVHKERfU1RSRUFNLCAiUmVnIDB4JTAyeCA9IDB4JTAyeCIsIDB4ODAsCisJCSAgICAg
ICB0ZXN0X2J5dGUpOworCQlyZWdfdyhnc3BjYV9kZXYsIDB4NmM4MCk7CisJfQorCiAJcmVnX3df
aXhidWYoZ3NwY2FfZGV2LCAweGQwLCBzZW5zb3ItPmRhdGExLCBzaXplb2Ygc2Vuc29yLT5kYXRh
MSk7CiAJcmVnX3dfaXhidWYoZ3NwY2FfZGV2LCAweGM3LCBzZW5zb3ItPmRhdGEyLCBzaXplb2Yg
c2Vuc29yLT5kYXRhMik7CiAJcmVnX3dfaXhidWYoZ3NwY2FfZGV2LCAweGUwLCBzZW5zb3ItPmRh
dGEzLCBzaXplb2Ygc2Vuc29yLT5kYXRhMyk7CkBAIC04MjQsNiArODY0LDEzIEBACiAJcmVnX3df
YnVmKGdzcGNhX2Rldiwgc2Vuc29yLT5uc2V0OCwgc2l6ZW9mIHNlbnNvci0+bnNldDgpOwogCXJl
Z193X2J1Zihnc3BjYV9kZXYsIHNlbnNvci0+c3RyZWFtLCBzaXplb2Ygc2Vuc29yLT5zdHJlYW0p
OwogCisJaWYgKHNkLT5zZW5zb3IgPT0gU0VOU09SX0xUMTY4RykgeworCQl0ZXN0X2J5dGUgPSBy
ZWdfcihnc3BjYV9kZXYsIDB4ODApOworCQlQREVCVUcoRF9TVFJFQU0sICJSZWcgMHglMDJ4ID0g
MHglMDJ4IiwgMHg4MCwKKwkJICAgICAgIHRlc3RfYnl0ZSk7CisJCXJlZ193KGdzcGNhX2Rldiwg
MHg2YzgwKTsKKwl9CisKIAlyZWdfd19peGJ1Zihnc3BjYV9kZXYsIDB4ZDAsIHNlbnNvci0+ZGF0
YTEsIHNpemVvZiBzZW5zb3ItPmRhdGExKTsKIAlyZWdfd19peGJ1Zihnc3BjYV9kZXYsIDB4Yzcs
IHNlbnNvci0+ZGF0YTIsIHNpemVvZiBzZW5zb3ItPmRhdGEyKTsKIAlyZWdfd19peGJ1Zihnc3Bj
YV9kZXYsIDB4ZTAsIHNlbnNvci0+ZGF0YTMsIHNpemVvZiBzZW5zb3ItPmRhdGEzKTsKQEAgLTkz
MCw2ICs5NzcsOCBAQAogCWNhc2UgU0VOU09SX09NNjgwMjoKIAkJb202ODAyX3NlbnNvcl9pbml0
KGdzcGNhX2Rldik7CiAJCWJyZWFrOworCWNhc2UgU0VOU09SX0xUMTY4RzoKKwkJYnJlYWs7CiAJ
Y2FzZSBTRU5TT1JfT1RIRVI6CiAJCWJyZWFrOwogCWRlZmF1bHQ6Cg==
--0016e6d7e0a97e7347047bef2512--
