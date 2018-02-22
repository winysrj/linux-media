Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39445 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752961AbeBVJro (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 04:47:44 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 1/3] MAINTAINERS: Add entry for Renesas CEU
Date: Thu, 22 Feb 2018 10:47:17 +0100
Message-Id: <1519292839-7028-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519292839-7028-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519292839-7028-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add entry for Renesas Capture Engine Interface listing myself as
maintainer.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aee793b..de0d4c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8617,6 +8617,16 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Supported
 F:	drivers/media/pci/netup_unidvb/*
 
+MEDIA DRIVERS FOR RENESAS - CEU
+M:	Jacopo Mondi <jacopo@jmondi.org>
+L:	linux-media@vger.kernel.org
+L:	linux-renesas-soc@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Supported
+F:	Documentation/devicetree/bindings/media/renesas,ceu.txt
+F:	drivers/media/platform/renesas-ceu.c
+F:	include/media/drv-intf/renesas-ceu.h
+
 MEDIA DRIVERS FOR RENESAS - DRIF
 M:	Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
 L:	linux-media@vger.kernel.org
-- 
2.7.4
