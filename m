Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:42160 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZGTUhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 16:37:10 -0400
Received: by ewy26 with SMTP id 26so2591162ewy.37
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 13:37:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907201949.n6KJnOdY016111@demeter.kernel.org>
References: <bug-13708-12914@http.bugzilla.kernel.org/>
	 <200907201949.n6KJnOdY016111@demeter.kernel.org>
Date: Mon, 20 Jul 2009 22:37:08 +0200
Message-ID: <5c3736670907201337n41f08957r94fcde4383dd74d9@mail.gmail.com>
Subject: Re: [Bug 13708] Aiptek DV-T300 support is incomplete
From: =?ISO-8859-1?Q?Bal=E1zs_H=E1morszky?= <balihb@gmail.com>
To: bugzilla-daemon@bugzilla.kernel.org, mchehab@infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016364c78071426ae046f291a01
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0016364c78071426ae046f291a01
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I don't have my kernel tree with me (I'm at vacation atm.). The patch
is made with only the -uN options, but I can make a new one on Friday
(if needed).

Thanks for the help!

On Mon, Jul 20, 2009 at 21:49, <bugzilla-daemon@bugzilla.kernel.org> wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=3D13708
>
>
> Andrew Morton <akpm@linux-foundation.org> changed:
>
> =A0 =A0 =A0 =A0 =A0 What =A0 =A0|Removed =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 |Added
> -------------------------------------------------------------------------=
---
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CC| =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0|akpm@linux-foundation.org
>
>
>
>
> --- Comment #2 from Andrew Morton <akpm@linux-foundation.org> =A02009-07-=
20 19:49:22 ---
> It's quite painful to handle patches via bugzilla. =A0Could you resend it=
 via
> email please? =A0Documentation/SubmittingPatches has some details.
>
> Suitable recipients are
>
> Mauro Carvalho Chehab <mchehab@infradead.org>
> Andrew Morton <akpm@linux-foundation.org>
> linux-media@vger.kernel.org
>
> Thanks.
>
> --
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
> ------- You are receiving this mail because: -------
> You reported the bug.
>

--0016364c78071426ae046f291a01
Content-Type: text/x-diff; charset=US-ASCII; name="zr364xx.patch"
Content-Disposition: attachment; filename="zr364xx.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fxdn7s1s0

LS0tIHpyMzY0eHgtbmVtbXV4LWRlLXVqLTIuNi4zMC11cGdyYWRlLXV0YW4tMjAwOTA3MDQuYwky
MDA5LTA3LTA0IDIzOjI5OjUxLjAwMDAwMDAwMCArMDIwMAorKysgenIzNjR4eC1uZW1tdXgtZGUt
dWotMi42LjMwLXVwZ3JhZGUtZWxvdHQtMjAwOTA2MjcuYwkyMDA5LTA2LTI3IDE0OjM3OjUxLjAw
MDAwMDAwMCArMDIwMApAQCAtNTksNiArNTksNyBAQAogI2RlZmluZSBNRVRIT0QwIDAKICNkZWZp
bmUgTUVUSE9EMSAxCiAjZGVmaW5lIE1FVEhPRDIgMgorI2RlZmluZSBNRVRIT0QzIDMKIAogCiAv
KiBNb2R1bGUgcGFyYW1ldGVycyAqLwpAQCAtOTUsNyArOTYsNyBAQAogCXtVU0JfREVWSUNFKDB4
MDZkNiwgMHgwMDNiKSwgLmRyaXZlcl9pbmZvID0gTUVUSE9EMCB9LAogCXtVU0JfREVWSUNFKDB4
MGExNywgMHgwMDRlKSwgLmRyaXZlcl9pbmZvID0gTUVUSE9EMiB9LAogCXtVU0JfREVWSUNFKDB4
MDQxZSwgMHg0MDVkKSwgLmRyaXZlcl9pbmZvID0gTUVUSE9EMiB9LAotCXtVU0JfREVWSUNFKDB4
MDhjYSwgMHgyMTAyKSwgLmRyaXZlcl9pbmZvID0gTUVUSE9EMiB9LAorCXtVU0JfREVWSUNFKDB4
MDhjYSwgMHgyMTAyKSwgLmRyaXZlcl9pbmZvID0gTUVUSE9EMyB9LAogCXt9CQkJLyogVGVybWlu
YXRpbmcgZW50cnkgKi8KIH07CiAKQEAgLTIxMyw3ICsyMTQsNyBAQAogfTsKIAogLyogaW5pdCB0
YWJsZSAqLwotc3RhdGljIG1lc3NhZ2UgKmluaXRbM10gPSB7IG0wLCBtMSwgbTIgfTsKK3N0YXRp
YyBtZXNzYWdlICppbml0WzRdID0geyBtMCwgbTEsIG0yLCBtMiB9OwogCiAKIC8qIEpQRUcgc3Rh
dGljIGRhdGEgaW4gaGVhZGVyIChIdWZmbWFuIHRhYmxlLCBldGMpICovCkBAIC0zNDcsNiArMzQ4
LDExIEBACiAJCQkgICAgY2FtLT5idWZmZXJbM10sIGNhbS0+YnVmZmVyWzRdLCBjYW0tPmJ1ZmZl
cls1XSwKIAkJCSAgICBjYW0tPmJ1ZmZlcls2XSwgY2FtLT5idWZmZXJbN10sIGNhbS0+YnVmZmVy
WzhdKTsKIAkJfSBlbHNlIHsKKwkJCWlmIChwdHIgKyBhY3R1YWxfbGVuZ3RoIC0ganBlZyA+IE1B
WF9GUkFNRV9TSVpFKQorCQkJeworCQkJCURCRygiZnJhbWUgdG9vIGJpZyEiKTsKKwkJCQlyZXR1
cm4gMDsKKwkJCX0KIAkJCW1lbWNweShwdHIsIGNhbS0+YnVmZmVyLCBhY3R1YWxfbGVuZ3RoKTsK
IAkJCXB0ciArPSBhY3R1YWxfbGVuZ3RoOwogCQl9CkBAIC04NDcsNiArODUzLDIyIEBACiAJbTBk
MVswXSA9IG1vZGU7CiAJbTFbMl0udmFsdWUgPSAweGYwMDAgKyBtb2RlOwogCW0yWzFdLnZhbHVl
ID0gMHhmMDAwICsgbW9kZTsKKworCS8qIHNwZWNpYWwgY2FzZSBmb3IgTUVUSE9EMywgdGhlIG1v
ZGVzIGFyZSBkaWZmZXJlbnQgKi8KKwlpZiAoY2FtLT5tZXRob2QgPT0gTUVUSE9EMykgeworCQlz
d2l0Y2ggKG1vZGUpIHsKKwkJY2FzZSAxOgorCQkJbTJbMV0udmFsdWUgPSAweGYwMDAgKyA0Owor
CQkJYnJlYWs7CisJCWNhc2UgMjoKKwkJCW0yWzFdLnZhbHVlID0gMHhmMDAwICsgMDsKKwkJCWJy
ZWFrOworCQlkZWZhdWx0OgorCQkJbTJbMV0udmFsdWUgPSAweGYwMDAgKyAxOworCQkJYnJlYWs7
CisJCX0KKwl9CisKIAloZWFkZXIyWzQzN10gPSBjYW0tPmhlaWdodCAvIDI1NjsKIAloZWFkZXIy
WzQzOF0gPSBjYW0tPmhlaWdodCAlIDI1NjsKIAloZWFkZXIyWzQzOV0gPSBjYW0tPndpZHRoIC8g
MjU2Owo=
--0016364c78071426ae046f291a01--
