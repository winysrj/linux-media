Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:20993 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab2BRCVG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 21:21:06 -0500
Message-ID: <4F3F0AFE.8050705@iki.fi>
Date: Sat, 18 Feb 2012 04:20:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 3/6] V4L: Add g_embedded_data subdev callback
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com> <6366737.ZEMB1VQOcD@avalon> <4F3EE3C3.6070605@gmail.com> <4603092.UUnjJ05PXI@avalon>
In-Reply-To: <4603092.UUnjJ05PXI@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> On Saturday 18 February 2012 00:33:23 Sylwester Nawrocki wrote:
>> On 02/18/2012 12:23 AM, Laurent Pinchart wrote:
>>>>   struct v4l2_subdev_video_ops {
>>>>   
>>>>   	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32
>>>>
>>>> config); @@ -321,6 +329,8 @@ struct v4l2_subdev_video_ops {
>>>>
>>>>   			     struct v4l2_mbus_config *cfg);
>>>>   	
>>>>   	int (*s_mbus_config)(struct v4l2_subdev *sd,
>>>>   	
>>>>   			     const struct v4l2_mbus_config *cfg);
>>>>
>>>> +	int (*g_embedded_data)(struct v4l2_subdev *sd, unsigned int *size,
>>>> +			       void **buf);
>>>>
>>>>   };
>>>
>>> How is the embedded data transferred from the sensor to the host in your
>>> case ? Over I2C ?
>>
>> It's transferred over MIPI-CSI2 bus and is intercepted by the MIPI-CSI2
>> receiver, before the image data DMA. The MIPI-CSI2 doesn't have its own
>> DMA engine. More details can be found in patch 6/6.
> 
> As the data is transmitted by the device without any polling from the host, 
> shouldn't it just go to a metadata plane in the V4L2 buffer ?

I'd say that if it can be given to the user space separately, a way
should be provided to do that. It's all about timing: software
controlled digital camera depend on that.

Some receivers are also able to put such metadata into a separate memory
area using DMA, such as the OMAP 3 ISP CCP-2 receiver.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
