Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52809 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab2BRPSV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Feb 2012 10:18:21 -0500
Received: by eekc14 with SMTP id c14so1699949eek.19
        for <linux-media@vger.kernel.org>; Sat, 18 Feb 2012 07:18:20 -0800 (PST)
Message-ID: <4F3FC138.4010407@gmail.com>
Date: Sat, 18 Feb 2012 16:18:16 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 3/6] V4L: Add g_embedded_data subdev callback
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com> <6366737.ZEMB1VQOcD@avalon> <4F3EE3C3.6070605@gmail.com> <4603092.UUnjJ05PXI@avalon>
In-Reply-To: <4603092.UUnjJ05PXI@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 02/18/2012 02:43 AM, Laurent Pinchart wrote:
> On Saturday 18 February 2012 00:33:23 Sylwester Nawrocki wrote:
>> On 02/18/2012 12:23 AM, Laurent Pinchart wrote:
>>>> config); @@ -321,6 +329,8 @@ struct v4l2_subdev_video_ops {
>>>>
>>>>    			     struct v4l2_mbus_config *cfg);
>>>>    	
>>>>    	int (*s_mbus_config)(struct v4l2_subdev *sd,
>>>>    	
>>>>    			     const struct v4l2_mbus_config *cfg);
>>>>
>>>> +	int (*g_embedded_data)(struct v4l2_subdev *sd, unsigned int *size,
>>>> +			       void **buf);
>>>>
>>>>    };
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

That would be more correct and more optimal from performance perspective.
However I was a bit concerned about synchronization between two interrupt
handlers and over complicating subdev-host interface.

On the other hand even now I do rely on proper interrupts' sequence and
it shouldn't be difficult to make the subdev write directly to the metadata
plane.

As far as the timing is concerned, in my case it was taking about 300 us 
to copy metadata from the MIPI-CSI receiver IO memory to the subdev's 
internal buffer and about 5 us to copy it again from that buffer to V4L2
buffer metadata plane. So I wasn't concerned much about the additional
latency. Nevertheless the numbers may be different in other cases.

As I really don't consider exposing a video node by the MIPI-CSIS driver
I'm wondering if we need some kind of buffer operations at v4l2_subdev 
interface, that would be used only in kernel space ?

For example queue_buffer/dequeue_buffer callbacks, what do you think about
it ?

--

Regards,
Sylwester
