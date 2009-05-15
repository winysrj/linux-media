Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49101 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754010AbZEORTa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 13:19:30 -0400
Date: Fri, 15 May 2009 19:19:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 05/10 v2] sh: soc-camera updates
In-Reply-To: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
Message-ID: <Pine.LNX.4.64.0905151827210.4658@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update ap325rxa to specify .bus_id in struct soc_camera_link explicitly, remove
unused .iface from struct soc_camera_platform_info.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Paul, you certainly could take this one, as well as a couple others, but 
maybe easier to push them all together.

 arch/sh/boards/board-ap325rxa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index ac964e4..f644ad7 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -308,7 +308,6 @@ static int ap325rxa_camera_add(struct soc_camera_link *icl, struct device *dev);
 static void ap325rxa_camera_del(struct soc_camera_link *icl);
 
 static struct soc_camera_platform_info camera_info = {
-	.iface = 0,
 	.format_name = "UYVY",
 	.format_depth = 16,
 	.format = {
@@ -321,6 +320,7 @@ static struct soc_camera_platform_info camera_info = {
 	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8,
 	.set_capture = camera_set_capture,
 	.link = {
+		.bus_id		= 0,
 		.add_device	= ap325rxa_camera_add,
 		.del_device	= ap325rxa_camera_del,
 	},
@@ -421,6 +421,7 @@ static struct ov772x_camera_info ov7725_info = {
 	.flags		= OV772X_FLAG_VFLIP | OV772X_FLAG_HFLIP,
 	.edgectrl	= OV772X_AUTO_EDGECTRL(0xf, 0),
 	.link = {
+		.bus_id		= 0,
 		.power		= ov7725_power,
 		.board_info	= &ap325rxa_i2c_camera[0],
 		.i2c_adapter_id	= 0,
-- 
1.6.2.4

