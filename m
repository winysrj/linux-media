Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39284 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752107AbdF3OfW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 10:35:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Eric Anholt <eric@anholt.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 11/12] MAINTAINERS: add cec-gpio entry
Date: Fri, 30 Jun 2017 16:35:08 +0200
Message-Id: <20170630143509.56029-12-hverkuil@xs4all.nl>
In-Reply-To: <20170630143509.56029-1-hverkuil@xs4all.nl>
References: <20170630143509.56029-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add an entry for the CEC GPIO driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c4be6d4af7d2..cffc77c8facf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3140,6 +3140,14 @@ F:	include/uapi/linux/cec.h
 F:	include/uapi/linux/cec-funcs.h
 F:	Documentation/devicetree/bindings/media/cec.txt
 
+CEC GPIO DRIVER
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Supported
+F:	drivers/media/platform/cec-gpio/
+
 CELL BROADBAND ENGINE ARCHITECTURE
 M:	Arnd Bergmann <arnd@arndb.de>
 L:	linuxppc-dev@lists.ozlabs.org
-- 
2.11.0
