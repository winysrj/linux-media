Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54607 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbcA0LWv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 06:22:51 -0500
Subject: Re: [PATCH v3 2/2] [media] tvp5150: Add pad-level subdev operations
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1453812384-15512-1-git-send-email-javier@osg.samsung.com>
 <1453812384-15512-3-git-send-email-javier@osg.samsung.com>
 <20160127073818.0bfda497@recife.lan>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Message-ID: <56A8A883.7060402@osg.samsung.com>
Date: Wed, 27 Jan 2016 08:22:43 -0300
MIME-Version: 1.0
In-Reply-To: <20160127073818.0bfda497@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 01/27/2016 06:38 AM, Mauro Carvalho Chehab wrote:
> Em Tue, 26 Jan 2016 09:46:24 -0300
> Javier Martinez Canillas <javier@osg.samsung.com> escreveu:
>
>> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>
>> This patch enables the tvp5150 decoder driver to be used with the media
>> controller framework by adding pad-level subdev operations and init the
>> media entity pad.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> ---
>>
>> Changes in v3:
>> - Split the format fix and the MC support in different patches.
>>    Suggested by Mauro Carvalho Chehab.
>>
>> Changes in v2:
>> - Embed mbus_type into struct tvp5150. Suggested by Laurent Pinchart.
>> - Remove platform data support. Suggested by Laurent Pinchart.
>> - Check if the hsync, vsync and field even active properties are correct.
>>    Suggested by Laurent Pinchart.
>>
>>   drivers/media/i2c/tvp5150.c | 21 ++++++++++-----------
>>   1 file changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
>> index 37853bc3f0b3..e48b529c53b4 100644
>> --- a/drivers/media/i2c/tvp5150.c
>> +++ b/drivers/media/i2c/tvp5150.c
>> @@ -37,6 +37,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
>>
>>   struct tvp5150 {
>>   	struct v4l2_subdev sd;
>> +	struct media_pad pad;
>>   	struct v4l2_ctrl_handler hdl;
>>   	struct v4l2_rect rect;
>>
>> @@ -826,17 +827,6 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
>>   	}
>>   }
>>
>> -static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
>> -		struct v4l2_subdev_pad_config *cfg,
>> -		struct v4l2_subdev_mbus_code_enum *code)
>> -{
>> -	if (code->pad || code->index)
>> -		return -EINVAL;
>> -
>> -	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
>> -	return 0;
>> -}
>> -
>
> Huh! Why are you removing this? It is causing compilation breakages!
>

Sigh, somehow I managed to post the wrong patch... I'm so sorry about that.

Laurent's patch moves this function so the V4L2 subdev pad ops are grouped
together. That's was the idea, not to remove it.
  
>>   static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
>>   		struct v4l2_subdev_pad_config *cfg,
>>   		struct v4l2_subdev_format *format)
>> @@ -1165,6 +1155,7 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
>>
>>   static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
>>   	.enum_mbus_code = tvp5150_enum_mbus_code,
>> +	.enum_frame_size = tvp5150_enum_frame_size,
>
> Also, you forgot to add tvp5150_enum_frame_size here!
>

Yes, this is also missing in the posted patch. Following [0] is the correct
one, please let me know if you want me to resend or sharing here is enough.

> drivers/media/i2c/tvp5150.c:1124:20: error: 'tvp5150_enum_mbus_code' undeclared here (not in a function)
>    .enum_mbus_code = tvp5150_enum_mbus_code,
>                      ^
> drivers/media/i2c/tvp5150.c:1125:21: error: 'tvp5150_enum_frame_size' undeclared here (not in a function)
>    .enum_frame_size = tvp5150_enum_frame_size,
>                       ^
> Regards,
> Mauro
>

[0]:
 From 3436139006fd4adc2cf195b60c10a3f7598b3e08 Mon Sep 17 00:00:00 2001
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Sun, 18 May 2014 17:53:06 +0200
Subject: [PATCH v3 2/2] [media] tvp5150: Add pad-level subdev operations

This patch enables the tvp5150 decoder driver to be used with the media
controller framework by adding pad-level subdev operations and init the
media entity pad.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

Changes in v3:
- Split the format fix and the MC support in different patches.
   Suggested by Mauro Carvalho Chehab.

Changes in v2:
- Embed mbus_type into struct tvp5150. Suggested by Laurent Pinchart.
- Remove platform data support. Suggested by Laurent Pinchart.
- Check if the hsync, vsync and field even active properties are correct.
   Suggested by Laurent Pinchart.

  drivers/media/i2c/tvp5150.c | 54 ++++++++++++++++++++++++++++++++++++---------
  1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 97d19de1b051..8e4f4fa5cfdc 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -37,6 +37,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
  
  struct tvp5150 {
  	struct v4l2_subdev sd;
+	struct media_pad pad;
  	struct v4l2_ctrl_handler hdl;
  	struct v4l2_rect rect;
  
@@ -826,17 +827,6 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
  	}
  }
  
-static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_mbus_code_enum *code)
-{
-	if (code->pad || code->index)
-		return -EINVAL;
-
-	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
-	return 0;
-}
-
  static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
  		struct v4l2_subdev_pad_config *cfg,
  		struct v4l2_subdev_format *format)
@@ -968,6 +958,39 @@ static int tvp5150_g_mbus_config(struct v4l2_subdev *sd,
  	return 0;
  }
  
+ /****************************************************************************
+			V4L2 subdev pad ops
+ ****************************************************************************/
+
+static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index)
+		return -EINVAL;
+
+	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
+	return 0;
+}
+
+static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+
+	if (fse->index >= 8 || fse->code != MEDIA_BUS_FMT_UYVY8_2X8)
+		return -EINVAL;
+
+	fse->code = MEDIA_BUS_FMT_UYVY8_2X8;
+	fse->min_width = decoder->rect.width;
+	fse->max_width = decoder->rect.width;
+	fse->min_height = decoder->rect.height / 2;
+	fse->max_height = decoder->rect.height / 2;
+
+	return 0;
+}
+
  /****************************************************************************
  			I2C Command
   ****************************************************************************/
@@ -1131,6 +1154,7 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
  
  static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
  	.enum_mbus_code = tvp5150_enum_mbus_code,
+	.enum_frame_size = tvp5150_enum_frame_size,
  	.set_fmt = tvp5150_fill_fmt,
  	.get_fmt = tvp5150_fill_fmt,
  };
@@ -1286,6 +1310,14 @@ static int tvp5150_probe(struct i2c_client *c,
  	}
  
  	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	core->pad.flags = MEDIA_PAD_FL_SOURCE;
+	res = media_entity_pads_init(&sd->entity, 1, &core->pad);
+	if (res < 0)
+		return res;
+#endif
  
  	res = tvp5150_detect_version(core);
  	if (res < 0)
-- 
2.5.0
