Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:52350 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756057AbdABNlx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 08:41:53 -0500
Subject: Re: [PATCH 00/15] atmel-isi/ov7670/ov2640: convert to standalone
 drivers
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
 <20161218221055.GW16630@valkosipuli.retiisi.org.uk>
 <0983edff-25ef-fc9b-3c13-7fad442dac70@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e4683b1b-7b4f-debe-41c9-9e8a18115824@xs4all.nl>
Date: Mon, 2 Jan 2017 14:41:47 +0100
MIME-Version: 1.0
In-Reply-To: <0983edff-25ef-fc9b-3c13-7fad442dac70@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/02/17 14:37, Hans Verkuil wrote:
> On 12/18/16 23:10, Sakari Ailus wrote:
>> On Mon, Dec 12, 2016 at 04:55:05PM +0100, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> This patch series converts the soc-camera atmel-isi to a standalone V4L2
>>> driver.
>>>
>>> The same is done for the ov7670 and ov2640 sensor drivers: the ov7670 was
>>> used to test the atmel-isi driver. The ov2640 is needed because the em28xx
>>> driver has a soc_camera include dependency. Both ov7670 and ov2640 sensors
>>> have been tested with the atmel-isi driver.
>>>
>>> The first 6 patches improve the ov7670 sensor driver, mostly adding modern
>>> features such as MC and DT support.
>>>
>>> The next three convert the atmel-isi and move it out of soc_camera.
>>
>> You're adding Media controller support but without device nodes. Does that
>> make sense? You'll have an entity but the user won't be able to do anything
>> with it.
>>
>
> Well, without the MC support the sensor driver wouldn't load since the atmel
> driver expects that the subdev is MC-enabled. However, the atmel-isi doesn't
> need the user to configure the pipeline, it's just a simple standard v4l driver.
>
> So just filling in the entity information is sufficient in this case.
>
> That said, I see that the atmel-isi driver calls v4l2_device_register_subdev_nodes().
> Since this is a simple V4L driver, that call should probably be dropped, since
> we really don't want or need subdev nodes.
>
> I will also need to take another look at the atmel-isi code to see if this MC
> dependency is really needed: I think I copied some of that code from the rcar
> driver, and it may not be relevant for the atmel driver.

In fact, I don't think it is needed at all.

But does it hurt to add MC support to these ov drivers?

Regards,

	Hans
