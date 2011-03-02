Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47344 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1CBPuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 10:50:04 -0500
Received: by fxm17 with SMTP id 17so110035fxm.19
        for <linux-media@vger.kernel.org>; Wed, 02 Mar 2011 07:50:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201103021013.23827.hansverk@cisco.com>
References: <4D6CC36B.50009@cisco.com>
	<AANLkTikS6AkBprfiDrW+M83YpUBjm_o3cfNJhcpzCM9N@mail.gmail.com>
	<201103021013.23827.hansverk@cisco.com>
Date: Wed, 2 Mar 2011 10:49:45 -0500
Message-ID: <AANLkTimXO9NPeHM+htHbuuUHrXVEwuravWBuVnEura5u@mail.gmail.com>
Subject: Re: [RFC] HDMI-CEC proposal
From: Alex Deucher <alexdeucher@gmail.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: "Martin Bugge (marbugge)" <marbugge@cisco.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Mar 2, 2011 at 4:13 AM, Hans Verkuil <hansverk@cisco.com> wrote:
> Hi Alex,
>
> On Tuesday, March 01, 2011 18:52:28 Alex Deucher wrote:
>> On Tue, Mar 1, 2011 at 4:59 AM, Martin Bugge (marbugge)
>> <marbugge@cisco.com> wrote:
>> > Author: Martin Bugge <marbugge@cisco.com>
>> > Date:  Tue, 1 March 2010
>> > ======================
>> >
>> > This is a proposal for adding a Consumer Electronic Control (CEC) API to
>> > V4L2.
>> > This document describes the changes and new ioctls needed.
>> >
>> > Version 1.0 (This is first version)
>> >
>> > Background
>> > ==========
>> > CEC is a protocol that provides high-level control functions between
> various
>> > audiovisual products.
>> > It is an optional supplement to the High-Definition Multimedia Interface
>> > Specification (HDMI).
>> > Physical layer is a one-wire bidirectional serial bus that uses the
>> > industry-standard AV.link protocol.
>> >
>> > In short: CEC uses pin 13 on the HDMI connector to transmit and receive
>> > small data-packets
>> >          (maximum 16 bytes including a 1 byte header) at low data rates
>> > (~400 bits/s).
>> >
>> > A CEC device may have any of 15 logical addresses (0 - 14).
>> > (address 15 is broadcast and some addresses are reserved)
>> >
>>
>> It would be nice if this was not tied to v4l as we'll start seeing CEC
>> support show in GPUs soon as well.
>
> As mentioned in other emails it is my firm believe that mixing APIs is a bad
> idea. I've never seen that work in practice. That said, I do think that any
> userspace CEC library shouldn't be tied to V4L allowing it to be used by GPUs.
>

Right.  That was my concern.  You are probably more of an expert on
CEC so I'll leave the API to you, but as it's going to show up in
GPUs, I'd rather not re-invent the wheel to support it on the GPU side
in some incompatible manner if it can be avoided.

> It would also be interesting to see if i2c HDMI receiver/transmitter drivers
> can be used by both subsystems. This would make a lot of sense.

There are already several i2c tmds drivers in the drm tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree;f=drivers/gpu/drm/i2c;h=9eb6dad3ffa6cac6dfc07afb0b8526049416398b;hb=HEAD
And a few in the intel kms driver that could be broken out as
independent drivers.  See the dvo_*.c files in:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree;f=drivers/gpu/drm/i915;h=19e4b8fe8f5413f0c5d5059d8b2561eafab9e5dd;hb=HEAD
Still they are tied to the drm as they are used as kms encoders.


>
> Apologies if I asked this before, but are you planning to attend the ELC in
> San Francisco? If so, then we should sit together and compare the subsystems
> and see if we can work something out.

Probably not, but I'll know more soon.

Alex

