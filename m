Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:33990 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751555AbdHJLLY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 07:11:24 -0400
Subject: Re: [GIT PULL for 4.14] Stream control documentation
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <20170809080340.4c5b4jjypqiqyllp@valkosipuli.retiisi.org.uk>
 <20170809122917.0461db2c@vento.lan> <20170809125757.57cd8d2b@vento.lan>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fb0fc810-1e42-be44-788f-e51c46a0ae22@xs4all.nl>
Date: Thu, 10 Aug 2017 13:11:21 +0200
MIME-Version: 1.0
In-Reply-To: <20170809125757.57cd8d2b@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

My apologies, I should have reviewed this weeks ago. Please ping me next time,
this got buried under all the other patches, even though it was delegated to me.

Anyway, better late than never:

On 09/08/17 17:57, Mauro Carvalho Chehab wrote:
> Em Wed, 9 Aug 2017 12:29:17 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> 
>> Em Wed, 9 Aug 2017 11:03:40 +0300
>> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
>>
>>> Hi Mauro,
>>>
>>> Add stream control documentation.
>>>
>>> We have recently added support for hardware that makes it possible to have
>>> pipelines that are controlled by more than two drivers. This necessitates
>>> documenting V4L2 stream control behaviour for such pipelines.  
>>
>> Perhaps I missed this one, but I'm not seeing any e-mail with
>> 	"docs-rst: media: Document s_stream() video op usage"
>>
>> Please always submit patches via e-mail too, as it makes easier for
>> us to comment/review when needed.
>>
>> In any case, I'm appending the patch contents here. I'll reply to it
>> on a next e-mail.
>>
>>> From ef8e5d20b45b05290c56450d2130a0dc3c021c5a Mon Sep 17 00:00:00 2001
>>> From: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> Date: Thu, 9 Mar 2017 15:07:57 +0200
>>> Subject: docs-rst: media: Document s_stream() video op usage
>>> MIME-Version: 1.0
>>> Content-Type: text/plain; charset=UTF-8
>>> Content-Transfer-Encoding: 8bit
>>> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
>>>     Mauro Carvalho Chehab <mchehab@infradead.org>
>>>
>>> As we begin to add support for systems with media pipelines controlled by
>>> more than one device driver, it is essential that we precisely define the
>>> responsibilities of each component in the stream control and common
>>> practices.
> 
> Not sure what you meant here. Currently, there is support already
> for multiple subdevs attached to a driver.
> 
> As we're talking here about kAPI, it is quite common that a V4L2 the
> need to set multiple devices while stream. A typical non-MC device like
> bttv can set up to 4 types of devices:
> 	- tuner;
> 	- audio decoder;
> 	- video decoder;
> 	- video enhancers.

I agree. The document *only* applies to MC-controlled pipelines and that
should be made clear.

> 
>>> Specifically, this patch documents two things:
>>>
>>> 1) streaming control is done per sub-device and sub-device drivers
>>> themselves are responsible for streaming setup in upstream sub-devices and
> 
> In the case of non-MC devices, it is the bridge driver that it is
> responsible to pass a "broadcast" message to all subdevices for
> them to be at "stream mode".

Indeed.

> 
>>>
>>> 2) broken frames should be tolerated at streaming stop. It is the
>>> responsibility of the sub-device driver to stop the transmitter after
>>> itself if it cannot handle broken frames (and it should be probably be
>>> done anyway).
> 
> You should define what you mean by "transmitter".

Please note that partial/broken frames can *also* happen at streaming *start*,
especially HDMI receivers often do that. And especially in the case of HDMI
(also DVI, VGA, etc) you can get frames that are too long or too short.

Particularly too long frames can be a nightmare (happens when due to a pin-bounce
when connecting an HDMI device the receiver misses the v-sync and so the frame
is suddenly twice the normal height). And yes, this really can happen.

