Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34494 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753839AbeCWL5d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Anton Sviridenko <anton@corp.bluecherry.net>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>
Subject: [PATCH 23/30] media: solo6x10: get rid of an address space warning
Date: Fri, 23 Mar 2018 07:57:09 -0400
Message-Id: <43e69758e6c0cc05adc4d39316f65abb120a00a0.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using an ancillary function to avoid duplicating
a small portion of code that copies data either to kernelspace
or between userspace-kernelspace, duplicate the code,
as it prevents static analyzers to complain about it:

	drivers/media/pci/solo6x10/solo6x10-g723.c:260:46: warning: cast removes address space of expression

The hole idea of using __user is to make sure that the code is
doing the right thing with address space, so there's no
sense on use casting.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/solo6x10/solo6x10-g723.c | 73 +++++++++++++++++-------------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
index 81be1b8df758..2ac33b5cc454 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -223,48 +223,57 @@ static snd_pcm_uframes_t snd_solo_pcm_pointer(struct snd_pcm_substream *ss)
 	return idx * G723_FRAMES_PER_PAGE;
 }
 
-static int __snd_solo_pcm_copy(struct snd_pcm_substream *ss,
-			       unsigned long pos, void *dst,
-			       unsigned long count, bool in_kernel)
-{
-	struct solo_snd_pcm *solo_pcm = snd_pcm_substream_chip(ss);
-	struct solo_dev *solo_dev = solo_pcm->solo_dev;
-	int err, i;
-
-	for (i = 0; i < (count / G723_FRAMES_PER_PAGE); i++) {
-		int page = (pos / G723_FRAMES_PER_PAGE) + i;
-
-		err = solo_p2m_dma_t(solo_dev, 0, solo_pcm->g723_dma,
-				     SOLO_G723_EXT_ADDR(solo_dev) +
-				     (page * G723_PERIOD_BLOCK) +
-				     (ss->number * G723_PERIOD_BYTES),
-				     G723_PERIOD_BYTES, 0, 0);
-		if (err)
-			return err;
-
-		if (in_kernel)
-			memcpy(dst, solo_pcm->g723_buf, G723_PERIOD_BYTES);
-		else if (copy_to_user((void __user *)dst,
-				      solo_pcm->g723_buf, G723_PERIOD_BYTES))
-			return -EFAULT;
-		dst += G723_PERIOD_BYTES;
-	}
-
-	return 0;
-}
-
 static int snd_solo_pcm_copy_user(struct snd_pcm_substream *ss, int channel,
 				  unsigned long pos, void __user *dst,
 				  unsigned long count)
 {
-	return __snd_solo_pcm_copy(ss, pos, (void *)dst, count, false);
+	struct solo_snd_pcm *solo_pcm = snd_pcm_substream_chip(ss);
+	struct solo_dev *solo_dev = solo_pcm->solo_dev;
+	int err, i;
+
+	for (i = 0; i < (count / G723_FRAMES_PER_PAGE); i++) {
+		int page = (pos / G723_FRAMES_PER_PAGE) + i;
+
+		err = solo_p2m_dma_t(solo_dev, 0, solo_pcm->g723_dma,
+				     SOLO_G723_EXT_ADDR(solo_dev) +
+				     (page * G723_PERIOD_BLOCK) +
+				     (ss->number * G723_PERIOD_BYTES),
+				     G723_PERIOD_BYTES, 0, 0);
+		if (err)
+			return err;
+
+		if (copy_to_user(dst, solo_pcm->g723_buf, G723_PERIOD_BYTES))
+			return -EFAULT;
+		dst += G723_PERIOD_BYTES;
+	}
+
+	return 0;
 }
 
 static int snd_solo_pcm_copy_kernel(struct snd_pcm_substream *ss, int channel,
 				    unsigned long pos, void *dst,
 				    unsigned long count)
 {
-	return __snd_solo_pcm_copy(ss, pos, dst, count, true);
+	struct solo_snd_pcm *solo_pcm = snd_pcm_substream_chip(ss);
+	struct solo_dev *solo_dev = solo_pcm->solo_dev;
+	int err, i;
+
+	for (i = 0; i < (count / G723_FRAMES_PER_PAGE); i++) {
+		int page = (pos / G723_FRAMES_PER_PAGE) + i;
+
+		err = solo_p2m_dma_t(solo_dev, 0, solo_pcm->g723_dma,
+				     SOLO_G723_EXT_ADDR(solo_dev) +
+				     (page * G723_PERIOD_BLOCK) +
+				     (ss->number * G723_PERIOD_BYTES),
+				     G723_PERIOD_BYTES, 0, 0);
+		if (err)
+			return err;
+
+		memcpy(dst, solo_pcm->g723_buf, G723_PERIOD_BYTES);
+		dst += G723_PERIOD_BYTES;
+	}
+
+	return 0;
 }
 
 static const struct snd_pcm_ops snd_solo_pcm_ops = {
-- 
2.14.3
