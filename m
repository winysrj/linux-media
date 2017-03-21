Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36781 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757076AbdCUXpc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 19:45:32 -0400
Received: by mail-pf0-f182.google.com with SMTP id o126so86083265pfb.3
        for <linux-media@vger.kernel.org>; Tue, 21 Mar 2017 16:45:30 -0700 (PDT)
Subject: Re: CEC button pass-through
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <22e92133-6a64-ffaf-a41f-5ae9b19f24e5@nelint.com>
 <53fd17db-af5d-335b-0337-e5aeffd12305@xs4all.nl>
 <7ad3b464-1813-5535-fffc-36589d72d86d@nelint.com>
 <67b5e8a1-8a79-27e2-8e5f-1c58a4adc0d8@nelint.com>
 <4cacc06e-8573-53fc-39a9-551b426fdcfb@xs4all.nl>
 <033583b4-4d3e-85b8-88dc-9be366612fe0@nelint.com>
 <0d5fc7c9-f609-2a9c-12a1-780d6101be9a@xs4all.nl>
Cc: linux-media@vger.kernel.org
From: Eric Nelson <eric@nelint.com>
Message-ID: <692e4fa4-097f-1a05-fe30-b98bd85c688a@nelint.com>
Date: Tue, 21 Mar 2017 16:45:28 -0700
MIME-Version: 1.0
In-Reply-To: <0d5fc7c9-f609-2a9c-12a1-780d6101be9a@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 03/21/2017 02:29 PM, Hans Verkuil wrote:
> On 03/21/2017 09:03 PM, Eric Nelson wrote:
>> On 03/21/2017 11:46 AM, Hans Verkuil wrote:
>>> On 03/21/2017 07:23 PM, Eric Nelson wrote:
>>>> On 03/21/2017 10:44 AM, Eric Nelson wrote:
>>>>> On 03/21/2017 10:05 AM, Hans Verkuil wrote:
>>>>>> On 03/21/2017 05:49 PM, Eric Nelson wrote:
>>>>

<snip>

>>>> I think this is the culprit:
>>>> cec-uinput: L8: << 10:8e:00
>>>>
>>>> The 1.3 spec says this about the 8E message:
>>>>
>>>> "If Menu State indicates activated, TV enters ‘Device Menu Active’
>>>> state and forwards those Remote control commands, shown in
>>>> Table 26, to the initiator. If deactivated, TV enters ‘Device Menu Inactive’
>>>> state and stops forwarding remote control commands".
>>>>
>>>> In section 13.12.2, it also says this:
>>>>
>>>> "The TV may initiate a device’s menu by sending a <Menu Request>
>>>> [“Activate”] command. It may subsequently remove the menu by sending
>>>> a <Menu Request> [“Deactivate”] message. The TV may also query a
>>>> devices menu status by sending a <Menu Request> [“Query”]. The
>>>> menu device shall always respond with a <Menu Status> command
>>>> when it receives a <Menu Request>."
>>>>
>>>
>>> That sounds plausible. When you tested with my CEC framework, did you also
>>> run the cec-follower utility? That emulates a CEC follower.
>>>
>>
>> Yes. I'm running it with no arguments.
>>
>>> Note: you really need to use the --cec-version-1.4 option when configuring
>>> the i.MX6 CEC adapter since support for <Menu Request> is only enabled with
>>> CEC version 1.4. It is no longer supported with 2.0.
>>>
>>
>> I'm not sure what I did in my previous attempt, but I'm now seeing
>> both the arrow and function key sets being received by cec-ctl and
>> cec-follower with --cec-version-1.4.
>>
>> Or not. Removing the --cec-version-1.4 parameter still shows these
>> events, but after a re-boot and re-selection of the proper source
>> on my TV shows that they're no longer coming up with or without
>> the parameter.
>>
>> Further testing showed that by running the older driver and libCEC
>> code, then re-booting into the new kernel (with cec-ctl) shows the
>> messages with or without the flag.
>>
>> In other words, the TV seems to retain some state from the
>> execution of the Pulse8/libCEC code.
>>
>> Is there a way to send a raw message to the television using cec-ctl?
>>
>> Never mind, I found it and after a bunch of messing around,
>> confirmed that I can get the menu keys to be passed from my
>> TV by sending the 0x8e command with a payload of 0x00 to
>> the television:
>>
>> ~/# cec-ctl --custom-command=cmd=0x8e,payload=0x00 --to=0
> 
> Or more elegantly:
> 
> cec-ctl --menu-status=menu-state=activated -t0
> 
> See also: cec-ctl --help-device-menu-control
> 

My first RTFM for this subsystem!

> But cec-follower should receive a menu-request message and reply with
> menu-status(activated).
> 
> If you run cec-ctl -M, do you see the menu-request message arriving and the
> proper reply?
> 

After a re-boot with the CEC input clear on my television, I don't see it
during the initial startup of cec-ctl:

