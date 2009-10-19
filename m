Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33216 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbZJSWeU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 18:34:20 -0400
Received: by fxm18 with SMTP id 18so5681731fxm.37
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 15:34:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380910191456g5c53f37bh82ae6d7359ae5d2e@mail.gmail.com>
References: <51bd605b0910181441l7d6ac90g53978e3e4436f6ba@mail.gmail.com>
	 <829197380910191218u2c281553pad57bff61ffbd3b5@mail.gmail.com>
	 <51bd605b0910191328i3b58c955ha3ade305b4af928d@mail.gmail.com>
	 <829197380910191341p484e070ftd190143f73b1d10e@mail.gmail.com>
	 <51bd605b0910191451x22287c5ai3f829f2af0243879@mail.gmail.com>
	 <829197380910191456g5c53f37bh82ae6d7359ae5d2e@mail.gmail.com>
Date: Tue, 20 Oct 2009 00:34:22 +0200
Message-ID: <51bd605b0910191534x48973759g721f4ee79b692059@mail.gmail.com>
Subject: Re: pctv nanoStick Solo not recognized
From: Matteo Miraz <telegraph.road@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=001517473434e744d90476515893
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001517473434e744d90476515893
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Devin,

it worked.

I added the new vendor, and changed the other entry. I'm wondering if
exists a "pinnacle" pctv 73e se usb device...

attached to this mail there is the (easy) patch.

Thank you very much!
Matteo

On Mon, Oct 19, 2009 at 11:56 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Mon, Oct 19, 2009 at 5:51 PM, Matteo Miraz <telegraph.road@gmail.com> =
wrote:
>> Devin,
>>
>> thanks for the support.
>>
>> In the meanwhile, can I try to force the "new" vendor id?
>> Since I have another pinnacle USB device, I was thinking about
>> creating a new vendor (something like USB_VID_PINNACLE2).
>> Is it enough to add it just after the USB_VID_PINNACLE definition and
>> change the 57th line to
>>
>> { USB_DEVICE(USB_VID_PINNACLE2, USB_PID_PINNACLE_PCTV73ESE) },
>>
>> or should I do something else?
>
> You can definitely give that a try and see if it starts working. =A0I
> would suggest you call it USB_VID_PCTVSYSTEMS though, since that is
> the new name. =A0If it works, send in a patch and we'll merge it.
>
> My speculation is that they got a new USB ID because of the Hauppauge
> acquisition, and they started shipping the existing products with the
> new ID (thereby we would need both USB ids in the driver).
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>



--=20
ciao, teo

20 minutes is the average that a Windows based PC lasts
before it's compromised. (Internet Storm Center)

--001517473434e744d90476515893
Content-Type: application/octet-stream; name="PCTVSYSTEMS.patch"
Content-Disposition: attachment; filename="PCTVSYSTEMS.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g0zszuh20

ZGlmZiAtciBmNjY4MGZhOGU3ZWMgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIw
NzAwX2RldmljZXMuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3
MDBfZGV2aWNlcy5jCVR1ZSBPY3QgMjAgMDA6MDg6MDUgMjAwOSArMDkwMAorKysgYi9saW51eC9k
cml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCVR1ZSBPY3QgMjAgMDA6
MzI6MDkgMjAwOSArMDIwMApAQCAtMTkzMCw3ICsxOTMwLDcgQEAKIAl7IFVTQl9ERVZJQ0UoVVNC
X1ZJRF9ZVUFOLCAgICAgIFVTQl9QSURfWVVBTl9TVEs3NzAwRCkgfSwKIC8qIDU1ICoveyBVU0Jf
REVWSUNFKFVTQl9WSURfWVVBTiwJVVNCX1BJRF9ZVUFOX1NUSzc3MDBEXzIpIH0sCiAJeyBVU0Jf
REVWSUNFKFVTQl9WSURfUElOTkFDTEUsCVVTQl9QSURfUElOTkFDTEVfUENUVjczQSkgfSwKLQl7
IFVTQl9ERVZJQ0UoVVNCX1ZJRF9QSU5OQUNMRSwJVVNCX1BJRF9QSU5OQUNMRV9QQ1RWNzNFU0Up
IH0sCisJeyBVU0JfREVWSUNFKFVTQl9WSURfUENUVlNZU1RFTVMsIFVTQl9QSURfUElOTkFDTEVf
UENUVjczRVNFKSB9LAogCXsgVVNCX0RFVklDRShVU0JfVklEX1BJTk5BQ0xFLAlVU0JfUElEX1BJ
Tk5BQ0xFX1BDVFYyODJFKSB9LAogCXsgVVNCX0RFVklDRShVU0JfVklEX0RJQkNPTSwJVVNCX1BJ
RF9ESUJDT01fU1RLNzc3MFApIH0sCiAvKiA2MCAqL3sgVVNCX0RFVklDRShVU0JfVklEX1RFUlJB
VEVDLAlVU0JfUElEX1RFUlJBVEVDX0NJTkVSR1lfVF9YWFNfMikgfSwKZGlmZiAtciBmNjY4MGZh
OGU3ZWMgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNiLWlkcy5oCi0tLSBh
L2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaAlUdWUgT2N0IDIw
IDAwOjA4OjA1IDIwMDkgKzA5MDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVz
Yi9kdmItdXNiLWlkcy5oCVR1ZSBPY3QgMjAgMDA6MzI6MDkgMjAwOSArMDIwMApAQCAtNDYsNiAr
NDYsNyBAQAogI2RlZmluZSBVU0JfVklEX01TSV8yCQkJCTB4MTQ2MgogI2RlZmluZSBVU0JfVklE
X09QRVJBMQkJCQkweDY5NWMKICNkZWZpbmUgVVNCX1ZJRF9QSU5OQUNMRQkJCTB4MjMwNAorI2Rl
ZmluZSBVU0JfVklEX1BDVFZTWVNURU1TCQkJMHgyMDEzCiAjZGVmaW5lIFVTQl9WSURfUElYRUxW
SUVXCQkJMHgxNTU0CiAjZGVmaW5lIFVTQl9WSURfVEVDSE5PVFJFTkQJCQkweDBiNDgKICNkZWZp
bmUgVVNCX1ZJRF9URVJSQVRFQwkJCTB4MGNjZAo=
--001517473434e744d90476515893--