> 
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>> ---
>>>  Documentation/media/kapi/v4l2-subdev.rst | 36 ++++++++++++++++++++++++++++++++
>>>  1 file changed, 36 insertions(+)
>>>
>>> diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
>>> index e1f0b726e438..100ffc783f72 100644
>>> --- a/Documentation/media/kapi/v4l2-subdev.rst
>>> +++ b/Documentation/media/kapi/v4l2-subdev.rst
>>> @@ -262,6 +262,42 @@ is called. After all subdevices have been located the .complete() callback is
>>>  called. When a subdevice is removed from the system the .unbind() method is
>>>  called. All three callbacks are optional.
>>>  
>>> +Streaming control
>>> +^^^^^^^^^^^^^^^^^
>>> +
>>> +Starting and stopping the stream are somewhat complex operations that
>>> +often require walking the media graph to enable streaming on
>>> +sub-devices which the pipeline consists of. This involves interaction
>>> +between multiple drivers, sometimes more than two.
>>> +
>>> +The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is responsible
>>> +for starting and stopping the stream on the sub-device it is called on.
>>> +Additionally, if there are sub-devices further up in the pipeline, i.e.
>>> +connected to that sub-device's sink pads through enabled links, the
>>> +sub-device driver must call the ``.s_stream()`` video op of all such
>>> +sub-devices.

I think you mean that it calls s_stream for the immediately connected subdevs,
not for subdevs that are one or more subdevs removed. I.e.:

S1 -> S2 -> S3 -> BRIDGE

BRIDGE calls s_stream for S3, S3 calls s_stream for S2 and S2 calls it for S1.

Right? The text above ('Additionally...') is a bit ambiguous.

>>> The sub-device driver is thus in control of whether the
>>> +upstream sub-devices start (or stop) streaming before or after the
>>> +sub-device itself is set up for streaming.
> 
> Why the sub-device? Even in the MC case, the stream on operation is
> usually called via the v4l devnode, where the DMA engine is.

Actually, it's always called from a video node, I think. So the bridge driver
initiates the first s_stream for a connected v4l2_subdev.

> 
>>> +
>>> +.. note::
>>> +
>>> +   As the ``.s_stream()`` callback is called recursively through the
>>> +   sub-devices along the pipeline, it is important to keep the
>>> +   recursion as short as possible. To this end, drivers are encouraged
>>> +   not to internally call ``.s_stream()`` recursively in order to make
>>> +   only a single additional recursion per driver in the pipeline. This
>>> +   greatly reduces stack usage.
> 
> what "drivers" are encouraged not to ...?
> 
>>> +
>>> +Stopping the transmitter
>>> +^^^^^^^^^^^^^^^^^^^^^^^^
> 
> What is a transmitter? There are only two places inside kAPI that
> uses the word "transmitter":
> 	Documentation/media/kapi/cec-core.rst
> 	Documentation/media/kapi/csi2.rst
> 
> On both documents, the meaning of the term is clear, but I can't
> understand what you mean by "transmitter" at the subdev's core
> documentation. Is it the tuner? the bridge driver? a CSI bus?
> the DMA engine? all of them?

I guess 'source' is what you mean? But this could apply to sensors, but
also intermediate subdevs (e.g. stopping a scaler subdev can also cause
a partial frame even though the sensor gave a full frame).

Regards,

	Hans

> 
>>> +
>>> +A transmitter stops sending the stream of images as a result of
>>> +calling the ``.s_stream()`` callback. Some transmitters may stop the
>>> +stream at a frame boundary whereas others stop immediately,
>>> +effectively leaving the current frame unfinished. The receiver driver
>>> +should not make assumptions either way, but function properly in both
>>> +cases.
>>> +
>>>  V4L2 sub-device userspace API
>>>  -----------------------------
>>>  
>>> -- 
>>> 2.13.3
>>>   
>>
>>
>> Thanks,
>> Mauro
> 
> 
> 
> Thanks,
> Mauro
> 
