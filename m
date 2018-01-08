Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1678950229.outbound-mail.sendgrid.net ([167.89.50.229]:14385
        "EHLO o1678950229.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754896AbeAHSOF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 13:14:05 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] media: i2c: adv748x: fix HDMI field heights
Date: Mon, 08 Jan 2018 18:14:04 +0000 (UTC)
Message-Id: <1515435242-22956-1-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
content-transfer-encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV748x handles interlaced media using V4L2_FIELD_ALTERNATE field=0D
types.  The correct specification for the height on the mbus is the=0D
image height, in this instance, the field height.=0D
=0D
The AFE component already correctly adjusts the height on the mbus, but=0D
the HDMI component got left behind.=0D
=0D
Adjust the mbus height to correctly describe the image height of the=0D
fields when processing interlaced video for HDMI pipelines.=0D
=0D
Fixes: 3e89586a64df ("media: i2c: adv748x: add adv748x driver")=0D
Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>=
=0D
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>=0D
---=0D
v2:=0D
 - switch conditional to check the fmt->field, removing the need for=0D
   the comment.=0D
=0D
 drivers/media/i2c/adv748x/adv748x-hdmi.c | 3 +++=0D
 1 file changed, 3 insertions(+)=0D
=0D
diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/a=
dv748x/adv748x-hdmi.c=0D
index 4da4253553fc..10d229a4f088 100644=0D
--- a/drivers/media/i2c/adv748x/adv748x-hdmi.c=0D
+++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c=0D
@@ -105,6 +105,9 @@ static void adv748x_hdmi_fill_format(struct adv748x_hdm=
i *hdmi,=0D
 =0D
 	fmt->width =3D hdmi->timings.bt.width;=0D
 	fmt->height =3D hdmi->timings.bt.height;=0D
+=0D
+	if (fmt->field =3D=3D V4L2_FIELD_ALTERNATE)=0D
+		fmt->height /=3D 2;=0D
 }=0D
 =0D
 static void adv748x_fill_optional_dv_timings(struct v4l2_dv_timings *timin=
gs)=0D
-- =0D
2.7.4=0D
