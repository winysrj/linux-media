Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:53813 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752557AbdHBIms (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:42:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Eric Anholt <eric@anholt.net>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] MAINTAINERS: add cec-gpio entry
Date: Wed,  2 Aug 2017 10:42:42 +0200
Message-Id: <20170802084242.14947-4-hverkuil@xs4all.nl>
In-Reply-To: <20170802084242.14947-1-hverkuil@xs4all.nl>
References: <20170802084242.14947-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add an entry for the CEC GPIO driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aeb84877854b..d85959f82a09 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3199,6 +3199,15 @@ F:	include/uapi/linux/cec.h
 F:	include/uapi/linux/cec-funcs.h
 F:	Documentation/devicetree/bindings/media/cec.txt
 
+CEC GPIO DRIVER
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Supported
+F:	drivers/media/platform/cec-gpio/
+F:	Documentation/devicetree/bindings/media/cec-gpio.txt
+
 CELL BROADBAND ENGINE ARCHITECTURE
 M:	Arnd Bergmann <arnd@arndb.de>
 L:	linuxppc-dev@lists.ozlabs.org
-- 
2.13.2
