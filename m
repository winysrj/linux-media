Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:35066 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbdF3HA3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 03:00:29 -0400
Received: by mail-wr0-f169.google.com with SMTP id k67so198873115wrc.2
        for <linux-media@vger.kernel.org>; Fri, 30 Jun 2017 00:00:29 -0700 (PDT)
Subject: Re: [PATCH v2 04/19] media: camss: Add CSIPHY files
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
 <1497883719-12410-5-git-send-email-todor.tomov@linaro.org>
 <20170628213433.7ehkz62rw75t4yxa@valkosipuli.retiisi.org.uk>
 <4b28ce1a-84af-858b-50d1-79fb3e461387@linaro.org>
 <20170629235332.m6ru4uxvdt6bmsod@valkosipuli.retiisi.org.uk>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <8e5494d9-f8a3-16df-3850-fbfd3bf87965@linaro.org>
Date: Fri, 30 Jun 2017 10:00:25 +0300
MIME-Version: 1.0
In-Reply-To: <20170629235332.m6ru4uxvdt6bmsod@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/30/2017 02:53 AM, Sakari Ailus wrote:
> Hi Todor,
> 
> On Thu, Jun 29, 2017 at 07:36:47PM +0300, Todor Tomov wrote:
>>>> +/*
>>>> + * csiphy_link_setup - Setup CSIPHY connections
>>>> + * @entity: Pointer to media entity structure
>>>> + * @local: Pointer to local pad
>>>> + * @remote: Pointer to remote pad
>>>> + * @flags: Link flags
>>>> + *
>>>> + * Rreturn 0 on success
>>>> + */
>>>> +static int csiphy_link_setup(struct media_entity *entity,
>>>> +			     const struct media_pad *local,
>>>> +			     const struct media_pad *remote, u32 flags)
>>>> +{
>>>> +	if ((local->flags & MEDIA_PAD_FL_SOURCE) &&
>>>> +	    (flags & MEDIA_LNK_FL_ENABLED)) {
>>>> +		struct v4l2_subdev *sd;
>>>> +		struct csiphy_device *csiphy;
>>>> +		struct csid_device *csid;
>>>> +
>>>> +		if (media_entity_remote_pad((struct media_pad *)local))
>>>
>>> This is ugly.
>>>
>>> What do you intend to find with media_entity_remote_pad()? The pad flags
>>> haven't been assigned to the pad yet, so media_entity_remote_pad() could
>>> give you something else than remote.
>>
>> This is an attempt to check whether the pad is already linked - to refuse
>> a second active connection from the same src pad. As far as I can say, it
>> was a successful attempt. Do you see any problem with it?
> 
> Ah. So you have multiple links here only one of which may be active?

Exactly. Below I'm adding the output of media-ctl --print-dot as you have
requested. I can add it in the driver document as well.

> 
> I guess you can well use media_entity_remote_pad(), but then
> media_entity_remote_pad() argument needs to be made const. Feel free to
> spin a patch. I don't think it'd have further implications elsewhere.
> 

Well media_entity_remote_pad() accepts struct media_pad *pad, not a
const and trying to pass a const triggers a warning. This is why I had
to cast. Or did I misunderstand you?


# media-ctl -d /dev/media1 --print-dot
digraph board {
        rankdir=TB
        n00000001 [label="msm_csiphy0\n/dev/v4l-subdev0", shape=box, style=filled, fillcolor=yellow]
        n00000001 -> n00000007 [style=dashed]
        n00000001 -> n0000000a [style=dashed]
        n00000004 [label="msm_csiphy1\n/dev/v4l-subdev1", shape=box, style=filled, fillcolor=yellow]
        n00000004 -> n00000007 [style=dashed]
        n00000004 -> n0000000a [style=dashed]
        n00000007 [label="msm_csid0\n/dev/v4l-subdev2", shape=box, style=filled, fillcolor=yellow]
        n00000007 -> n0000000d [style=dashed]
        n00000007 -> n00000010 [style=dashed]
        n0000000a [label="msm_csid1\n/dev/v4l-subdev3", shape=box, style=filled, fillcolor=yellow]
        n0000000a -> n0000000d [style=dashed]
        n0000000a -> n00000010 [style=dashed]
        n0000000d [label="msm_ispif0\n/dev/v4l-subdev4", shape=box, style=filled, fillcolor=yellow]
        n0000000d -> n00000013:port0 [style=dashed]
        n0000000d -> n0000001c:port0 [style=dashed]
        n0000000d -> n00000025:port0 [style=dashed]
        n0000000d -> n0000002e:port0 [style=dashed]
        n00000010 [label="msm_ispif1\n/dev/v4l-subdev5", shape=box, style=filled, fillcolor=yellow]
        n00000010 -> n00000013:port0 [style=dashed]
        n00000010 -> n0000001c:port0 [style=dashed]
        n00000010 -> n00000025:port0 [style=dashed]
        n00000010 -> n0000002e:port0 [style=dashed]
        n00000013 [label="{{<port0> 0} | msm_vfe0_rdi0\n/dev/v4l-subdev6 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
        n00000013:port1 -> n00000016 [style=bold]
        n00000016 [label="msm_vfe0_video0\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
        n0000001c [label="{{<port0> 0} | msm_vfe0_rdi1\n/dev/v4l-subdev7 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
        n0000001c:port1 -> n0000001f [style=bold]
        n0000001f [label="msm_vfe0_video1\n/dev/video1", shape=box, style=filled, fillcolor=yellow]
        n00000025 [label="{{<port0> 0} | msm_vfe0_rdi2\n/dev/v4l-subdev8 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
        n00000025:port1 -> n00000028 [style=bold]
        n00000028 [label="msm_vfe0_video2\n/dev/video2", shape=box, style=filled, fillcolor=yellow]
        n0000002e [label="{{<port0> 0} | msm_vfe0_pix\n/dev/v4l-subdev9 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
        n0000002e:port1 -> n00000031 [style=bold]
        n00000031 [label="msm_vfe0_video3\n/dev/video3", shape=box, style=filled, fillcolor=yellow]
        n00000057 [label="{{} | ov5645 1-0076\n/dev/v4l-subdev10 | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
        n00000057:port0 -> n00000001 [style=bold]
        n00000059 [label="{{} | ov5645 1-0074\n/dev/v4l-subdev11 | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
        n00000059:port0 -> n00000004 [style=bold]
}


--
Best regards,
Todor Tomov
