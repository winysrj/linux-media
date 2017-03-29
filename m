Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54199 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753805AbdC2H4u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 03:56:50 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] dev-capture.rst/dev-output.rst: video standards ioctls are
 optional
Message-ID: <8e21fc74-64a8-8767-8bcf-4b954d4e22c1@xs4all.nl>
Date: Wed, 29 Mar 2017 09:56:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation for video capture and output devices claims that the video standard
ioctls are required. This is not the case, they are only required for PAL/NTSC/SECAM
type inputs and outputs. Sensors do not implement this at all and e.g. HDMI inputs
implement the DV Timings ioctls.

Just drop the mention of 'video standard' ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/dev-capture.rst b/Documentation/media/uapi/v4l/dev-capture.rst
index 32b32055d070..4218742ab5d9 100644
--- a/Documentation/media/uapi/v4l/dev-capture.rst
+++ b/Documentation/media/uapi/v4l/dev-capture.rst
@@ -42,8 +42,8 @@ Video capture devices shall support :ref:`audio input <audio>`,
 :ref:`tuner`, :ref:`controls <control>`,
 :ref:`cropping and scaling <crop>` and
 :ref:`streaming parameter <streaming-par>` ioctls as needed. The
-:ref:`video input <video>` and :ref:`video standard <standard>`
-ioctls must be supported by all video capture devices.
+:ref:`video input <video>` ioctls must be supported by all video
+capture devices.


 Image Format Negotiation
diff --git a/Documentation/media/uapi/v4l/dev-output.rst b/Documentation/media/uapi/v4l/dev-output.rst
index 25ae8ec96fdf..342eb4931f5c 100644
--- a/Documentation/media/uapi/v4l/dev-output.rst
+++ b/Documentation/media/uapi/v4l/dev-output.rst
@@ -40,8 +40,8 @@ Video output devices shall support :ref:`audio output <audio>`,
 :ref:`modulator <tuner>`, :ref:`controls <control>`,
 :ref:`cropping and scaling <crop>` and
 :ref:`streaming parameter <streaming-par>` ioctls as needed. The
-:ref:`video output <video>` and :ref:`video standard <standard>`
-ioctls must be supported by all video output devices.
+:ref:`video output <video>` ioctls must be supported by all video
+output devices.


 Image Format Negotiation
