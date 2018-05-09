Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40685 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932875AbeEIMkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 08:40:15 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Harry Wei <harryxiyou@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Walls <awalls@md.metrocast.net>,
        Erik Andren <erik.andren@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@zh-kernel.org,
        linux-doc@vger.kernel.org, mjpeg-users@lists.sourceforge.net
Subject: [PATCH 3/3] media: v4l: fix broken video4linux docs locations
Date: Wed,  9 May 2018 09:40:07 -0300
Message-Id: <8ee3955662fb6a652599ae4f3b00201b44eda97a.1525869503.git.mchehab+samsung@kernel.org>
In-Reply-To: <d805b8f0265652f5b9dfc8f8f276a490a1fdba5f.1525869503.git.mchehab+samsung@kernel.org>
References: <d805b8f0265652f5b9dfc8f8f276a490a1fdba5f.1525869503.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
In-Reply-To: <d805b8f0265652f5b9dfc8f8f276a490a1fdba5f.1525869503.git.mchehab+samsung@kernel.org>
References: <d805b8f0265652f5b9dfc8f8f276a490a1fdba5f.1525869503.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several places pointing to old documentation files:

  Documentation/video4linux/API.html
  Documentation/video4linux/bttv/
  Documentation/video4linux/cx2341x/fw-encoder-api.txt
  Documentation/video4linux/m5602.txt
  Documentation/video4linux/v4l2-framework.txt
  Documentation/video4linux/videobuf
  Documentation/video4linux/Zoran

Make them point to the new location where available, removing
otherwise.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../translations/zh_CN/video4linux/v4l2-framework.txt  |  6 +++---
 drivers/media/pci/bt8xx/Kconfig                        |  2 +-
 drivers/media/pci/cx18/cx18-streams.c                  |  4 ++--
 drivers/media/pci/zoran/Kconfig                        |  2 +-
 drivers/media/radio/Kconfig                            | 10 +++++-----
 drivers/media/radio/wl128x/Kconfig                     |  2 +-
 drivers/media/usb/gspca/m5602/Kconfig                  |  2 --
 7 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt b/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt
index 698660b7f21f..054716a7ae77 100644
--- a/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt
+++ b/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt
@@ -1,4 +1,4 @@
-Chinese translated version of Documentation/video4linux/v4l2-framework.txt
+Chinese translated version of Documentation/media/media_kapi.rst
 
 If you have any comment or update to the content, please contact the
 original document maintainer directly.  However, if you have a problem
@@ -9,7 +9,7 @@ or if there is a problem with the translation.
 Maintainer: Mauro Carvalho Chehab <mchehab@infradead.org>
 Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
 ---------------------------------------------------------------------
-Documentation/video4linux/v4l2-framework.txt 的中文翻译
+Documentation/media/media_kapi.rst 的中文翻译
 
 如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
 交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
