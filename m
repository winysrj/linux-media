Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1582 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab1AKXGj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 18:06:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH 12/12] soc_camera: remove the now obsolete controls/num_controls fields.
Date: Wed, 12 Jan 2011 00:06:12 +0100
Message-Id: <377d596236a408e0fc65af90282bf93053d438e0.1294786597.git.hverkuil@xs4all.nl>
In-Reply-To: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
References: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 include/media/soc_camera.h |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index b71b26e..361309b 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -190,8 +190,6 @@ struct soc_camera_ops {
 	unsigned long (*query_bus_param)(struct soc_camera_device *);
 	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
 	int (*enum_input)(struct soc_camera_device *, struct v4l2_input *);
-	const struct v4l2_queryctrl *controls;
-	int num_controls;
 };
 
 #define SOCAM_SENSE_PCLK_CHANGED	(1 << 0)
@@ -220,18 +218,6 @@ struct soc_camera_sense {
 	unsigned long pixel_clock;
 };
 
-static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
-	struct soc_camera_ops *ops, int id)
-{
-	int i;
-
-	for (i = 0; i < ops->num_controls; i++)
-		if (ops->controls[i].id == id)
-			return &ops->controls[i];
-
-	return NULL;
-}
-
 #define SOCAM_MASTER			(1 << 0)
 #define SOCAM_SLAVE			(1 << 1)
 #define SOCAM_HSYNC_ACTIVE_HIGH		(1 << 2)
-- 
1.7.0.4

