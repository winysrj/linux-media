Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:16607 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbcFKXBn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2016 19:01:43 -0400
From: Henrik Austad <henrik@austad.us>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, alsa-devel@vger.kernel.org,
	netdev@vger.kernel.org, henrk@austad.us,
	Henrik Austad <haustad@cisco.com>
Subject: [very-RFC 8/8] MAINTAINERS: add TSN/AVB-entries
Date: Sun, 12 Jun 2016 01:01:36 +0200
Message-Id: <1465686096-22156-9-git-send-email-henrik@austad.us>
In-Reply-To: <1465686096-22156-1-git-send-email-henrik@austad.us>
References: <1465686096-22156-1-git-send-email-henrik@austad.us>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Henrik Austad <haustad@cisco.com>

Not sure how relevant this is other than making a point about
maintaining it.

Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 MAINTAINERS | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ed42cb6..ef5d926 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11634,6 +11634,20 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/tuners/tua9001*
 
+TSN CORE DRIVER
+M:	Henrik Austad <haustad@cisco.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	drivers/net/tsn/
+F:	include/linux/tsn.h
+F:	include/trace/events/tsn.h
+
+TSN_AVB_DRIVER
+M:	Henrik Austad <haustad@cisco.com>
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
+S:	Supported
+F:	drivers/media/avb/
+
 TULIP NETWORK DRIVERS
 L:	netdev@vger.kernel.org
 L:	linux-parisc@vger.kernel.org
-- 
2.7.4

