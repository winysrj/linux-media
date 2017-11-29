Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50476 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752211AbdK2TIr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:47 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 01/22] media: sta2x11: document missing function parameters
Date: Wed, 29 Nov 2017 14:08:19 -0500
Message-Id: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned:

    drivers/media/pci/sta2x11/sta2x11_vip.c:414: warning: No description found for parameter 'priv'
    drivers/media/pci/sta2x11/sta2x11_vip.c:442: warning: No description found for parameter 'priv'
    drivers/media/pci/sta2x11/sta2x11_vip.c:476: warning: No description found for parameter 'priv'
    drivers/media/pci/sta2x11/sta2x11_vip.c:493: warning: No description found for parameter 'priv'
    drivers/media/pci/sta2x11/sta2x11_vip.c:524: warning: No description found for parameter 'priv'
    drivers/media/pci/sta2x11/sta2x11_vip.c:548: warning: No description found for parameter 'priv'
    drivers/media/pci/sta2x11/sta2x11_vip.c:566: warning: No description found for parameter 'file'
    drivers/media/pci/sta2x11/sta2x11_vip.c:566: warning: No description found for parameter 'priv'
    drivers/media/pci/sta2x11/sta2x11_vip.c:594: warning: No description found for parameter 'priv'
    drivers/media/pci/sta2x11/sta2x11_vip.c:651: warning: No description found for parameter 'priv'
    drivers/media/pci/sta2x11/sta2x11_vip.c:717: warning: No description found for parameter 'priv'

Most of the above are for the unused priv argument.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/sta2x11/sta2x11_vip.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index eb5a9eae7c8e..dd199bfc1d45 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -404,6 +404,7 @@ static const struct v4l2_file_operations vip_fops = {
  * vidioc_querycap - return capabilities of device
  * @file: descriptor of device
  * @cap: contains return values
+ * @priv: unused
  *
  * the capabilities of the device are returned
  *
@@ -429,6 +430,7 @@ static int vidioc_querycap(struct file *file, void *priv,
  * vidioc_s_std - set video standard
  * @file: descriptor of device
  * @std: contains standard to be set
+ * @priv: unused
  *
  * the video standard is set
  *
@@ -466,6 +468,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id std)
 /**
  * vidioc_g_std - get video standard
  * @file: descriptor of device
+ * @priv: unused
  * @std: contains return values
  *
  * the current video standard is returned
@@ -483,6 +486,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *std)
 /**
  * vidioc_querystd - get possible video standards
  * @file: descriptor of device
+ * @priv: unused
  * @std: contains return values
  *
  * all possible video standards are returned
@@ -512,6 +516,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 /**
  * vidioc_s_input - set input line
  * @file: descriptor of device
+ * @priv: unused
  * @i: new input line number
  *
  * the current active input line is set
@@ -538,6 +543,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 /**
  * vidioc_g_input - return input line
  * @file: descriptor of device
+ * @priv: unused
  * @i: returned input line number
  *
  * the current active input line is returned
@@ -554,6 +560,8 @@ static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 
 /**
  * vidioc_enum_fmt_vid_cap - return video capture format
+ * @file: descriptor of device
+ * @priv: unused
  * @f: returned format information
  *
  * returns name and format of video capture
@@ -577,6 +585,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 /**
  * vidioc_try_fmt_vid_cap - set video capture format
  * @file: descriptor of device
+ * @priv: unused
  * @f: new format
  *
  * new video format is set which includes width and
@@ -639,6 +648,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 /**
  * vidioc_s_fmt_vid_cap - set current video format parameters
  * @file: descriptor of device
+ * @priv: unused
  * @f: returned format information
  *
  * set new capture format
@@ -706,6 +716,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 /**
  * vidioc_g_fmt_vid_cap - get current video format parameters
  * @file: descriptor of device
+ * @priv: unused
  * @f: contains format information
  *
  * returns current video format parameters
-- 
2.14.3
