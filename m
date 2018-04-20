Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38056 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbeDTQkR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 12:40:17 -0400
Received: by mail-pf0-f196.google.com with SMTP id y69so4536744pfb.5
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2018 09:40:17 -0700 (PDT)
Subject: Re: [PATCH v3 06/13] media: platform: video-mux: Register a subdev
 notifier
To: Hans Verkuil <hverkuil@xs4all.nl>, Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org
References: <1521592649-7264-1-git-send-email-steve_longerbeam@mentor.com>
 <1521592649-7264-7-git-send-email-steve_longerbeam@mentor.com>
 <9d85012a-bd0d-6676-9918-7c9804d9a040@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <b32ba558-60e2-3185-871c-ecc679bd6e24@gmail.com>
Date: Fri, 20 Apr 2018 09:40:14 -0700
MIME-Version: 1.0
In-Reply-To: <9d85012a-bd0d-6676-9918-7c9804d9a040@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 04/20/2018 05:28 AM, Hans Verkuil wrote:
> On 03/21/18 01:37, Steve Longerbeam wrote:
>> Parse neighbor remote devices on the video muxes input ports, add them to a
>> subdev notifier, and register the subdev notifier for the video mux, by
>> calling v4l2_async_register_fwnode_subdev().
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>> Changes since v2:
>> - none
>> Changes since v1:
>> - add #include <linux/slab.h> for kcalloc() declaration.
>> ---
>>   drivers/media/platform/video-mux.c | 36 +++++++++++++++++++++++++++++++++++-
>>   1 file changed, 35 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
>> index ee89ad7..b93b0af 100644
>> --- a/drivers/media/platform/video-mux.c
>> +++ b/drivers/media/platform/video-mux.c
>> @@ -21,8 +21,10 @@
>>   #include <linux/of.h>
>>   #include <linux/of_graph.h>
>>   #include <linux/platform_device.h>
>> +#include <linux/slab.h>
>>   #include <media/v4l2-async.h>
>>   #include <media/v4l2-device.h>
>> +#include <media/v4l2-fwnode.h>
>>   #include <media/v4l2-subdev.h>
>>   
>>   struct video_mux {
>> @@ -193,6 +195,38 @@ static const struct v4l2_subdev_ops video_mux_subdev_ops = {
>>   	.video = &video_mux_subdev_video_ops,
>>   };
>>   
>> +static int video_mux_parse_endpoint(struct device *dev,
>> +				    struct v4l2_fwnode_endpoint *vep,
>> +				    struct v4l2_async_subdev *asd)
>> +{
>> +	/*
>> +	 * it's not an error if remote is missing on a video-mux
>> +	 * input port, return -ENOTCONN to skip this endpoint with
>> +	 * no error.
>> +	 */
>> +	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -ENOTCONN;
>> +}
>> +
>> +static int video_mux_async_register(struct video_mux *vmux,
>> +				    unsigned int num_pads)
>> +{
>> +	unsigned int i, *ports;
>> +	int ret;
>> +
>> +	ports = kcalloc(num_pads - 1, sizeof(*ports), GFP_KERNEL);
>> +	if (!ports)
>> +		return -ENOMEM;
>> +	for (i = 0; i < num_pads - 1; i++)
>> +		ports[i] = i;
>> +
>> +	ret = v4l2_async_register_fwnode_subdev(
>> +		&vmux->subdev, sizeof(struct v4l2_async_subdev),
>> +		ports, num_pads - 1, video_mux_parse_endpoint);
>> +
>> +	kfree(ports);
>> +	return ret;
>> +}
>> +
>>   static int video_mux_probe(struct platform_device *pdev)
>>   {
>>   	struct device_node *np = pdev->dev.of_node;
>> @@ -258,7 +292,7 @@ static int video_mux_probe(struct platform_device *pdev)
>>   
>>   	vmux->subdev.entity.ops = &video_mux_ops;
>>   
>> -	return v4l2_async_register_subdev(&vmux->subdev);
>> +	return video_mux_async_register(vmux, num_pads);
> I would prefer to change the last argument to 'num_pads - 1' and drop the ' - 1'
> part in the video_mux_async_register() function. Perhaps renaming the num_pads
> argument there to num_input_pads.

Yes makes sense. I will do that.

Steve
