Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44576 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbZKBQFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 11:05:07 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Date: Mon, 2 Nov 2009 10:05:01 -0600
Subject: RE: [PATCH/RFC 9/9] mt9t031: make the use of the soc-camera client
 API optional
Message-ID: <A69FA2915331DC488A831521EAE36FE40155798D56@dlee06.ent.ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301442570.4378@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE401557987F6@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0910302112300.4378@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0910302112300.4378@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

Thanks for the reply.

>> >+};
>> >+
>> >+static struct soc_camera_ops mt9t031_ops = {
>> >+	.set_bus_param		= mt9t031_set_bus_param,
>> >+	.query_bus_param	= mt9t031_query_bus_param,
>> >+	.controls		= mt9t031_controls,
>> >+	.num_controls		= ARRAY_SIZE(mt9t031_controls),
>> >+};
>> >+
>>
>> [MK] Why don't you implement queryctrl ops in core? query_bus_param
>> & set_bus_param() can be implemented as a sub device operation as well
>> right? I think we need to get the bus parameter RFC implemented and
>> this driver could be targeted for it's first use so that we could
>> work together to get it accepted. I didn't get a chance to study your
>> bus image format RFC, but plan to review it soon and to see if it can be
>> used in my platform as well. For use of this driver in our platform,
>> all reference to soc_ must be removed. I am ok if the structure is
>> re-used, but if this driver calls any soc_camera function, it canot
>> be used in my platform.
>
>Why? Some soc-camera functions are just library functions, you just have
>to build soc-camera into your kernel. (also see below)
>
My point is that the control is for the sensor device, so why to implement
queryctrl in SoC camera? Just for this I need to include SOC camera in my build? That doesn't make any sense at all. IMHO, queryctrl() logically belongs to this sensor driver which can be called from the bridge driver using sudev API call. Any reverse dependency from MT9T031 to SoC camera to be removed if it is to be re-used across other platforms. Can we agree on this? Did you have a chance to compare the driver file that I had sent to you?

Thanks.

Murali
>> BTW, I am attaching a version of the driver that we use in our kernel
>> tree for your reference which will give you an idea of my requirement.
>>
>
>[snip]
>
>> >@@ -565,7 +562,6 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd,
>> >struct v4l2_control *ctrl)
>> > {
>> > 	struct i2c_client *client = sd->priv;
>> > 	struct mt9t031 *mt9t031 = to_mt9t031(client);
>> >-	struct soc_camera_device *icd = client->dev.platform_data;
>> > 	const struct v4l2_queryctrl *qctrl;
>> > 	int data;
>> >
>> >@@ -657,7 +653,8 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd,
>> >struct v4l2_control *ctrl)
>> >
>> > 			if (set_shutter(client, total_h) < 0)
>> > 				return -EIO;
>> >-			qctrl = soc_camera_find_qctrl(icd->ops,
>> >V4L2_CID_EXPOSURE);
>> >+			qctrl = soc_camera_find_qctrl(&mt9t031_ops,
>> >+						      V4L2_CID_EXPOSURE);
>>
>> [MK] Why do we still need this call? In my version of the sensor driver,
>> I just implement the queryctrl() operation in core_ops. This cannot work
>> since soc_camera_find_qctrl() is implemented only in SoC camera.
>
>As mentioned above, that's just a library function without any further
>dependencies, so, why reimplement it?
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