@@ -777,7 +777,7 @@ v4l2 核心 API 提供了一个处理视频缓冲的标准方法(称为“videob
 线性 DMA(videobuf-dma-contig)以及大多用于 USB 设备的用 vmalloc
 分配的缓冲(videobuf-vmalloc)。
 
-请参阅 Documentation/video4linux/videobuf，以获得更多关于 videobuf
+请参阅 Documentation/media/kapi/v4l2-videobuf.rst，以获得更多关于 videobuf
 层的使用信息。
 
 v4l2_fh 结构体
diff --git a/drivers/media/pci/bt8xx/Kconfig b/drivers/media/pci/bt8xx/Kconfig
index 4a93f6ded100..bc89e37608cd 100644
--- a/drivers/media/pci/bt8xx/Kconfig
+++ b/drivers/media/pci/bt8xx/Kconfig
@@ -16,7 +16,7 @@ config VIDEO_BT848
 	---help---
 	  Support for BT848 based frame grabber/overlay boards. This includes
 	  the Miro, Hauppauge and STB boards. Please read the material in
-	  <file:Documentation/video4linux/bttv/> for more information.
+	  <file:Documentation/media/v4l-drivers/bttv.rst> for more information.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called bttv.
diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index a594cfdeca20..b36f4ce25d22 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -853,7 +853,7 @@ int cx18_start_v4l2_encode_stream(struct cx18_stream *s)
 
 		/*
 		 * Audio related reset according to
-		 * Documentation/video4linux/cx2341x/fw-encoder-api.txt
+		 * Documentation/media/v4l-drivers/cx2341x.rst
 		 */
 		if (atomic_read(&cx->ana_capturing) == 0)
 			cx18_vapi(cx, CX18_CPU_SET_MISC_PARAMETERS, 2,
@@ -861,7 +861,7 @@ int cx18_start_v4l2_encode_stream(struct cx18_stream *s)
 
 		/*
 		 * Number of lines for Field 1 & Field 2 according to
-		 * Documentation/video4linux/cx2341x/fw-encoder-api.txt
+		 * Documentation/media/v4l-drivers/cx2341x.rst
 		 * Field 1 is 312 for 625 line systems in BT.656
 		 * Field 2 is 313 for 625 line systems in BT.656
 		 */
diff --git a/drivers/media/pci/zoran/Kconfig b/drivers/media/pci/zoran/Kconfig
index 39ec35bd21a5..66c4c238ac0f 100644
--- a/drivers/media/pci/zoran/Kconfig
+++ b/drivers/media/pci/zoran/Kconfig
@@ -7,7 +7,7 @@ config VIDEO_ZORAN
 	  36057/36067 PCI controller chipset. This includes the Iomega
 	  Buz, Pinnacle DC10+ and the Linux Media Labs LML33. There is
 	  a driver homepage at <http://mjpeg.sf.net/driver-zoran/>. For
-	  more information, check <file:Documentation/video4linux/Zoran>.
+	  more information, check <file:Documentation/media/v4l-drivers/zoran.rst>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called zr36067.
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 8fa403c7149e..04ddd5057098 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -35,7 +35,7 @@ config RADIO_SI476X
 	  In order to control your radio card, you will need to use programs
 	  that are compatible with the Video For Linux 2 API.  Information on
 	  this API and pointers to "v4l2" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
+	  <file:Documentation/media/media_uapi.rst>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-si476x.
@@ -75,7 +75,7 @@ config RADIO_MAXIRADIO
 	  In order to control your radio card, you will need to use programs
 	  that are compatible with the Video For Linux API.  Information on
 	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
+	  <file:Documentation/media/media_uapi.rst>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-maxiradio.
@@ -93,7 +93,7 @@ config RADIO_SHARK
 	  In order to control your radio card, you will need to use programs
 	  that are compatible with the Video For Linux API.  Information on
 	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
+	  <file:Documentation/media/media_uapi.rst>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-shark.
@@ -110,7 +110,7 @@ config RADIO_SHARK2
 	  In order to control your radio card, you will need to use programs
 	  that are compatible with the Video For Linux API.  Information on
 	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
+	  <file:Documentation/media/media_uapi.rst>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-shark2.
@@ -217,7 +217,7 @@ config RADIO_WL1273
 	  In order to control your radio card, you will need to use programs
 	  that are compatible with the Video For Linux 2 API.  Information on
 	  this API and pointers to "v4l2" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
+	  <file:Documentation/media/media_uapi.rst>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-wl1273.
diff --git a/drivers/media/radio/wl128x/Kconfig b/drivers/media/radio/wl128x/Kconfig
index 2add222ea346..64b66bbdae72 100644
--- a/drivers/media/radio/wl128x/Kconfig
+++ b/drivers/media/radio/wl128x/Kconfig
@@ -12,6 +12,6 @@ config RADIO_WL128X
 	  In order to control your radio card, you will need to use programs
 	  that are compatible with the Video For Linux 2 API.  Information on
 	  this API and pointers to "v4l2" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
+	  <file:Documentation/media/media_uapi.rst>.
 
 endmenu
diff --git a/drivers/media/usb/gspca/m5602/Kconfig b/drivers/media/usb/gspca/m5602/Kconfig
index 5a69016ed75f..13a00399ced9 100644
--- a/drivers/media/usb/gspca/m5602/Kconfig
+++ b/drivers/media/usb/gspca/m5602/Kconfig
@@ -5,7 +5,5 @@ config USB_M5602
 	  Say Y here if you want support for cameras based on the
 	  ALi m5602 connected to various image sensors.
 
-	  See <file:Documentation/video4linux/m5602.txt> for more info.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called gspca_m5602.
-- 
2.17.0
