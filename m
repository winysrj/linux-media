Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbaCCKIF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:05 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 33/79] [media] drx-j: get rid of some ugly macros
Date: Mon,  3 Mar 2014 07:06:27 -0300
Message-Id: <1393841233-24840-34-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several get/set macros that are bogus: they just
call another macro and do either:
	x = FOO(d)
or
	FOO(d) = x

As checkpatch complains about that, and replacing all of them
are as easy as running a small coccinelle script, get rid
of all of them.

Script used:

@@
expression d, x;
@@
-DRX_SET_MIRRORFREQSPECT(d, x);
+DRX_ATTR_MIRRORFREQSPECT(d) = x;

@@
expression d, x;
@@
-DRX_GET_MIRRORFREQSPECT(d, x);
+x = DRX_ATTR_MIRRORFREQSPECT(d);

@@
expression d, x;
@@
-DRX_SET_CURRENTPOWERMODE(d, x);
+DRX_ATTR_CURRENTPOWERMODE(d) = x;

@@
expression d, x;
@@
-DRX_GET_CURRENTPOWERMODE(d, x);
+x = DRX_ATTR_CURRENTPOWERMODE(d);

@@
expression d, x;
@@
-DRX_SET_MICROCODE(d, x);
+DRX_ATTR_MICROCODE(d) = x;

@@
expression d, x;
@@
-DRX_GET_MICROCODE(d, x);
+x = DRX_ATTR_MICROCODE(d);

@@
expression d, x;
@@
-DRX_SET_MICROCODESIZE(d, x);
+DRX_ATTR_MICROCODESIZE(d) = x;

@@
expression d, x;
@@
-DRX_GET_MICROCODESIZE(d, x);
+x = DRX_ATTR_MICROCODESIZE(d);

@@
expression d, x;
@@
-DRX_SET_VERIFYMICROCODE(d, x);
+DRX_ATTR_VERIFYMICROCODE(d) = x;

@@
expression d, x;
@@
-DRX_GET_VERIFYMICROCODE(d, x);
+x = DRX_ATTR_VERIFYMICROCODE(d);

@@
expression d, x;
@@
-DRX_SET_MCVERTYPE(d, x);
+DRX_ATTR_MCRECORD(d).aux_type = x;

@@
expression d, x;
@@
-DRX_GET_MCVERTYPE(d, x);
+x = DRX_ATTR_MCRECORD(d).aux_type;

@@
expression d, x;
@@
-DRX_SET_MCDEV(d, x);
+DRX_ATTR_MCRECORD(d).mc_dev_type = x;

@@
expression d, x;
@@
-DRX_GET_MCDEV(d, x);
+x = DRX_ATTR_MCRECORD(d).mc_dev_type;

@@
expression d, x;
@@
-DRX_SET_MCVERSION(d, x);
+DRX_ATTR_MCRECORD(d).mc_version = x;

@@
expression d, x;
@@
-DRX_GET_MCVERSION(d, x);
+x = DRX_ATTR_MCRECORD(d).mc_version;

@@
expression d, x;
@@
-DRX_SET_MCPATCH(d, x);
+DRX_ATTR_MCRECORD(d).mc_base_version = x;

@@
expression d, x;
@@
-DRX_GET_MCPATCH(d, x);
+x = DRX_ATTR_MCRECORD(d).mc_base_version;

@@
expression d, x;
@@
-DRX_SET_I2CADDR(d, x);
+DRX_ATTR_I2CADDR(d) = x;

@@
expression d, x;
@@
-DRX_GET_I2CADDR(d, x);
+x = DRX_ATTR_I2CADDR(d);

@@
expression d, x;
@@
-DRX_SET_I2CDEVID(d, x);
+DRX_ATTR_I2CDEVID(d) = x;

@@
expression d, x;
@@
-DRX_GET_I2CDEVID(d, x);
+x = DRX_ATTR_I2CDEVID(d);

@@
expression d, x;
@@
-DRX_SET_USEBOOTLOADER(d, x);
+DRX_ATTR_USEBOOTLOADER(d) = x;

