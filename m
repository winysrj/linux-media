Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58250
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751286AbdH1MyK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 08:54:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v5 5/7] media: open.rst: Adjust some terms to match the glossary
Date: Mon, 28 Aug 2017 09:53:59 -0300
Message-Id: <e173f9d7a787511e6ee46cec702ab98963a10af0.1503924361.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503924361.git.mchehab@s-opensource.com>
References: <cover.1503924361.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503924361.git.mchehab@s-opensource.com>
References: <cover.1503924361.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we now have a glossary, some terms used on open.rst
require adjustments.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/open.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index 21b8f7c5ca55..2575b6aea029 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -138,7 +138,7 @@ Related Devices
 Devices can support several functions. For example video capturing, VBI
 capturing and radio support.
 
-The V4L2 API creates different nodes for each of these functions.
+The V4L2 API creates different V4L2 device nodes for each of these functions.
 
 The V4L2 API was designed with the idea that one device node could
 support all functions. However, in practice this never worked: this
@@ -148,17 +148,17 @@ switching a device node between different functions only works when
 using the streaming I/O API, not with the
 :ref:`read() <func-read>`/\ :ref:`write() <func-write>` API.
 
-Today each device node supports just one function.
+Today each V4L2 device node supports just one function.
 
 Besides video input or output the hardware may also support audio
 sampling or playback. If so, these functions are implemented as ALSA PCM
 devices with optional ALSA audio mixer devices.
 
 One problem with all these devices is that the V4L2 API makes no
-provisions to find these related devices. Some really complex devices
-use the Media Controller (see :ref:`media_controller`) which can be
-used for this purpose. But most drivers do not use it, and while some
-code exists that uses sysfs to discover related devices (see
+provisions to find these related V4L2 device nodes. Some really complex
+hardware use the Media Controller (see :ref:`media_controller`) which can
+be used for this purpose. But several drivers do not use it, and while some
+code exists that uses sysfs to discover related V4L2 device nodes (see
 libmedia_dev in the
 `v4l-utils <http://git.linuxtv.org/cgit.cgi/v4l-utils.git/>`__ git
 repository), there is no library yet that can provide a single API
-- 
2.13.5
