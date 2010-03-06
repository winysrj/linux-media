Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:59766 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0CFTqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 14:46:11 -0500
MIME-Version: 1.0
In-Reply-To: <4B8F9FC6.9030105@redhat.com>
References: <1820d69d1003030445n18b35839r407d4d277b1bf48d@mail.gmail.com>
	 <62e5edd41003030517g6fa9b64awdf18578d6c5db7e@mail.gmail.com>
	 <4B8F974A.4090001@redhat.com>
	 <62e5edd41003040336x16253369ycb1905a9938432db@mail.gmail.com>
	 <4B8F9FC6.9030105@redhat.com>
Date: Sat, 6 Mar 2010 20:46:09 +0100
Message-ID: <62e5edd41003061146x689527c9s5b3ab81eec3425a0@mail.gmail.com>
Subject: Re: Gspca USB driver zc3xx and STV06xx probe the same device ..
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Content-Type: multipart/mixed; boundary=00163649906364c8bd04812715b9
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--00163649906364c8bd04812715b9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2010/3/4 Hans de Goede <hdegoede@redhat.com>:
> Hi,
>
> On 03/04/2010 12:36 PM, Erik Andr=E9n wrote:
>>
>> 2010/3/4 Hans de Goede<hdegoede@redhat.com>:
>>>
>>> Hi,
>>>
>>> On 03/03/2010 02:17 PM, Erik Andr=E9n wrote:
>>>>
>>>> 2010/3/3 Gabriel C<nix.or.die@googlemail.com>:
>>>>>
>>>>> Hello,
>>>>>
>>>>> I own a QuickCam Messanger webcam.. I didn't used it in ages but toda=
y
>>>>> I plugged it in..
>>>>> ( Device 002: ID 046d:08da Logitech, Inc. QuickCam Messanger )
>>>>>
>>>>> Now zc3xx and stv06xx are starting both to probe the device .. In
>>>>> 2.6.33 that result in a not working webcam.
>>>>> ( rmmod both&& =A0 =A0modprobe zc3xx one seems to fix that )
>>>>>
>>>>> On current git head zc3xx works fine even when both are probing the
>>>>> device.
>>>>>
>>>>> Also I noticed stv06xx fails anyway for my webcam with this error:
>>>>> ....
>>>>>
>>>>> [ =A0360.910243] STV06xx: Configuring camera
>>>>> [ =A0360.910244] STV06xx: st6422 sensor detected
>>>>> [ =A0360.910245] STV06xx: Initializing camera
>>>>> [ =A0361.161948] STV06xx: probe of 6-1:1.0 failed with error -32
>>>>> [ =A0361.161976] usbcore: registered new interface driver STV06xx
>>>>> [ =A0361.161978] STV06xx: registered
>>>>> .....
>>>>>
>>>>> Next thing is stv06xx tells it is an st6422 sensor and does not work
>>>>> with it while zc3xx tells it is an HV7131R(c) sensor and works fine
>>>>> with it.
>>>>>
>>>>> What is right ?
>>>>
>>>> Hans,
>>>> As you added support for the st6422 sensor to the stv06xx subdriver I
>>>> imagine you best know what's going on.
>>>>
>>>
>>> I took the USB-ID in question from the out of tree v4l1 driver I was
>>> basing
>>> my
>>> st6422 work on. Looking at the other ID's (which are very close togethe=
r)
>>> and
>>> combining that with this bug report, I think it is safe to say that the
>>> USB-ID
>>> in question should be removed from the stv06xx driver.
>>>
>>> Erik will you handle this, or shall I ?
>>>
>> Either way is fine by me.
>> I can try to do it tonight.
>>
>
> If you could take care of this that would be great!
>
> Thanks,
>
> Hans
>

Sorry for delaying this, real life came in the way.
I'm pasting in a patch that removes the usb id.
I'm also attaching it as an attachment as gmail probably will stomp on
the inline version.

Gabriel, could you please apply and test this patch and verify that it
works as intended, i. e. the stv06xx driver _doesn't_ bind to your
camera but the zx3xx driver instead does.
If it works as intended could you please reply to this mail with a
tested-by: your name <email> tag.

Best regards,
Erik

>From 6f40494d48c5641326168115a96659581cea6273 Mon Sep 17 00:00:00 2001
From: =3D?utf-8?q?Erik=3D20Andr=3DC3=3DA9n?=3D <erik.andren@gmail.com>
Date: Sat, 6 Mar 2010 20:34:51 +0100
Subject: [PATCH 1/1] gspca-stv06xx: Remove the 046d:08da usb id from
linking to the stv06xx driver
MIME-Version: 1.0
Content-Type: text/plain; charset=3Dutf-8
Content-Transfer-Encoding: 8bit

The 046d:08da usb id shouldn't be associated with the stv06xx driver
as they're not compatible with each other.
This fixes a bug where Quickcam Messenger cams fail to use its proper
driver (gspca-zc3xx), rendering the camera inoperable.

Signed-off-by: Erik Andr=E9n <erik.andren@gmail.com>
---
 drivers/media/video/gspca/stv06xx/stv06xx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/gspca/stv06xx/stv06xx.c
