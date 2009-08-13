Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:44755 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbZHMSvM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 14:51:12 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n7DIp8Ga011064
	for <linux-media@vger.kernel.org>; Thu, 13 Aug 2009 13:51:13 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id n7DIp8J4027169
	for <linux-media@vger.kernel.org>; Thu, 13 Aug 2009 13:51:08 -0500 (CDT)
Received: from dlee75.ent.ti.com (localhost [127.0.0.1])
	by dlep20.itg.ti.com (8.12.11/8.12.11) with ESMTP id n7DIp8fR005489
	for <linux-media@vger.kernel.org>; Thu, 13 Aug 2009 13:51:08 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 13 Aug 2009 13:51:06 -0500
Subject: [RFC][PATCH] v4l2: Add other RAW Bayer 10bit component orders
Message-ID: <A24693684029E5489D1D202277BE89444A7839B7@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_A24693684029E5489D1D202277BE89444A7839B7dlee02entticom_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_A24693684029E5489D1D202277BE89444A7839B7dlee02entticom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Sergio Aguirre <saaguirre@ti.com>

This helps clarifying different pattern orders for RAW Bayer 10 bit
cases.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 include/linux/videodev2.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 9e66c50..8aa6255 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -327,6 +327,9 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0')
 /* 10bit raw bayer DPCM compressed to 8 bits */
 #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
+#define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0')
+#define V4L2_PIX_FMT_SBGGR10 v4l2_fourcc('B', 'G', '1', '0')
+#define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0')
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG..=
 GRGR.. */
=20
 /* compressed formats */
--=20
1.6.3.2


--_002_A24693684029E5489D1D202277BE89444A7839B7dlee02entticom_
Content-Type: application/octet-stream;
	name="0001-v4l2-Add-other-RAW-Bayer-10bit-component-orders.patch"
Content-Description: 0001-v4l2-Add-other-RAW-Bayer-10bit-component-orders.patch
Content-Disposition: attachment;
	filename="0001-v4l2-Add-other-RAW-Bayer-10bit-component-orders.patch";
	size=1135; creation-date="Wed, 12 Aug 2009 15:08:39 GMT";
	modification-date="Wed, 12 Aug 2009 15:08:39 GMT"
Content-Transfer-Encoding: base64

RnJvbSA5YzBlMGVkMmM4YzVjZDg2YTVjZmViZjliNmU1Yzk2Mzk3YTcyMGQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZXJnaW8gQWd1aXJyZSA8c2FhZ3VpcnJlQHRpLmNvbT4KRGF0
ZTogTW9uLCAyOSBKdW4gMjAwOSAwODo1NTowMCAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMS8zXSB2
NGwyOiBBZGQgb3RoZXIgUkFXIEJheWVyIDEwYml0IGNvbXBvbmVudCBvcmRlcnMKClRoaXMgaGVs
cHMgY2xhcmlmeWluZyBkaWZmZXJlbnQgcGF0dGVybiBvcmRlcnMgZm9yIFJBVyBCYXllciAxMCBi
aXQKY2FzZXMuCgpTaWduZWQtb2ZmLWJ5OiBTZXJnaW8gQWd1aXJyZSA8c2FhZ3VpcnJlQHRpLmNv
bT4KLS0tCiBpbmNsdWRlL2xpbnV4L3ZpZGVvZGV2Mi5oIHwgICAgMyArKysKIDEgZmlsZXMgY2hh
bmdlZCwgMyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvdmlkZW9kZXYyLmggYi9pbmNsdWRlL2xpbnV4L3ZpZGVvZGV2Mi5oCmluZGV4IDll
NjZjNTAuLjhhYTYyNTUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvdmlkZW9kZXYyLmgKKysr
IGIvaW5jbHVkZS9saW51eC92aWRlb2RldjIuaApAQCAtMzI3LDYgKzMyNyw5IEBAIHN0cnVjdCB2
NGwyX3BpeF9mb3JtYXQgewogI2RlZmluZSBWNEwyX1BJWF9GTVRfU0dSQkcxMCB2NGwyX2ZvdXJj
YygnQicsICdBJywgJzEnLCAnMCcpCiAvKiAxMGJpdCByYXcgYmF5ZXIgRFBDTSBjb21wcmVzc2Vk
IHRvIDggYml0cyAqLwogI2RlZmluZSBWNEwyX1BJWF9GTVRfU0dSQkcxMERQQ004IHY0bDJfZm91
cmNjKCdCJywgJ0QnLCAnMScsICcwJykKKyNkZWZpbmUgVjRMMl9QSVhfRk1UX1NSR0dCMTAgdjRs
Ml9mb3VyY2MoJ1InLCAnRycsICcxJywgJzAnKQorI2RlZmluZSBWNEwyX1BJWF9GTVRfU0JHR1Ix
MCB2NGwyX2ZvdXJjYygnQicsICdHJywgJzEnLCAnMCcpCisjZGVmaW5lIFY0TDJfUElYX0ZNVF9T
R0JSRzEwIHY0bDJfZm91cmNjKCdHJywgJ0InLCAnMScsICcwJykKICNkZWZpbmUgVjRMMl9QSVhf
Rk1UX1NCR0dSMTYgdjRsMl9mb3VyY2MoJ0InLCAnWScsICdSJywgJzInKSAvKiAxNiAgQkdCRy4u
IEdSR1IuLiAqLwogCiAvKiBjb21wcmVzc2VkIGZvcm1hdHMgKi8KLS0gCjEuNi4zLjIKCg==

--_002_A24693684029E5489D1D202277BE89444A7839B7dlee02entticom_--
