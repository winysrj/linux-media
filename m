Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54957 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751695AbdK2TIp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:45 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 03/22] media: tw68: fix kernel-doc markups
Date: Wed, 29 Nov 2017 14:08:21 -0500
Message-Id: <bbea65fccf2c5d12624aeba3edbc79337f0d13fd.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a few mistakes on the existing markups:

  drivers/media/pci/tw68/tw68-risc.c:32: warning: Cannot understand  *  @rp		pointer to current risc program position
   on line 32 - I thought it was a doc line
  drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'pci'
  drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'buf'
  drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'sglist'
  drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'top_offset'
  drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'bottom_offset'
  drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'bpl'
  drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'padding'
  drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'lines'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/tw68/tw68-risc.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/media/pci/tw68/tw68-risc.c b/drivers/media/pci/tw68/tw68-risc.c
index 7439db212a69..82ff9c9494f3 100644
--- a/drivers/media/pci/tw68/tw68-risc.c
+++ b/drivers/media/pci/tw68/tw68-risc.c
@@ -29,14 +29,15 @@
 #include "tw68.h"
 
 /**
- *  @rp		pointer to current risc program position
- *  @sglist	pointer to "scatter-gather list" of buffer pointers
- *  @offset	offset to target memory buffer
- *  @sync_line	0 -> no sync, 1 -> odd sync, 2 -> even sync
- *  @bpl	number of bytes per scan line
- *  @padding	number of bytes of padding to add
- *  @lines	number of lines in field
- *  @jump	insert a jump at the start
+ * tw68_risc_field
+ *  @rp:	pointer to current risc program position
+ *  @sglist:	pointer to "scatter-gather list" of buffer pointers
+ *  @offset:	offset to target memory buffer
+ *  @sync_line:	0 -> no sync, 1 -> odd sync, 2 -> even sync
+ *  @bpl:	number of bytes per scan line
+ *  @padding:	number of bytes of padding to add
+ *  @lines:	number of lines in field
+ *  @jump:	insert a jump at the start
  */
 static __le32 *tw68_risc_field(__le32 *rp, struct scatterlist *sglist,
 			    unsigned int offset, u32 sync_line,
@@ -120,18 +121,18 @@ static __le32 *tw68_risc_field(__le32 *rp, struct scatterlist *sglist,
  *	memory for the dma controller "program" and then fills in that
  *	memory with the appropriate "instructions".
  *
- *	@pci_dev	structure with info about the pci
+ *	@pci:		structure with info about the pci
  *			slot which our device is in.
- *	@risc		structure with info about the memory
+ *	@buf:		structure with info about the memory
  *			used for our controller program.
- *	@sglist		scatter-gather list entry
- *	@top_offset	offset within the risc program area for the
+ *	@sglist:	scatter-gather list entry
+ *	@top_offset:	offset within the risc program area for the
  *			first odd frame line
- *	@bottom_offset	offset within the risc program area for the
+ *	@bottom_offset:	offset within the risc program area for the
  *			first even frame line
- *	@bpl		number of data bytes per scan line
- *	@padding	number of extra bytes to add at end of line
- *	@lines		number of scan lines
+ *	@bpl:		number of data bytes per scan line
+ *	@padding:	number of extra bytes to add at end of line
+ *	@lines:		number of scan lines
  */
 int tw68_risc_buffer(struct pci_dev *pci,
 			struct tw68_buf *buf,
-- 
2.14.3
