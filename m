Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4643 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaHUUUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:20:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/12] cx18: fix sparse warnings
Date: Thu, 21 Aug 2014 22:19:33 +0200
Message-Id: <1408652376-39525-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
References: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

/home/hans/work/build/media-git/drivers/media/pci/cx18/cx18-firmware.c:169:32: warning: cast to restricted __le32
/home/hans/work/build/media-git/drivers/media/pci/cx18/cx18-firmware.c:170:32: warning: cast to restricted __le32
/home/hans/work/build/media-git/drivers/media/pci/cx18/cx18-firmware.c:171:31: warning: cast to restricted __le32
/home/hans/work/build/media-git/drivers/media/pci/cx18/cx18-firmware.c:172:31: warning: cast to restricted __le32

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx18/cx18-firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-firmware.c b/drivers/media/pci/cx18/cx18-firmware.c
index a1c1cec..53a7578 100644
--- a/drivers/media/pci/cx18/cx18-firmware.c
+++ b/drivers/media/pci/cx18/cx18-firmware.c
@@ -164,7 +164,7 @@ static int load_apu_fw_direct(const char *fn, u8 __iomem *dst, struct cx18 *cx,
 
 	apu_version = (vers[0] << 24) | (vers[4] << 16) | vers[32];
 	while (offset + sizeof(seghdr) < fw->size) {
-		const u32 *shptr = src + offset / 4;
+		const __le32 *shptr = (__force __le32 *)src + offset / 4;
 
 		seghdr.sync1 = le32_to_cpu(shptr[0]);
 		seghdr.sync2 = le32_to_cpu(shptr[1]);
-- 
2.1.0.rc1