@@
expression d, x;
@@
-DRX_GET_USEBOOTLOADER(d, x);
+x = DRX_ATTR_USEBOOTLOADER(d);

@@
expression d, x;
@@
-DRX_SET_CURRENTSTANDARD(d, x);
+DRX_ATTR_CURRENTSTANDARD(d) = x;

@@
expression d, x;
@@
-DRX_GET_CURRENTSTANDARD(d, x);
+x = DRX_ATTR_CURRENTSTANDARD(d);

@@
expression d, x;
@@
-DRX_SET_PREVSTANDARD(d, x);
+DRX_ATTR_PREVSTANDARD(d) = x;

@@
expression d, x;
@@
-DRX_GET_PREVSTANDARD(d, x);
+x = DRX_ATTR_PREVSTANDARD(d);

@@
expression d, x;
@@
-DRX_SET_CACHESTANDARD(d, x);
+DRX_ATTR_CACHESTANDARD(d) = x;

@@
expression d, x;
@@
-DRX_GET_CACHESTANDARD(d, x);
+x = DRX_ATTR_CACHESTANDARD(d);

@@
expression d, x;
@@
-DRX_SET_CURRENTCHANNEL(d, x);
+DRX_ATTR_CURRENTCHANNEL(d) = x;

@@
expression d, x;
@@
-DRX_GET_CURRENTCHANNEL(d, x);
+x = DRX_ATTR_CURRENTCHANNEL(d);

@@
expression d, x;
@@
-DRX_SET_ISOPENED(d, x);
+DRX_ATTR_ISOPENED(d) = x;

@@
expression d, x;
@@
-DRX_GET_ISOPENED(d, x);
+x = DRX_ATTR_ISOPENED(d);

@@
expression d, x;
@@
-DRX_SET_TUNER(d, x);
+DRX_ATTR_TUNER(d) = x;

@@
expression d, x;
@@
-DRX_GET_TUNER(d, x);
+x = DRX_ATTR_TUNER(d);

@@
expression d, x;
@@
-DRX_SET_CAPABILITIES(d, x);
+DRX_ATTR_CAPABILITIES(d) = x;

@@
expression d, x;
@@
-DRX_GET_CAPABILITIES(d, x);
+x = DRX_ATTR_CAPABILITIES(d);

@@
expression d, x;
@@
-DRX_SET_PRODUCTID(d, x);
+DRX_ATTR_PRODUCTID(d) = x;

@@
expression d, x;
@@
-DRX_GET_PRODUCTID(d, x);
+x = DRX_ATTR_PRODUCTID(d);

@@
expression d, x;
@@
-DRX_SET_MFX(d, x);
+DRX_ATTR_PRODUCTID(d) = x;

@@
expression d, x;
@@
-DRX_GET_MFX(d, x);
+x = DRX_ATTR_PRODUCTID(d);

@@
expression d, x;
@@
-DRX_SET_INTERMEDIATEFREQ(d, x);
+DRX_ATTR_INTERMEDIATEFREQ(d) = x;

@@
expression d, x;
@@
-DRX_GET_INTERMEDIATEFREQ(d, x);
+x = DRX_ATTR_INTERMEDIATEFREQ(d);

@@
expression d, x;
@@
-DRX_SET_SYSCLOCKFREQ(d, x);
+DRX_ATTR_SYSCLOCKFREQ(d) = x;

@@
expression d, x;
@@
-DRX_GET_SYSCLOCKFREQ(d, x);
+x = DRX_ATTR_SYSCLOCKFREQ(d);

@@
expression d, x;
@@
-DRX_SET_TUNERRFAGCPOL(d, x);
+DRX_ATTR_TUNERRFAGCPOL(d) = x;

@@
expression d, x;
@@
-DRX_GET_TUNERRFAGCPOL(d, x);
+x = DRX_ATTR_TUNERRFAGCPOL(d);

