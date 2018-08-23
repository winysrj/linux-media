Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:37072 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729973AbeHWRZh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 13:25:37 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] video_function_calls.rst: drop obsolete video-set-attributes
 reference
Message-ID: <d80d2a85-3afd-e07a-edf0-b04452ab1e47@xs4all.nl>
Date: Thu, 23 Aug 2018 15:55:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes this warning:

Documentation/media/uapi/dvb/video_function_calls.rst:9: WARNING: toctree contains
reference to nonexisting document 'uapi/dvb/video-set-attributes'

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/dvb/video_function_calls.rst b/Documentation/media/uapi/dvb/video_function_calls.rst
index 3f4f6c9ffad7..a4222b6cd2d3 100644
--- a/Documentation/media/uapi/dvb/video_function_calls.rst
+++ b/Documentation/media/uapi/dvb/video_function_calls.rst
@@ -33,4 +33,3 @@ Video Function Calls
     video-clear-buffer
     video-set-streamtype
     video-set-format
-    video-set-attributes
