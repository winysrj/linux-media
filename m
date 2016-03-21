Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39482 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756522AbcCUQBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 12:01:51 -0400
Subject: Re: [RFC PATCH 1/3] [media] v4l2-mc.h: Add a S-Video C input PAD to
 demod enum
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
 <1457550566-5465-2-git-send-email-javier@osg.samsung.com>
 <56EC2294.603@xs4all.nl> <56EC3BF3.5040100@xs4all.nl>
 <20160321114045.00f200a0@recife.lan> <56F00DAA.8000701@xs4all.nl>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56F01AE7.6070508@xs4all.nl>
Date: Mon, 21 Mar 2016 17:01:43 +0100
MIME-Version: 1.0
In-Reply-To: <56F00DAA.8000701@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2016 04:05 PM, Hans Verkuil wrote:
> On 03/21/2016 03:40 PM, Mauro Carvalho Chehab wrote:
>> Em Fri, 18 Mar 2016 18:33:39 +0100
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>> On 03/18/2016 04:45 PM, Hans Verkuil wrote:
>>>> On 03/09/2016 08:09 PM, Javier Martinez Canillas wrote:  
>>>>> The enum demod_pad_index list the PADs that an analog TV demod has but
>>>>> in some decoders the S-Video Y (luminance) and C (chrominance) signals
>>>>> are carried by different connectors. So a single DEMOD_PAD_IF_INPUT is
>>>>> not enough and an additional PAD is needed in the case of S-Video for
>>>>> the additional C signal.
>>>>>
>>>>> Add a DEMOD_PAD_C_INPUT that can be used for this case and the existing
>>>>> DEMOD_PAD_IF_INPUT can be used for either Composite or the Y signal.
>>>>>
>>>>> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>>>>
>>>>> ---
>>>>> Hello,
>>>>>
>>>>> This change was suggested by Mauro in [0] although is still not clear
>>>>> if this is the way forward since changing PAD indexes can break the
>>>>> uAPI depending on how the PADs are looked up. Another alternative is
>>>>> to have a PAD type as Mauro mentioned on the same email but since the
>>>>> series are RFC, I'm making this change as an example and hopping that
>>>>> the patches can help with the discussion.
>>>>>
>>>>> [0]: http://www.spinics.net/lists/linux-media/msg98042.html
>>>>>
>>>>> Best regards,
>>>>> Javier
>>>>>
>>>>>  include/media/v4l2-mc.h | 3 ++-
>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
>>>>> index 98a938aabdfb..47c00c288a06 100644
>>>>> --- a/include/media/v4l2-mc.h
>>>>> +++ b/include/media/v4l2-mc.h
>>>>> @@ -94,7 +94,8 @@ enum if_aud_dec_pad_index {
>>>>>   * @DEMOD_NUM_PADS:	Maximum number of output pads.
>>>>>   */
>>>>>  enum demod_pad_index {
>>>>> -	DEMOD_PAD_IF_INPUT,
>>>>> +	DEMOD_PAD_IF_INPUT, /* S-Video Y input or Composite */
>>>>> +	DEMOD_PAD_C_INPUT,  /* S-Video C input or Composite */
>>>>>  	DEMOD_PAD_VID_OUT,
>>>>>  	DEMOD_PAD_VBI_OUT,
>>>>>  	DEMOD_PAD_AUDIO_OUT,
>>>>>  
>>>>
>>>> These pad index enums are butt ugly and won't scale in the long run. An entity
>>>> should have just as many pads as it needs and no more.
>>>>
>>>> If you want to have an heuristic so you can find which pad carries e.g.
>>>> composite video, then it is better to ask the subdev for that.
>>>>
>>>> E.g.: err = v4l2_subdev_call(sd, pad, g_signal_pad, V4L2_PAD_Y_SIG_INPUT, &pad)
>>>>
>>>> The subdev driver knows which pad has which signal, so this does not rely on
>>>> hardcoding all combinations of possible pad types and you can still heuristically
>>>> build a media graph for legacy drivers.
>>
>> Yes, accessing PADs via a hardcoded index is butt ugly.
>>
>> For sure, we need a better strategy than that. This is one of the things
>> we need to discuss at the media summit.
>>
>>>> What we do now is reminiscent of the bad old days when the input numbers (as
>>>> returned by ENUMINPUT) where mapped to the i2c routing (basically pads). I worked
>>>> hard to get rid of that hardcoded relationship and I don't like to see it coming
>>>> back.
>>
>> No, this is completely unrelated with ENUMINPUT. 
>>
>> With VIDIOC_*INPUT ioctls, a hardcoded list of inputs can happen only at
>> the Kernel side, as, userspace should not rely on the input index, but,
>> instead, should call VIDIOC_ENUMINPUT.
>>
>> However, the media controller currently lacks an "ENUMPADS" ioctl that
>> would tell userspace what kind of data each PAD contains. Due to that,
>> on entities with more than one sink pad and/or more than one source
>> pad, the application should rely on the PAD index.
>>
>> That also reflects on the Kernel side, that forces drivers to do
>> things like:
>>
>> 	struct tvp5150 *core = to_tvp5150(sd);
>> 	int res;
>>
>> 	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
>> 	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
>> 	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
>>
>> 	res = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, core->pads);
>>
>> hardcoding the PAD indexes.
>>
>> The enums that are right now at v4l2-mc.h just prevents the mess to
>> spread all over the drivers, while we don't have a better solution, as
>> at least it will prevent two different devices with the very same type
>> to have a completely different set of PADs, with would cause lots of
>> pain on drivers that work with a multiple set of entities of the same
>> type.
> 
> This is already device specific. The video and audio s_routing ops are there
> precisely because the routing between devices is board specific. It links
> entities with each other the way we had to before we had the media controller.
> 
> Subdev entities should *not* use these fake pads. It's going to be a nightmare.
> 
> A reasonable solution to simplify converting legacy drivers without creating
> these global ugly pad indices is to add a new video (and probably audio) op
> 'g_pad_of_type(type)' where you ask the subdev entity to return which pad carries
> signals of a certain type.

This basically puts a layer between the low-level pads as defined by the entity
and the 'meta-pads' that a generic MC link creator would need to handle legacy
drivers. The nice thing is that this is wholly inside the kernel so we can
modify it at will later without impacting userspace.

Regards,

	Hans
