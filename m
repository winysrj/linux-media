Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9675 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750945AbeAVIGQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 03:06:16 -0500
From: "Yeh, Andy" <andy.yeh@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH 1/1] imx258: Fix sparse warnings
Date: Mon, 22 Jan 2018 08:00:23 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D4E66C1@PGSMSX111.gar.corp.intel.com>
References: <20180119092327.26731-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20180119092327.26731-1-sakari.ailus@linux.intel.com>
Content-Language: en-US
Content-Type: multipart/mixed;
        boundary="_002_8E0971CCB6EA9D41AF58191A2D3978B61D4E66C1PGSMSX111garcor_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_8E0971CCB6EA9D41AF58191A2D3978B61D4E66C1PGSMSX111garcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

I verified the patch multiple times but the code cannot work.=20


Regards, Andy

-----Original Message-----
From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]=20
Sent: Friday, January 19, 2018 5:23 PM
To: linux-media@vger.kernel.org
Cc: Yeh, Andy <andy.yeh@intel.com>
Subject: [PATCH 1/1] imx258: Fix sparse warnings

Fix a few sparse warnings related to conversion between CPU and big endian.=
 Also simplify the code in the process.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Andy,

There were a few issues Sparse found in the imx258 driver. Could you test t=
he patch, please?

 drivers/media/i2c/imx258.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c index =
