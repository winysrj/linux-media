Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:32932 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751419AbdHaLB7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 07:01:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 5/5] MAINTAINERS: add cec-gpio entry
Date: Thu, 31 Aug 2017 13:01:56 +0200
Message-Id: <20170831110156.11018-6-hverkuil@xs4all.nl>
In-Reply-To: <20170831110156.11018-1-hverkuil@xs4all.nl>
References: <20170831110156.11018-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add an entry for the CEC GPIO driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index eb930ebecfcb..5ef0d34ef502 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3205,6 +3205,15 @@ F:	include/uapi/linux/cec.h
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
2.14.1
