Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55005 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752024AbdEIHks (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 03:40:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] 50-udev-default.rules.in: set correct group for mediaX/cecX
To: systemd-devel@lists.freedesktop.org
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <072f4734-5636-7a9d-2151-5fb95e48a262@xs4all.nl>
Date: Tue, 9 May 2017 09:40:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The /dev/mediaX and /dev/cecX devices belong to the video group.
Add two default rules for that.

The /dev/cecX devices were introduced in kernel 4.8 in staging and moved
out of staging in 4.10. These devices support the HDMI CEC bus.

The /dev/mediaX devices are much older, but because they are not used very
frequently nobody got around to adding this rule to systemd. They let the
user control complex media pipelines.

---
 rules/50-udev-default.rules.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rules/50-udev-default.rules.in b/rules/50-udev-default.rules.in
index 064f66a97..e55653302 100644
--- a/rules/50-udev-default.rules.in
+++ b/rules/50-udev-default.rules.in
@@ -34,6 +34,8 @@ SUBSYSTEM=="video4linux", GROUP="video"
 SUBSYSTEM=="graphics", GROUP="video"
 SUBSYSTEM=="drm", GROUP="video"
 SUBSYSTEM=="dvb", GROUP="video"
+SUBSYSTEM=="media", GROUP="video"
+SUBSYSTEM=="cec", GROUP="video"

 SUBSYSTEM=="sound", GROUP="audio", \
   OPTIONS+="static_node=snd/seq", OPTIONS+="static_node=snd/timer"
-- 
2.11.0
