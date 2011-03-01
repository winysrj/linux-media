Return-path: <mchehab@pedra>
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:34026 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab1CAOgm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 09:36:42 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] HDMI-CEC proposal
Date: Tue, 1 Mar 2011 15:38:51 +0100
Cc: "Martin Bugge (marbugge)" <marbugge@cisco.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Jarod Wilson <jarod@redhat.com>
References: <4D6CC36B.50009@cisco.com> <4D6CE673.2050608@redhat.com>
In-Reply-To: <4D6CE673.2050608@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011538.51844.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Tuesday, March 01, 2011 13:28:35 Mauro Carvalho Chehab wrote:
> Hi Martin,
> 
> Em 01-03-2011 06:59, Martin Bugge (marbugge) escreveu:
> > Author: Martin Bugge <marbugge@cisco.com>
> > Date:  Tue, 1 March 2010
> > ======================
> > 
> > This is a proposal for adding a Consumer Electronic Control (CEC) API to 
V4L2.
> > This document describes the changes and new ioctls needed.
> > 
> > Version 1.0 (This is first version)
> > 
> > Background
> > ==========
> > CEC is a protocol that provides high-level control functions between 
various audiovisual products.
> > It is an optional supplement to the High-Definition Multimedia Interface 
Specification (HDMI).
> > Physical layer is a one-wire bidirectional serial bus that uses the 
industry-standard AV.link protocol.
> > 
> > In short: CEC uses pin 13 on the HDMI connector to transmit and receive 
small data-packets
> >           (maximum 16 bytes including a 1 byte header) at low data rates 
(~400 bits/s).
> > 
> > A CEC device may have any of 15 logical addresses (0 - 14).
> > (address 15 is broadcast and some addresses are reserved)
> > 
> > 
> > References
> > ==========
> > [1] High-Definition Multimedia Interface Specification version 1.3a,
> >     Supplement 1 Consumer Electronic Control (CEC).
> >     http://www.hdmi.org/manufacturer/specification.aspx
> > 
> > [2] 
http://www.hdmi.org/pdf/whitepaper/DesigningCECintoYourNextHDMIProduct.pdf
> > 
> > 
> > Proposed solution
> > =================
> > 
> > Two new ioctls:
> >     VIDIOC_CEC_CAP (read)
> >     VIDIOC_CEC_CMD (read/write)
> 
> How this proposal will interact with RC core? The way I see it, HDMI-CEC is 
just a way to get/send
> Remote Controller data, and should be interacting with the proper Kernel 
subsystems, e. g.,
> with Remote Controller and input/event subsystems.

I knew you were going to mention this :-)

Actually, while CEC does support IR commands, this is only a very small part 
of the standard. Routing IR commands to the IR core is possible to do, 
although it is not in this initial version. Should this be needed, then a flag 
can be created that tells V4L to route IR commands to the IR core.

This should be optional, though, because if you are a repeater you do not want 
to pass such IR commands to the IR core, instead you want to retransmit them 
to a CEC output.

> 
> I don't think we need two ioctls for that, as RC capabilities are already 
exported via
> sysfs, and we have two interfaces already for receiving events (input/event 
and lirc).
> For sending, lirc interface might be used, but it is currently focused only 
on sending
> raw pulse/space sequences. So, we'll need to add some capability there for 
IR/CEC TX.
> I had a few discussions about that with Jarod, but we didn't write yet an 
interface for it.

Again, CEC != IR. All you need is a simple API to be able to send and receive 
CEC packets and a libcec that you can use to do the topology discovery and 
send/receive the commands. You don't want nor need that in the kernel.

The only place where routing things to the IR core is useful is when someone 
points a remote at a TV (for example), which then passes it over CEC to your 
device which is not a repeater but can actually handle the remote command.

This is a future extension, though.

Regards,

	Hans

> 
> 
> > 
> > VIDIOC_CEC_CAP:
> > ---------------
> > 
> > struct vl2_cec_cap {
> >        __u32 logicaldevices;
> >        __u32 reserved[7];
> > };
> > 
> > The capability ioctl will return the number of logical devices/addresses 
which can be
> > simultaneously supported on this HW.
> >     0:       This HW don't support CEC.
> >     1 -> 14: This HW supports n logical devices simultaneously.
> > 
> > VIDIOC_CEC_CMD:
> > ---------------
> > 
> > struct v4l2_cec_cmd {
> >     __u32 cmd;
> >     __u32 reserved[7];
> >     union {
> >         struct {
> >             __u32 index;
> >             __u32 enable;
> >             __u32 addr;
> >         } conf;
> >         struct {
> >             __u32 len;
> >             __u8  msg[16];
> >             __u32 status;
> >         } data;
> >         __u32 raw[8];
> >     };
> > };
> > 
> > Alternatively the data struct could be:
> >         struct {
> >             __u8  initiator;
> >             __u8  destination;
> >             __u8  len;
> >             __u8  msg[15];
> >             __u32 status;
> >         } data;
> > 
> > Commands:
> > 
> > #define V4L2_CEC_CMD_CONF  (1)
> > #define V4L2_CEC_CMD_TX    (2)
> > #define V4L2_CEC_CMD_RX    (3)
> > 
> > Tx status field:
> > 
> > #define V4L2_CEC_STAT_TX_OK            (0)
> > #define V4L2_CEC_STAT_TX_ARB_LOST      (1)
> > #define V4L2_CEC_STAT_TX_RETRY_TIMEOUT (2)
> > 
> > The command ioctl is used both for configuration and to receive/transmit 
data.
> > 
> > * The configuration command must be done for each logical device address
> >   which is to be enabled on this HW. Maximum number of logical devices
> >   is found with the capability ioctl.
> >     conf:
> >          index:  0 -> number_of_logical_devices-1
> >          enable: true/false
> >          addr:   logical address
> > 
> >   By default all logical devices are disabled.
> > 
> > * Tx/Rx command
> >     data:
> >          len:    length of message (data + header)
> >          msg:    the raw CEC message received/transmitted
> >          status: when the driver is in blocking mode it gives the result 
for transmit.
> > 
> > Events
> > ------
> > 
> > In the case of non-blocking mode the driver will issue the following 
events:
> > 
> > V4L2_EVENT_CEC_TX
> > V4L2_EVENT_CEC_RX
> > 
> > V4L2_EVENT_CEC_TX
> > -----------------
> >  * transmit is complete with the following status:
> > Add an additional struct to the struct v4l2_event
> > 
> > struct v4l2_event_cec_tx {
> >        __u32 status;
> > }
> > 
> > V4L2_EVENT_CEC_RX
> > -----------------
> >  * received a complete message
> > 
> > 
> > Comments ?
> > 
> >            Martin Bugge
> > 
> > -- 
> > Martin Bugge - Tandberg (now a part of Cisco)
> > -- 
> > 
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
