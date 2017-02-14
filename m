Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.helmutauer.de ([185.170.112.187]:36008 "EHLO
        v2201612530341454.powersrv.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752286AbdBNHLj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 02:11:39 -0500
Message-ID: <a3094b0048a1ce3f295417e9330e1194.squirrel@helmutauer.de>
In-Reply-To: <20170213134244.GA18860@gofer.mess.org>
References: <20170127080622.GA4153@mwanda>
    <ae72e45aeea9d3cbead7c50e1cbe4c5b.squirrel@helmutauer.de>
    <33044ec5031546f79ae9d37565240ed3.squirrel@helmutauer.de>
    <cfb14339f809faa9b5e40d2fa53f330b.squirrel@helmutauer.de>
    <20170213134244.GA18860@gofer.mess.org>
Date: Tue, 14 Feb 2017 08:11:56 +0100
Subject: Re: [PATCH] [MEDIA] add device ID to ati remote
From: "Helmut Auer" <vdr@helmutauer.de>
To: "Sean Young" <sean@mess.org>
Cc: "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20170214081156_79922"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_20170214081156_79922
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

P.S. Here is the patch again with a correction.

> On Tue, Feb 07, 2017 at 09:42:47AM +0100, vdr@helmutauer.de wrote:
>>
>> Author: Helmut Auer <vdr@xxx.de>
>> Date:   Fri Jan 27 19:09:35 2017 +0100
>>
>>     Adding 1 device ID to ati_remote driver.
>
> If possible, a more descriptive message would be preferred, e.g. what
> device do you have, what branding, what product did it come with.
>
>>
>>     Signed-off-by: Helmut Auer <vdr@xxx.de>
>
> Unless I'm mistaken, contributions can't be anonymous or use a fake email
> address.
>
>>
>> diff --git a/drivers/media/rc/ati_remote.c
>> b/drivers/media/rc/ati_remote.c
>> index 0884b7d..83022b1 100644
>> --- a/drivers/media/rc/ati_remote.c
>> +++ b/drivers/media/rc/ati_remote.c
>> @@ -108,6 +108,7 @@
>>  #define NVIDIA_REMOTE_PRODUCT_ID       0x0005
>>  #define MEDION_REMOTE_PRODUCT_ID       0x0006
>>  #define FIREFLY_REMOTE_PRODUCT_ID      0x0008
>> +#define REYCOM_REMOTE_PRODUCT_ID       0x000c
>>
>>  #define DRIVER_VERSION         "2.2.1"
>>  #define DRIVER_AUTHOR           "Torrey Hoffman <thoffman@arnor.net>"
>> @@ -227,6 +228,10 @@ static struct usb_device_id ati_remote_table[] = {
>>                 USB_DEVICE(ATI_REMOTE_VENDOR_ID,
>> FIREFLY_REMOTE_PRODUCT_ID),
>>                 .driver_info = (unsigned long)&type_firefly
>>         },
>> +       {
>> +               USB_DEVICE(ATI_REMOTE_VENDOR_ID,
>> REYCOM_REMOTE_PRODUCT_ID),
>> +               .driver_info = (unsigned long)&type_firefly
>> +       },
>>         {}      /* Terminating entry */
>>  };
>
> Your email client replaced all tabs with spaces so the patch no longer
> applies.
>
> Thanks,
> Sean
>

------=_20170214081156_79922
Content-Type: application/octet-stream; name="015_atireycom.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="015_atireycom.patch"

LS0tIGRyaXZlcnMvbWVkaWEvcmMvYXRpX3JlbW90ZS5jCTIwMTYtMTItMTEgMjA6MTc6NTQuMDAw
MDAwMDAwICswMTAwCisrKyBkcml2ZXJzL21lZGlhL3JjL2F0aV9yZW1vdGUuYwkyMDE3LTAyLTA3
IDA4OjM5OjI1Ljg2MDY0NDE3NyArMDEwMApAQCAtMTA4LDYgKzEwOCw3IEBACiAjZGVmaW5lIE5W
SURJQV9SRU1PVEVfUFJPRFVDVF9JRAkweDAwMDUKICNkZWZpbmUgTUVESU9OX1JFTU9URV9QUk9E
VUNUX0lECTB4MDAwNgogI2RlZmluZSBGSVJFRkxZX1JFTU9URV9QUk9EVUNUX0lECTB4MDAwOAor
I2RlZmluZSBSRVlDT01fUkVNT1RFX1BST0RVQ1RfSUQJMHgwMDBjCiAKICNkZWZpbmUgRFJJVkVS
X1ZFUlNJT04JCSIyLjIuMSIKICNkZWZpbmUgRFJJVkVSX0FVVEhPUiAgICAgICAgICAgIlRvcnJl
eSBIb2ZmbWFuIDx0aG9mZm1hbkBhcm5vci5uZXQ+IgpAQCAtMjI3LDYgKzIyOCwxMCBAQAogCQlV
U0JfREVWSUNFKEFUSV9SRU1PVEVfVkVORE9SX0lELCBGSVJFRkxZX1JFTU9URV9QUk9EVUNUX0lE
KSwKIAkJLmRyaXZlcl9pbmZvID0gKHVuc2lnbmVkIGxvbmcpJnR5cGVfZmlyZWZseQogCX0sCisJ
eworCQlVU0JfREVWSUNFKEFUSV9SRU1PVEVfVkVORE9SX0lELCBSRVlDT01fUkVNT1RFX1BST0RV
Q1RfSUQpLAorCQkuZHJpdmVyX2luZm8gPSAodW5zaWduZWQgbG9uZykmdHlwZV9tZWRpb24KKwl9
LAogCXt9CS8qIFRlcm1pbmF0aW5nIGVudHJ5ICovCiB9OwogCg==
------=_20170214081156_79922--
