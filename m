Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32773 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbcJAXhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2016 19:37:50 -0400
Received: by mail-pf0-f196.google.com with SMTP id i85so80650pfa.0
        for <linux-media@vger.kernel.org>; Sat, 01 Oct 2016 16:37:50 -0700 (PDT)
Date: Sat, 1 Oct 2016 16:37:46 -0700
From: Wayne Porter <wporter82@gmail.com>
To: laurent.pinchart@ideasonboard.com
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] [media] v4l: omap4iss: Fix using BIT macro
Message-ID: <20161001233746.nowzbvhimd3jutbz@Chronos>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jdga764t5ezxkgr6"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jdga764t5ezxkgr6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Checks found by checkpatch

Signed-off-by: Wayne Porter <wporter82@gmail.com>
---
 drivers/staging/media/omap4iss/iss_regs.h | 76 +++++++++++++++------------=
----
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_regs.h b/drivers/staging/me=
dia/omap4iss/iss_regs.h
index cb415e8..c675212 100644
--- a/drivers/staging/media/omap4iss/iss_regs.h
+++ b/drivers/staging/media/omap4iss/iss_regs.h
@@ -42,7 +42,7 @@
 #define ISS_CTRL_CLK_DIV_MASK				(3 << 4)
 #define ISS_CTRL_INPUT_SEL_MASK				(3 << 2)
 #define ISS_CTRL_INPUT_SEL_CSI2A			(0 << 2)
-#define ISS_CTRL_INPUT_SEL_CSI2B			(1 << 2)
+#define ISS_CTRL_INPUT_SEL_CSI2B			BIT(2)
 #define ISS_CTRL_SYNC_DETECT_VS_RAISING			(3 << 0)
=20
 #define ISS_CLKCTRL					0x84
@@ -97,10 +97,10 @@
 #define CSI2_SYSCONFIG					0x10
 #define CSI2_SYSCONFIG_MSTANDBY_MODE_MASK		(3 << 12)
 #define CSI2_SYSCONFIG_MSTANDBY_MODE_FORCE		(0 << 12)
-#define CSI2_SYSCONFIG_MSTANDBY_MODE_NO			(1 << 12)
+#define CSI2_SYSCONFIG_MSTANDBY_MODE_NO			BIT(12)
 #define CSI2_SYSCONFIG_MSTANDBY_MODE_SMART		(2 << 12)
-#define CSI2_SYSCONFIG_SOFT_RESET			(1 << 1)
-#define CSI2_SYSCONFIG_AUTO_IDLE			(1 << 0)
+#define CSI2_SYSCONFIG_SOFT_RESET			BIT(1)
+#define CSI2_SYSCONFIG_AUTO_IDLE			BIT(0)
=20
 #define CSI2_SYSSTATUS					0x14
 #define CSI2_SYSSTATUS_RESET_DONE			BIT(0)
@@ -123,37 +123,37 @@
 #define CSI2_CTRL_MFLAG_LEVH_SHIFT			20
 #define CSI2_CTRL_MFLAG_LEVL_MASK			(7 << 17)
 #define CSI2_CTRL_MFLAG_LEVL_SHIFT			17
-#define CSI2_CTRL_BURST_SIZE_EXPAND			(1 << 16)
-#define CSI2_CTRL_VP_CLK_EN				(1 << 15)
-#define CSI2_CTRL_NON_POSTED_WRITE			(1 << 13)
-#define CSI2_CTRL_VP_ONLY_EN				(1 << 11)
+#define CSI2_CTRL_BURST_SIZE_EXPAND			BIT(16)
+#define CSI2_CTRL_VP_CLK_EN				BIT(15)
+#define CSI2_CTRL_NON_POSTED_WRITE			BIT(13)
+#define CSI2_CTRL_VP_ONLY_EN				BIT(11)
 #define CSI2_CTRL_VP_OUT_CTRL_MASK			(3 << 8)
 #define CSI2_CTRL_VP_OUT_CTRL_SHIFT			8