>
> Regards,
>
>        Hans
>
>>
>> Alex
>>
>> >
>> > References
>> > ==========
>> > [1] High-Definition Multimedia Interface Specification version 1.3a,
>> >    Supplement 1 Consumer Electronic Control (CEC).
>> >    http://www.hdmi.org/manufacturer/specification.aspx
>> >
>> > [2]
>> > http://www.hdmi.org/pdf/whitepaper/DesigningCECintoYourNextHDMIProduct.pdf
>> >
>> >
>> > Proposed solution
>> > =================
>> >
>> > Two new ioctls:
>> >    VIDIOC_CEC_CAP (read)
>> >    VIDIOC_CEC_CMD (read/write)
>> >
>> > VIDIOC_CEC_CAP:
>> > ---------------
>> >
>> > struct vl2_cec_cap {
>> >       __u32 logicaldevices;
>> >       __u32 reserved[7];
>> > };
>> >
>> > The capability ioctl will return the number of logical devices/addresses
>> > which can be
>> > simultaneously supported on this HW.
>> >    0:       This HW don't support CEC.
>> >    1 -> 14: This HW supports n logical devices simultaneously.
>> >
>> > VIDIOC_CEC_CMD:
>> > ---------------
>> >
>> > struct v4l2_cec_cmd {
>> >    __u32 cmd;
>> >    __u32 reserved[7];
>> >    union {
>> >        struct {
>> >            __u32 index;
>> >            __u32 enable;
>> >            __u32 addr;
>> >        } conf;
>> >        struct {
>> >            __u32 len;
>> >            __u8  msg[16];
>> >            __u32 status;
>> >        } data;
>> >        __u32 raw[8];
>> >    };
>> > };
>> >
>> > Alternatively the data struct could be:
>> >        struct {
>> >            __u8  initiator;
>> >            __u8  destination;
>> >            __u8  len;
>> >            __u8  msg[15];
>> >            __u32 status;
>> >        } data;
>> >
>> > Commands:
>> >
>> > #define V4L2_CEC_CMD_CONF  (1)
>> > #define V4L2_CEC_CMD_TX    (2)
>> > #define V4L2_CEC_CMD_RX    (3)
>> >
>> > Tx status field:
>> >
>> > #define V4L2_CEC_STAT_TX_OK            (0)
>> > #define V4L2_CEC_STAT_TX_ARB_LOST      (1)
>> > #define V4L2_CEC_STAT_TX_RETRY_TIMEOUT (2)
>> >
>> > The command ioctl is used both for configuration and to receive/transmit
>> > data.
>> >
>> > * The configuration command must be done for each logical device address
>> >  which is to be enabled on this HW. Maximum number of logical devices
>> >  is found with the capability ioctl.
>> >    conf:
>> >         index:  0 -> number_of_logical_devices-1
>> >         enable: true/false
>> >         addr:   logical address
>> >
>> >  By default all logical devices are disabled.
>> >
>> > * Tx/Rx command
>> >    data:
>> >         len:    length of message (data + header)
>> >         msg:    the raw CEC message received/transmitted
>> >         status: when the driver is in blocking mode it gives the result
> for
>> > transmit.
>> >
>> > Events
>> > ------
>> >
>> > In the case of non-blocking mode the driver will issue the following
> events:
>> >
>> > V4L2_EVENT_CEC_TX
>> > V4L2_EVENT_CEC_RX
>> >
>> > V4L2_EVENT_CEC_TX
>> > -----------------
>> >  * transmit is complete with the following status:
>> > Add an additional struct to the struct v4l2_event
>> >
>> > struct v4l2_event_cec_tx {
>> >       __u32 status;
>> > }
>> >
>> > V4L2_EVENT_CEC_RX
>> > -----------------
>> >  * received a complete message
>> >
>> >
>> > Comments ?
>> >
>> >           Martin Bugge
>> >
>> > --
>> > Martin Bugge - Tandberg (now a part of Cisco)
>> > --
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>>
>
