Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:4687 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750951AbdE3Ucj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 16:32:39 -0400
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
 <8150d62a-ecbc-6235-5595-1764fe616d8b@xs4all.nl>
Cc: intel-gfx@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
From: Clint Taylor <clinton.a.taylor@intel.com>
Message-ID: <ca46b0db-1ee2-ec78-04cf-90e9d48b7109@intel.com>
Date: Tue, 30 May 2017 13:32:33 -0700
MIME-Version: 1.0
In-Reply-To: <8150d62a-ecbc-6235-5595-1764fe616d8b@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/30/2017 09:54 AM, Hans Verkuil wrote:
> On 05/30/2017 06:49 PM, Hans Verkuil wrote:
>> On 05/30/2017 04:19 PM, Clint Taylor wrote:
>>>
>>>
>>> On 05/30/2017 12:11 AM, Jani Nikula wrote:
>>>> On Tue, 30 May 2017, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>> On 05/29/2017 09:00 PM, Daniel Vetter wrote:
>>>>>> On Fri, May 26, 2017 at 12:20:48PM +0200, Hans Verkuil wrote:
>>>>>>> On 05/26/2017 09:15 AM, Daniel Vetter wrote:
>>>>>>>> Did you look into also wiring this up for dp mst chains?
>>>>>>> Isn't this sufficient? I have no way of testing mst chains.
>>>>>>>
>>>>>>> I think I need some pointers from you, since I am a complete 
>>>>>>> newbie when it
>>>>>>> comes to mst.
>>>>>> I don't really have more clue, but yeah if you don't have an mst 
>>>>>> thing (a
>>>>>> simple dp port multiplexer is what I use for testing here, then 
>>>>>> plug in a
>>>>>> converter dongle or cable into that) then probably better to not 
>>>>>> wire up
>>>>>> the code for it.
>>>>> I think my NUC already uses mst internally. But I was planning on 
>>>>> buying a
>>>>> dp multiplexer to make sure there is nothing special I need to do 
>>>>> for mst.
>>>>>
>>>>> The CEC Tunneling is all in the branch device, so if I understand 
>>>>> things
>>>>> correctly it is not affected by mst.
>>>>>
>>>>> BTW, I did a bit more testing on my NUC7i5BNK: for the HDMI output 
>>>>> they
>>>>> use a MegaChip MCDP2800 DP-to-HDMI converter which according to their
>>>>> datasheet is supposed to implement CEC Tunneling, but if they do 
>>>>> it is not
>>>>> exposed as a capability. I'm not sure if it is a MegaChip firmware 
>>>>> issue
>>>>> or something else. The BIOS is able to do some CEC, but whether 
>>>>> they hook
>>>>> into the MegaChip or have the CEC pin connected to a GPIO or 
>>>>> something and
>>>>> have their own controller is something I do not know.
>>>>>
>>>>> If anyone can clarify what Intel did on the NUC, then that would 
>>>>> be very
>>>>> helpful.
>>>> It's called LSPCON, see i915/intel_lspcon.c, basically to support HDMI
>>>> 2.0. Currently we only use it in PCON mode, shows up as DP for us. It
>>>> could be used in LS mode, showing up as HDMI 1.4, but we don't support
>>>> that in i915.
>>>>
>>>> I don't know about the CEC on that.
>>>
>>> My NUC6i7KYK has the MCDP2850 LSPCON and it does support CEC over Aux.
>>> The release notes for the NUC state that there is a BIOS configuration
>>> option for enabling support. My doesn't have the option but the LSPCON
>>> fully supports CEC.
>>
>> What is the output of:
>>
>> dd if=/dev/drm_dp_aux0 of=aux0 skip=12288 ibs=1 count=48
>> od -t x1 aux0
>>
>> Assuming drm_dp_aux0 is the aux channel for the HDMI output on your NUC.
>>
>> If the first byte is != 0x00, then it advertises CEC over Aux.
>>
>> For me it says 0x00.
>>
>> When you say "it does support CEC over Aux", does that mean you have 
>> actually
>> tested it somehow? The only working solution I have seen mentioned 
>> for the
>> NUC6i7KYK is a Pulse-Eight adapter.
>>
>> With the NUC7i Intel made BIOS support for CEC, but it is not at all
>> clear to me if they used CEC tunneling or just hooked up the CEC pin to
>> some microcontroller.
>>
>> The only working chipset I have seen is the Parade PS176.
>
> If it really is working on your NUC, then can you add the output of
> /sys/kernel/debug/dri/0/i915_display_info?