-#define CSI2_CTRL_DBG_EN				(1 << 7)
+#define CSI2_CTRL_DBG_EN				BIT(7)
 #define CSI2_CTRL_BURST_SIZE_MASK			(3 << 5)
-#define CSI2_CTRL_ENDIANNESS				(1 << 4)
-#define CSI2_CTRL_FRAME					(1 << 3)
-#define CSI2_CTRL_ECC_EN				(1 << 2)
-#define CSI2_CTRL_IF_EN					(1 << 0)
+#define CSI2_CTRL_ENDIANNESS				BIT(4)
+#define CSI2_CTRL_FRAME					BIT(3)
+#define CSI2_CTRL_ECC_EN				BIT(2)
+#define CSI2_CTRL_IF_EN					BIT(0)
=20
 #define CSI2_DBG_H					0x44
=20
 #define CSI2_COMPLEXIO_CFG				0x50
-#define CSI2_COMPLEXIO_CFG_RESET_CTRL			(1 << 30)
-#define CSI2_COMPLEXIO_CFG_RESET_DONE			(1 << 29)
+#define CSI2_COMPLEXIO_CFG_RESET_CTRL			BIT(30)
+#define CSI2_COMPLEXIO_CFG_RESET_DONE			BIT(29)
 #define CSI2_COMPLEXIO_CFG_PWD_CMD_MASK			(3 << 27)
 #define CSI2_COMPLEXIO_CFG_PWD_CMD_OFF			(0 << 27)
-#define CSI2_COMPLEXIO_CFG_PWD_CMD_ON			(1 << 27)
+#define CSI2_COMPLEXIO_CFG_PWD_CMD_ON			BIT(27)
 #define CSI2_COMPLEXIO_CFG_PWD_CMD_ULP			(2 << 27)
 #define CSI2_COMPLEXIO_CFG_PWD_STATUS_MASK		(3 << 25)
 #define CSI2_COMPLEXIO_CFG_PWD_STATUS_OFF		(0 << 25)
-#define CSI2_COMPLEXIO_CFG_PWD_STATUS_ON		(1 << 25)
+#define CSI2_COMPLEXIO_CFG_PWD_STATUS_ON		BIT(25)
 #define CSI2_COMPLEXIO_CFG_PWD_STATUS_ULP		(2 << 25)
-#define CSI2_COMPLEXIO_CFG_PWR_AUTO			(1 << 24)
+#define CSI2_COMPLEXIO_CFG_PWR_AUTO			BIT(24)
 #define CSI2_COMPLEXIO_CFG_DATA_POL(i)			(1 << (((i) * 4) + 3))
 #define CSI2_COMPLEXIO_CFG_DATA_POSITION_MASK(i)	(7 << ((i) * 4))
 #define CSI2_COMPLEXIO_CFG_DATA_POSITION_SHIFT(i)	((i) * 4)
-#define CSI2_COMPLEXIO_CFG_CLOCK_POL			(1 << 3)
+#define CSI2_COMPLEXIO_CFG_CLOCK_POL			BIT(3)
 #define CSI2_COMPLEXIO_CFG_CLOCK_POSITION_MASK		(7 << 0)
 #define CSI2_COMPLEXIO_CFG_CLOCK_POSITION_SHIFT		0
=20
@@ -222,7 +222,7 @@
 		(0x3 << CSI2_CTX_CTRL2_USER_DEF_MAP_SHIFT)
 #define CSI2_CTX_CTRL2_VIRTUAL_ID_MASK			(3 << 11)
 #define CSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT			11
-#define CSI2_CTX_CTRL2_DPCM_PRED			(1 << 10)
+#define CSI2_CTX_CTRL2_DPCM_PRED			BIT(10)
 #define CSI2_CTX_CTRL2_FORMAT_MASK			(0x3ff << 0)
 #define CSI2_CTX_CTRL2_FORMAT_SHIFT			0
=20
@@ -263,9 +263,9 @@
 #define ISP5_SYSCONFIG					(0x0010)
 #define ISP5_SYSCONFIG_STANDBYMODE_MASK			(3 << 4)
 #define ISP5_SYSCONFIG_STANDBYMODE_FORCE		(0 << 4)
