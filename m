Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39101 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbeILTT5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 15:19:57 -0400
Received: by mail-lf1-f65.google.com with SMTP id v77-v6so1841101lfa.6
        for <linux-media@vger.kernel.org>; Wed, 12 Sep 2018 07:15:13 -0700 (PDT)
Subject: Re: [Xen-devel][PATCH v2 1/1] cameraif: add ABI for para-virtual
 camera
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
References: <20180911082952.23322-1-andr2000@gmail.com>
 <20180911082952.23322-2-andr2000@gmail.com>
 <7291d10d-3fe2-2cba-e5f7-cd30b91a7cf1@xs4all.nl>
 <1e6eca59-c002-42b7-d8b6-f8a525898291@gmail.com>
 <bffe0f61-c2b6-33c9-1fbc-d81bbf52f013@xs4all.nl>
 <8a7b3f0d-4385-201a-d50a-69d81470f2fb@gmail.com>
 <457d93c8-b01e-0824-483d-5bdf6a49e69b@xs4all.nl>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <1a8e5f3e-cf57-ccb0-f1d2-650e4c325166@gmail.com>
Date: Wed, 12 Sep 2018 17:15:09 +0300
MIME-Version: 1.0
In-Reply-To: <457d93c8-b01e-0824-483d-5bdf6a49e69b@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2018 04:38 PM, Hans Verkuil wrote:
> On 09/12/18 15:02, Oleksandr Andrushchenko wrote:
>> On 09/12/2018 03:25 PM, Hans Verkuil wrote:
>>>>>> + * formats
>>>>>> + *      Values:         <format, char[4]>
>>>>>> + *
>>>>>> + *      Formats are organized as a set of directories one per each
>>>>>> + *      supported pixel format. The name of the directory is the
>>>>>> + *      corresponding FOURCC string label. The next level of
>>>>>> + *      the directory under <formats> represents supported resolutions.
>>>>> So how will this work for a pixelformat like V4L2_PIX_FMT_ARGB555X?
>>>>>
>>>>> As mentioned before, we display such formats as 'XXXX-BE', i.e. char[7].
>>>> ok, then I'll change this to char[7] and put a note on big-endian:
>>>>
>>>>     *      If format represents a big-endian FOURCC code, then "-BE"
>>>>     *      suffix must be added, case insensitive.
>>> Since the fourcc is case-sensitive, I'd keep -BE case sensitive as well.
>>> Your decision, though.
>> hm, I'm a little bit confused here... One of the previous comments was...
>>
>>   >> + *      Formats are organized as a set of directories one per each
>>   >> + *      supported pixel format. The name of the directory is an
>> upper case
>>   >> + *      string of the corresponding FOURCC string label. The next
>> level of
>>   >> + *      the directory under <formats> represents supported resolutions.
>>
>>   >Lower-case characters are also use in pixelformats, so I'd just keep
>> this as-is.
>>   >
>>   >In addition it is common to set bit 31 of the fourcc to 1 if the format is
>>   >big-endian (see v4l2_fourcc_be macro). When v4l utilities print this
>> format we
>>   >add a -BE suffix, so V4L2_PIX_FMT_ARGB555X becomes "AR15-BE". You
>> might want to
>>   >keep that convention.
>>
>> So, finally, I'll put upper case constraint here for fourcc and "-BE"?
>> Did I miss something here?
> Easiest is to look at videodev2.h. Let me take two examples:
>
> #define V4L2_PIX_FMT_ARGB555 v4l2_fourcc('A', 'R', '1', '5') /* 16  ARGB-1-5-5-5  */
> #define V4L2_PIX_FMT_ARGB555X v4l2_fourcc_be('A', 'R', '1', '5') /* 16  ARGB-5-5-5 BE */
>
> The fourcc macros are defined as:
>
> #define v4l2_fourcc(a, b, c, d)\
>          ((__u32)(a) | ((__u32)(b) << 8) | ((__u32)(c) << 16) | ((__u32)(d) << 24))
> #define v4l2_fourcc_be(a, b, c, d)      (v4l2_fourcc(a, b, c, d) | (1 << 31))
>
> The characters can be any printable character, but currently we only use
> a-z, A-Z, 0-9 and space (' ').
>
> For big-endian formats we also set bit 31 (i.e. bit 7 of the last character)
> to indicate this.
>
> In our v4l2 utilities we use this function when we want to print a fourcc:
>
> std::string fcc2s(__u32 val)
> {
>          std::string s;
>
>          s += val & 0x7f;
>          s += (val >> 8) & 0x7f;
>          s += (val >> 16) & 0x7f;
>          s += (val >> 24) & 0x7f;
>          if (val & (1 << 31))
>                  s += "-BE";
>          return s;
> }
>
> So the four characters (with bit 7 masked out) and the -BE suffix
> if bit 7 was set for the fourth character.
>
> So for your protocol, if you want to specify the fourcc, then I
> assume dealing with characters with bit 7 set is a pain as well,
> and in that case you are better off using the same scheme that we
> do.
>
> And to match the formats, applications should remember that the
> string is case-sensitive, so 'abcd' != 'Abcd'.
Ah, got it, so I'll just make sure that "-BE" part
is case sensitive, e.g. remove "case insensitive":

  * formats
  *      Values:         <format, char[7]>
  *
  *      Formats are organized as a set of directories one per each
  *      supported pixel format. The name of the directory is the
  *      corresponding FOURCC string label. The next level of
  *      the directory under <formats> represents supported resolutions.
  *      If format represents a big-endian FOURCC code, then "-BE"
  *      suffix must be added.

