Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:36495 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754490AbdGXUxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 16:53:44 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH V2 3/3] build: fix up build w/kernels <=4.12 by reverting 4.13 patches
Date: Mon, 24 Jul 2017 22:53:37 +0200
Message-Id: <1500929617-13623-4-git-send-email-jasmin@anw.at>
In-Reply-To: <1500929617-13623-1-git-send-email-jasmin@anw.at>
References: <1500929617-13623-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/backports.txt                            |  3 +
 .../v4.12_revert_solo6x10_copykerneluser.patch     | 71 ++++++++++++++++++++++
 2 files changed, 74 insertions(+)
 create mode 100644 backports/v4.12_revert_solo6x10_copykerneluser.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 9803f76..873b2f5 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -26,6 +26,9 @@ add pr_fmt.patch
 add debug.patch
 add drx39xxj.patch
 
+[4.12.255]
+add v4.12_revert_solo6x10_copykerneluser.patch
+
 [4.10.255]
 add v4.10_sched_signal.patch
 add v4.10_fault_page.patch
diff --git a/backports/v4.12_revert_solo6x10_copykerneluser.patch b/backports/v4.12_revert_solo6x10_copykerneluser.patch
new file mode 100644
index 0000000..2ccb9d8
--- /dev/null
+++ b/backports/v4.12_revert_solo6x10_copykerneluser.patch
@@ -0,0 +1,71 @@
+commit bbf3d164ec2723f090533c14ec1dc166eaca46f8
+Author: Daniel Scheller <d.scheller@gmx.net>
+Date:   Fri Jul 21 20:41:49 2017 +0200
+
+    Revert "[media] solo6x10: Convert to the new PCM ops"
+    
+    This reverts commit 1facf21e8b903524b34f09c39a7d27b4b71a07f7.
+
+diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
+index 3ca947092775..36e93540bb49 100644
+--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
++++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
+@@ -223,9 +223,9 @@ static snd_pcm_uframes_t snd_solo_pcm_pointer(struct snd_pcm_substream *ss)
+ 	return idx * G723_FRAMES_PER_PAGE;
+ }
+ 
+-static int __snd_solo_pcm_copy(struct snd_pcm_substream *ss,
+-			       unsigned long pos, void *dst,
+-			       unsigned long count, bool in_kernel)
++static int snd_solo_pcm_copy(struct snd_pcm_substream *ss, int channel,
++			     snd_pcm_uframes_t pos, void __user *dst,
++			     snd_pcm_uframes_t count)
+ {
+ 	struct solo_snd_pcm *solo_pcm = snd_pcm_substream_chip(ss);
+ 	struct solo_dev *solo_dev = solo_pcm->solo_dev;
+@@ -242,31 +242,16 @@ static int __snd_solo_pcm_copy(struct snd_pcm_substream *ss,
+ 		if (err)
+ 			return err;
+ 
+-		if (in_kernel)
+-			memcpy(dst, solo_pcm->g723_buf, G723_PERIOD_BYTES);
+-		else if (copy_to_user((void __user *)dst,
+-				      solo_pcm->g723_buf, G723_PERIOD_BYTES))
++		err = copy_to_user(dst + (i * G723_PERIOD_BYTES),
++				   solo_pcm->g723_buf, G723_PERIOD_BYTES);
++
++		if (err)
+ 			return -EFAULT;
+-		dst += G723_PERIOD_BYTES;
+ 	}
+ 
+ 	return 0;
+ }
+ 
+-static int snd_solo_pcm_copy_user(struct snd_pcm_substream *ss, int channel,
+-				  unsigned long pos, void __user *dst,
+-				  unsigned long count)
+-{
+-	return __snd_solo_pcm_copy(ss, pos, (void *)dst, count, false);
+-}
+-
+-static int snd_solo_pcm_copy_kernel(struct snd_pcm_substream *ss, int channel,
+-				    unsigned long pos, void *dst,
+-				    unsigned long count)
+-{
+-	return __snd_solo_pcm_copy(ss, pos, dst, count, true);
+-}
+-
+ static const struct snd_pcm_ops snd_solo_pcm_ops = {
+ 	.open = snd_solo_pcm_open,
+ 	.close = snd_solo_pcm_close,
+@@ -276,8 +261,7 @@ static const struct snd_pcm_ops snd_solo_pcm_ops = {
+ 	.prepare = snd_solo_pcm_prepare,
+ 	.trigger = snd_solo_pcm_trigger,
+ 	.pointer = snd_solo_pcm_pointer,
+-	.copy_user = snd_solo_pcm_copy_user,
+-	.copy_kernel = snd_solo_pcm_copy_kernel,
++	.copy = snd_solo_pcm_copy,
+ };
+ 
+ static int snd_solo_capture_volume_info(struct snd_kcontrol *kcontrol,
-- 
2.7.4
