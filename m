Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49642 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358Ab1CANrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 08:47:23 -0500
Subject: Re: [RFC] HDMI-CEC proposal
From: Andy Walls <awalls@md.metrocast.net>
To: "Martin Bugge (marbugge)" <marbugge@cisco.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
In-Reply-To: <4D6CC36B.50009@cisco.com>
References: <4D6CC36B.50009@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 08:47:31 -0500
Message-ID: <1298987251.3311.32.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-03-01 at 10:59 +0100, Martin Bugge (marbugge) wrote:
> Author: Martin Bugge <marbugge@cisco.com>
> Date:  Tue, 1 March 2010
> ======================
> 
> This is a proposal for adding a Consumer Electronic Control (CEC) API to 
> V4L2.
> This document describes the changes and new ioctls needed.
> 
> Version 1.0 (This is first version)
> 
> Background
> ==========
> CEC is a protocol that provides high-level control functions between 
> various audiovisual products.
> It is an optional supplement to the High-Definition Multimedia Interface 
> Specification (HDMI).
> Physical layer is a one-wire bidirectional serial bus that uses the 
> industry-standard AV.link protocol.
> 
> In short: CEC uses pin 13 on the HDMI connector to transmit and receive 
> small data-packets
>            (maximum 16 bytes including a 1 byte header) at low data 
> rates (~400 bits/s).
> 
> A CEC device may have any of 15 logical addresses (0 - 14).
> (address 15 is broadcast and some addresses are reserved)
> 
> 
> References
> ==========
> [1] High-Definition Multimedia Interface Specification version 1.3a,
>      Supplement 1 Consumer Electronic Control (CEC).
>      http://www.hdmi.org/manufacturer/specification.aspx
> 
> [2] 
> http://www.hdmi.org/pdf/whitepaper/DesigningCECintoYourNextHDMIProduct.pdf


Hi Martin,

After reading the whitepaper, and the the general purpose nature of your
proposed API calls, I'm wondering if a socket interface wouldn't be
appropriate.

The CEC bus seems to be designed as a network.  A broadcast medium, with
multiport devices (switches), physical (MAC) addresses in dotted decimal
notation (1.0.0.0), dynamic logical address assignment, arbitration
(Media Access Control), etc.  The whitepaper even suggests OSI layers,
using the term PHY in a few places.


A network interface could be implemented something like what is done for
SLIP in figure 2 here (compare with figure 1):

	http://www.linux.it/~rubini/docs/serial/serial.html


Using that diagram as a guide, a socket interface would need a CEC tty
line discipline, CEC network device, and code to hook the CEC serial
device to the tty layer.  Multiple CEC serial devices would show up as
multiple network interfaces.

Once a network device is available, user-space could then use AF_PACKET
sockets.  If CEC's layers are standardized enough, a new address family
could be added to the kernel, I guess.

Of course, all that is a lot of work.  Since Cisco should have some
networking experts hanging around, maybe it wouldn't be too hard. ;)


Regards,
Andy

> Proposed solution
> =================
> 
> Two new ioctls:
>      VIDIOC_CEC_CAP (read)
>      VIDIOC_CEC_CMD (read/write)
> 
> VIDIOC_CEC_CAP:
> ---------------
> 
> struct vl2_cec_cap {
>         __u32 logicaldevices;
>         __u32 reserved[7];
> };
> 
> The capability ioctl will return the number of logical devices/addresses 
> which can be
> simultaneously supported on this HW.
>      0:       This HW don't support CEC.
>      1 -> 14: This HW supports n logical devices simultaneously.
> 
> VIDIOC_CEC_CMD:
> ---------------
> 
> struct v4l2_cec_cmd {
>      __u32 cmd;
>      __u32 reserved[7];
>      union {
>          struct {
>              __u32 index;
>              __u32 enable;
>              __u32 addr;
>          } conf;
>          struct {
>              __u32 len;
>              __u8  msg[16];
>              __u32 status;
>          } data;
>          __u32 raw[8];
>      };
> };
> 
> Alternatively the data struct could be:
>          struct {
>              __u8  initiator;
>              __u8  destination;
>              __u8  len;
>              __u8  msg[15];
>              __u32 status;
>          } data;
> 
> Commands:
> 
> #define V4L2_CEC_CMD_CONF  (1)
> #define V4L2_CEC_CMD_TX    (2)
> #define V4L2_CEC_CMD_RX    (3)
> 
> Tx status field:
> 
> #define V4L2_CEC_STAT_TX_OK            (0)
> #define V4L2_CEC_STAT_TX_ARB_LOST      (1)
> #define V4L2_CEC_STAT_TX_RETRY_TIMEOUT (2)
> 
> The command ioctl is used both for configuration and to receive/transmit 
> data.
> 
> * The configuration command must be done for each logical device address
>    which is to be enabled on this HW. Maximum number of logical devices
>    is found with the capability ioctl.
>      conf:
>           index:  0 -> number_of_logical_devices-1
>           enable: true/false
>           addr:   logical address
> 
>    By default all logical devices are disabled.
> 
> * Tx/Rx command
>      data:
>           len:    length of message (data + header)
>           msg:    the raw CEC message received/transmitted
>           status: when the driver is in blocking mode it gives the 
> result for transmit.
> 
> Events
> ------
> 
> In the case of non-blocking mode the driver will issue the following events:
> 
> V4L2_EVENT_CEC_TX
> V4L2_EVENT_CEC_RX
> 
> V4L2_EVENT_CEC_TX
> -----------------
>   * transmit is complete with the following status:
> Add an additional struct to the struct v4l2_event
> 
> struct v4l2_event_cec_tx {
>         __u32 status;
> }
> 
> V4L2_EVENT_CEC_RX
> -----------------
>   * received a complete message
> 
> 
> Comments ?
> 
>             Martin Bugge
> 
> --
> Martin Bugge - Tandberg (now a part of Cisco)
> --
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