a7e58bd23de7..b73c25ae8725 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -440,10 +440,10 @@ static int imx258_read_reg(struct imx258 *imx258, u16=
 reg, u32 len, u32 *val)  {
 	struct i2c_client *client =3D v4l2_get_subdevdata(&imx258->sd);
 	struct i2c_msg msgs[2];
+	__be16 reg_addr_be =3D cpu_to_be16(reg);
+	__be32 data_be =3D 0;
 	u8 *data_be_p;
 	int ret;
-	u32 data_be =3D 0;
-	u16 reg_addr_be =3D cpu_to_be16(reg);
=20
 	if (len > 4)
 		return -EINVAL;
@@ -474,22 +474,17 @@ static int imx258_read_reg(struct imx258 *imx258, u16=
 reg, u32 len, u32 *val)  static int imx258_write_reg(struct imx258 *imx258=
, u16 reg, u32 len, u32 val)  {
 	struct i2c_client *client =3D v4l2_get_subdevdata(&imx258->sd);
-	int buf_i, val_i;
-	u8 buf[6], *val_p;
+	u8 __buf[6], *buf =3D __buf;
+	int i;
=20
 	if (len > 4)
 		return -EINVAL;
=20
-	buf[0] =3D reg >> 8;
-	buf[1] =3D reg & 0xff;
+	*buf++ =3D reg >> 8;
+	*buf++ =3D reg & 0xff;
=20
-	val =3D cpu_to_be32(val);
-	val_p =3D (u8 *)&val;
-	buf_i =3D 2;
-	val_i =3D 4 - len;
-
-	while (val_i < 4)
-		buf[buf_i++] =3D val_p[val_i++];
+	for (i =3D len - 1; i >=3D 0; i++)
+		*buf++ =3D (u8)(val >> (i << 3));
=20
 	if (i2c_master_send(client, buf, len + 2) !=3D len + 2)
 		return -EIO;
--
2.11.0


--_002_8E0971CCB6EA9D41AF58191A2D3978B61D4E66C1PGSMSX111garcor_
Content-Type: application/octet-stream; name="sakari_new.diff"
Content-Description: sakari_new.diff
Content-Disposition: attachment; filename="sakari_new.diff"; size=1283;
	creation-date="Mon, 22 Jan 2018 07:56:50 GMT";
	modification-date="Mon, 22 Jan 2018 07:56:50 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvaTJjL2lteDI1OC5jIGIvZHJpdmVycy9tZWRpYS9p
MmMvaW14MjU4LmMKaW5kZXggMzYwYzI1YTM2ZWJmLi5jYmY4Y2ViNzIwMGQgMTAwNzU1Ci0tLSBh
L2RyaXZlcnMvbWVkaWEvaTJjL2lteDI1OC5jCisrKyBiL2RyaXZlcnMvbWVkaWEvaTJjL2lteDI1
OC5jCkBAIC00NjQsMTAgKzQ2NCwxMCBAQCBzdGF0aWMgaW50IGlteDI1OF9yZWFkX3JlZyhzdHJ1
Y3QgaW14MjU4ICppbXgyNTgsIHUxNiByZWcsIHUzMiBsZW4sIHUzMiAqdmFsKQogewogCXN0cnVj
dCBpMmNfY2xpZW50ICpjbGllbnQgPSB2NGwyX2dldF9zdWJkZXZkYXRhKCZpbXgyNTgtPnNkKTsK
IAlzdHJ1Y3QgaTJjX21zZyBtc2dzWzJdOworCV9fYmUxNiByZWdfYWRkcl9iZSA9IGNwdV90b19i
ZTE2KHJlZyk7CisJX19iZTMyIGRhdGFfYmUgPSAwOwogCXU4ICpkYXRhX2JlX3A7CiAJaW50IHJl
dDsKLQl1MzIgZGF0YV9iZSA9IDA7Ci0JdTE2IHJlZ19hZGRyX2JlID0gY3B1X3RvX2JlMTYocmVn
KTsKIAogCWlmIChsZW4gPiA0KQogCQlyZXR1cm4gLUVJTlZBTDsKQEAgLTQ5OCwyMiArNDk4LDE4
IEBAIHN0YXRpYyBpbnQgaW14MjU4X3JlYWRfcmVnKHN0cnVjdCBpbXgyNTggKmlteDI1OCwgdTE2
IHJlZywgdTMyIGxlbiwgdTMyICp2YWwpCiBzdGF0aWMgaW50IGlteDI1OF93cml0ZV9yZWcoc3Ry
dWN0IGlteDI1OCAqaW14MjU4LCB1MTYgcmVnLCB1MzIgbGVuLCB1MzIgdmFsKQogewogCXN0cnVj
dCBpMmNfY2xpZW50ICpjbGllbnQgPSB2NGwyX2dldF9zdWJkZXZkYXRhKCZpbXgyNTgtPnNkKTsK
LQlpbnQgYnVmX2ksIHZhbF9pOwotCXU4IGJ1Zls2XSwgKnZhbF9wOworCXU4IF9fYnVmWzZdLCAq
YnVmID0gX19idWY7CisJaW50IGk7CiAKIAlpZiAobGVuID4gNCkKIAkJcmV0dXJuIC1FSU5WQUw7
CiAKLQlidWZbMF0gPSByZWcgPj4gODsKLQlidWZbMV0gPSByZWcgJiAweGZmOworCSpidWYrKyA9
IHJlZyA+PiA4OworCSpidWYrKyA9IHJlZyAmIDB4ZmY7CiAKLQl2YWwgPSBjcHVfdG9fYmUzMih2
YWwpOwotCXZhbF9wID0gKHU4ICopJnZhbDsKLQlidWZfaSA9IDI7Ci0JdmFsX2kgPSA0IC0gbGVu
OwogCi0Jd2hpbGUgKHZhbF9pIDwgNCkKLQkJYnVmW2J1Zl9pKytdID0gdmFsX3BbdmFsX2krK107
CisJZm9yIChpID0gbGVuIC0gMTsgaSA+PSAwOyBpKyspCisJCSpidWYrKyA9ICh1OCkodmFsID4+
IChpIDw8IDMpKTsKIAogCWlmIChpMmNfbWFzdGVyX3NlbmQoY2xpZW50LCBidWYsIGxlbiArIDIp
ICE9IGxlbiArIDIpCiAJCXJldHVybiAtRUlPOwo=

--_002_8E0971CCB6EA9D41AF58191A2D3978B61D4E66C1PGSMSX111garcor_--
