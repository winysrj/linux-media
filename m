Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:37781 "EHLO
	email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751439AbcHJSBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:01:30 -0400
Subject: Re: [PATCH v8 1/2] [media] atmel-isc: add the Image Sensor Controller
 code
To: Hans Verkuil <hverkuil@xs4all.nl>, <nicolas.ferre@atmel.com>,
	<robh@kernel.org>
References: <1470211686-2198-1-git-send-email-songjun.wu@microchip.com>
 <1470211686-2198-2-git-send-email-songjun.wu@microchip.com>
 <07cf3e49-da67-74d7-528c-618fe94a15ff@xs4all.nl>
 <240d957c-6738-bab5-824a-1e6a0ddb12ad@xs4all.nl>
CC: <laurent.pinchart@ideasonboard.com>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
	=?UTF-8?Q?Niklas_S=c3=83=c2=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Benoit Parrot <bparrot@ti.com>, <linux-kernel@vger.kernel.org>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Kamil Debski <kamil@wypas.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms+renesas@verge.net.au>
From: "Wu, Songjun" <Songjun.Wu@microchip.com>
Message-ID: <d200c6d3-80d4-e81e-e7c3-e5716e47ceb8@microchip.com>
Date: Wed, 10 Aug 2016 13:36:23 +0800
MIME-Version: 1.0
In-Reply-To: <240d957c-6738-bab5-824a-1e6a0ddb12ad@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 8/8/2016 17:56, Hans Verkuil wrote:
> On 08/08/2016 11:37 AM, Hans Verkuil wrote:
>> On 08/03/2016 10:08 AM, Songjun Wu wrote:
>>> Add driver for the Image Sensor Controller. It manages
>>> incoming data from a parallel based CMOS/CCD sensor.
>>> It has an internal image processor, also integrates a
>>> triple channel direct memory access controller master
>>> interface.
>>>
>>> Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
>>> ---
>>>
>>> Changes in v8:
>>> - Power on the sensor on the first open in function
>>>   'isc_open'.
>>> - Power off the sensor on the last release in function
>>>   'isc_release'.
>>> - Remove the switch of the pipeline.
>>>
>>> Changes in v7:
>>> - Add enum_framesizes and enum_frameintervals.
>>> - Call s_stream(0) when stream start fail.
>>> - Fill the device_caps field of struct video_device
>>>   with V4L2_CAP_STREAMING and V4L2_CAP_VIDEO_CAPTURE.
>>> - Initialize the dev of struct vb2_queue.
>>> - Set field to FIELD_NONE if the pix field is not supported.
>>> - Return the result directly when call g/s_parm of subdev.
>>>
>>> Changes in v6: None
>>> Changes in v5:
>>> - Modify the macro definition and the related code.
>>>
>>> Changes in v4:
>>> - Modify the isc clock code since the dt is changed.
>>>
>>> Changes in v3:
>>> - Add pm runtime feature.
>>> - Modify the isc clock code since the dt is changed.
>>>
>>> Changes in v2:
>>> - Add "depends on COMMON_CLK" and "VIDEO_V4L2_SUBDEV_API"
>>>   in Kconfig file.
>>> - Correct typos and coding style according to Laurent's remarks
>>> - Delete the loop while in 'isc_clk_enable' function.
>>> - Replace 'hsync_active', 'vsync_active' and 'pclk_sample'
>>>   with 'pfe_cfg0' in struct isc_subdev_entity.
>>> - Add the code to support VIDIOC_CREATE_BUFS in
>>>   'isc_queue_setup' function.
>>> - Invoke isc_config to configure register in
>>>   'isc_start_streaming' function.
>>> - Add the struct completion 'comp' to synchronize with
>>>   the frame end interrupt in 'isc_stop_streaming' function.
>>> - Check the return value of the clk_prepare_enable
>>>   in 'isc_open' function.
>>> - Set the default format in 'isc_open' function.
>>> - Add an exit condition in the loop while in 'isc_config'.
>>> - Delete the hardware setup operation in 'isc_set_format'.
>>> - Refuse format modification during streaming
>>>   in 'isc_s_fmt_vid_cap' function.
>>> - Invoke v4l2_subdev_alloc_pad_config to allocate and
>>>   initialize the pad config in 'isc_async_complete' function.
>>> - Remove the '.owner  = THIS_MODULE,' in atmel_isc_driver.
>>> - Replace the module_platform_driver_probe() with
>>>   module_platform_driver().
>>>
>>>  drivers/media/platform/Kconfig                |    1 +
>>>  drivers/media/platform/Makefile               |    2 +
>>>  drivers/media/platform/atmel/Kconfig          |    9 +
>>>  drivers/media/platform/atmel/Makefile         |    1 +
>>>  drivers/media/platform/atmel/atmel-isc-regs.h |  165 +++
>>>  drivers/media/platform/atmel/atmel-isc.c      | 1503 +++++++++++++++++++++++++
>>>  6 files changed, 1681 insertions(+)
>>>  create mode 100644 drivers/media/platform/atmel/Kconfig
>>>  create mode 100644 drivers/media/platform/atmel/Makefile
>>>  create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
>>>  create mode 100644 drivers/media/platform/atmel/atmel-isc.c
>>>
>>
>> <snip>
>>
>>> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
>>> new file mode 100644
>>> index 0000000..d99d4a5
>>> --- /dev/null
>>> +++ b/drivers/media/platform/atmel/atmel-isc.c
>>
>> <snip>
>>
>>> +static int isc_set_default_fmt(struct isc_device *isc)
>>> +{
>>> +	u32 index = isc->num_user_formats - 1;
>>
>> Why pick the last format? Strictly speaking it doesn't matter, but in practice
>> the most common formats tend to be at the beginning of the format list.
>>
>>> +	struct v4l2_format f = {
>>> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
>>> +		.fmt.pix = {
>>> +			.width		= VGA_WIDTH,
>>> +			.height		= VGA_HEIGHT,
>>> +			.field		= V4L2_FIELD_NONE,
>>> +			.pixelformat	= isc->user_formats[index]->fourcc,
>>> +		},
>>> +	};
>>> +
>>> +	return isc_set_fmt(isc, &f);
>>> +}
>>> +
>>> +static int isc_open(struct file *file)
>>> +{
>>> +	struct isc_device *isc = video_drvdata(file);
>>> +	struct v4l2_subdev *sd = isc->current_subdev->sd;
>>> +	int ret;
>>> +
>>> +	if (mutex_lock_interruptible(&isc->lock))
>>> +		return -ERESTARTSYS;
>>> +
>>> +	ret = v4l2_fh_open(file);
>>> +	if (ret < 0)
>>> +		goto unlock;
>>> +
>>> +	if (!v4l2_fh_is_singular_file(file))
>>> +		goto unlock;
>>> +
>>> +	ret = v4l2_subdev_call(sd, core, s_power, 1);
>>> +	if (ret < 0 && ret != -ENOIOCTLCMD)
>>> +		goto unlock;
>>> +
>>> +	ret = isc_set_default_fmt(isc);
>>
>> This doesn't belong here, this needs to be done in isc_async_complete().
>>
>> Having the code here means that every time you open the device, the format
>> changes back to the default. That's not what you want.
>
> Actually, you do need to set the format here since here is where you turn on
> the sensor power, but it should be the current format, not the default format.
>
> And in isc_set_default_fmt I recommend that you call the try fmt of the subdev
> in order to let the subdev adjust the proposed default format. The 'try' doesn't
> need to power on the sensor.
>
I replace the 'set fmt' with 'try fmt', then test with v4l2-compliance, 
but there are tree fail cases. I think it's reasonable that setting a 
default fmt on the first open. When app open the device on the first 
open, it should set a fmt, or the default fmt will be set.

        Format ioctls:
                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                 test VIDIOC_G/S_PARM: OK
                 test VIDIOC_G_FBUF: OK (Not Supported)
                 fail: v4l2-test-formats.cpp(423): fmt.type != type
                 test VIDIOC_G_FMT: FAIL
                 test VIDIOC_TRY_FMT: OK (Not Supported)
                 test VIDIOC_S_FMT: OK (Not Supported)
                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                 test Cropping: OK (Not Supported)
                 test Composing: OK (Not Supported)
                 fail: v4l2-test-formats.cpp(1530): doioctl(node, 
VIDIOC_S_FMT, &fmt)
                 fail: v4l2-test-formats.cpp(1627): doioctl(node, 
VIDIOC_S_FMT, &fmt)
                 test Scaling: FAIL

>>
>>> +	if (ret)
>
> You also need to power off the sd on error!
>
>>> +		goto unlock;
>>> +
>>> +unlock:
>>> +	mutex_unlock(&isc->lock);
>>> +	return ret;
>>> +}
>>> +
>>
>
> Regards,
>
> 	Hans
>