>
> Note that there can be spaces:
>
> #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
> #define V4L2_PIX_FMT_Y16_BE  v4l2_fourcc_be('Y', '1', '6', ' ') /* 16  Greyscale BE  */
>
> So that would be:
>
> /local/domain/1/device/vcamera/0/formats/Y16 /1200x720/frame-rates = "15/2"
>
> and:
>
> /local/domain/1/device/vcamera/0/formats/Y16 -BE/1200x720/frame-rates = "15/2"
>
> Not sure if that will fly for you.
>
> Currently if there are spaced, then they are at the end, but I don't think
> we can guarantee that for all time.
This is a problem as I cannot have spaces...
So, I can only put something like:

  *      If FOURCC string label has spaces then those are only allowed to
  *      be at the end of the label and must be trimmed.

>
>>>>> I assume the pixelformats you use here are based on the V4L2_PIX_FMT_ fourccs?
>>>>>
>>>>> Note that there is no real standard for fourcc values, so if you want to
>>>>> support a Windows backend as well, then you'll need mappings from whatever
>>>>> Windows uses to the V4L2 fourccs.
>>>>>
>>>>> The V4L2_PIX_FMT_ fourccs are entirely V4L2 specific.
>>>>>
>>>>> So you have to define here whose fourccs you are using.
>>>> I thought that [1] defines all these values, but if this is not the case,
>>>> then I think we can use what V4L2 uses. In this case,
>>>> what would be the best reference in the protocol to those fourcc
>>>> codes? For example, I can reference [2] in the protocol's assumptions:
>>>>
>>>>     ******************************************************************************
>>>>     *                              Assumptions
>>>>     ******************************************************************************
>>>> ...
>>>>     * - all FOURCC mappings used for configuration and messaging are
>>>>     *   Linux V4L2 ones:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/videodev2.h
>>> Yeah, I'd pick videodev2.h. We document the formats fairly carefully in
>>> our spec.
>> Agreed
>>> [1] is useless: there are many, many more formats (often HW specific) and
>>> variants of formats, just look in our spec at how many Bayer variants there
>>> are.
>>>
>>>>>> + *
>>>>>> + * resolution
>>>>>> + *      Values:         <width, uint32_t>x<height, uint32_t>
>>>>>> + *
>>>>>> + *      Resolutions are organized as a set of directories one per each
>>>>>> + *      supported resolution under corresponding <formats> directory.
>>>>>> + *      The name of the directory is the supported width and height
>>>>>> + *      of the camera resolution in pixels.
>>>>> So how will this work for sources like HDMI where the resolution depends on
>>>>> the signal? Will this only show the received resolution? And if so, what
>>>>> happens if there is no signal? Or the resolution changes?
>>>>>
>>>>> If you want to support such devices, you'll need to define the behavior.
>>>>>
>>>>> It might be OK to rely on the XenbusStateReconfiguring state, but I think
>>>>> this would have to be described somewhere. I.e. if the source is disconnected,
>>>>> then you enter state XenbusStateReconfiguring, when a new source is connected,
>>>>> then you setup a new configuration based on the newly detected timings. But
>>>>> what to do when the timings change? Reconfiguring again? Whether this is an
>>>>> option depends in part on how long it takes before the new configuration
>>>>> becomes active.
>>>> Well, IMO this is something which is a part of the backend's
>>>> logic: backend may decide to tear down the whole virtual camera
>>>> device, e.g. going into closed state, or it can try reconfiguring the device
>>>> or whatever.
>>>>
>>>> One note on such complex use-cases: we are trying to keep the protocol
>>>> as simple as possible not trying to mimic really complex HW.
>>>> If need be to support this one can probably just pass through that
>>>> HW device to a guest, so it can benefit from all those features.
>>> This is not a complex use-case. The only difference is that you don't have an
>>> integrated sensor, but instead a connector through which you receive a video
>>> signal.
>>>
>>> If you want you can consider this a 'remote hotpluggable sensor' use-case.
>>>
>>>> Most use-cases we see only need captured frames and most of the work
>>>> of getting those is handled by the backend. And the configuration
>>>> most of the time should remain static, e.g. all the parameters are defined
>>>> for known HW and VMs are configured with specific use-cases in mind.
>>>> Thus, the backend should hide all the real complexity from a virtual
>>>> camera device driver as much as it can (BTW, frontend might not be a
>>>> V4L2 device driver, but a unikernel application for instance)
>>> It is my feeling that you need to test this use-case before finalizing
>>> this spec. It does not have to include this functionality for the first
>>> version, but at least you should know that it can be added later.
>> Before virtualizing camera we have done the same for display
>> and sound. And that time we first created the corresponding
>> protocols, frontends and backends and then started upstreaming.
>> That led to number of comments from the respective communities,
>> so we changed the protocols/frontends/backends to fit those requirements
>> (that was done that way for number of reasons).
>> This time we started working on the protocol and decided to show
>> it to the community first in order to minimize efforts later.
>> Long story short: if the protocol is ok for the community at the
>> first round then, even if we have R-b's on it, we won't ask to
>> accept it, until frontend/backend is implemented and the protocol
>> proves to work. Only then we'll ask the community to accept
>> the protocol.
> OK, thank you for the clarification. I'm happy with that. My job is
> just to provide you with all the potential pitfalls :-)
Thank you for your help!
>
>>> BTW, once one frontend starts streaming, then other frontends can only
>>> stream provided that they use same configuration (format).
>> Yes
>>>    I doubt you
>>> want to implement conversions betwee pixelformats or sizes.
> I just wonder how you want to expose that. E.g. there is one backend and
> two frontends. The backend supports two resolutions and that is exposed
> to both backends. But once the first backend starts streaming, then the
> second backend is suddenly limited to a single resolution.
>
> Something for you to think about.
Scaling on backend side for the second frontend
>> Well, at the first stage the backend will limit all frontends
>> to use the same format. But, it is perfectly doable to provide the
>> conversions you mention later, for example, doing some OpenGL magic on the
>> buffers or whatever. But of course, this will eat GPU/CPU which is
>> critical for embedded systems.
>>> So how is that handled?
>> This is backend's implementation specific
> Fair enough.
>
> <snip>
>
>>>>>> + * flags - uint32_t, set of the XENCAMERA_EVT_CFG_FLG_XXX flags.
>>>>>> + */
>>>>>> +struct xencamera_cfg_change_evt {
>>>>>> +    uint32_t flags;
>>>>>> +};
>>>>> This needs some more work: what should the frontend do when this is received?
>>>>>
>>>>> I would expect it should stop streaming, free all buffers, reread the config
>>>>> and start again.
>>>> That effectively means almost the same as going into
>>>> Closed state and then going back into Connected state
>>>> which can be controlled by the backend with XenBus state machine.
>>>> So, this particular configuration change event can be omitted
>>>> at all. Does this sound reasonable?
>>> Yes.
>> So, I will remove this event completely - did I get you right?
> Yes, just remove it.
>
>>>>> But what if there is no new config because the source was disconnected?
>>>> This is the backend's responsibility to control that,
>>>> e.g. if the source has disconnected then the backend must
>>>> hold virtual camera device via the XenBus state machine in
>>>> closed or any non-operatable state until that source comes back.
>>> I think a lot of this can be resolved by chosing appropriate states
>>> for when something gets connected or disconnected, or is reconfigured
>>> while connected.
>>>
>>> This is all a bit of brainstorming, this is all a bit different from what
>>> I'm used to.
>> I'm implementing virtual camera for the first time as well ;)
> Hmm, a learning experience for the both of us.
>
>>>>>> +
>>>>>> +/*
>>>>>> + * Control change event- event from back to front when camera control
>>>>>> + * has changed:
>>>>>> + *         0                1                 2               3        octet
>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>> + * |               id                |_EVT_CTRL_CHANGE|   reserved     | 4
>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>> + * |       type     |                     reserved                     | 8
>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>> + * |                             reserved                              | 12
>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>> + * |                             reserved                              | 16
>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>> + * |                          value low 32-bit                         | 20
>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>> + * |                          value high 32-bit                        | 24
>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>> + * |                             reserved                              | 28
>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>> + * |                             reserved                              | 64
>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>> + *
>>>>>> + * type - uint8_t, type of the control, one of the XENCAMERA_CTRL_XXX.
>>>>>> + * value - int64_t, new value of the control.
>>>>>> + */
>>>>> So will this happen for all controls (except write-only)? What about volatile
>>>>> controls? What if the frontend sets a control, does it also get this event?
>>>>> Does it get this event with the current value of a control when it first connects?
>>>>>
>>>>> What happens if there are multiple quick changes to the same control? Can the event
>>>>> queue overflow?
>>>>>
>>>>> Sorry, these are all questions we had to answer when we added control event
>>>>> support. We spend a lot of time making the event handling reliable without losing
>>>>> information (intermediate values can be lost, but never the current value).
>>>>>
>>>>> Since this is relying on a Xen event mechanism you will have to think about this
>>>>> as well.
>>>> I'll put these notes:
>>>>     * Notes:
>>>>     *  - this event is not sent for write-only controls
>>>>     *  - this event is also sent to the originator of the control change
>>> I actually recommend against this. We don't do this, an application has
>>> to explicitly request this.
>>>
>>> The problem is that you don't know if the event you receive is from your
>>> own change, or if an external actor changed it.
>>>
>>> So if a frontend receives this event, then it is because another frontend
>>> or the backend changed the control, and not because you did it yourself.
>> Ah, indeed. So, I'll turn it vice versa:
>>     *  - this event is NOT sent to the originator of the control change
> I think that's wise.
>
> BTW, when I started developing control events I initially also sent it to
> the originator. But once I started using it in a real application I quickly
> realized that that was a really bad idea :-)
Great that you can share your practical experience, thank you
> Regards,
>
> 	Hans
Thank you,
Oleksandr
