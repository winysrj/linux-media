Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2397 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab3EaIWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 04:22:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v6] V4L2: I2C: ML86V7667 video decoder driver
Date: Fri, 31 May 2013 10:22:31 +0200
Cc: mchehab@redhat.com, linux-media@vger.kernel.org, matsu@igel.co.jp,
	linux-sh@vger.kernel.org, vladimir.barinov@cogentembedded.com
References: <201305292252.29007.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201305292252.29007.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305311022.31321.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On Wed May 29 2013 20:52:28 Sergei Shtylyov wrote:
> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> Add OKI Semiconductor ML86V7667 video decoder driver.
> 

I've accepted this patch, but I've added a patch to fix this function:

> +static int ml86v7667_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int status;
> +
> +	status = i2c_smbus_read_byte_data(client, STATUS_REG);
> +	if (status < 0)
> +		return status;
> +
> +	if (!(status & STATUS_HLOCK_DETECT))
> +		return V4L2_STD_UNKNOWN;
> +
> +	*std = status & STATUS_NTSCPAL ? V4L2_STD_625_50 : V4L2_STD_525_60;
> +
> +	return 0;
> +}
> +

[PATCH] ml86v7667: fix the querystd implementation

The *std should be set to V4L2_STD_UNKNOWN, not the function's return code.

Also, *std should be ANDed with 525_60 or 625_50.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ml86v7667.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ml86v7667.c b/drivers/media/i2c/ml86v7667.c
index 0f256d3..cd9f86e 100644
--- a/drivers/media/i2c/ml86v7667.c
+++ b/drivers/media/i2c/ml86v7667.c
@@ -169,10 +169,10 @@ static int ml86v7667_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	if (status < 0)
 		return status;
 
-	if (!(status & STATUS_HLOCK_DETECT))
-		return V4L2_STD_UNKNOWN;
-
-	*std = status & STATUS_NTSCPAL ? V4L2_STD_625_50 : V4L2_STD_525_60;
+	if (status & STATUS_HLOCK_DETECT)
+		*std &= status & STATUS_NTSCPAL ? V4L2_STD_625_50 : V4L2_STD_525_60;
+	else
+		*std = V4L2_STD_UNKNOWN;
 
 	return 0;
 }
-- 
1.7.10.4

I've queued this one up in my for-v3.11 branch, so you don't need to do
anything.

Regards,

	Hans