-#define ISP5_SYSCONFIG_STANDBYMODE_NO			(1 << 4)
+#define ISP5_SYSCONFIG_STANDBYMODE_NO			BIT(4)
 #define ISP5_SYSCONFIG_STANDBYMODE_SMART		(2 << 4)
-#define ISP5_SYSCONFIG_SOFTRESET			(1 << 1)
+#define ISP5_SYSCONFIG_SOFTRESET			BIT(1)
=20
 #define ISP5_IRQSTATUS(i)				(0x0028 + (0x10 * (i)))
 #define ISP5_IRQENABLE_SET(i)				(0x002c + (0x10 * (i)))
@@ -319,14 +319,14 @@
 #define ISIF_MODESET					(0x0004)
 #define ISIF_MODESET_INPMOD_MASK			(3 << 12)
 #define ISIF_MODESET_INPMOD_RAW				(0 << 12)
-#define ISIF_MODESET_INPMOD_YCBCR16			(1 << 12)
+#define ISIF_MODESET_INPMOD_YCBCR16			BIT(12)
 #define ISIF_MODESET_INPMOD_YCBCR8			(2 << 12)
 #define ISIF_MODESET_CCDW_MASK				(7 << 8)
 #define ISIF_MODESET_CCDW_2BIT				(2 << 8)
-#define ISIF_MODESET_CCDMD				(1 << 7)
-#define ISIF_MODESET_SWEN				(1 << 5)
-#define ISIF_MODESET_HDPOL				(1 << 3)
-#define ISIF_MODESET_VDPOL				(1 << 2)
+#define ISIF_MODESET_CCDMD				BIT(7)
+#define ISIF_MODESET_SWEN				BIT(5)
+#define ISIF_MODESET_HDPOL				BIT(3)
+#define ISIF_MODESET_VDPOL				BIT(2)
=20
 #define ISIF_SPH					(0x0018)
 #define ISIF_SPH_MASK					(0x7fff)
@@ -349,19 +349,19 @@
=20
 #define ISIF_CCOLP					(0x004c)
 #define ISIF_CCOLP_CP0_F0_R				(0 << 6)
-#define ISIF_CCOLP_CP0_F0_GR				(1 << 6)
+#define ISIF_CCOLP_CP0_F0_GR				BIT(6)
 #define ISIF_CCOLP_CP0_F0_B				(3 << 6)
 #define ISIF_CCOLP_CP0_F0_GB				(2 << 6)
 #define ISIF_CCOLP_CP1_F0_R				(0 << 4)
-#define ISIF_CCOLP_CP1_F0_GR				(1 << 4)
+#define ISIF_CCOLP_CP1_F0_GR				BIT(4)
 #define ISIF_CCOLP_CP1_F0_B				(3 << 4)
 #define ISIF_CCOLP_CP1_F0_GB				(2 << 4)
 #define ISIF_CCOLP_CP2_F0_R				(0 << 2)
-#define ISIF_CCOLP_CP2_F0_GR				(1 << 2)
+#define ISIF_CCOLP_CP2_F0_GR				BIT(2)
 #define ISIF_CCOLP_CP2_F0_B				(3 << 2)
 #define ISIF_CCOLP_CP2_F0_GB				(2 << 2)
 #define ISIF_CCOLP_CP3_F0_R				(0 << 0)
-#define ISIF_CCOLP_CP3_F0_GR				(1 << 0)
+#define ISIF_CCOLP_CP3_F0_GR				BIT(0)
 #define ISIF_CCOLP_CP3_F0_B				(3 << 0)
 #define ISIF_CCOLP_CP3_F0_GB				(2 << 0)
=20
@@ -381,12 +381,12 @@
 #define IPIPEIF_CFG1					(0x0004)
 #define IPIPEIF_CFG1_INPSRC1_MASK			(3 << 14)
 #define IPIPEIF_CFG1_INPSRC1_VPORT_RAW			(0 << 14)
