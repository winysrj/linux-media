Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:46161 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3AHLhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 06:37:42 -0500
Message-ID: <50EC0500.4030708@gmail.com>
Date: Tue, 08 Jan 2013 12:37:36 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH 1/6 v4] media: V4L2: support asynchronous subdevice registration
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de> <13183539.ohZBrHhPax@avalon> <Pine.LNX.4.64.1301081123590.1794@axis700.grange> <18858693.KSUhrxG65A@avalon>
In-Reply-To: <18858693.KSUhrxG65A@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/08/2013 11:35 AM, Laurent Pinchart wrote:
>>>>> If we need a workaround, I'd rather pass the device name in addition
>>>>> to the I2C adapter number and address, instead of embedding the
>>>>> workaround in this new API.
>>>>
>>>> ...or we can change the I2C subdevice name format. The actual need to do
>>>>
>>>> 	snprintf(clk_name, sizeof(clk_name), "%s %d-%04x",
>>>> 	
>>>> 		 asdl->dev->driver->name,
>>>> 		 i2c_adapter_id(client->adapter), client->addr);
>>>>
>>>> in soc-camera now to exactly match the subdevice name, as created by
>>>> v4l2_i2c_subdev_init(), doesn't make me specifically happy either. What
>>>> if the latter changes at some point? Or what if one driver wishes to
>>>> create several subdevices for one I2C device?
>>>
>>> The common clock framework uses %d-%04x, maybe we could use that as well
>>> for clock names ?
>>
>> And preserve the subdevice names? Then matching would be more difficult
>> and less precise. Or change subdevice names too? I think, we can do the
>> latter, since anyway at any time only one driver can be attached to an I2C
>> device.
>
> That's right. Where else is the subdev name used ?

Subdev names are exposed to user space by the media controller API.
So they are really part of an ABI, aren't they ?

Also having I2C bus number or I2C slave address as part of the subdev
name makes it more difficult to write portable applications. Hence
in sensor drivers I used to overwrite subdev name to remove I2C bus
and slave address, as the format used v4l2_i2c_subdev_init() seemed
highly unsuitable..

--

Regards,
Sylwester
