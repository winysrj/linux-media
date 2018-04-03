Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:34862 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753367AbeDCVQA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 17:16:00 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 3/5] media: docs: selection: rename files to something meaningful
Date: Tue,  3 Apr 2018 23:15:44 +0200
Message-Id: <1522790146-16061-3-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1522790146-16061-1-git-send-email-luca@lucaceresoli.net>
References: <1522790146-16061-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These files have an automatically-generated numbering. Replaname them
to something that suggests their meaning.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 .../{selection-api-004.rst => selection-api-configuration.rst} |  0
 .../v4l/{selection-api-006.rst => selection-api-examples.rst}  |  0
 .../v4l/{selection-api-002.rst => selection-api-intro.rst}     |  0
 .../v4l/{selection-api-003.rst => selection-api-targets.rst}   |  0
 .../{selection-api-005.rst => selection-api-vs-crop-api.rst}   |  0
 Documentation/media/uapi/v4l/selection-api.rst                 | 10 +++++-----
 6 files changed, 5 insertions(+), 5 deletions(-)
 rename Documentation/media/uapi/v4l/{selection-api-004.rst => selection-api-configuration.rst} (100%)
 rename Documentation/media/uapi/v4l/{selection-api-006.rst => selection-api-examples.rst} (100%)
 rename Documentation/media/uapi/v4l/{selection-api-002.rst => selection-api-intro.rst} (100%)
 rename Documentation/media/uapi/v4l/{selection-api-003.rst => selection-api-targets.rst} (100%)
 rename Documentation/media/uapi/v4l/{selection-api-005.rst => selection-api-vs-crop-api.rst} (100%)

diff --git a/Documentation/media/uapi/v4l/selection-api-004.rst b/Documentation/media/uapi/v4l/selection-api-configuration.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selection-api-004.rst
rename to Documentation/media/uapi/v4l/selection-api-configuration.rst
diff --git a/Documentation/media/uapi/v4l/selection-api-006.rst b/Documentation/media/uapi/v4l/selection-api-examples.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selection-api-006.rst
rename to Documentation/media/uapi/v4l/selection-api-examples.rst
diff --git a/Documentation/media/uapi/v4l/selection-api-002.rst b/Documentation/media/uapi/v4l/selection-api-intro.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selection-api-002.rst
rename to Documentation/media/uapi/v4l/selection-api-intro.rst
diff --git a/Documentation/media/uapi/v4l/selection-api-003.rst b/Documentation/media/uapi/v4l/selection-api-targets.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selection-api-003.rst
rename to Documentation/media/uapi/v4l/selection-api-targets.rst
diff --git a/Documentation/media/uapi/v4l/selection-api-005.rst b/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selection-api-005.rst
rename to Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
diff --git a/Documentation/media/uapi/v4l/selection-api.rst b/Documentation/media/uapi/v4l/selection-api.rst
index e4e623824b30..390233f704a3 100644
--- a/Documentation/media/uapi/v4l/selection-api.rst
+++ b/Documentation/media/uapi/v4l/selection-api.rst
@@ -9,8 +9,8 @@ Cropping, composing and scaling -- the SELECTION API
 .. toctree::
     :maxdepth: 1
 
-    selection-api-002
-    selection-api-003
-    selection-api-004
-    selection-api-005
-    selection-api-006
+    selection-api-intro.rst
+    selection-api-targets.rst
+    selection-api-configuration.rst
+    selection-api-vs-crop-api.rst
+    selection-api-examples.rst
-- 
2.7.4
