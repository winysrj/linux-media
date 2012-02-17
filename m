Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53582 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab2BQXde (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 18:33:34 -0500
Received: by eekc14 with SMTP id c14so1530268eek.19
        for <linux-media@vger.kernel.org>; Fri, 17 Feb 2012 15:33:33 -0800 (PST)
Message-ID: <4F3EE3C3.6070605@gmail.com>
Date: Sat, 18 Feb 2012 00:33:23 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 3/6] V4L: Add g_embedded_data subdev callback
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com> <1329416639-19454-4-git-send-email-s.nawrocki@samsung.com> <6366737.ZEMB1VQOcD@avalon>
In-Reply-To: <6366737.ZEMB1VQOcD@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 02/18/2012 12:23 AM, Laurent Pinchart wrote:
>>   struct v4l2_subdev_video_ops {
>>   	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32
>> config); @@ -321,6 +329,8 @@ struct v4l2_subdev_video_ops {
>>   			     struct v4l2_mbus_config *cfg);
>>   	int (*s_mbus_config)(struct v4l2_subdev *sd,
>>   			     const struct v4l2_mbus_config *cfg);
>> +	int (*g_embedded_data)(struct v4l2_subdev *sd, unsigned int *size,
>> +			       void **buf);
>>   };
>
> How is the embedded data transferred from the sensor to the host in your case
> ? Over I2C ?

It's transferred over MIPI-CSI2 bus and is intercepted by the MIPI-CSI2
receiver, before the image data DMA. The MIPI-CSI2 doesn't have its own
DMA engine. More details can be found in patch 6/6.

--

Regards,
Sylwester
