Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSsP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:48:15 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id ADAE4804E0
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:48:15 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 16/17] docs/tvtime.desktop: Modernize desktop file
Date: Sat, 13 Feb 2016 19:47:37 +0100
Message-Id: <1455389258-13470-16-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bring the desktop file up to date with the latest freedesktop.org
standards.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 docs/tvtime.desktop | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/docs/tvtime.desktop b/docs/tvtime.desktop
index 7e13285..566a181 100644
--- a/docs/tvtime.desktop
+++ b/docs/tvtime.desktop
@@ -1,5 +1,4 @@
 [Desktop Entry]
-Encoding=UTF-8
 Comment=High quality video deinterlacer
 Icon=tvtime
 Exec=tvtime
@@ -7,4 +6,5 @@ Name=TVtime Television Viewer
 GenericName=Television Viewer
 Terminal=false
 Type=Application
-Categories=Application;AudioVideo;
+Categories=AudioVideo;
+Keywords=tvtime;video;tv;viewer;v4l;v4l2;video4linux;deinterlacer;
-- 
2.5.0

