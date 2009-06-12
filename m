Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56933 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbZFLRf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 13:35:57 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv7 1/9] v4l2-subdev.h: Add g_modulator callbacks to subdev api
Date: Fri, 12 Jun 2009 20:30:32 +0300
Message-Id: <1244827840-886-2-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 linux/include/media/v4l2-subdev.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/linux/include/media/v4l2-subdev.h b/linux/include/media/v4l2-subdev.h
index 5dcb367..4dc3788 100644
--- a/linux/include/media/v4l2-subdev.h
+++ b/linux/include/media/v4l2-subdev.h
@@ -137,6 +137,8 @@ struct v4l2_subdev_tuner_ops {
 	int (*g_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
 	int (*g_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
 	int (*s_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
+	int (*g_modulator)(struct v4l2_subdev *sd, struct v4l2_modulator *vm);
+	int (*s_modulator)(struct v4l2_subdev *sd, struct v4l2_modulator *vm);
 	int (*s_type_addr)(struct v4l2_subdev *sd, struct tuner_setup *type);
 	int (*s_config)(struct v4l2_subdev *sd, const struct v4l2_priv_tun_config *config);
 	int (*s_standby)(struct v4l2_subdev *sd);
-- 
1.6.2.GIT

