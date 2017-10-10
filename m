Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57389 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755272AbdJJLpd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 07:45:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v8 5/7] media: open.rst: Adjust some terms to match the glossary
Date: Tue, 10 Oct 2017 08:45:21 -0300
Message-Id: <57ad7d66ae6c9de96cae48cecc77137a0970bab6.1507635716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507635716.git.mchehab@s-opensource.com>
References: <cover.1507635716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507635716.git.mchehab@s-opensource.com>
References: <cover.1507635716.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we now have a glossary, some terms used on open.rst
require adjustments.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/open.rst | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index 1a8a9e1d0e84..c9e6bc9280a6 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -159,27 +159,28 @@ Related Devices
 Devices can support several functions. For example video capturing, VBI
 capturing and radio support.
 
-The V4L2 API creates different nodes for each of these functions.
+The V4L2 API creates different :term:`V4L2 device nodes <v4l2 device node>`
+types for each of these functions.
 
-The V4L2 API was designed with the idea that one device node could
+The V4L2 API was designed with the idea that one :term:`device node` could
 support all functions. However, in practice this never worked: this
-'feature' was never used by applications and many drivers did not
-support it and if they did it was certainly never tested. In addition,
+'feature' was never used by applications and many :term:`drivers <driver>`
+did not support it and if they did it was certainly never tested. In addition,
 switching a device node between different functions only works when
 using the streaming I/O API, not with the
 :ref:`read() <func-read>`/\ :ref:`write() <func-write>` API.
 
-Today each device node supports just one function.
+Today each V4L2 device node supports just one function.
 
-Besides video input or output the hardware may also support audio
-sampling or playback. If so, these functions are implemented as ALSA PCM
-devices with optional ALSA audio mixer devices.
+Besides video input or output, the :term:`media hardware` may also support
+audio sampling or playback. If so, these functions are implemented as ALSA
+PCM devices with optional ALSA audio mixer devices.
 
 One problem with all these devices is that the V4L2 API makes no
-provisions to find these related devices. Some really complex devices
-use the Media Controller (see :ref:`media_controller`) which can be
-used for this purpose. But most drivers do not use it, and while some
-code exists that uses sysfs to discover related devices (see
+provisions to find these related V4L2 device nodes. Some really complex
+hardware use the :term:`media controller` (see :ref:`media_controller`) which
+can be used for this purpose. But several drivers do not use it, and while
+some code exists that uses sysfs to discover related V4L2 device nodes (see
 libmedia_dev in the
 `v4l-utils <http://git.linuxtv.org/cgit.cgi/v4l-utils.git/>`__ git
 repository), there is no library yet that can provide a single API
-- 
2.13.6