~# cec-ctl --record --cec-version-1.4 -M
Driver Info:
Driver Name : dwhdmi-imx
Adapter Name : dw_hdmi
Capabilities : 0x00000016
Logical Addresses
Transmit
Remote Control Support
Driver version : 4.10.0
Available Logical Addresses: 4
Physical Address : 1.0.0.0
Logical Address Mask : 0x0002
CEC Version : 1.4
Vendor ID : 0x000c03 (HDMI)
OSD Name : 'Record'
Logical Addresses : 1 (Allow RC Passthrough)
Logical Address : 1 (Recording Device 1)
Primary Device Type : Record
Logical Address Type : Record

Monitor All mode is not supported, falling back to regular monitoring

Event: State Change: PA: 1.0.0.0, LA mask: 0x0002
Transmitted by Recording Device 1 to all (1 to 15):
CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
phys-addr: 1.0.0.0
prim-devtype: record (0x01)
Received from TV to Recording Device 1 (0 to 1):
CEC_MSG_GIVE_DEVICE_VENDOR_ID (0x8c)
Transmitted by Recording Device 1 to all (1 to 15):
CEC_MSG_DEVICE_VENDOR_ID (0x87):
vendor-id: 3075 (0x00000c03)
Received from TV to Recording Device 1 (0 to 1): CEC_MSG_GIVE_OSD_NAME
(0x46)
Transmitted by Recording Device 1 to TV (1 to 0): CEC_MSG_SET_OSD_NAME
(0x47):
name: Record
Received from TV to Recording Device 1 (0 to 1):
CEC_MSG_VENDOR_COMMAND_WITH_ID:
vendor-id: 240 (0x000000f0)
vendor-specific-data: 0x23
Transmitted by Recording Device 1 to TV (1 to 0): CEC_MSG_FEATURE_ABORT
(0x00):
abort-msg: 160 (0xa0)
reason: unrecognized-op (0x00)
Received from TV to Recording Device 1 (0 to 1): CEC_MSG_GET_CEC_VERSION
(0x9f)
Transmitted by Recording Device 1 to TV (1 to 0): CEC_MSG_CEC_VERSION
(0x9e):
cec-version: version-1-4 (0x05)

But when I switch to the CEC source, I do see a set of state queries,
including the MENU_REQUEST
message.

Received from TV to Recording Device 1 (0 to 1):
CEC_MSG_GIVE_DEVICE_POWER_STATUS (0x8f)
Transmitted by Recording Device 1 to TV (1 to 0):
CEC_MSG_REPORT_POWER_STATUS (0x90):
pwr-state: on (0x00)
Received from TV to Recording Device 1 (0 to 1):
CEC_MSG_GIVE_PHYSICAL_ADDR (0x83)
Transmitted by Recording Device 1 to all (1 to 15):
CEC_MSG_REPORT_PHYSICAL_ADDR (0x84):
phys-addr: 1.0.0.0
prim-devtype: record (0x01)
Received from TV to all (0 to 15): CEC_MSG_SET_STREAM_PATH (0x86):
phys-addr: 1.0.0.0
Transmitted by Recording Device 1 to all (1 to 15):
CEC_MSG_ACTIVE_SOURCE (0x82):
phys-addr: 1.0.0.0
Received from TV to Recording Device 1 (0 to 1): CEC_MSG_MENU_REQUEST
(0x8d):
menu-req: query (0x02)
Transmitted by Recording Device 1 to TV (1 to 0): CEC_MSG_MENU_STATUS
(0x8e):
menu-state: activated (0x00)
Received from TV to Recording Device 1 (0 to 1):
CEC_MSG_GIVE_DECK_STATUS (0x1a):
status-req: on (0x01)
Transmitted by Recording Device 1 to TV (1 to 0): CEC_MSG_FEATURE_ABORT
(0x00):
abort-msg: 26 (0x1a)
reason: unrecognized-op (0x00)

As shown, the menu state returned is activated and I am seeing

I suspect that this failed earlier because I already had the source set
to this input (logical address?) and the television didn't update things.

> Again, you must configure the cec adapter with:
> 
> cec-ctl --record --cec-version-1.4
> 

Right. The same sequence as above but without the --cec-version-1.4 flag
generates a FEATURE_ABORT message:

Received from TV to Recording Device 1 (0 to 1): CEC_MSG_MENU_REQUEST
(0x8d):
menu-req: query (0x02)
Transmitted by Recording Device 1 to TV (1 to 0): CEC_MSG_FEATURE_ABORT
(0x00):
abort-msg: 141 (0x8d)
reason: unrecognized-op (0x00)

And it doesn't allow the arrow or function keys through.

Re-running cec-ctl with the 1.4 flag and forcing a routing switch does
cause a repeat of the MENU_REQUEST query, but it's still rejected unless
I also restart cec-follower:

Received from TV to Recording Device 1 (0 to 1): CEC_MSG_MENU_REQUEST
(0x8d):
menu-req: query (0x02)
Transmitted by Recording Device 1 to TV (1 to 0): CEC_MSG_FEATURE_ABORT
(0x00):
abort-msg: 141 (0x8d)
reason: unrecognized-op (0x00)

> otherwise it won't work (I'm not sure that's correct since the TV isn't
> CEC 2.0, I'll have to read up on that).
> 

Thanks again for your help.

Regards,


Eric
