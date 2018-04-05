Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44934 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751645AbeDEU36 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:29:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH v2 04/19] media: fsl-viu: mark static functions as such
Date: Thu,  5 Apr 2018 16:29:31 -0400
Message-Id: <687520dc31a88c82c694492423c5d9c503cbdebb.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several functions that are used only inside the
driver. Stop exposing that to global symbolspace.

Get rid of the following gcc warnings:

drivers/media/platform/fsl-viu.c:240:17: warning: no previous prototype for ‘format_by_fourcc’ [-Wmissing-prototypes]
 struct viu_fmt *format_by_fourcc(int fourcc)
                 ^~~~~~~~~~~~~~~~
drivers/media/platform/fsl-viu.c:253:6: warning: no previous prototype for ‘viu_start_dma’ [-Wmissing-prototypes]
 void viu_start_dma(struct viu_dev *dev)
      ^~~~~~~~~~~~~
drivers/media/platform/fsl-viu.c:262:6: warning: no previous prototype for ‘viu_stop_dma’ [-Wmissing-prototypes]
 void viu_stop_dma(struct viu_dev *dev)
      ^~~~~~~~~~~~
drivers/media/platform/fsl-viu.c:807:5: warning: no previous prototype for ‘vidioc_g_fbuf’ [-Wmissing-prototypes]
 int vidioc_g_fbuf(struct file *file, void *priv, struct v4l2_framebuffer *arg)
     ^~~~~~~~~~~~~
drivers/media/platform/fsl-viu.c:818:5: warning: no previous prototype for ‘vidioc_s_fbuf’ [-Wmissing-prototypes]
 int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_framebuffer *arg)
     ^~~~~~~~~~~~~
drivers/media/platform/fsl-viu.c: In function ‘viu_open’:
drivers/media/platform/fsl-viu.c:1170:6: warning: variable ‘status_cfg’ set but not used [-Wunused-but-set-variable]
  u32 status_cfg;
      ^~~~~~~~~~
drivers/media/platform/fsl-viu.c: At top level:
drivers/media/platform/fsl-viu.c:1304:6: warning: no previous prototype for ‘viu_reset’ [-Wmissing-prototypes]
 void viu_reset(struct viu_reg *reg)
      ^~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/fsl-viu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 200c47c69a75..9abe79779659 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -229,7 +229,7 @@ enum status_config {
 
 static irqreturn_t viu_intr(int irq, void *dev_id);
 
-struct viu_fmt *format_by_fourcc(int fourcc)
+static struct viu_fmt *format_by_fourcc(int fourcc)
 {
 	int i;
 
@@ -242,7 +242,7 @@ struct viu_fmt *format_by_fourcc(int fourcc)
 	return NULL;
 }
 
-void viu_start_dma(struct viu_dev *dev)
+static void viu_start_dma(struct viu_dev *dev)
 {
 	struct viu_reg *vr = dev->vr;
 
@@ -253,7 +253,7 @@ void viu_start_dma(struct viu_dev *dev)
 	out_be32(&vr->status_cfg, INT_FIELD_EN);
 }
 
-void viu_stop_dma(struct viu_dev *dev)
+static void viu_stop_dma(struct viu_dev *dev)
 {
 	struct viu_reg *vr = dev->vr;
 	int cnt = 100;
@@ -802,7 +802,7 @@ static int vidioc_overlay(struct file *file, void *priv, unsigned int on)
 	return 0;
 }
 
-int vidioc_g_fbuf(struct file *file, void *priv, struct v4l2_framebuffer *arg)
+static int vidioc_g_fbuf(struct file *file, void *priv, struct v4l2_framebuffer *arg)
 {
 	struct viu_fh  *fh = priv;
 	struct viu_dev *dev = fh->dev;
@@ -813,7 +813,7 @@ int vidioc_g_fbuf(struct file *file, void *priv, struct v4l2_framebuffer *arg)
 	return 0;
 }
 
-int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_framebuffer *arg)
+static int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_framebuffer *arg)
 {
 	struct viu_fh  *fh = priv;
 	struct viu_dev *dev = fh->dev;
@@ -1305,7 +1305,7 @@ static int viu_release(struct file *file)
 	return 0;
 }
 
-void viu_reset(struct viu_reg *reg)
+static void viu_reset(struct viu_reg *reg)
 {
 	out_be32(&reg->status_cfg, 0);
 	out_be32(&reg->luminance, 0x9512a254);
-- 
2.14.3
