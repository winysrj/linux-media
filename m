Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab2IMULo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 16:11:44 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] DocBook: Fix docbook compilation
Date: Thu, 13 Sep 2012 17:11:40 -0300
Message-Id: <1347567100-2256-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 1248c7cb66d734b60efed41be7c7b86909812c0e broke html compilation:

Documentation/DocBook/v4l2.xml:584: parser error : Entity 'sub-subdev-g-edid' not defined
Documentation/DocBook/v4l2.xml:626: parser error : chunk is not well balanced
Documentation/DocBook/media_api.xml:74: parser error : Failure to process entity sub-v4l2
Documentation/DocBook/media_api.xml:74: parser error : Entity 'sub-v4l2' not defined

I suspect that one file was simply missed at the patch. Yet, keeping
it broken is a very bad idea, so we should either remove the broken
patch or to remove just the invalid include. Let's take the latter
approach.

Due to that, a warning is now produced:

Error: no ID for constraint linkend: v4l2-subdev-edid.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/v4l/v4l2.xml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 10ccde9..0292ed1 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -581,7 +581,6 @@ and discussions on the V4L mailing list.</revremark>
     &sub-subdev-enum-frame-size;
     &sub-subdev-enum-mbus-code;
     &sub-subdev-g-crop;
-    &sub-subdev-g-edid;
     &sub-subdev-g-fmt;
     &sub-subdev-g-frame-interval;
     &sub-subdev-g-selection;
-- 
1.7.11.4

