Return-path: <SRS0=Se8P=JZ=qq.com=zrlw@kernel.org>
From: Lao Wei <zrlw@qq.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org,
	zrlw@qq.com
Subject: [PATCH v1] fix: media: pci: meye: validate offset to avoid arbitrary access
Date: Mon,  9 Jul 2018 20:15:53 +0800
Message-Id: <1531138553-11560-1-git-send-email-zrlw@qq.com>
List-ID: <linux-media.vger.kernel.org>

Motion eye video4linux driver for Sony Vaio PictureBook desn't validate user-controlled parameter
'vma->vm_pgoff', a malicious process might access all of kernel memory from user space by trying
pass different arbitrary address. 
Discussion: http://www.openwall.com/lists/oss-security/2018/07/06/1

Signed-off-by: Lao Wei <zrlw@qq.com>
---
 drivers/media/pci/meye/meye.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 8001d3e..db2a7ad 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1460,7 +1460,7 @@ static int meye_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long page, pos;
 
 	mutex_lock(&meye.lock);
-	if (size > gbuffers * gbufsize) {
+	if (size > gbuffers * gbufsize || offset > gbuffers * gbufsize - size) {
 		mutex_unlock(&meye.lock);
 		return -EINVAL;
 	}
-- 
1.8.5.6