@@
expression d, x;
@@
-DRX_SET_TUNERIFAGCPOL(d, x);
+DRX_ATTR_TUNERIFAGCPOL(d) = x;

@@
expression d, x;
@@
-DRX_GET_TUNERIFAGCPOL(d, x);
+x = DRX_ATTR_TUNERIFAGCPOL(d);

@@
expression d, x;
@@
-DRX_SET_TUNERSLOWMODE(d, x);
+DRX_ATTR_TUNERSLOWMODE(d) = x;

@@
expression d, x;
@@
-DRX_GET_TUNERSLOWMODE(d, x);
+x = DRX_ATTR_TUNERSLOWMODE(d);

@@
expression d, x;
@@
-DRX_SET_TUNERPORTNR(d, x);
+DRX_ATTR_TUNERSPORTNR(d) = x;

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c |  26 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h | 331 ----------------------
 drivers/media/dvb-frontends/drx39xyj/drxj.c       |   6 +-
 3 files changed, 14 insertions(+), 349 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 1737a8cc9d81..34bc76c644b9 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -767,7 +767,7 @@ ctrl_program_tuner(struct drx_demod_instance *demod, struct drx_channel *channel
 		return -EINVAL;
 	}
 
-	DRX_GET_TUNERSLOWMODE(demod, tuner_slow_mode);
+	tuner_slow_mode = DRX_ATTR_TUNERSLOWMODE(demod);
 
 	/* select fast (switch) or slow (lock) tuner mode */
 	if (tuner_slow_mode) {
@@ -818,7 +818,7 @@ ctrl_program_tuner(struct drx_demod_instance *demod, struct drx_channel *channel
 
 	/* update common attributes with information available from this function;
 	   TODO: check if this is required and safe */
-	DRX_SET_INTERMEDIATEFREQ(demod, if_frequency);
+	DRX_ATTR_INTERMEDIATEFREQ(demod) = if_frequency;
 
 	return 0;
 }
@@ -1010,10 +1010,10 @@ ctrl_u_code(struct drx_demod_instance *demod,
 	/* Scan microcode blocks first for version info if uploading */
 	if (action == UCODE_UPLOAD) {
 		/* Clear version block */
-		DRX_SET_MCVERTYPE(demod, 0);
-		DRX_SET_MCDEV(demod, 0);
-		DRX_SET_MCVERSION(demod, 0);
-		DRX_SET_MCPATCH(demod, 0);
+		DRX_ATTR_MCRECORD(demod).aux_type = 0;
+		DRX_ATTR_MCRECORD(demod).mc_dev_type = 0;
+		DRX_ATTR_MCRECORD(demod).mc_version = 0;
+		DRX_ATTR_MCRECORD(demod).mc_base_version = 0;
 		for (i = 0; i < mc_nr_of_blks; i++) {
 			drxu_code_block_hdr_t block_hdr;
 
@@ -1032,17 +1032,13 @@ ctrl_u_code(struct drx_demod_instance *demod,
 				u8 *auxblk = mc_info->mc_data + block_hdr.addr;
 				u16 auxtype = u_code_read16(auxblk);
 				if (DRX_ISMCVERTYPE(auxtype)) {
-					DRX_SET_MCVERTYPE(demod,
-							  u_code_read16(auxblk));
+					DRX_ATTR_MCRECORD(demod).aux_type = u_code_read16(auxblk);
 					auxblk += sizeof(u16);
-					DRX_SET_MCDEV(demod,
-						      u_code_read32(auxblk));
+					DRX_ATTR_MCRECORD(demod).mc_dev_type = u_code_read32(auxblk);
 					auxblk += sizeof(u32);
-					DRX_SET_MCVERSION(demod,
-							  u_code_read32(auxblk));
+					DRX_ATTR_MCRECORD(demod).mc_version = u_code_read32(auxblk);
 					auxblk += sizeof(u32);
-					DRX_SET_MCPATCH(demod,
-							u_code_read32(auxblk));
+					DRX_ATTR_MCRECORD(demod).mc_base_version = u_code_read32(auxblk);
 				}
 			}
 
@@ -1351,7 +1347,7 @@ int drx_close(struct drx_demod_instance *demod)
 
 	status = (*(demod->my_demod_funct->close_func)) (demod);
 
-	DRX_SET_ISOPENED(demod, false);
+	DRX_ATTR_ISOPENED(demod) = false;
 
 	return status;
 }
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 1b716228cdd4..2a7846699f3c 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -2364,341 +2364,10 @@ Access macros
 #define DRX_ATTR_TUNER(d)           ((d)->my_tuner)
 #define DRX_ATTR_I2CADDR(d)         ((d)->my_i2c_dev_addr->i2c_addr)
 #define DRX_ATTR_I2CDEVID(d)        ((d)->my_i2c_dev_addr->i2c_dev_id)
-
-/**
-* \brief Actual access macro's
-* \param d pointer to demod instance
-* \param x value to set ar to get
-*
-* SET macro's must be used to set the value of an attribute.
-* GET macro's must be used to retrieve the value of an attribute.
-*
-*/
-
-/**************************/
-
-#define DRX_SET_MIRRORFREQSPECT(d, x)                     \
-   do {                                                     \
-      DRX_ATTR_MIRRORFREQSPECT(d) = (x);                  \
-   } while (0)
-
-#define DRX_GET_MIRRORFREQSPECT(d, x)                     \
-   do {                                                     \
-      (x) = DRX_ATTR_MIRRORFREQSPECT(d);                    \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_CURRENTPOWERMODE(d, x)                    \
-   do {                                                     \
-      DRX_ATTR_CURRENTPOWERMODE(d) = (x);                 \
-   } while (0)
-
-#define DRX_GET_CURRENTPOWERMODE(d, x)                    \
-   do {                                                     \
-      (x) = DRX_ATTR_CURRENTPOWERMODE(d);                   \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_MICROCODE(d, x)                           \
-   do {                                                     \
-      DRX_ATTR_MICROCODE(d) = (x);                        \
-   } while (0)
-
-#define DRX_GET_MICROCODE(d, x)                           \
-   do {                                                     \
-      (x) = DRX_ATTR_MICROCODE(d);                          \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_MICROCODESIZE(d, x)                       \
-   do {                                                     \
-      DRX_ATTR_MICROCODESIZE(d) = (x);                      \
-   } while (0)
-
-#define DRX_GET_MICROCODESIZE(d, x)                       \
-   do {                                                     \
-      (x) = DRX_ATTR_MICROCODESIZE(d);                        \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_VERIFYMICROCODE(d, x)                     \
-   do {                                                     \
-      DRX_ATTR_VERIFYMICROCODE(d) = (x);                    \
-   } while (0)
-
-#define DRX_GET_VERIFYMICROCODE(d, x)                     \
-   do {                                                     \
-      (x) = DRX_ATTR_VERIFYMICROCODE(d);                      \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_MCVERTYPE(d, x)                           \
-   do {                                                     \
-      DRX_ATTR_MCRECORD(d).aux_type = (x);                   \
-   } while (0)
-
-#define DRX_GET_MCVERTYPE(d, x)                           \
-   do {                                                     \
-      (x) = DRX_ATTR_MCRECORD(d).aux_type;                   \
-   } while (0)
-
-/**************************/
-
 #define DRX_ISMCVERTYPE(x) ((x) == AUX_VER_RECORD)
 
 /**************************/
 
-#define DRX_SET_MCDEV(d, x)                               \
-   do {                                                     \
-      DRX_ATTR_MCRECORD(d).mc_dev_type = (x);                 \
-   } while (0)
-
-#define DRX_GET_MCDEV(d, x)                               \
-   do {                                                     \
-      (x) = DRX_ATTR_MCRECORD(d).mc_dev_type;                 \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_MCVERSION(d, x)                           \
-   do {                                                     \
-      DRX_ATTR_MCRECORD(d).mc_version = (x);                 \
-   } while (0)
-
-#define DRX_GET_MCVERSION(d, x)                           \
-   do {                                                     \
-      (x) = DRX_ATTR_MCRECORD(d).mc_version;                 \
-   } while (0)
-
-/**************************/
-#define DRX_SET_MCPATCH(d, x)                             \
-   do {                                                     \
-      DRX_ATTR_MCRECORD(d).mc_base_version = (x);             \
-   } while (0)
-
-#define DRX_GET_MCPATCH(d, x)                             \
-   do {                                                     \
-      (x) = DRX_ATTR_MCRECORD(d).mc_base_version;             \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_I2CADDR(d, x)                             \
-   do {                                                     \
-      DRX_ATTR_I2CADDR(d) = (x);                            \
-   } while (0)
-
-#define DRX_GET_I2CADDR(d, x)                             \
-   do {                                                     \
-      (x) = DRX_ATTR_I2CADDR(d);                              \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_I2CDEVID(d, x)                            \
-   do {                                                     \
-      DRX_ATTR_I2CDEVID(d) = (x);                           \
-   } while (0)
-
-#define DRX_GET_I2CDEVID(d, x)                            \
-   do {                                                     \
-      (x) = DRX_ATTR_I2CDEVID(d);                             \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_USEBOOTLOADER(d, x)                       \
-   do {                                                     \
-      DRX_ATTR_USEBOOTLOADER(d) = (x);                      \
-   } while (0)
-
-#define DRX_GET_USEBOOTLOADER(d, x)                        \
-   do {                                                     \
-      (x) = DRX_ATTR_USEBOOTLOADER(d);                        \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_CURRENTSTANDARD(d, x)                     \
-   do {                                                     \
-      DRX_ATTR_CURRENTSTANDARD(d) = (x);                    \
-   } while (0)
-
-#define DRX_GET_CURRENTSTANDARD(d, x)                      \
-   do {                                                     \
-      (x) = DRX_ATTR_CURRENTSTANDARD(d);                      \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_PREVSTANDARD(d, x)                        \
-   do {                                                     \
-      DRX_ATTR_PREVSTANDARD(d) = (x);                       \
-   } while (0)
-
-#define DRX_GET_PREVSTANDARD(d, x)                         \
-   do {                                                     \
-      (x) = DRX_ATTR_PREVSTANDARD(d);                         \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_CACHESTANDARD(d, x)                       \
-   do {                                                     \
-      DRX_ATTR_CACHESTANDARD(d) = (x);                      \
-   } while (0)
-
-#define DRX_GET_CACHESTANDARD(d, x)                        \
-   do {                                                     \
-      (x) = DRX_ATTR_CACHESTANDARD(d);                        \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_CURRENTCHANNEL(d, x)                      \
-   do {                                                     \
-      DRX_ATTR_CURRENTCHANNEL(d) = (x);                     \
-   } while (0)
-
-#define DRX_GET_CURRENTCHANNEL(d, x)                       \
-   do {                                                     \
-      (x) = DRX_ATTR_CURRENTCHANNEL(d);                       \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_ISOPENED(d, x)                            \
-   do {                                                     \
-      DRX_ATTR_ISOPENED(d) = (x);                           \
-   } while (0)
-
-#define DRX_GET_ISOPENED(d, x)                             \
-   do {                                                     \
-      (x) = DRX_ATTR_ISOPENED(d);                           \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_TUNER(d, x)                               \
-   do {                                                     \
-      DRX_ATTR_TUNER(d) = (x);                              \
-   } while (0)
-
-#define DRX_GET_TUNER(d, x)                                \
-   do {                                                     \
-      (x) = DRX_ATTR_TUNER(d);                              \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_CAPABILITIES(d, x)                        \
-   do {                                                     \
-      DRX_ATTR_CAPABILITIES(d) = (x);                       \
-   } while (0)
-
-#define DRX_GET_CAPABILITIES(d, x)                         \
-   do {                                                     \
-      (x) = DRX_ATTR_CAPABILITIES(d);                       \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_PRODUCTID(d, x)                           \
-   do {                                                     \
-      DRX_ATTR_PRODUCTID(d) |= (x << 4);                    \
-   } while (0)
-
-#define DRX_GET_PRODUCTID(d, x)                            \
-   do {                                                     \
-      (x) = (DRX_ATTR_PRODUCTID(d) >> 4);                   \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_MFX(d, x)                                 \
-   do {                                                     \
-      DRX_ATTR_PRODUCTID(d) |= (x);                         \
-   } while (0)
-
-#define DRX_GET_MFX(d, x)                                  \
-   do {                                                     \
-      (x) = (DRX_ATTR_PRODUCTID(d) & 0xF);                  \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_INTERMEDIATEFREQ(d, x)                    \
-   do {                                                     \
-      DRX_ATTR_INTERMEDIATEFREQ(d) = (x);                   \
-   } while (0)
-
-#define DRX_GET_INTERMEDIATEFREQ(d, x)                     \
-   do {                                                     \
-      (x) = DRX_ATTR_INTERMEDIATEFREQ(d);                   \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_SYSCLOCKFREQ(d, x)                        \
-   do {                                                     \
-      DRX_ATTR_SYSCLOCKFREQ(d) = (x);                       \
-   } while (0)
-
-#define DRX_GET_SYSCLOCKFREQ(d, x)                         \
-   do {                                                     \
-      (x) = DRX_ATTR_SYSCLOCKFREQ(d);                       \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_TUNERRFAGCPOL(d, x)                       \
-   do {                                                     \
-      DRX_ATTR_TUNERRFAGCPOL(d) = (x);                      \
-   } while (0)
-
-#define DRX_GET_TUNERRFAGCPOL(d, x)                        \
-   do {                                                     \
-      (x) = DRX_ATTR_TUNERRFAGCPOL(d);                      \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_TUNERIFAGCPOL(d, x)                       \
-   do {                                                     \
-      DRX_ATTR_TUNERIFAGCPOL(d) = (x);                      \
-   } while (0)
-
-#define DRX_GET_TUNERIFAGCPOL(d, x)                        \
-   do {                                                     \
-      (x) = DRX_ATTR_TUNERIFAGCPOL(d);                      \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_TUNERSLOWMODE(d, x)                       \
-   do {                                                     \
-      DRX_ATTR_TUNERSLOWMODE(d) = (x);                      \
-   } while (0)
-
-#define DRX_GET_TUNERSLOWMODE(d, x)                        \
-   do {                                                     \
-      (x) = DRX_ATTR_TUNERSLOWMODE(d);                      \
-   } while (0)
-
-/**************************/
-
-#define DRX_SET_TUNERPORTNR(d, x)                         \
-   do {                                                     \
-      DRX_ATTR_TUNERSPORTNR(d) = (x);                       \
-   } while (0)
-
-/**************************/
-
 /* Macros with device-specific handling are converted to CFG functions */
 
 #define DRX_ACCESSMACRO_SET(demod, value, cfg_name, data_type)             \
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index aafe6dffdab5..668ac1a07959 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -5205,9 +5205,9 @@ static int ctrl_validate_u_code(struct drx_demod_instance *demod)
 	 *   - product ID in version record's device ID does not
 	 *     match DRXJ1 product IDs - 0x393 or 0x394
 	 */
-	DRX_GET_MCVERTYPE(demod, ver_type);
-	DRX_GET_MCDEV(demod, mc_dev);
-	DRX_GET_MCPATCH(demod, mc_patch);
+	ver_type = DRX_ATTR_MCRECORD(demod).aux_type;
+	mc_dev = DRX_ATTR_MCRECORD(demod).mc_dev_type;
+	mc_patch = DRX_ATTR_MCRECORD(demod).mc_base_version;
 
 	if (DRX_ISMCVERTYPE(ver_type)) {
 		if ((mc_dev != 0) &&
-- 
1.8.5.3

