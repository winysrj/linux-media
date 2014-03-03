Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49425 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaCCKIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:01 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 34/79] [media] drx-j: remove typedefs at drx_driver.c
Date: Mon,  3 Mar 2014 07:06:28 -0300
Message-Id: <1393841233-24840-35-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of another typedef defined on this driver.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 34bc76c644b9..9eb4bbf2627a 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -117,7 +117,7 @@ GLOBAL VARIABLES
 STRUCTURES
 ------------------------------------------------------------------------------*/
 /** \brief  Structure of the microcode block headers */
-typedef struct {
+struct drxu_code_block_hdr {
 	u32 addr;
 		  /**<  Destination address of the data in this block */
 	u16 size;
@@ -129,8 +129,7 @@ typedef struct {
 			- bit[1]= compression on/off
 			- bit[15..2]=reserved */
 	u16 CRC;/**<  CRC value of the data block, only valid if CRC flag is
-			set. */
-} drxu_code_block_hdr_t, *pdrxu_code_block_hdr_t;
+			set. */};
 
 /*------------------------------------------------------------------------------
 FUNCTIONS
@@ -1015,7 +1014,7 @@ ctrl_u_code(struct drx_demod_instance *demod,
 		DRX_ATTR_MCRECORD(demod).mc_version = 0;
 		DRX_ATTR_MCRECORD(demod).mc_base_version = 0;
 		for (i = 0; i < mc_nr_of_blks; i++) {
-			drxu_code_block_hdr_t block_hdr;
+			struct drxu_code_block_hdr block_hdr;
 
 			/* Process block header */
 			block_hdr.addr = u_code_read32(mc_data);
@@ -1060,7 +1059,7 @@ ctrl_u_code(struct drx_demod_instance *demod,
 
 	/* Process microcode blocks */
 	for (i = 0; i < mc_nr_of_blks; i++) {
-		drxu_code_block_hdr_t block_hdr;
+		struct drxu_code_block_hdr block_hdr;
 		u16 mc_block_nr_bytes = 0;
 
 		/* Process block header */
-- 
1.8.5.3

