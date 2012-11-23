Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3500 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2KWNKm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:10:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <michael@mihu.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] MAINTAINERS: add tda9840, tea6415c and tea6420 entries.
Date: Fri, 23 Nov 2012 14:10:31 +0100
Message-Id: <802fc6c93c32effb499c09a9b6c6f3af57efdd83.1353675798.git.hans.verkuil@cisco.com>
In-Reply-To: <1353676231-5684-1-git-send-email-hverkuil@xs4all.nl>
References: <1353676231-5684-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a2e0787b707c15e5905e9cc9a7be50e9c077f78a.1353675798.git.hans.verkuil@cisco.com>
References: <a2e0787b707c15e5905e9cc9a7be50e9c077f78a.1353675798.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 76b1c1d..c25ade7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7412,6 +7412,14 @@ T:	git git://linuxtv.org/mkrufky/tuners.git
 S:	Maintained
 F:	drivers/media/tuners/tda8290.*
 
+TDA9840 MEDIA DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/i2c/tda9840*
+
 TEA5761 TUNER DRIVER
 M:	Mauro Carvalho Chehab <mchehab@redhat.com>
 L:	linux-media@vger.kernel.org
@@ -7428,6 +7436,22 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/tuners/tea5767.*
 
+TEA6415C MEDIA DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/i2c/tea6415c*
+
+TEA6420 MEDIA DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/i2c/tea6420*
+
 TEAM DRIVER
 M:	Jiri Pirko <jpirko@redhat.com>
 L:	netdev@vger.kernel.org
-- 
1.7.10.4

