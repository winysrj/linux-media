Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbcBXLHQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 06:07:16 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 2/4] docs/tvtime.desktop: Add Video to Categories.
Date: Wed, 24 Feb 2016 12:07:05 +0100
Message-Id: <1456312027-8484-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1456312027-8484-1-git-send-email-hdegoede@redhat.com>
References: <1456312027-8484-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Video to the desktop file Categories.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 docs/tvtime.desktop | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/docs/tvtime.desktop b/docs/tvtime.desktop
index 566a181..941746c 100644
--- a/docs/tvtime.desktop
+++ b/docs/tvtime.desktop
@@ -6,5 +6,5 @@ Name=TVtime Television Viewer
 GenericName=Television Viewer
 Terminal=false
 Type=Application
-Categories=AudioVideo;
+Categories=AudioVideo;Video;
 Keywords=tvtime;video;tv;viewer;v4l;v4l2;video4linux;deinterlacer;
-- 
2.7.1

