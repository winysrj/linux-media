Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:50190 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750703AbeCJTIX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 14:08:23 -0500
Date: Sat, 10 Mar 2018 20:08:19 +0100
In-Reply-To: <1520706931-25278-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520706931-25278-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH] media: soc_camera: mt9t112: Update to new interface
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
CC: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <F0DC37D2-31C6-4594-8AEC-286D232AA600@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If possible, post a v2. It avoids mistakes.

Hans

On March 10, 2018 7:35:31 PM GMT+01:00, Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
>Use in the soc_camera version of mt9t112 driver the new name for the
>driver's platform data as defined by the new v4l2 driver for the same
>chip.
>
>Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>
>---
>
>Hans: to not break bisect, would you like me to resend the whole series
>with this commit squashed in:
>[PATCH 2/5] media: i2c: mt9t112: Remove soc_camera dependencies
>that changes the driver interface, or can you do that when applying?
>
>Thanks
>   j
>
>---
> drivers/media/i2c/soc_camera/mt9t112.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/media/i2c/soc_camera/mt9t112.c
>b/drivers/media/i2c/soc_camera/mt9t112.c
>index 297d22e..b53c36d 100644
>--- a/drivers/media/i2c/soc_camera/mt9t112.c
>+++ b/drivers/media/i2c/soc_camera/mt9t112.c
>@@ -85,7 +85,7 @@ struct mt9t112_format {
>
> struct mt9t112_priv {
> 	struct v4l2_subdev		 subdev;
>-	struct mt9t112_camera_info	*info;
>+	struct mt9t112_platform_data	*info;
> 	struct i2c_client		*client;
> 	struct v4l2_rect		 frame;
> 	struct v4l2_clk			*clk;
>--
>2.7.4

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
