Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55916 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab2ANS2U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 13:28:20 -0500
Received: by bkuw12 with SMTP id w12so698498bku.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 10:28:19 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 14 Jan 2012 19:28:19 +0100
Message-ID: <CAEN_-SDqT6DHLmRsvqiTh+5DerxnFLHtSw+4utGs2Y0RnsAfhQ@mail.gmail.com>
Subject: Fix possible null dereference for Leadtek DTV 3200H
From: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015175cab9e4b0c8d04b6812569
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015175cab9e4b0c8d04b6812569
Content-Type: text/plain; charset=ISO-8859-1

This time with signed-off headers

--0015175cab9e4b0c8d04b6812569
Content-Type: text/x-patch; charset=US-ASCII;
	name="cx23885-fix-possible-null-dereference.patch"
Content-Disposition: attachment;
	filename="cx23885-fix-possible-null-dereference.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxeyxry00

U2lnbmVkLW9mZi1ieTogTWlyb3NsYXYgU2x1Z2VuIDx0aHVuZGVyLm1tbUBnbWFpbC5jb20+CkZy
b206IE1pcm9zbGF2IFNsdWdlbiA8dGh1bmRlci5tbW1AZ21haWwuY29tPgpEYXRlOiBTdW4sIDEx
IERlYyAyMDExIDIyOjU3OjU4ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gRml4IHBvc3NpYmxlIG51
bGwgZGVyZWZlcmVuY2UgZm9yIExlYWR0ZWsgRFRWIDMyMDBIIFhDNDAwMCB0dW5lciB3aGVuIG5v
IGZpcm13YXJlIGZpbGUgYXZhaWxhYmxlLgoKLS0tCiBkcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4
ODUvY3gyMzg4NS1kdmIuYyB8ICAgIDUgKysrKysKIDEgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRp
b25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8v
Y3gyMzg4NS9jeDIzODg1LWR2Yi5jIGIvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4
ODUtZHZiLmMKaW5kZXggYmNiNDViZS4uZjA0ODJiMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRp
YS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZiLmMKKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9j
eDIzODg1L2N4MjM4ODUtZHZiLmMKQEAgLTk0MCw2ICs5NDAsMTEgQEAgc3RhdGljIGludCBkdmJf
cmVnaXN0ZXIoc3RydWN0IGN4MjM4ODVfdHNwb3J0ICpwb3J0KQogCiAJCQlmZSA9IGR2Yl9hdHRh
Y2goeGM0MDAwX2F0dGFjaCwgZmUwLT5kdmIuZnJvbnRlbmQsCiAJCQkJCSZkZXYtPmkyY19idXNb
MV0uaTJjX2FkYXAsICZjZmcpOworCQkJaWYgKCFmZSkgeworCQkJCXByaW50ayhLRVJOX0VSUiAi
JXMvMjogeGM0MDAwIGF0dGFjaCBmYWlsZWRcbiIsCisJCQkJICAgICAgIGRldi0+bmFtZSk7CisJ
CQkJZ290byBmcm9udGVuZF9kZXRhY2g7CisJCQl9CiAJCX0KIAkJYnJlYWs7CiAJY2FzZSBDWDIz
ODg1X0JPQVJEX1RCU182OTIwOgotLSAKMS43LjIuMwoK
--0015175cab9e4b0c8d04b6812569--
