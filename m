Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:52587 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754066AbeBLKLt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 05:11:49 -0500
Subject: Re: Fwd: Re: [PATCHv5 0/3] drm/i915: add DisplayPort
 CEC-Tunneling-over-AUX support
From: Hans Verkuil <hverkuil@xs4all.nl>
To: ville.syrjala@linux.intel.com
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <b6ac8671-7b66-977e-1322-f31e08d76436@xs4all.nl>
 <7ec14da2-7aed-906e-3d55-8af1907aaf0c@xs4all.nl>
 <20180112163027.GG10981@intel.com>
 <e7c4e82c-e563-834b-8708-42efa222e7d3@xs4all.nl>
 <20180112175218.GJ10981@intel.com>
 <47a32832-4a4e-c66b-2d7f-f8f7a6093ada@xs4all.nl>
 <9e28a8fe-c792-df98-012d-f7d02ad1e9b2@xs4all.nl>
Message-ID: <89934a2a-1a2f-4ea8-f9b8-16e5c575a8f6@xs4all.nl>
Date: Mon, 12 Feb 2018 11:11:44 +0100
MIME-Version: 1.0
In-Reply-To: <9e28a8fe-c792-df98-012d-f7d02ad1e9b2@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ville,

On 12/01/18 20:08, Hans Verkuil wrote:
> On 01/12/2018 07:12 PM, Hans Verkuil wrote:
>> On 01/12/2018 06:52 PM, Ville Syrjälä wrote:
>>> On Fri, Jan 12, 2018 at 06:14:53PM +0100, Hans Verkuil wrote:
>>>> On 01/12/2018 05:30 PM, Ville Syrjälä wrote:
>>>>> On Fri, Jan 12, 2018 at 05:19:44PM +0100, Hans Verkuil wrote:
>>>>>> Hi Ville,
>>>>>>
>>>>>> For some strange reason your email disappeared from the Cc list. Perhaps it's the
>>>>>> ä that confuses something somewhere.
>>>>>>
>>>>>> So I'll just forward this directly to you.
>>>>>>
>>>>>> Can you please take a look? This patch series has been in limbo for too long.
>>>>>
>>>>> IIRC last I looked we still had some ragistration race to deal with.
>>>>> Was that fixed?
>>>>
>>>> That was fixed in v5.
>>>>
>>>>>
>>>>> Also I think we got stuck on leaving the zombie device lingering around
>>>>> when the display is disconnected. I couldn't understand why that is
>>>>> at all useful since you anyway remove the device eventually.
>>>>
>>>> It's not a zombie device. If you disconnect and reconnect the display then the
>>>> application using the CEC device will see the display disappear and reappear
>>>> as expected.
>>>>
>>>> It helps if you think of the normal situation (as is present in most ARM SoCs)
>>>> where CEC is integral to the HDMI transmitter. I.e. it is not functionality that
>>>> can be removed. So the cec device is always there and an application opens the
>>>> device and can use it, regardless of whether a display is connected or not.
>>>>
>>>> If a display is detected, the EDID will be read and the CEC physical address is
>>>> set. The application is informed of that through an event and the CEC adapter
>>>> can be used. If the HPD disappears the physical address is reset to f.f.f.f and
>>>> again the application is informed. And in fact it still has to be able to use
>>>> the CEC adapter even if there is no HPD since some displays turn off the HPD when
>>>> in standby, but CEC can still be used to power them up again.
>>>
>>> Hmm. So you're saying there are DP devices out there that release HPD
>>> but still respond to DPCD accesses? That sounds... wrong.
>>
>> Not quite. To be precise: there are HDMI displays that release HPD when in standby
>> but still respond to CEC commands.
>>
>> Such displays are still being made today so if you are building a product like
>> a media streaming box, then this is something to take into account.
>>
>> However, for this specific case (CEC tunneling) it is a non-issue since the
>> DP CEC protocol simply doesn't support sending CEC commands without HPD.
>>
>>> In general I don't think we can assume that a device has retained its
>>> state if it has deasserted HPD, thus we have to reconfigure everything
>>> again anyway.
>>>
>>>>
>>>> Now consider a future Intel NUC with an HDMI connector on the backplane and
>>>> working DP CEC-Tunneling-over-AUX support (e.g. the Megachips MCDP2900): the
>>>> CEC support is always there (it's built in), but only becomes visible to the
>>>> kernel when you connect a display. You don't want the cec device to disappear
>>>> whenever you unplug the display, that makes no sense. Applications would
>>>> loose the CEC configuration and have to close and reopen (when it reappears)
>>>> the cec device for no good reason since it is built in.
>>>
>>> If the application can't remember its settings across a disconnect it
>>> sounds broken anwyay. This would anyway happen when you disconenct the
>>> entire dongle.
>>
>> Huh?
>>
>>>
>>>>
>>>> The same situation is valid when using a USB-C to HDMI adapter: disconnecting
>>>> or reconnecting a display should not lead to the removal of the CEC device.
>>>> Only when an adapter with different CEC capabilities is detected is there a
>>>> need to actually unregister the CEC device.
>>>>
>>>> All this is really a workaround of the fact that when the HPD disappears the
>>>> DP-to-HDMI adapter (either external or built-in) also disappears from the
>>>> topology, even though it is physically still there.
>>>
>>> The dongles I've seen do not disappear. The downstream hpd is
>>> signalled with short hpd pulses + SINK_COUNT instead.
>>>
>>> But I've not actually seen a dongle that implements the
>>> BRANCH_DEVICE_CTRL DPCD register, so not quite sure what those would
>>> actually do. The spec does say they should default to using long
>>> hpd for downstream hpd handling.
>>
>> I did a few more experiments and it appears that someone somewhere keeps
>> track of DP branch devices. I.e. after disconnecting my usb-c to hdmi adapter
>> it still appears in i915_display_info. At least until something else is
>> connected. I basically need to hook into the DP branch detection.
>>
>> Something to look at this weekend.
> 
> I found a better place to do the CEC (un)registration: a long HPD pulse
> indicates that the DPCD registers have changed, so that's when I should
> detect whether there is a new branch device with CEC capabilities.

Just FYI: unfortunately this is delayed due to a lot of other work.
I will get back to this as soon as have some time.

Regards,

	Hans
