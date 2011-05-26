Return-path: <mchehab@pedra>
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:58496 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110Ab1EZFKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 01:10:15 -0400
Message-ID: <4DDDE08A.2090406@st.com>
Date: Thu, 26 May 2011 10:39:30 +0530
From: vipul kumar samar <vipulkumar.samar@st.com>
MIME-Version: 1.0
To: "Martin Bugge (marbugge)" <marbugge@cisco.com>
Cc: "hdegoede@redhat.com" <hdegoede@redhat.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: About RFC of HDMI-CEC
References: <4DDCED60.3080907@st.com> <4DDCF95C.1020705@cisco.com>
In-Reply-To: <4DDCF95C.1020705@cisco.com>
Content-Type: multipart/mixed;
	boundary="------------050202090402070102030805"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--------------050202090402070102030805
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

On 05/25/2011 06:13 PM, Martin Bugge (marbugge) wrote:
> Hello
>
> To be honest I became a bit disengaded after all the discussion.
>
> What caused me a lot of problems was the request for AV link support
> (which is used in SCART connectors).
> Something I never plan to implement.
>
> But after the "v4l2 Warsaw Brainstroming meeting" it was sort of approved.
>
> It only need to be reworked to be a subdev level api.
> (for that I need some help from Hans Verkuil)
>
> But it is great that someone else also need an API for this.
> I include the latest version here so you can see if you agree, and
> together we will get it in.
>

Yes, sure.

> We currently have two drivers which uses this API for CEC.
>
> * Analog Devices adv7604
>
> * TMS320DM8x
>

i want to see source code of these two drivers.From where i can get 
source code of these drivers??

Thanks and Regards
Vipul Kumar Samar

> At least the adv7604 is planned to be upstreamed.
>
> Best regards
> Martin Bugge
>
>
> On 05/25/2011 01:52 PM, vipul kumar samar wrote:
>> Hello,
>>
>> I am working on HDMI-CEC and planning to implement it in v4l2
>> framework.I came to know that a RFC is going on for the same driver.
>>
>> I want to know is their any friezed version of that RFC or discussion
>> is still going on?? Is it included in kernel??
>>
>> Thanks and Regards
>> Vipul Kumar Samar
>
>


-- 
You won't skid if you stay in a rut. -- Frank Hubbard

--------------050202090402070102030805
Content-Type: text/plain; name="RFC-v3.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="RFC-v3.txt"

Author: Martin Bugge <marbugge@cisco.com>
Date:  Thu, 17th of March 2011
==============================

This is a proposal for adding a Consumer Electronic Control (CEC) API to V4L2.
This document describes the changes and new ioctls needed.

Version 1.
           Initial version.

Version 2.
          Added support for AV.link EN 50157-2-[123].

Version 3.
          Rework of mode 1.
          Mode 3 is to be decided (TDB).
          Minor cleanup.

Background
==========
CEC is a protocol that provides high-level control functions between various audiovisual products.
It is an optional supplement to the High-Definition Multimedia Interface Specification (HDMI).

In short: CEC uses pin 13 on the HDMI connector to transmit and receive small data-packets
          (maximum 16 bytes including a 1 byte header) at low data rates (~400 bits/s).

A CEC device may have any of 15 logical addresses (0 - 14).
(address 15 is broadcast and some addresses are reserved)

Physical layer is a one-wire bidirectional serial bus that uses the
industry-standard AV.link, see [3].
Due to this the proposed ioctls and events are meant to cover expansion for the protocols in [3].

Note that AV.link mode 3 is still TBD.


References
==========
[1] High-Definition Multimedia Interface Specification version 1.3a,
    Supplement 1 Consumer Electronic Control (CEC).
    http://www.hdmi.org/manufacturer/specification.aspx

[2] http://www.hdmi.org/pdf/whitepaper/DesigningCECintoYourNextHDMIProduct.pdf

[3] Domestic and similar electronic equipment interconnection requirements
    AV.link. EN 50157-2-[123]


Proposed solution
=================

Two new ioctls:
    VIDIOC_AV_LINK_CAP (read)
    VIDIOC_AV_LINK_CMD (read/write)


VIDIOC_AV_LINK_CAP:
-------------------

#define AV_LINK_CAP_MODE_CEC (1 << 0)
#define AV_LINK_CAP_MODE_1   (1 << 1)
#define AV_LINK_CAP_MODE_2   (1 << 2)
#define AV_LINK_CAP_MODE_3   (1 << 3)

Note about AV.Link Mode 3: TBD
Different manufactures might have different implementations and an option is to
have a mode per implementation.

struct vl2_av_link_cap {
       __u32 capabilities;
       __u32 logicaldevices;
       __u32 reserved[14];
};

The capabilities field will indicate which protocols/formats this HW supports.

* AV link mode CEC:
     logicaldevices: 1 -> 14, this HW supports n logical devices simultaneously.

* AV link mode 1:
     logicaldevices: not used.

* AV link mode 2:
     Same as AV link mode CEC.

* AV link mode 3: TBD

     reserved: for future use.


VIDIOC_AV_LINK_CMD:
-------------------
The command ioctl is used both for configuration and to receive/transmit data.

/* mode 1 */
struct avl_mode1_conf {
       __u32 enable;
       __u32 upstream_arb_mask;
       __u32 downstream_arb_mask;
};
struct avl_mode1 {
       __u32 ctrl_signal_frame;
       __u32 tx_frame_arb;
       __u32 tx_status;
};

