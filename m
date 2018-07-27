Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:50748 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729519AbeG0MCH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 08:02:07 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media-types.rst: fix doc warnings
Message-ID: <11e91b1e-e527-1601-a04c-d04c0a39974a@xs4all.nl>
Date: Fri, 27 Jul 2018 12:40:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix these warnings when building the documentation:

media.h.rst:6: WARNING: undefined label: media-ent-f-dv-decoder (if the link has no caption the label must precede a section header)
media.h.rst:6: WARNING: undefined label: media-ent-f-dv-encoder (if the link has no caption the label must precede a section header)
media.h.rst:6: WARNING: undefined label: media-ent-f-dv-decoder (if the link has no caption the label must precede a section header)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 0e9adc7869b8..e4c57c8f4553 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -41,7 +41,8 @@ Types and flags used to represent the media graph elements
 .. _MEDIA-ENT-F-PROC-VIDEO-DECODER:
 .. _MEDIA-ENT-F-VID-MUX:
 .. _MEDIA-ENT-F-VID-IF-BRIDGE:
-.. _MEDIA-ENT-F-DTV-DECODER:
+.. _MEDIA-ENT-F-DV-DECODER:
+.. _MEDIA-ENT-F-DV-ENCODER:

 .. cssclass:: longtable
