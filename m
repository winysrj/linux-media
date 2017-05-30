Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:62200 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbdE3Ubl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 16:31:41 -0400
Subject: Re: [RFC PATCH 7/7] drm/i915: add DisplayPort CEC-Tunneling-over-AUX
 support
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
References: <20170525150626.29748-1-hverkuil@xs4all.nl>
 <20170525150626.29748-8-hverkuil@xs4all.nl>
 <20170526071550.3gsq3pc375cnk2gk@phenom.ffwll.local>
 <0a417a9c-4a41-796c-9876-51b61d429bb5@xs4all.nl>
 <20170529190004.ipdeyntsmzzb3iij@phenom.ffwll.local>
 <d9e9354b-eeb7-0a1e-2dbc-16c1ba0c0784@xs4all.nl> <87y3tekedi.fsf@intel.com>
 <f7d14e1c-9a6a-6d0f-bfe8-b4b619efd3bc@intel.com>
 <22961af9-5157-ae14-3000-f91cedc27958@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Clint Taylor <clinton.a.taylor@intel.com>
Message-ID: <8071df35-1bce-d537-693f-486478459f9c@intel.com>
Date: Tue, 30 May 2017 13:31:40 -0700
MIME-Version: 1.0
In-Reply-To: <22961af9-5157-ae14-3000-f91cedc27958@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/30/2017 09:49 AM, Hans Verkuil wrote:
> On 05/30/2017 04:19 PM, Clint Taylor wrote:
>>
>>
>> On 05/30/2017 12:11 AM, Jani Nikula wrote:
>>> On Tue, 30 May 2017, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On 05/29/2017 09:00 PM, Daniel Vetter wrote:
>>>>> On Fri, May 26, 2017 at 12:20:48PM +0200, Hans Verkuil wrote:
>>>>>> On 05/26/2017 09:15 AM, Daniel Vetter wrote:
>>>>>>> Did you look into also wiring this up for dp mst chains?
>>>>>> Isn't this sufficient? I have no way of testing mst chains.
>>>>>>
>>>>>> I think I need some pointers from you, since I am a complete 
>>>>>> newbie when it
>>>>>> comes to mst.
>>>>> I don't really have more clue, but yeah if you don't have an mst 
>>>>> thing (a
>>>>> simple dp port multiplexer is what I use for testing here, then 
>>>>> plug in a
>>>>> converter dongle or cable into that) then probably better to not 
>>>>> wire up
>>>>> the code for it.
>>>> I think my NUC already uses mst internally. But I was planning on 
>>>> buying a
>>>> dp multiplexer to make sure there is nothing special I need to do 
>>>> for mst.
>>>>
>>>> The CEC Tunneling is all in the branch device, so if I understand 
>>>> things
>>>> correctly it is not affected by mst.
>>>>
>>>> BTW, I did a bit more testing on my NUC7i5BNK: for the HDMI output 
>>>> they
>>>> use a MegaChip MCDP2800 DP-to-HDMI converter which according to their
>>>> datasheet is supposed to implement CEC Tunneling, but if they do it 
>>>> is not
>>>> exposed as a capability. I'm not sure if it is a MegaChip firmware 
>>>> issue
>>>> or something else. The BIOS is able to do some CEC, but whether 
>>>> they hook
>>>> into the MegaChip or have the CEC pin connected to a GPIO or 
>>>> something and
>>>> have their own controller is something I do not know.
>>>>
>>>> If anyone can clarify what Intel did on the NUC, then that would be 
>>>> very
>>>> helpful.
>>> It's called LSPCON, see i915/intel_lspcon.c, basically to support HDMI
>>> 2.0. Currently we only use it in PCON mode, shows up as DP for us. It
>>> could be used in LS mode, showing up as HDMI 1.4, but we don't support
>>> that in i915.
>>>
>>> I don't know about the CEC on that.
>>
>> My NUC6i7KYK has the MCDP2850 LSPCON and it does support CEC over Aux.
>> The release notes for the NUC state that there is a BIOS configuration
>> option for enabling support. My doesn't have the option but the LSPCON
>> fully supports CEC.
>
> What is the output of:
>
> dd if=/dev/drm_dp_aux0 of=aux0 skip=12288 ibs=1 count=48
> od -t x1 aux0
>
> Assuming drm_dp_aux0 is the aux channel for the HDMI output on your NUC.
>
> If the first byte is != 0x00, then it advertises CEC over Aux.
>
> For me it says 0x00.
slightly different command, but it still dumps DPCD 0x3000 for 48 bytes.

sudo dd if=/dev/drm_dp_aux0 bs=1 skip=12288 count=48 | hexdump -C
00000000  07 00 00 00 00 00 00 00  00 00 00 00 00 00 00 80 
|................|
00000010  f8 23 c4 8f 06 d8 59 7b  37 bb 1e 14 9c cb cd 88 
|.#....Y{7.......|
00000020  4e 84 10 00 04 00 f7 f5  e2 fa a3 30 ad 42 ed 19 
|N..........0.B..|


>
> When you say "it does support CEC over Aux", does that mean you have 
> actually
> tested it somehow? The only working solution I have seen mentioned for 
> the
> NUC6i7KYK is a Pulse-Eight adapter.
>
> With the NUC7i Intel made BIOS support for CEC, but it is not at all
> clear to me if they used CEC tunneling or just hooked up the CEC pin to
> some microcontroller.
>
> The only working chipset I have seen is the Parade PS176.
I have a couple PS176 based devices that I purchased from Amazon that do 
not work even though they advertise support at DPCD 0x3000.

Club 3D USB-C->HDMI 2.0 UHD
Uptab    USB-C->HDMI 2.0

-Clint


>
> Regards,
>
>     Hans
>
>>
>> -Clint
>>
>>>
>>>
>>> BR,
>>> Jani.
>>>
>>>> It would be so nice to get MegaChip CEC Tunneling working on the 
>>>> NUC, because
>>>> then you have native CEC support without requiring any Pulse Eight 
>>>> adapter.
>>>>
>>>> And add a CEC-capable USB-C to HDMI adapter and you have it on the 
>>>> USB-C
>>>> output as well.
>>>>
>>>> Regards,
>>>>
>>>>     Hans
>>
>
