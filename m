Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60484 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1CCKhN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 05:37:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Martin Bugge (marbugge)" <marbugge@cisco.com>
Subject: Re: [RFC] HDMI-CEC proposal
Date: Thu, 3 Mar 2011 11:37:26 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <4D6CC36B.50009@cisco.com>
In-Reply-To: <4D6CC36B.50009@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103031137.26599.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Martin,

On Tuesday 01 March 2011 10:59:07 Martin Bugge (marbugge) wrote:
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
> 
> 
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
> In the case of non-blocking mode the driver will issue the following
> events:
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

In non-blocking mode, will applications be able to send several messages 
without waiting for a transmission done event between each of them ? If so, 
maybe some kind of ID to correlate TX events with TX commands would be useful.

> V4L2_EVENT_CEC_RX
> -----------------
>   * received a complete message

-- 
Regards,

Laurent Pinchart
