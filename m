Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbcHPQrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:47:42 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/9] [media] pixfmt-nv12mt.rst: use PNG instead of GIF
Date: Tue, 16 Aug 2016 13:47:29 -0300
Message-Id: <a7e22ac4d577519f4845755a79fbb92181550cdc.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pdflatex doesn't like gif images:
	None:None: WARNING: no matching candidate for image URI u'media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.*'
	None:None: WARNING: no matching candidate for image URI u'media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.*'

But it works fine with png. So, convert them. As a plus, PNG images
are smaller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-nv12mt.rst           |   4 ++--
 .../media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif        | Bin 2108 -> 0 bytes
 .../media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.png        | Bin 0 -> 1920 bytes
 .../uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.gif      | Bin 6858 -> 0 bytes
 .../uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.png      | Bin 0 -> 5261 bytes
 5 files changed, 2 insertions(+), 2 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.png
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.gif
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.png

diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
index 6198941bb814..1e6fdf0194f5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
@@ -36,7 +36,7 @@ Layout of macroblocks in memory is presented in the following figure.
 .. _nv12mt:
 
 .. figure::  pixfmt-nv12mt_files/nv12mt.*
-    :alt:    nv12mt.gif
+    :alt:    nv12mt.png
     :align:  center
 
     V4L2_PIX_FMT_NV12MT macroblock Z shape memory layout
@@ -53,7 +53,7 @@ interleaved. Height of the buffer is aligned to 32.
 .. _nv12mt_ex:
 
 .. figure::  pixfmt-nv12mt_files/nv12mt_example.*
-    :alt:    nv12mt_example.gif
+    :alt:    nv12mt_example.png
     :align:  center
 
     Example V4L2_PIX_FMT_NV12MT memory layout of macroblocks
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif b/Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif
deleted file mode 100644
index ef2d4cf8367b97293eb9139de0f33d0a2ac236be..0000000000000000000000000000000000000000
GIT binary patch
literal 0
HcmV?d00001

literal 2108
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
JfkA-P{{T*w8|nZ6

diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.png b/Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.png
new file mode 100644
index 0000000000000000000000000000000000000000..41401860fb737739658c354c0cb7ca12313a0265
GIT binary patch
literal 1920
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
JC_3vN^#^QHk<b7D

literal 0
HcmV?d00001

diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.gif b/Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.gif
deleted file mode 100644
index df81d68108eeb66569417b475984aa634385eebb..0000000000000000000000000000000000000000
GIT binary patch
literal 0
HcmV?d00001

literal 6858
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
V-^XO_BChtj?V@hK$vy-q{tq)sSegI;

diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.png b/Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.png
new file mode 100644
index 0000000000000000000000000000000000000000..7775f5d7cc4661b7ec082e7ed5542eddb7dc65de
GIT binary patch
literal 5261
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
HjxqlNW%-jc

literal 0
HcmV?d00001

-- 
2.7.4