b/drivers/media/video/gspca/stv06xx/stv06xx.c
index de823ed..b1f7e28 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx.c
@@ -497,8 +497,6 @@ static const __devinitdata struct usb_device_id
device_table[] =3D {
        {USB_DEVICE(0x046D, 0x08F5), .driver_info =3D BRIDGE_ST6422 },
        /* QuickCam Messenger (new) */
        {USB_DEVICE(0x046D, 0x08F6), .driver_info =3D BRIDGE_ST6422 },
-       /* QuickCam Messenger (new) */
-       {USB_DEVICE(0x046D, 0x08DA), .driver_info =3D BRIDGE_ST6422 },
        {}
 };
 MODULE_DEVICE_TABLE(usb, device_table);
--=20
1.6.3.3

--00163649906364c8bd04812715b9
Content-Type: application/octet-stream;
	name="0001-gspca-stv06xx-Remove-the-046d-08da-usb-id-from-linki.patch"
Content-Disposition: attachment;
	filename="0001-gspca-stv06xx-Remove-the-046d-08da-usb-id-from-linki.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g6gtq0xs0

RnJvbSA2ZjQwNDk0ZDQ4YzU2NDEzMjYxNjgxMTVhOTY2NTk1ODFjZWE2MjczIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P3V0Zi04P3E/RXJpaz0yMEFuZHI9QzM9QTluPz0gPGVyaWsu
YW5kcmVuQGdtYWlsLmNvbT4KRGF0ZTogU2F0LCA2IE1hciAyMDEwIDIwOjM0OjUxICswMTAwClN1
YmplY3Q6IFtQQVRDSCAxLzFdIGdzcGNhLXN0djA2eHg6IFJlbW92ZSB0aGUgMDQ2ZDowOGRhIHVz
YiBpZCBmcm9tIGxpbmtpbmcgdG8gdGhlIHN0djA2eHggZHJpdmVyCk1JTUUtVmVyc2lvbjogMS4w
CkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD11dGYtOApDb250ZW50LVRyYW5zZmVy
LUVuY29kaW5nOiA4Yml0CgpUaGUgMDQ2ZDowOGRhIHVzYiBpZCBzaG91bGRuJ3QgYmUgYXNzb2Np
YXRlZCB3aXRoIHRoZSBzdHYwNnh4IGRyaXZlciBhcyB0aGV5J3JlIG5vdCBjb21wYXRpYmxlIHdp
dGggZWFjaCBvdGhlci4KVGhpcyBmaXhlcyBhIGJ1ZyB3aGVyZSBRdWlja2NhbSBNZXNzZW5nZXIg
Y2FtcyBmYWlsIHRvIHVzZSBpdHMgcHJvcGVyIGRyaXZlciAoZ3NwY2EtemMzeHgpLCByZW5kZXJp
bmcgdGhlIGNhbWVyYSBpbm9wZXJhYmxlLgoKU2lnbmVkLW9mZi1ieTogRXJpayBBbmRyw6luIDxl
cmlrLmFuZHJlbkBnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9tZWRpYS92aWRlby9nc3BjYS9zdHYw
Nnh4L3N0djA2eHguYyB8ICAgIDIgLS0KIDEgZmlsZXMgY2hhbmdlZCwgMCBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vZ3NwY2Ev
c3R2MDZ4eC9zdHYwNnh4LmMgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL2dzcGNhL3N0djA2eHgvc3R2
MDZ4eC5jCmluZGV4IGRlODIzZWQuLmIxZjdlMjggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEv
dmlkZW8vZ3NwY2Evc3R2MDZ4eC9zdHYwNnh4LmMKKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9n
c3BjYS9zdHYwNnh4L3N0djA2eHguYwpAQCAtNDk3LDggKzQ5Nyw2IEBAIHN0YXRpYyBjb25zdCBf
X2RldmluaXRkYXRhIHN0cnVjdCB1c2JfZGV2aWNlX2lkIGRldmljZV90YWJsZVtdID0gewogCXtV
U0JfREVWSUNFKDB4MDQ2RCwgMHgwOEY1KSwgLmRyaXZlcl9pbmZvID0gQlJJREdFX1NUNjQyMiB9
LAogCS8qIFF1aWNrQ2FtIE1lc3NlbmdlciAobmV3KSAqLwogCXtVU0JfREVWSUNFKDB4MDQ2RCwg
MHgwOEY2KSwgLmRyaXZlcl9pbmZvID0gQlJJREdFX1NUNjQyMiB9LAotCS8qIFF1aWNrQ2FtIE1l
c3NlbmdlciAobmV3KSAqLwotCXtVU0JfREVWSUNFKDB4MDQ2RCwgMHgwOERBKSwgLmRyaXZlcl9p
bmZvID0gQlJJREdFX1NUNjQyMiB9LAogCXt9CiB9OwogTU9EVUxFX0RFVklDRV9UQUJMRSh1c2Is
IGRldmljZV90YWJsZSk7Ci0tIAoxLjYuMy4zCgo=
--00163649906364c8bd04812715b9--