/* mode 2, CEC and possible mode 3 */
struct avl_conf {
        __u32 enable;
        __u32 index;
        __u32 addr;
};
struct avl {
       __u32 len;
       __u8  msg[16];
       __u32 tx_status;
};

struct v4l2_av_link_cmd {
    __u32 command;
    __u32 mode;
    __u32 reserved[2];
    union {
        struct avl_mode1_conf avlm1_conf;
        struct avl_mode1 avlm1;
        struct avl_conf conf;
        struct avl avl;
        __u32 raw[12];
    };
};

/* command */
#define V4L2_AV_LINK_CMD_CONF (1)
#define V4L2_AV_LINK_CMD_TX   (2)
#define V4L2_AV_LINK_CMD_RX   (3)

/* mode */
#define AV_LINK_CMD_MODE_CEC (1)
#define AV_LINK_CMD_MODE_1   (2)
#define AV_LINK_CMD_MODE_2   (3)
#define AV_LINK_CMD_MODE_3   (4)

/* Tx status */
#define V4L2_AV_LINK_STAT_TX_OK                 (0)
#define V4L2_AV_LINK_STAT_TX_ARB_LOST           (1)
#define V4L2_AV_LINK_STAT_TX_RETRY_TIMEOUT      (2)
#define V4L2_AV_LINK_STAT_TX_BROADCAST_REJECT   (3)

Not every tx status is applicable for all modes, see table 1.

|-------------------------------------------------------|
|    Av link Mode     |  CEC  |   1   |   2   |   3     |
|-------------------------------------------------------|
|      Status         |       |       |       |         |
|-------------------------------------------------------|
|      TX_OK          |   a   |   a*  |   a   |   a**   |
|-------------------------------------------------------|
|  TX_ARB_LOST        |   a   |   a   |   a   |   a**   |
|-------------------------------------------------------|
| TX_RETRY_TIMEOUT    |   a   |  n/a  |   a   |   a**   |
|-------------------------------------------------------|
| TX_BROADCAST_REJECT |   a   |  n/a  |   a   |   a**   |
|-------------------------------------------------------|
Table 1: tx status versus mode.
         a:   applicable
         n/a: not applicable
         *: TX_OK for mode 1 only imply transmit complete, no ack bit
         **: mode 3 is TBD


Configuration command:
----------------------

* AV link mode CEC:
     Must be done for each logical device address which is to be
     enabled on this HW. Maximum number of logical devices
     is found with the capability ioctl.
     conf:
         index:  0 -> number_of_logical_devices-1
         enable: true/false
         addr:   logical address


* AV link mode 1:
     In mode 1 the message frame length is fixed to 20 bits (excluding the START and ESC bit).
     Some of these bits (Qty 1 - 6) and /PAS and /DES can be arbitrated by
     the receiver to signal modes and supported formats/standards.
     conf:
         enable: true/false
         upstream_arb_mask:
         downstream_arb_mask:
             A "0" in a bit position will pull down that bit during reveive,
             if that bit is allowed to be arbitrated.
         |--------------------------------------------------------------------|
         | Bits:       | 31 - 21 |  19 |  18  |  17  |  16  |   15  ->  0     |
         |--------------------------------------------------------------------|
         | head bits:  |    x    | DIR | /PAS | /NAS | /DES | Qty-1 -> Qty-16 |
         |--------------------------------------------------------------------|
         Table 2: Mode 1 Control signal frame (x: not used)

* AV link mode 2:
     Same as AV link mode CEC.

* AV link mode 3:  TBD

Tx/Rx command:
--------------

* AV link mode CEC:
     len:    length of message in bytes (data + header).
     msg:    the raw message received/transmitted.
     tx_status: tx status in blocking mode.


* AV link mode 1:
     Frame received/transmitted:
     ctrl_signal_frame: See Table 2.
     In blocking mode only:
        tx_frame_arb: The resulting frame as transmitted. Will indicate which
                      bits was arbitrated during transmit, see Table 2.
        tx_status: tx status, see Table 1.

* AV link mode 2:
     len:    length of message in bytes (data + command block).
     msg:    the raw message received/transmitted (without the start sequence).
     tx_status: tx status in blocking mode.

* AV link mode 3: TBD.
     len: length of message in bits, maximum 100 bits.
     msg: the raw message received/transmitted. (without the start sequence).
     tx_status: tx status in blocking mode.


Events
------

In the case of non-blocking mode the driver will issue the following events:

V4L2_EVENT_AV_LINK_TX
V4L2_EVENT_AV_LINK_RX


V4L2_EVENT_AV_LINK_TX
-----------------
 * transmit is complete with the following status:
Add an additional struct to the struct v4l2_event

struct v4l2_event_av_link_tx {
       __u32 status;
       __u32 tx_mode1_frame_arb;
};
 * The status field is the same as in blocking mode described above.
 * The tx_mode1_frame_arb apply only to mode 1.


V4L2_EVENT_AV_LINK_RX
-----------------
 * received a complete message
   Use the VIDIOC_AV_LINK_CMD to read the message.


Comments ?

           Martin Bugge

--
Martin Bugge - Tandberg (now a part of Cisco)
--


--------------050202090402070102030805--
