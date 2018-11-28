Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:39069 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbeK2EWA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 23:22:00 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 1/6] media: v4l2-subdev: stub v4l2_subdev_get_try_format()
Date: Wed, 28 Nov 2018 18:19:13 +0100
Message-Id: <20181128171918.160643-2-lkundrak@v3.sk>
In-Reply-To: <20181128171918.160643-1-lkundrak@v3.sk>
References: <20181128171918.160643-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide a dummy implementation when configured without
CONFIG_VIDEO_V4L2_SUBDEV_API to avoid ifdef dance in the drivers that can
be built either with or without the option.

Suggested-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 include/media/v4l2-subdev.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 9102d6ca566e..906e28011bb4 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -967,6 +967,17 @@ static inline struct v4l2_rect
 		pad =3D 0;
 	return &cfg[pad].try_compose;
 }
+
+#else /* !defined(CONFIG_VIDEO_V4L2_SUBDEV_API) */
+
+static inline struct v4l2_mbus_framefmt
+*v4l2_subdev_get_try_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    unsigned int pad)
+{
+	return ERR_PTR(-ENOTTY);
+}
+
 #endif
=20
 extern const struct v4l2_file_operations v4l2_subdev_fops;
--=20
2.19.1