-#define IPIPEIF_CFG1_INPSRC1_SDRAM_RAW			(1 << 14)
+#define IPIPEIF_CFG1_INPSRC1_SDRAM_RAW			BIT(14)
 #define IPIPEIF_CFG1_INPSRC1_ISIF_DARKFM		(2 << 14)
 #define IPIPEIF_CFG1_INPSRC1_SDRAM_YUV			(3 << 14)
 #define IPIPEIF_CFG1_INPSRC2_MASK			(3 << 2)
 #define IPIPEIF_CFG1_INPSRC2_ISIF			(0 << 2)
-#define IPIPEIF_CFG1_INPSRC2_SDRAM_RAW			(1 << 2)
+#define IPIPEIF_CFG1_INPSRC2_SDRAM_RAW			BIT(2)
 #define IPIPEIF_CFG1_INPSRC2_ISIF_DARKFM		(2 << 2)
 #define IPIPEIF_CFG1_INPSRC2_SDRAM_YUV			(3 << 2)
=20
@@ -410,25 +410,25 @@
=20
 #define IPIPE_SRC_FMT					(0x0008)
 #define IPIPE_SRC_FMT_RAW2YUV				(0 << 0)
-#define IPIPE_SRC_FMT_RAW2RAW				(1 << 0)
+#define IPIPE_SRC_FMT_RAW2RAW				BIT(0)
 #define IPIPE_SRC_FMT_RAW2STATS				(2 << 0)
 #define IPIPE_SRC_FMT_YUV2YUV				(3 << 0)
=20
 #define IPIPE_SRC_COL					(0x000c)
 #define IPIPE_SRC_COL_OO_R				(0 << 6)
-#define IPIPE_SRC_COL_OO_GR				(1 << 6)
+#define IPIPE_SRC_COL_OO_GR				BIT(6)
 #define IPIPE_SRC_COL_OO_B				(3 << 6)
 #define IPIPE_SRC_COL_OO_GB				(2 << 6)
 #define IPIPE_SRC_COL_OE_R				(0 << 4)
-#define IPIPE_SRC_COL_OE_GR				(1 << 4)
+#define IPIPE_SRC_COL_OE_GR				BIT(4)
 #define IPIPE_SRC_COL_OE_B				(3 << 4)
 #define IPIPE_SRC_COL_OE_GB				(2 << 4)
 #define IPIPE_SRC_COL_EO_R				(0 << 2)
-#define IPIPE_SRC_COL_EO_GR				(1 << 2)
+#define IPIPE_SRC_COL_EO_GR				BIT(2)
 #define IPIPE_SRC_COL_EO_B				(3 << 2)
 #define IPIPE_SRC_COL_EO_GB				(2 << 2)
 #define IPIPE_SRC_COL_EE_R				(0 << 0)
-#define IPIPE_SRC_COL_EE_GR				(1 << 0)
+#define IPIPE_SRC_COL_EE_GR				BIT(0)
 #define IPIPE_SRC_COL_EE_B				(3 << 0)
 #define IPIPE_SRC_COL_EE_GB				(2 << 0)
=20
--=20
2.9.3


--jdga764t5ezxkgr6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX8EjEAAoJEMcDZgYHTWDOzWcH/3e37o/6CuCIRfmdOo3FqFi9
IawgbIGLYaH6PZD3OvCaKRe9uJZ8brsVgMjRBBksphebOkmLN2+YQLjDUkRMfE4/
GbQ/4AbuykxxLClf7O+Bo1/L9nm0uhTsnh069Ztd9vl7hQW40PZFsKmGX5/0doqH
56sLCmhqiOAVZmj7A9FHAPlrJ4MHE7wVgYM4CtOvYtwWjzMbFghOKjMxkjOBBtRV
Lj0dlzE+KogADUQaUqZUKJ0vla5gj+s82uN0VzHAXN9YUx/6Payki71KHq7r0TAn
iASAUvrivc/Y56QvnfXq6F/AbWXPT9iyBjpkXhiat7bfRJUIcEKvOpCSWpNnX60=
=QJKu
-----END PGP SIGNATURE-----

--jdga764t5ezxkgr6--
