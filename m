Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:37974 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752035AbdLEMKT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Dec 2017 07:10:19 -0500
Subject: Re: camss: camera controls missing on vfe interfaces
From: Daniel Mack <daniel@zonque.org>
To: Todor Tomov <todor.tomov@linaro.org>,
        "laurent.pinchart" <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <79ac06f5-0c68-14d9-673c-7781881f81b8@zonque.org>
 <bc991d7c-e204-334a-1135-d10757405e08@zonque.org>
 <9ac5306d-c048-5d04-4ea9-2d5d08165350@linaro.org>
 <b2ee60be-508f-bc16-5632-1bd0e694b6cc@zonque.org>
 <597a0559-13a1-c3e6-8d03-8dc67c335234@zonque.org>
Message-ID: <45dc43ba-1af4-3b61-1cb8-b9e2deb1708f@zonque.org>
Date: Tue, 5 Dec 2017 13:10:16 +0100
MIME-Version: 1.0
In-Reply-To: <597a0559-13a1-c3e6-8d03-8dc67c335234@zonque.org>
Content-Type: multipart/mixed;
 boundary="------------7DDD59F92FB37751022C2A72"
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------7DDD59F92FB37751022C2A72
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

FWIW, we are using the attached trivial patch in our tree now. Not sure
if this is interesting for upstream, but it does solve our problem. Let
me know what you think.


Thanks,
Daniel


On Monday, November 27, 2017 12:50 AM, Daniel Mack wrote:
> Hi Todor, everyone,
> 
> On Monday, November 20, 2017 11:59 AM, Daniel Mack wrote:
>> On Monday, November 20, 2017 09:32 AM, Todor Tomov wrote:
>>> It is not a missing feature, it is more of a missing userspace implementation.
>>> When working with a media oriented device driver, the userspace has to
>>> config the media pipeline too and if controls are exposed by the subdev nodes,
>>> the userspace has to configure them on the subdev nodes.
>>>
>>> As there weren't a lot of media oriented drivers there is no generic
>>> implementation/support for this in the userspace (at least I'm not aware of
>>> any). There have been discussions about adding such functionality in libv4l
>>> so that applications which do not support media configuration can still
>>> use these drivers. I'm not sure if decision for this was taken or not or
>>> is it just that there was noone to actually do the work. Probably Laurent,
>>> Mauro or Hans know more about what were the plans for this.
>>
>> Hmm, that's not good.
>>
>> Considering the use-case in our application, the pipeline is set up once
>> and considered more or less static, and then applications such as the
>> Chrome browsers make use of the high-level VFE interface. If there are
>> no controls exposed on that interface, they are not available to the
>> application. Patching all userspace applications is an uphill battle
>> that can't be won I'm afraid.
>>
>> Is there any good reason not to expose the sensor controls on the VFE? I
>> guess it would be easy to do, right?
> 
> Do you see an alternative to implementing the above in order to support
> existing v4l-enabled applications?
> 
> 
> Thanks,
> Daniel
> 


--------------7DDD59F92FB37751022C2A72
Content-Type: text/x-patch;
 name="0001-camss-expose-sensor-controls-on-video-node.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-camss-expose-sensor-controls-on-video-node.patch"

>From 5142b5cdf613f6b61e9506eee81e908045b22404 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@zonque.org>
Date: Tue, 5 Dec 2017 11:39:42 +0100
Subject: [PATCH] camss: expose sensor controls on video node

---
 .../media/platform/qcom/camss-8x16/camss-video.c   | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-video.c b/drivers/media/platform/qcom/camss-8x16/camss-video.c
index 2998ad677bee..fd9403b988ec 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-video.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-video.c
@@ -640,10 +640,34 @@ static const struct v4l2_ioctl_ops msm_vid_ioctl_ops = {
  * V4L2 file operations
  */
 
+static struct media_entity *video_find_sensor(struct camss_video *video)
+{
+	struct media_pad *pad = &video->pad;
+
+	while (1) {
+		struct media_entity *entity;
+
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			return NULL;
+
+		pad = media_entity_remote_pad(pad);
+		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
+			return NULL;
+
+		entity = pad->entity;
+
+		if (entity->function == MEDIA_ENT_F_CAM_SENSOR)
+			return entity;
+
+		pad = &entity->pads[0];
+	}
+}
+
 static int video_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct camss_video *video = video_drvdata(file);
+	struct media_entity *sensor_entity;
 	struct v4l2_fh *vfh;
 	int ret;
 
@@ -660,6 +684,14 @@ static int video_open(struct file *file)
 
 	file->private_data = vfh;
 
+	sensor_entity = video_find_sensor(video);
+	if (sensor_entity) {
+		struct v4l2_subdev *sd =
+			media_entity_to_v4l2_subdev(sensor_entity);
+
+		vdev->ctrl_handler = sd->ctrl_handler;
+	}
+
 	ret = v4l2_pipeline_pm_use(&vdev->entity, 1);
 	if (ret < 0) {
 		dev_err(video->camss->dev, "Failed to power up pipeline: %d\n",
-- 
2.14.3


--------------7DDD59F92FB37751022C2A72--
