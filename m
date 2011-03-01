Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:56407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539Ab1CAQT3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 11:19:29 -0500
Message-ID: <4D6D1C89.4000900@redhat.com>
Date: Tue, 01 Mar 2011 13:19:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: "Martin Bugge (marbugge)" <marbugge@cisco.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC] HDMI-CEC proposal
References: <4D6CC36B.50009@cisco.com> <201103011538.51844.hansverk@cisco.com> <4D6D0EB9.60903@redhat.com> <201103011649.58110.hansverk@cisco.com>
In-Reply-To: <201103011649.58110.hansverk@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-03-2011 12:49, Hans Verkuil escreveu:
> On Tuesday, March 01, 2011 16:20:25 Mauro Carvalho Chehab wrote:
>> Em 01-03-2011 11:38, Hans Verkuil escreveu:
>>> Hi Mauro,
>>>
>>> On Tuesday, March 01, 2011 13:28:35 Mauro Carvalho Chehab wrote:
>>>> Hi Martin,
>>>>
>>>> Em 01-03-2011 06:59, Martin Bugge (marbugge) escreveu:
>>>>> Author: Martin Bugge <marbugge@cisco.com>
>>>>> Date:  Tue, 1 March 2010
>>>>> ======================
>>>>>
>>>>> This is a proposal for adding a Consumer Electronic Control (CEC) API to 
>>> V4L2.
>>>>> This document describes the changes and new ioctls needed.
>>>>>
>>>>> Version 1.0 (This is first version)
>>>>>
>>>>> Background
>>>>> ==========
>>>>> CEC is a protocol that provides high-level control functions between 
>>> various audiovisual products.
>>>>> It is an optional supplement to the High-Definition Multimedia Interface 
>>> Specification (HDMI).
>>>>> Physical layer is a one-wire bidirectional serial bus that uses the 
>>> industry-standard AV.link protocol.
>>>>>
>>>>> In short: CEC uses pin 13 on the HDMI connector to transmit and receive 
>>> small data-packets
>>>>>           (maximum 16 bytes including a 1 byte header) at low data rates 
>>> (~400 bits/s).
>>>>>
>>>>> A CEC device may have any of 15 logical addresses (0 - 14).
>>>>> (address 15 is broadcast and some addresses are reserved)
>>>>>
>>>>>
>>>>> References
>>>>> ==========
>>>>> [1] High-Definition Multimedia Interface Specification version 1.3a,
>>>>>     Supplement 1 Consumer Electronic Control (CEC).
>>>>>     http://www.hdmi.org/manufacturer/specification.aspx
>>>>>
>>>>> [2] 
>>> http://www.hdmi.org/pdf/whitepaper/DesigningCECintoYourNextHDMIProduct.pdf
>>>>>
>>>>>
>>>>> Proposed solution
>>>>> =================
>>>>>
>>>>> Two new ioctls:
>>>>>     VIDIOC_CEC_CAP (read)
>>>>>     VIDIOC_CEC_CMD (read/write)
>>>>
>>>> How this proposal will interact with RC core? The way I see it, HDMI-CEC 
> is 
>>> just a way to get/send
>>>> Remote Controller data, and should be interacting with the proper Kernel 
>>> subsystems, e. g.,
>>>> with Remote Controller and input/event subsystems.
>>>
>>> I knew you were going to mention this :-)
>>>
>>> Actually, while CEC does support IR commands, this is only a very small 
> part 
>>> of the standard. Routing IR commands to the IR core is possible to do, 
>>> although it is not in this initial version. Should this be needed, then a 
> flag 
>>> can be created that tells V4L to route IR commands to the IR core.
>>>
>>> This should be optional, though, because if you are a repeater you do not 
> want 
>>> to pass such IR commands to the IR core, instead you want to retransmit 
> them 
>>> to a CEC output.
>>>
>>>>
>>>> I don't think we need two ioctls for that, as RC capabilities are already 
>>> exported via
>>>> sysfs, and we have two interfaces already for receiving events 
> (input/event 
>>> and lirc).
>>>> For sending, lirc interface might be used, but it is currently focused 
> only 
>>> on sending
>>>> raw pulse/space sequences. So, we'll need to add some capability there 
> for 
>>> IR/CEC TX.
>>>> I had a few discussions about that with Jarod, but we didn't write yet an 
>>> interface for it.
>>>
>>> Again, CEC != IR. All you need is a simple API to be able to send and 
> receive 
>>> CEC packets and a libcec that you can use to do the topology discovery and 
>>> send/receive the commands. You don't want nor need that in the kernel.
>>>
>>> The only place where routing things to the IR core is useful is when 
> someone 
>>> points a remote at a TV (for example), which then passes it over CEC to 
> your 
>>> device which is not a repeater but can actually handle the remote command.
>>>
>>> This is a future extension, though.
>>
>> There are two separate things when dealing with CEC: the low-level kernel
>> implementation of a bus for connecting with CEC devices, and userspace APIs
>> for using its features.
>>
>> If you were needing it only internally inside the kernel, there's no need 
> for 
>> new ioctl's. So, your proposal seems to add a raw interface for it, and do 
>> all the work in userspace.
>>
>> An alternative approach, that it is the way most Kernel API's do is to 
> write/use
>> higher userspace APIs, abstracting the hardware internals. V4L, DVB and RC, 
> input/event,
>> vfs, tty, etc are good examples of how we do APIs in Linux. We should only 
> go 
>> to a raw API if the high-level ones won't work. 
> 
> What high-level API? There isn't much high-level about CEC. It's a very 
> simplistic standard. Each packet has a source and destination address (0-14 
> which you can choose yourself), an optional command with an optional payload. 
> You can put in pretty much what you want since you can make custom commands as 
> well.

I2C is even simpler in theory (1 TX wire, 1 RX wire, low speed, 7 bits for address), 
but a hole subsystem and several API's are needed in order to handle with I2C 
device complexity.
 
> You also assume that you can handle packets at a high level. But you can't, 
> because what you want to do with packets depends very much on what device you 
> are: TV, recorder, set-top, CEC switch, etc.

Again, it sounds similar to I2C.

>> Also, a raw-level implementation of CEC may/will interfere on higher level
>> interfaces. For example, assuming that we have both raw and RC interfaces 
> using 
>> HDMI-CIC, a raw access on one process during a RC reception or transmit 
> could 
>> interfere on another process using the high-level interface for RC (as a raw
>> access to a block device may actually corrupt data). So, raw interfaces are
>> evil, and generally require CAP_SYS_ADMIN.
> 
> ??? If we add a flag that causes the IR commands to go to the IR core, then 
> they will obviously not appear on the normal CEC interface.
> 
>> So, I think we should first discuss what are the needs, and then discuss how
>> to implement them.
> 
> Well, the need is to receive and transmit CEC packets. And this is a possible 
> implementation.
> 
> Don't give CEC too much status: CEC is a very simplistic, stupid and very low 
> bandwidth protocol. It is even simpler than RDS.

We should look what usage you have in mind for CEC, and then write an API for it,
not the opposite.

Usage of CEC for remote-controlling devices is one application whose usage is clear
to me, and that we have already Kernel APIs for them. As usual, the current API's may 
need additions in order to support some features.

What are the other use-cases?

Cheers,
Mauro.