[root@localhost cec-ctl]# cat /sys/kernel/debug/dri/0/i915_display_info
CRTC info
---------
CRTC 32: pipe: A, active=yes, (size=1920x1080), dither=no, bpp=24
     fb: 115, pos: 0x0, size: 3840x2160
     encoder 47: type: DDI B, connectors:
         connector 48: type: DP-1, status: connected, mode:
         id 0:"1920x1080" freq 60 clock 148500 hdisp 1920 hss 2008 hse 
2052 htot 2200 vdisp 1080 vss 1084 vse 1089 vtot 1125 type 0x48 flags 0x5
     cursor visible? no, position (0, 0), size 0x0, addr 0x00000000
     num_scalers=2, scaler_users=0 scaler_id=-1, scalers[0]: use=no, 
mode=0, scalers[1]: use=no, mode=0
     --Plane id 26: type=PRI, crtc_pos=   0x   0, crtc_size=1920x1080, 
src_pos=0.0000x0.0000, src_size=1920.0000x1080.0000, format=XR24 
little-endian (0x34325258), rotation=0 (0x00000001)
     --Plane id 28: type=OVL, crtc_pos=   0x   0, crtc_size=   0x 0, 
src_pos=0.0000x0.0000, src_size=0.0000x0.0000, format=N/A, rotation=0 
(0x00000001)
     --Plane id 30: type=CUR, crtc_pos=   0x   0, crtc_size=   0x 0, 
src_pos=0.0000x0.0000, src_size=0.0000x0.0000, format=N/A, rotation=0 
(0x00000001)
     underrun reporting: cpu=yes pch=yes
CRTC 39: pipe: B, active=yes, (size=3840x2160), dither=no, bpp=36
     fb: 115, pos: 0x0, size: 3840x2160
     encoder 54: type: DDI C, connectors:
         connector 55: type: DP-2, status: connected, mode:
         id 0:"3840x2160" freq 30 clock 296703 hdisp 3840 hss 4016 hse 
4104 htot 4400 vdisp 2160 vss 2168 vse 2178 vtot 2250 type 0x48 flags 0x5
     cursor visible? no, position (0, 0), size 0x0, addr 0x00000000
     num_scalers=2, scaler_users=0 scaler_id=-1, scalers[0]: use=no, 
mode=0, scalers[1]: use=no, mode=0
     --Plane id 33: type=PRI, crtc_pos=   0x   0, crtc_size=3840x2160, 
src_pos=0.0000x0.0000, src_size=3840.0000x2160.0000, format=XR24 
little-endian (0x34325258), rotation=0 (0x00000001)
     --Plane id 35: type=OVL, crtc_pos=   0x   0, crtc_size=   0x 0, 
src_pos=0.0000x0.0000, src_size=0.0000x0.0000, format=N/A, rotation=0 
(0x00000001)
     --Plane id 37: type=CUR, crtc_pos=   0x   0, crtc_size=   0x 0, 
src_pos=0.0000x0.0000, src_size=0.0000x0.0000, format=N/A, rotation=0 
(0x00000001)
     underrun reporting: cpu=yes pch=yes
CRTC 46: pipe: C, active=no, (size=0x0), dither=no, bpp=0
     underrun reporting: cpu=yes pch=yes

Connector info
--------------
connector 48: type DP-1, status: connected
     name:
     physical dimensions: 700x400mm
     subpixel order: Unknown
     CEA rev: 3
     DPCD rev: 12
     audio support: yes
     DP branch device present: yes
         Type: HDMI
         ID: 175IB0
         HW: 1.0
         SW: 7.32
         Max TMDS clock: 600000 kHz
         Max bpc: 12
     modes:
         id 70:"1920x1080" freq 60 clock 148500 hdisp 1920 hss 2008 hse 
2052 htot 2200 vdisp 1080 vss 1084 vse 1089 vtot 1125 type 0x48 flags 0x5
         id 92:"1920x1080" freq 60 clock 148352 hdisp 1920 hss 2008 hse 
