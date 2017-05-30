Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:36654 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750938AbdE3V34 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 17:29:56 -0400
Subject: Re: [RFC PATCH 7/7] drm/i915: add DisplayPort CEC-Tunneling-over-AUX
 support
To: Clint Taylor <clinton.a.taylor@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20170525150626.29748-1-hverkuil@xs4all.nl>
 <20170525150626.29748-8-hverkuil@xs4all.nl>
 <20170526071550.3gsq3pc375cnk2gk@phenom.ffwll.local>
 <0a417a9c-4a41-796c-9876-51b61d429bb5@xs4all.nl>
 <20170529190004.ipdeyntsmzzb3iij@phenom.ffwll.local>
 <d9e9354b-eeb7-0a1e-2dbc-16c1ba0c0784@xs4all.nl> <87y3tekedi.fsf@intel.com>
 <f7d14e1c-9a6a-6d0f-bfe8-b4b619efd3bc@intel.com>
 <22961af9-5157-ae14-3000-f91cedc27958@xs4all.nl>
 <8150d62a-ecbc-6235-5595-1764fe616d8b@xs4all.nl>
 <ca46b0db-1ee2-ec78-04cf-90e9d48b7109@intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5dcf7b38-b833-2136-f755-73016522b982@xs4all.nl>
Date: Tue, 30 May 2017 23:29:44 +0200
MIME-Version: 1.0
In-Reply-To: <ca46b0db-1ee2-ec78-04cf-90e9d48b7109@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2017 10:32 PM, Clint Taylor wrote:
> 
> 
> On 05/30/2017 09:54 AM, Hans Verkuil wrote:
>> On 05/30/2017 06:49 PM, Hans Verkuil wrote:
>>> On 05/30/2017 04:19 PM, Clint Taylor wrote:
>>>>
>>>>
>>>> On 05/30/2017 12:11 AM, Jani Nikula wrote:
>>>>> On Tue, 30 May 2017, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>>> On 05/29/2017 09:00 PM, Daniel Vetter wrote:
>>>>>>> On Fri, May 26, 2017 at 12:20:48PM +0200, Hans Verkuil wrote:
>>>>>>>> On 05/26/2017 09:15 AM, Daniel Vetter wrote:
>>>>>>>>> Did you look into also wiring this up for dp mst chains?
>>>>>>>> Isn't this sufficient? I have no way of testing mst chains.
>>>>>>>>
>>>>>>>> I think I need some pointers from you, since I am a complete
>>>>>>>> newbie when it
>>>>>>>> comes to mst.
>>>>>>> I don't really have more clue, but yeah if you don't have an mst
>>>>>>> thing (a
>>>>>>> simple dp port multiplexer is what I use for testing here, then
>>>>>>> plug in a
>>>>>>> converter dongle or cable into that) then probably better to not
>>>>>>> wire up
>>>>>>> the code for it.
>>>>>> I think my NUC already uses mst internally. But I was planning on
>>>>>> buying a
>>>>>> dp multiplexer to make sure there is nothing special I need to do
>>>>>> for mst.
>>>>>>
>>>>>> The CEC Tunneling is all in the branch device, so if I understand
>>>>>> things
>>>>>> correctly it is not affected by mst.
>>>>>>
>>>>>> BTW, I did a bit more testing on my NUC7i5BNK: for the HDMI output
>>>>>> they
>>>>>> use a MegaChip MCDP2800 DP-to-HDMI converter which according to their
>>>>>> datasheet is supposed to implement CEC Tunneling, but if they do
>>>>>> it is not
>>>>>> exposed as a capability. I'm not sure if it is a MegaChip firmware
>>>>>> issue
>>>>>> or something else. The BIOS is able to do some CEC, but whether
>>>>>> they hook
>>>>>> into the MegaChip or have the CEC pin connected to a GPIO or
>>>>>> something and
>>>>>> have their own controller is something I do not know.
>>>>>>
>>>>>> If anyone can clarify what Intel did on the NUC, then that would
>>>>>> be very
>>>>>> helpful.
>>>>> It's called LSPCON, see i915/intel_lspcon.c, basically to support HDMI
>>>>> 2.0. Currently we only use it in PCON mode, shows up as DP for us. It
>>>>> could be used in LS mode, showing up as HDMI 1.4, but we don't support
>>>>> that in i915.
>>>>>
>>>>> I don't know about the CEC on that.
>>>>
>>>> My NUC6i7KYK has the MCDP2850 LSPCON and it does support CEC over Aux.
>>>> The release notes for the NUC state that there is a BIOS configuration
>>>> option for enabling support. My doesn't have the option but the LSPCON
>>>> fully supports CEC.
>>>
>>> What is the output of:
>>>
>>> dd if=/dev/drm_dp_aux0 of=aux0 skip=12288 ibs=1 count=48
>>> od -t x1 aux0
>>>
>>> Assuming drm_dp_aux0 is the aux channel for the HDMI output on your NUC.
>>>
>>> If the first byte is != 0x00, then it advertises CEC over Aux.
>>>
>>> For me it says 0x00.
>>>
>>> When you say "it does support CEC over Aux", does that mean you have
>>> actually
>>> tested it somehow? The only working solution I have seen mentioned
>>> for the
>>> NUC6i7KYK is a Pulse-Eight adapter.
>>>
>>> With the NUC7i Intel made BIOS support for CEC, but it is not at all
>>> clear to me if they used CEC tunneling or just hooked up the CEC pin to
>>> some microcontroller.
>>>
>>> The only working chipset I have seen is the Parade PS176.
>>
>> If it really is working on your NUC, then can you add the output of
>> /sys/kernel/debug/dri/0/i915_display_info?
> 
> [root@localhost cec-ctl]# cat /sys/kernel/debug/dri/0/i915_display_info


> Connector info
> --------------
> connector 48: type DP-1, status: connected
>       name:
>       physical dimensions: 700x400mm
>       subpixel order: Unknown
>       CEA rev: 3
>       DPCD rev: 12
>       audio support: yes
>       DP branch device present: yes
>           Type: HDMI
>           ID: 175IB0
>           HW: 1.0
>           SW: 7.32
>           Max TMDS clock: 600000 kHz
>           Max bpc: 12

Huh. Based on this document:

https://downloadmirror.intel.com/26061/eng/NUC6i7KYK%20HDMI%202.0%20Firmware%20update%20Instructions.pdf

this is the internal DP-to-HDMI adapter and it has the PS175. So it is a
Parade chipset, and I have seen that work before (at least the PS176).

<snip>

> connector 55: type DP-2, status: connected
>       name:
>       physical dimensions: 620x340mm
>       subpixel order: Unknown
>       CEA rev: 3
>       DPCD rev: 12
>       audio support: yes
>       DP branch device present: yes
>           Type: HDMI
>           ID: BCTRC0
>           HW: 2.0
>           SW: 0.26

And is this from a USB-C to HDMI adapter? Which one? I don't recognize the ID.

For the record, this is the internal HDMI output of my NUC7i5BNK:

connector 48: type DP-1, status: connected
         name:
         physical dimensions: 1050x590mm
         subpixel order: Unknown
         CEA rev: 3
         DPCD rev: 12
         audio support: yes
         DP branch device present: yes
                 Type: HDMI
                 ID: MC2800
                 HW: 2.2
                 SW: 1.66
                 Max TMDS clock: 600000 kHz
                 Max bpc: 16

Clearly a Megachip.

Regards,

	Hans
