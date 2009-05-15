Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51239 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754997AbZEORUF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 13:20:05 -0400
Date: Fri, 15 May 2009 19:20:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [RFC 09/10 v2] v4l2-subdev: re-add s_standby to v4l2_subdev_core_ops
In-Reply-To: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
Message-ID: <Pine.LNX.4.64.0905151907460.4658@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NOT FOR SUBMISSION. Probably, another solution has to be found. soc-camera
drivers need an .init() (marked as "don't use") and a .halt() methods.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Hans, you moved s_standby to tuner_ops, and init is not recommended for 
new drivers. Suggestions?

 include/media/v4l2-subdev.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1785608..ba907be 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -97,6 +97,7 @@ struct v4l2_subdev_core_ops {
 	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
 	int (*log_status)(struct v4l2_subdev *sd);
 	int (*init)(struct v4l2_subdev *sd, u32 val);
+	int (*s_standby)(struct v4l2_subdev *sd, u32 standby);
 	int (*load_fw)(struct v4l2_subdev *sd);
 	int (*reset)(struct v4l2_subdev *sd, u32 val);
 	int (*s_gpio)(struct v4l2_subdev *sd, u32 val);
-- 
1.6.2.4