2052 htot 2200 vdisp 1080 vss 1084 vse 1089 vtot 1125 type 0x40 flags 0x5
         id 71:"1920x1080i" freq 60 clock 74250 hdisp 1920 hss 2008 hse 
2052 htot 2200 vdisp 1080 vss 1084 vse 1094 vtot 1125 type 0x40 flags 0x15
         id 93:"1920x1080i" freq 60 clock 74176 hdisp 1920 hss 2008 hse 
2052 htot 2200 vdisp 1080 vss 1084 vse 1094 vtot 1125 type 0x40 flags 0x15
         id 91:"1920x1080" freq 50 clock 148500 hdisp 1920 hss 2448 hse 
2492 htot 2640 vdisp 1080 vss 1084 vse 1089 vtot 1125 type 0x40 flags 0x5
         id 77:"1920x1080i" freq 50 clock 74250 hdisp 1920 hss 2448 hse 
2492 htot 2640 vdisp 1080 vss 1084 vse 1094 vtot 1125 type 0x40 flags 0x15
         id 72:"1280x720" freq 60 clock 74250 hdisp 1280 hss 1390 hse 
1430 htot 1650 vdisp 720 vss 725 vse 730 vtot 750 type 0x40 flags 0x5
         id 94:"1280x720" freq 60 clock 74176 hdisp 1280 hss 1390 hse 
1430 htot 1650 vdisp 720 vss 725 vse 730 vtot 750 type 0x40 flags 0x5
         id 78:"1280x720" freq 50 clock 74250 hdisp 1280 hss 1720 hse 
1760 htot 1980 vdisp 720 vss 725 vse 730 vtot 750 type 0x40 flags 0x5
         id 75:"1440x480i" freq 60 clock 27000 hdisp 1440 hss 1478 hse 
1602 htot 1716 vdisp 480 vss 488 vse 494 vtot 525 type 0x40 flags 0x1a
         id 88:"720x576" freq 50 clock 27000 hdisp 720 hss 732 hse 796 
htot 864 vdisp 576 vss 581 vse 586 vtot 625 type 0x40 flags 0xa
         id 95:"720x480" freq 60 clock 27027 hdisp 720 hss 736 hse 798 
htot 858 vdisp 480 vss 489 vse 495 vtot 525 type 0x40 flags 0xa
         id 73:"720x480" freq 60 clock 27000 hdisp 720 hss 736 hse 798 
htot 858 vdisp 480 vss 489 vse 495 vtot 525 type 0x40 flags 0xa
         id 97:"640x480" freq 60 clock 25200 hdisp 640 hss 656 hse 752 
htot 800 vdisp 480 vss 490 vse 492 vtot 525 type 0x40 flags 0xa
         id 76:"640x480" freq 60 clock 25175 hdisp 640 hss 656 hse 752 
htot 800 vdisp 480 vss 490 vse 492 vtot 525 type 0x40 flags 0xa
connector 55: type DP-2, status: connected
     name:
     physical dimensions: 620x340mm
     subpixel order: Unknown
     CEA rev: 3
     DPCD rev: 12
     audio support: yes
     DP branch device present: yes
         Type: HDMI
         ID: BCTRC0
         HW: 2.0
         SW: 0.26
     modes:
         id 79:"3840x2160" freq 30 clock 296703 hdisp 3840 hss 4016 hse 
4104 htot 4400 vdisp 2160 vss 2168 vse 2178 vtot 2250 type 0x48 flags 0x5
         id 130:"3840x2160" freq 30 clock 297000 hdisp 3840 hss 4016 hse 
4104 htot 4400 vdisp 2160 vss 2168 vse 2178 vtot 2250 type 0x40 flags 0x5
         id 131:"3840x2160" freq 25 clock 297000 hdisp 3840 hss 4896 hse 
4984 htot 5280 vdisp 2160 vss 2168 vse 2178 vtot 2250 type 0x40 flags 0x5
         id 132:"3840x2160" freq 24 clock 297000 hdisp 3840 hss 5116 hse 
5204 htot 5500 vdisp 2160 vss 2168 vse 2178 vtot 2250 type 0x40 flags 0x5
         id 149:"3840x2160" freq 24 clock 296703 hdisp 3840 hss 5116 hse 
