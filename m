Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4070 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab1CARKI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 12:10:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] HDMI-CEC proposal
Date: Tue, 1 Mar 2011 18:09:46 +0100
Cc: Hans Verkuil <hansverk@cisco.com>,
	"Martin Bugge (marbugge)" <marbugge@cisco.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Jarod Wilson <jarod@redhat.com>
References: <4D6CC36B.50009@cisco.com> <201103011649.58110.hansverk@cisco.com> <4D6D1C89.4000900@redhat.com>
In-Reply-To: <4D6D1C89.4000900@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011809.46677.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, March 01, 2011 17:19:21 Mauro Carvalho Chehab wrote:
> Em 01-03-2011 12:49, Hans Verkuil escreveu:
> > On Tuesday, March 01, 2011 16:20:25 Mauro Carvalho Chehab wrote:
> >> Em 01-03-2011 11:38, Hans Verkuil escreveu:

<snip>

> >>> Again, CEC != IR. All you need is a simple API to be able to send and 
> > receive 
> >>> CEC packets and a libcec that you can use to do the topology discovery and 
> >>> send/receive the commands. You don't want nor need that in the kernel.
> >>>
> >>> The only place where routing things to the IR core is useful is when 
> > someone 
> >>> points a remote at a TV (for example), which then passes it over CEC to 
> > your 
> >>> device which is not a repeater but can actually handle the remote command.
> >>>
> >>> This is a future extension, though.
> >>
> >> There are two separate things when dealing with CEC: the low-level kernel
> >> implementation of a bus for connecting with CEC devices, and userspace APIs
> >> for using its features.
> >>
> >> If you were needing it only internally inside the kernel, there's no need 
> > for 
> >> new ioctl's. So, your proposal seems to add a raw interface for it, and do 
> >> all the work in userspace.
> >>
> >> An alternative approach, that it is the way most Kernel API's do is to 
> > write/use
> >> higher userspace APIs, abstracting the hardware internals. V4L, DVB and RC, 
> > input/event,
> >> vfs, tty, etc are good examples of how we do APIs in Linux. We should only 
> > go 
> >> to a raw API if the high-level ones won't work. 
> > 
> > What high-level API? There isn't much high-level about CEC. It's a very 
> > simplistic standard. Each packet has a source and destination address (0-14 
> > which you can choose yourself), an optional command with an optional payload. 
> > You can put in pretty much what you want since you can make custom commands as 
> > well.
> 
> I2C is even simpler in theory (1 TX wire, 1 RX wire, low speed, 7 bits for address), 
> but a hole subsystem and several API's are needed in order to handle with I2C 
> device complexity.

Nope, CEC is simpler: just one line and 400 bits per second. I win :-)

More to the point: i2c is a generic protocol to communicate with hardware devices.
Emphasis on 'generic'. CEC is far from generic: it is full of assumptions and
specific use-cases. In that respect it closely resembles RDS: this too is a low
bandwidth, application-specific protocol. For RDS the API is also at the packet
level, requiring a library to make use of it.

>  
> > You also assume that you can handle packets at a high level. But you can't, 
> > because what you want to do with packets depends very much on what device you 
> > are: TV, recorder, set-top, CEC switch, etc.
> 
> Again, it sounds similar to I2C.

No. The difference is that I2C is a generic protocol. For CEC these roles are
hardwired in the protocol.

> 
> >> Also, a raw-level implementation of CEC may/will interfere on higher level
> >> interfaces. For example, assuming that we have both raw and RC interfaces 
> > using 
> >> HDMI-CIC, a raw access on one process during a RC reception or transmit 
> > could 
> >> interfere on another process using the high-level interface for RC (as a raw
> >> access to a block device may actually corrupt data). So, raw interfaces are
> >> evil, and generally require CAP_SYS_ADMIN.
> > 
> > ??? If we add a flag that causes the IR commands to go to the IR core, then 
> > they will obviously not appear on the normal CEC interface.
> > 
> >> So, I think we should first discuss what are the needs, and then discuss how
> >> to implement them.
> > 
> > Well, the need is to receive and transmit CEC packets. And this is a possible 
> > implementation.
> > 
> > Don't give CEC too much status: CEC is a very simplistic, stupid and very low 
> > bandwidth protocol. It is even simpler than RDS.
> 
> We should look what usage you have in mind for CEC, and then write an API for it,
> not the opposite.
> 
> Usage of CEC for remote-controlling devices is one application whose usage is clear
> to me, and that we have already Kernel APIs for them. As usual, the current API's may 
> need additions in order to support some features.
> 
> What are the other use-cases?

Please read the CEC standard. In particular look at the CEC 13 chapter, which is
basically a list of the common use-cases. This proposed API basically handles the
protocol up to section CEC 9. CEC 15 is also useful to look at.

All this is highly specific to consumer electronics (and very restrictive as well:
something like video conferencing equipment doesn't really fit well in this
protocol).

All this screams 'userspace CEC protocol library' to me, with just the hardware
part of the protocol in the kernel. For exactly the same reason why RDS parsing
is done in userspace.

The only exception I see is the "Remote Control Pass Through" (CEC 13.13). This
can optionally be routed via the IR core.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
