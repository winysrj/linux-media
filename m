Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62516 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZJTK3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 06:29:14 -0400
Received: by fxm18 with SMTP id 18so6222528fxm.37
        for <linux-media@vger.kernel.org>; Tue, 20 Oct 2009 03:29:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.1.10.0910200938140.3543@pub2.ifh.de>
References: <51bd605b0910181441l7d6ac90g53978e3e4436f6ba@mail.gmail.com>
	 <829197380910191218u2c281553pad57bff61ffbd3b5@mail.gmail.com>
	 <51bd605b0910191328i3b58c955ha3ade305b4af928d@mail.gmail.com>
	 <829197380910191341p484e070ftd190143f73b1d10e@mail.gmail.com>
	 <51bd605b0910191451x22287c5ai3f829f2af0243879@mail.gmail.com>
	 <829197380910191456g5c53f37bh82ae6d7359ae5d2e@mail.gmail.com>
	 <51bd605b0910191534x48973759g721f4ee79b692059@mail.gmail.com>
	 <alpine.LRH.1.10.0910200938140.3543@pub2.ifh.de>
Date: Tue, 20 Oct 2009 12:29:17 +0200
Message-ID: <51bd605b0910200329u394e9e56m93ad8ca3cf1dedb5@mail.gmail.com>
Subject: Re: pctv nanoStick Solo not recognized
From: Matteo Miraz <telegraph.road@gmail.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0023545bd84ca92b1b04765b5565
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0023545bd84ca92b1b04765b5565
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

here it is the requested patch... note that I don't have a PCTV282E
device, so I cannot test it!

Thanks for the assistance,
Matteo

On Tue, Oct 20, 2009 at 9:42 AM, Patrick Boettcher
<pboettcher@kernellabs.com> wrote:
> Hi Matteo,
>
> Sorry for being quite in the first place.
>
> On Tue, 20 Oct 2009, Matteo Miraz wrote:
>
>> Devin,
>>
>> it worked.
>>
>> I added the new vendor, and changed the other entry. I'm wondering if
>> exists a "pinnacle" pctv 73e se usb device...
>>
>> attached to this mail there is the (easy) patch.
>
> This patch is in fact the right way to do things.
>
> Acked-by: =A0Patrick Boettcher <pboettcher@kernellabs.com>
>
> While you are at it, can you please also changed the vendor ID for the
> PCTV282E-device to PCTVSYSTEMS and file a new patch?
>
> thanks for the help,
>
> --
>
> Patrick Boettcher - Kernel Labs
> http://www.kernellabs.com/
>



--=20
ciao, teo

20 minutes is the average that a Windows based PC lasts
before it's compromised. (Internet Storm Center)

--0023545bd84ca92b1b04765b5565
Content-Type: application/octet-stream; name="PCTVSYSTEMS.patch"
Content-Disposition: attachment; filename="PCTVSYSTEMS.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g10ij7xw0

ZGlmZiAtciBmNjY4MGZhOGU3ZWMgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIw
NzAwX2RldmljZXMuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3
MDBfZGV2aWNlcy5jCVR1ZSBPY3QgMjAgMDA6MDg6MDUgMjAwOSArMDkwMAorKysgYi9saW51eC9k
cml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCVR1ZSBPY3QgMjAgMTI6
Mjc6MTQgMjAwOSArMDIwMApAQCAtMTkzMCw4ICsxOTMwLDggQEAKIAl7IFVTQl9ERVZJQ0UoVVNC
X1ZJRF9ZVUFOLCAgICAgIFVTQl9QSURfWVVBTl9TVEs3NzAwRCkgfSwKIC8qIDU1ICoveyBVU0Jf
REVWSUNFKFVTQl9WSURfWVVBTiwJVVNCX1BJRF9ZVUFOX1NUSzc3MDBEXzIpIH0sCiAJeyBVU0Jf
REVWSUNFKFVTQl9WSURfUElOTkFDTEUsCVVTQl9QSURfUElOTkFDTEVfUENUVjczQSkgfSwKLQl7
IFVTQl9ERVZJQ0UoVVNCX1ZJRF9QSU5OQUNMRSwJVVNCX1BJRF9QSU5OQUNMRV9QQ1RWNzNFU0Up
IH0sCi0JeyBVU0JfREVWSUNFKFVTQl9WSURfUElOTkFDTEUsCVVTQl9QSURfUElOTkFDTEVfUENU
VjI4MkUpIH0sCisJeyBVU0JfREVWSUNFKFVTQl9WSURfUENUVlNZU1RFTVMsIFVTQl9QSURfUElO
TkFDTEVfUENUVjczRVNFKSB9LAorCXsgVVNCX0RFVklDRShVU0JfVklEX1BDVFZTWVNURU1TLCBV
U0JfUElEX1BJTk5BQ0xFX1BDVFYyODJFKSB9LAogCXsgVVNCX0RFVklDRShVU0JfVklEX0RJQkNP
TSwJVVNCX1BJRF9ESUJDT01fU1RLNzc3MFApIH0sCiAvKiA2MCAqL3sgVVNCX0RFVklDRShVU0Jf
VklEX1RFUlJBVEVDLAlVU0JfUElEX1RFUlJBVEVDX0NJTkVSR1lfVF9YWFNfMikgfSwKIAl7IFVT
Ql9ERVZJQ0UoVVNCX1ZJRF9ESUJDT00sICAgIFVTQl9QSURfRElCQ09NX1NUSzgwN1hQVlIpIH0s
CmRpZmYgLXIgZjY2ODBmYThlN2VjIGxpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZi
LXVzYi1pZHMuaAotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2R2Yi11c2It
aWRzLmgJVHVlIE9jdCAyMCAwMDowODowNSAyMDA5ICswOTAwCisrKyBiL2xpbnV4L2RyaXZlcnMv
bWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaAlUdWUgT2N0IDIwIDEyOjI3OjE0IDIwMDkg
KzAyMDAKQEAgLTQ2LDYgKzQ2LDcgQEAKICNkZWZpbmUgVVNCX1ZJRF9NU0lfMgkJCQkweDE0NjIK
ICNkZWZpbmUgVVNCX1ZJRF9PUEVSQTEJCQkJMHg2OTVjCiAjZGVmaW5lIFVTQl9WSURfUElOTkFD
TEUJCQkweDIzMDQKKyNkZWZpbmUgVVNCX1ZJRF9QQ1RWU1lTVEVNUwkJCTB4MjAxMwogI2RlZmlu
ZSBVU0JfVklEX1BJWEVMVklFVwkJCTB4MTU1NAogI2RlZmluZSBVU0JfVklEX1RFQ0hOT1RSRU5E
CQkJMHgwYjQ4CiAjZGVmaW5lIFVTQl9WSURfVEVSUkFURUMJCQkweDBjY2QK
--0023545bd84ca92b1b04765b5565--
