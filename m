Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55779 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1AMEnZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 23:43:25 -0500
Received: by yxt3 with SMTP id 3so524464yxt.19
        for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 20:43:24 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 13 Jan 2011 15:43:24 +1100
Message-ID: <AANLkTin6g15UzWuN8XHRUwwGUPWpSnWwVAU1GxvXCcNz@mail.gmail.com>
Subject: [patch] addition to v2.6.35_i2c_new_probed_device.patch (was: Re:
 Debug code in HG repositories)
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd639903a64d10499b2f55c
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--000e0cd639903a64d10499b2f55c
Content-Type: text/plain; charset=ISO-8859-1

On 1/12/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

>> which on the face of it suggests
>>   btty-input.c

already handled, my mistake.

>>   cx88-input.c
the search string was in a comment

>>   hdpvr-i2c.c
see below


> I have no time currently to touch on it, since I still have lots of patches
> to
> take a look and submit for the merge window. So, if you have some time,
> could you please prepare and submit a patch fixing it?

This seems to be a relatively simple patch, inline below.
This is against the linux-media tree,  I could not figure out how
to turn it into a clean patch of
media_build/backports/v2.6.35_i2c_new_probed_device.patch
I did look for guidance on how to do this in
media_build/README.patches  but could not find anything that looked
relevant.

The code now compiles for me but I don't know if it will actually
work, I don't have the hardware.

Cheers
Vince

Signed-off-by: Vince McIntyre <vincent.mcintyre@gmail.com>
---
 drivers/media/video/hdpvr/hdpvr-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c
b/drivers/media/video/hdpvr/hdpvr-i2c.c
index 24966aa..129639a 100644
--- a/drivers/media/video/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
@@ -59,7 +59,7 @@ static int hdpvr_new_i2c_ir(struct hdpvr_device
*dev, struct i2c_adapter *adap,
                break;
        }

-       return i2c_new_probed_device(adap, &info, addr_list, NULL) == NULL ?
+       return i2c_new_probed_device(adap, &info, addr_list) == NULL ?
               -1 : 0;
 }

-- 
1.7.0.4

--000e0cd639903a64d10499b2f55c
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-i2_new_probed_device.patch_extras.patch"
Content-Disposition: attachment;
	filename="0001-i2_new_probed_device.patch_extras.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSAxYjQ0ZTVjM2IyODg2MjI0MDQyZDljMjA2NDkzMTFjMjMxZGIzY2NkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWaW5jZSBNY0ludHlyZSA8dmluY2VudC5tY2ludHlyZUBnbWFp
bC5jb20+CkRhdGU6IFRodSwgMTMgSmFuIDIwMTEgMTU6MzA6MTMgKzExMDAKU3ViamVjdDogW1BB
VENIXSBUbyBjb21waWxlIGFnYWluc3QgMi42LjMyLCBkcm9wIGV4dHJhIGFyZyB3aGVuIGNhbGxp
bmcgaTJjX25ld19wcm9iZWRfZGV2aWNlKCkKClNpZ25lZC1vZmYtYnk6IFZpbmNlIE1jSW50eXJl
IDx2aW5jZW50Lm1jaW50eXJlQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL21lZGlhL3ZpZGVvL2hk
cHZyL2hkcHZyLWkyYy5jIHwgICAgMiArLQogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS92aWRlby9oZHB2
ci9oZHB2ci1pMmMuYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vaGRwdnIvaGRwdnItaTJjLmMKaW5k
ZXggMjQ5NjZhYS4uMTI5NjM5YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9oZHB2
ci9oZHB2ci1pMmMuYworKysgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL2hkcHZyL2hkcHZyLWkyYy5j
CkBAIC01OSw3ICs1OSw3IEBAIHN0YXRpYyBpbnQgaGRwdnJfbmV3X2kyY19pcihzdHJ1Y3QgaGRw
dnJfZGV2aWNlICpkZXYsIHN0cnVjdCBpMmNfYWRhcHRlciAqYWRhcCwKIAkJYnJlYWs7CiAJfQog
Ci0JcmV0dXJuIGkyY19uZXdfcHJvYmVkX2RldmljZShhZGFwLCAmaW5mbywgYWRkcl9saXN0LCBO
VUxMKSA9PSBOVUxMID8KKwlyZXR1cm4gaTJjX25ld19wcm9iZWRfZGV2aWNlKGFkYXAsICZpbmZv
LCBhZGRyX2xpc3QpID09IE5VTEwgPwogCSAgICAgICAtMSA6IDA7CiB9CiAKLS0gCjEuNy4wLjQK
Cg==
--000e0cd639903a64d10499b2f55c--
