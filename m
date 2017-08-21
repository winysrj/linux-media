Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26574 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751079AbdHUGg4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 02:36:56 -0400
Subject: Re: [PATCH v2 1/2] docs-rst: media: Document s_stream() video op
 usage for MC enabled devices
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
References: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
 <1502886018-31488-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170819073552.08a0ea2b@vento.lan>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <eb59fda5-ce07-22fa-2973-02fe33efc8d4@linux.intel.com>
Date: Mon, 21 Aug 2017 09:36:49 +0300
MIME-Version: 1.0
In-Reply-To: <20170819073552.08a0ea2b@vento.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:
> Hi Sakari,
>
> Em Wed, 16 Aug 2017 15:20:17 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
>
>> As we begin to add support for systems with Media controller pipelines
>> controlled by more than one device driver, it is essential that we
>> precisely define the responsibilities of each component in the stream
>> control and common practices.
>>
>> Specifically, streaming control is done per sub-device and sub-device
>> drivers themselves are responsible for streaming setup in upstream
>> sub-devices.
>
> IMO, before this patch, we need something like this:
> 	https://patchwork.linuxtv.org/patch/43325/

Thanks. I'll reply separately to that thread.

>
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>> ---
>>  Documentation/media/kapi/v4l2-subdev.rst | 29 +++++++++++++++++++++++++++++
>>  1 file changed, 29 insertions(+)
>>
>> diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
>> index e1f0b72..45088ad 100644
>> --- a/Documentation/media/kapi/v4l2-subdev.rst
>> +++ b/Documentation/media/kapi/v4l2-subdev.rst
>> @@ -262,6 +262,35 @@ is called. After all subdevices have been located the .complete() callback is
>>  called. When a subdevice is removed from the system the .unbind() method is
>>  called. All three callbacks are optional.
>>
>> +Streaming control on Media controller enabled devices
>> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> +
>> +Starting and stopping the stream are somewhat complex operations that
>> +often require walking the media graph to enable streaming on
>> +sub-devices which the pipeline consists of. This involves interaction
>> +between multiple drivers, sometimes more than two.
>
> That's still not ok, as it creates a black hole for devnode-based
> devices.
>
> I would change it to something like:
>
> 	Streaming control
> 	^^^^^^^^^^^^^^^^^
>
> 	Starting and stopping the stream are somewhat complex operations that
> 	often require to enable streaming on sub-devices which the pipeline
> 	consists of. This involves interaction between multiple drivers, sometimes
> 	more than two.
>
> 	The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is responsible
> 	for starting and stopping the stream on the sub-device it is called
> 	on.
>
> 	Streaming control on devnode-centric devices
> 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> 	On **devnode-centric** devices, the main driver is responsible enable
> 	stream all all sub-devices. On most cases, all the main driver need
> 	to do is to broadcast s_stream to all connected sub-devices by calling
> 	:c:func:`v4l2_device_call_all`, e. g.::
>
> 		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);

Looks good to me.

>
> 	Streaming control on mc-centric devices
> 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> 	On **mc-centric** devices, it usually requires walking the media graph
> 	to enable streaming only at the sub-devices which the pipeline consists
> 	of.
>
> 	(place here the details for such scenario)

This part requires a more detailed description of the problem area. What 
makes a difference here is that there's a pipeline this pipeline may be 
controlled more than one driver. (More elaborate discussion below.)

>
>> +The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is responsible
>> +for starting and stopping the stream on the sub-device it is called
>> +on. A device driver is only responsible for calling the ``.s_stream()`` ops
>> +of the adjacent sub-devices that are connected to its sink pads
>> +through an enabled link. A driver may not call ``.s_stream()`` op
>> +of any other sub-device further up in the pipeline, for instance.
>> +
>> +This means that a sub-device driver is thus in direct control of
>> +whether the upstream sub-devices start (or stop) streaming before or
>> +after the sub-device itself is set up for streaming.
>> +
>> +.. note::
>> +
>> +   As the ``.s_stream()`` callback is called recursively through the
>> +   sub-devices along the pipeline, it is important to keep the
>> +   recursion as short as possible. To this end, drivers are encouraged
>> +   to avoid recursively calling ``.s_stream()`` internally to reduce
>> +   stack usage. Instead, the ``.s_stream()`` op of the directly
>> +   connected sub-devices should come from the callback through which
>> +   the driver was first called.
>> +
>
> That sounds too complex, and can lead into troubles, if the same
> sub-device driver is used on completely different devices.
>
> IMHO, it should be up to the main driver to navigate at the MC
> pipeline and call s_stream(), and not to the sub-drivers.

I would agree with the above statement *if* we had no devices that 
require doing this in a different way.

Consider the following case:

	sensor   -> CSI-2 receiver -> ISP (DMA)
	subdev A -> subdev B	   -> video node

Assume that the CSI-2 receiver requires hardware setup both *before and 
after* streaming has been enabled on the sensor.

In previous cases the CSI-2 receiver and the ISP have been part of the 
same device. This is not universally the case anymore. You'll also get 
the same when you add adv748x to the pipeline, and the upstream device 
in the pipeline before the adv748x is represented as a sub-device (and 
is thus controlled by its sub-device driver).

This is addressable by moving the control of the upstream sub-device 
streaming state to the driver which is next to it, and what the patch 
also documents. Note that there is no difference if you have a 
sub-device without sink pads (or in general case, a sub-device that only 
has one kind of pads).

What comes to compatibility between MC-centric and devnode-centric 
drivers --- on an MC-centric device you have a pipeline and you 
typically have multiple pads on the sub-devices along the pipeline. 
Drivers that are devnode-centric generally aren't aware of pads, and so 
cannot configure sub-devices with multiple pads to begin with.

You could do that in principle, but you'll start running into the same 
problems which were addressed by introducing the Media controller interface.

Note that this is not a commonplace. The difference will be only be 
there *if and only if* you have a sub-device with sink pads in a 
pipeline. There are not many of those, and that difference is not 
introduced by this patch: it is a property of hardware.

I'm definitely open to improving the wording as well as other solutions 
that can address this.

Cc Niklas.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
