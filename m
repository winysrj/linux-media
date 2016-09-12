Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42095 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755843AbcILMxq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 08:53:46 -0400
From: Helen Koike <helen.koike@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        jgebben@codeaurora.org, mchehab@osg.samsung.com
Cc: Helen Fornazier <helen.fornazier@gmail.com>
Subject: [PATCH] [media] MAINTAINERS: add vimc entry
Date: Mon, 12 Sep 2016 09:53:28 -0300
Message-Id: <0fe6a27b269e5d3da10e3c842f8cc3c466873703.1473684735.git.helen.koike@collabora.com>
In-Reply-To: <cd080d30-e0eb-a544-5512-0de634f1cf22@xs4all.nl>
References: <cd080d30-e0eb-a544-5512-0de634f1cf22@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Helen Koike <helen.koike@collabora.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0a16a82..43e0eb4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12540,6 +12540,14 @@ W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/platform/vivid/*
 
+VIMC VIRTUAL MEDIA CONTROLLER DRIVER
+M:	Helen Koike <helen.koike@collabora.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	https://linuxtv.org
+S:	Maintained
+F:	drivers/media/platform/vimc/*
+
 VLAN (802.1Q)
 M:	Patrick McHardy <kaber@trash.net>
 L:	netdev@vger.kernel.org
-- 
2.7.4