5204 htot 5500 vdisp 2160 vss 2168 vse 2178 vtot 2250 type 0x40 flags 0x5
         id 82:"1920x2160" freq 60 clock 297000 hdisp 1920 hss 2008 hse 
2052 htot 2200 vdisp 2160 vss 2168 vse 2178 vtot 2250 type 0x40 flags 0x5
         id 80:"2560x1440" freq 52 clock 241500 hdisp 2560 hss 2864 hse 
3152 htot 3153 vdisp 1440 vss 1443 vse 1448 vtot 1481 type 0x40 flags 0x9
         id 85:"2048x1152" freq 60 clock 162000 hdisp 2048 hss 2074 hse 
2154 htot 2250 vdisp 1152 vss 1153 vse 1156 vtot 1200 type 0x40 flags 0x5
         id 87:"1920x1200" freq 60 clock 154000 hdisp 1920 hss 1968 hse 
2000 htot 2080 vdisp 1200 vss 1203 vse 1209 vtot 1235 type 0x40 flags 0x9
         id 83:"1920x1080" freq 60 clock 148500 hdisp 1920 hss 2008 hse 
2052 htot 2200 vdisp 1080 vss 1084 vse 1089 vtot 1125 type 0x40 flags 0x5
         id 135:"1920x1080" freq 60 clock 148352 hdisp 1920 hss 2008 hse 
2052 htot 2200 vdisp 1080 vss 1084 vse 1089 vtot 1125 type 0x40 flags 0x5
         id 84:"1920x1080i" freq 60 clock 74250 hdisp 1920 hss 2008 hse 
2052 htot 2200 vdisp 1080 vss 1084 vse 1094 vtot 1125 type 0x40 flags 0x15
         id 136:"1920x1080i" freq 60 clock 74176 hdisp 1920 hss 2008 hse 
2052 htot 2200 vdisp 1080 vss 1084 vse 1094 vtot 1125 type 0x40 flags 0x15
         id 121:"1920x1080" freq 50 clock 148500 hdisp 1920 hss 2448 hse 
2492 htot 2640 vdisp 1080 vss 1084 vse 1089 vtot 1125 type 0x40 flags 0x5
         id 122:"1920x1080i" freq 50 clock 74250 hdisp 1920 hss 2448 hse 
2492 htot 2640 vdisp 1080 vss 1084 vse 1094 vtot 1125 type 0x40 flags 0x15
         id 128:"1920x1080" freq 24 clock 74250 hdisp 1920 hss 2558 hse 
2602 htot 2750 vdisp 1080 vss 1084 vse 1089 vtot 1125 type 0x40 flags 0x5
         id 146:"1920x1080" freq 24 clock 74176 hdisp 1920 hss 2558 hse 
2602 htot 2750 vdisp 1080 vss 1084 vse 1089 vtot 1125 type 0x40 flags 0x5
         id 89:"1600x1200" freq 60 clock 162000 hdisp 1600 hss 1664 hse 
1856 htot 2160 vdisp 1200 vss 1201 vse 1204 vtot 1250 type 0x40 flags 0x5
         id 90:"1680x1050" freq 60 clock 119000 hdisp 1680 hss 1728 hse 
1760 htot 1840 vdisp 1050 vss 1053 vse 1059 vtot 1080 type 0x40 flags 0x9
         id 86:"1600x900" freq 60 clock 108000 hdisp 1600 hss 1624 hse 
1704 htot 1800 vdisp 900 vss 901 vse 904 vtot 1000 type 0x40 flags 0x5
         id 106:"1280x1024" freq 75 clock 135000 hdisp 1280 hss 1296 hse 
1440 htot 1688 vdisp 1024 vss 1025 vse 1028 vtot 1066 type 0x40 flags 0x5
         id 96:"1280x1024" freq 60 clock 108000 hdisp 1280 hss 1328 hse 
1440 htot 1688 vdisp 1024 vss 1025 vse 1028 vtot 1066 type 0x40 flags 0x5
         id 113:"1152x864" freq 75 clock 108000 hdisp 1152 hss 1216 hse 
1344 htot 1600 vdisp 864 vss 865 vse 868 vtot 900 type 0x40 flags 0x5
         id 98:"1280x720" freq 60 clock 74250 hdisp 1280 hss 1390 hse 
