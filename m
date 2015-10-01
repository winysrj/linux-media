Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49350 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbbJAWRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 18:17:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: [PATCH 6/7] [media] c8sectpfe: fix namespace on memcpy/memset
Date: Thu,  1 Oct 2015 19:17:28 -0300
Message-Id: <5347f97c651906887446a8811946e54b5a972fe4.1443737683.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Solves those sparse warnings:

drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:1087:9: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:1087:9:    expected void *<noident>
drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:1087:9:    got void [noderef] <asn:2>*<noident>
drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:1090:9: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:1090:9:    expected void *<noident>
drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:1090:9:    got void [noderef] <asn:2>*

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 486aef50d99b..e358b9163a68 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -1084,10 +1084,10 @@ static void load_dmem_segment(struct c8sectpfei *fei, Elf32_Phdr *phdr,
 		seg_num, phdr->p_paddr, phdr->p_filesz,
 		dst, phdr->p_memsz);
 
-	memcpy((void __iomem *)dst, (void *)fw->data + phdr->p_offset,
+	memcpy((void __force *)dst, (void *)fw->data + phdr->p_offset,
 		phdr->p_filesz);
 
-	memset((void __iomem *)dst + phdr->p_filesz, 0,
+	memset((void __force *)dst + phdr->p_filesz, 0,
 		phdr->p_memsz - phdr->p_filesz);
 }
 
-- 
2.4.3