1430 htot 1650 vdisp 720 vss 725 vse 730 vtot 750 type 0x40 flags 0x5
         id 137:"1280x720" freq 60 clock 74176 hdisp 1280 hss 1390 hse 
1430 htot 1650 vdisp 720 vss 725 vse 730 vtot 750 type 0x40 flags 0x5
         id 123:"1280x720" freq 50 clock 74250 hdisp 1280 hss 1720 hse 
1760 htot 1980 vdisp 720 vss 725 vse 730 vtot 750 type 0x40 flags 0x5
         id 107:"1024x768" freq 75 clock 78750 hdisp 1024 hss 1040 hse 
1136 htot 1312 vdisp 768 vss 769 vse 772 vtot 800 type 0x40 flags 0x5
         id 108:"1024x768" freq 70 clock 75000 hdisp 1024 hss 1048 hse 
1184 htot 1328 vdisp 768 vss 771 vse 777 vtot 806 type 0x40 flags 0xa
         id 109:"1024x768" freq 60 clock 65000 hdisp 1024 hss 1048 hse 
1184 htot 1344 vdisp 768 vss 771 vse 777 vtot 806 type 0x40 flags 0xa
         id 110:"832x624" freq 75 clock 57284 hdisp 832 hss 864 hse 928 
htot 1152 vdisp 624 vss 625 vse 628 vtot 667 type 0x40 flags 0xa
         id 111:"800x600" freq 75 clock 49500 hdisp 800 hss 816 hse 896 
htot 1056 vdisp 600 vss 601 vse 604 vtot 625 type 0x40 flags 0x5
         id 112:"800x600" freq 72 clock 50000 hdisp 800 hss 856 hse 976 
htot 1040 vdisp 600 vss 637 vse 643 vtot 666 type 0x40 flags 0x5
         id 99:"800x600" freq 60 clock 40000 hdisp 800 hss 840 hse 968 
htot 1056 vdisp 600 vss 601 vse 605 vtot 628 type 0x40 flags 0x5
         id 100:"800x600" freq 56 clock 36000 hdisp 800 hss 824 hse 896 
htot 1024 vdisp 600 vss 601 vse 603 vtot 625 type 0x40 flags 0x5
         id 124:"720x576" freq 50 clock 27000 hdisp 720 hss 732 hse 796 
htot 864 vdisp 576 vss 581 vse 586 vtot 625 type 0x40 flags 0xa
         id 142:"720x480" freq 60 clock 27027 hdisp 720 hss 736 hse 798 
htot 858 vdisp 480 vss 489 vse 495 vtot 525 type 0x40 flags 0xa
         id 117:"720x480" freq 60 clock 27000 hdisp 720 hss 736 hse 798 
htot 858 vdisp 480 vss 489 vse 495 vtot 525 type 0x40 flags 0xa
         id 101:"640x480" freq 75 clock 31500 hdisp 640 hss 656 hse 720 
htot 840 vdisp 480 vss 481 vse 484 vtot 500 type 0x40 flags 0xa
         id 102:"640x480" freq 73 clock 31500 hdisp 640 hss 664 hse 704 
htot 832 vdisp 480 vss 489 vse 492 vtot 520 type 0x40 flags 0xa
         id 103:"640x480" freq 67 clock 30240 hdisp 640 hss 704 hse 768 
htot 864 vdisp 480 vss 483 vse 486 vtot 525 type 0x40 flags 0xa
         id 138:"640x480" freq 60 clock 25200 hdisp 640 hss 656 hse 752 
htot 800 vdisp 480 vss 490 vse 492 vtot 525 type 0x40 flags 0xa
         id 104:"640x480" freq 60 clock 25175 hdisp 640 hss 656 hse 752 
htot 800 vdisp 480 vss 490 vse 492 vtot 525 type 0x40 flags 0xa
         id 105:"720x400" freq 70 clock 28320 hdisp 720 hss 738 hse 846 
htot 900 vdisp 400 vss 412 vse 414 vtot 449 type 0x40 flags 0x6
connector 59: type HDMI-A-1, status: disconnected
     modes:
connector 62: type DP-3, status: disconnected
     DPCD rev: 0
     audio support: no
     DP branch device present: no
     modes:
connector 66: type HDMI-A-2, status: disconnected
     audio support: no
     modes:

>
> Thanks,
>
>     Hans
