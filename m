Return-path: <mchehab@pedra>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:30239 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab1CKLgM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 06:36:12 -0500
Message-ID: <4D7A0929.6080705@cisco.com>
Date: Fri, 11 Mar 2011 12:36:09 +0100
From: "Martin Bugge (marbugge)" <marbugge@cisco.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC] HDMI-CEC proposal, ver 2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

This is an updated version of the proposal for adding an api for 
HDMI-CEC to V4L2.
Main difference is the support of AV.link EN 50157-2-[123]. (thanks to 
Daniel Glöckner)


Author: Martin Bugge <marbugge@cisco.com>
Date:  Fri, 11th of March 2010
=============================

This is a proposal for adding a Consumer Electronic Control (CEC) API to 
V4L2.
This document describes the changes and new ioctls needed.

Version 1.
            Initial version

Version 2.
           Added support for AV.link EN 50157-2-[123].

Background
==========
CEC is a protocol that provides high-level control functions between 
various audiovisual products.
It is an optional supplement to the High-Definition Multimedia Interface 
Specification (HDMI).

In short: CEC uses pin 13 on the HDMI connector to transmit and receive 
small data-packets
           (maximum 16 bytes including a 1 byte header) at low data 
rates (~400 bits/s).

A CEC device may have any of 15 logical addresses (0 - 14).
(address 15 is broadcast and some addresses are reserved)

Physical layer is a one-wire bidirectional serial bus that uses the
industry-standard AV.link, see [3].
Due to this the proposed ioctls and events are meant to cover expansion 
for the protocols in [3].


References
==========
[1] High-Definition Multimedia Interface Specification version 1.3a,
     Supplement 1 Consumer Electronic Control (CEC).
     http://www.hdmi.org/manufacturer/specification.aspx

[2] 
http://www.hdmi.org/pdf/whitepaper/DesigningCECintoYourNextHDMIProduct.pdf

[3] Domestic and similar electronic equipment interconnection requirements
     AV.link. EN 50157-2-[123]


Proposed solution
=================

Two new ioctls:
     VIDIOC_AV_LINK_CAP (read)
     VIDIOC_AV_LINK_CMD (read/write)


VIDIOC_AV_LINK_CAP:
-------------------------------

#define AV_LINK_CAP_MODE_CEC (1 << 0)
#define AV_LINK_CAP_MODE_1   (1 << 1)
#define AV_LINK_CAP_MODE_2   (1 << 2)
#define AV_LINK_CAP_MODE_3   (1 << 3)

struct vl2_av_link_cap {
        __u32 capabilities;
        __u32 logicaldevices;
        __u32 reserved[14];
};

The capabilities field will indicate which protocols/formats this HW 
supports.

* AV link mode CEC:
      logicaldevices: 1 -> 14, this HW supports n logical devices 
simultaneously.

* AV link mode 1:
      logicaldevices: not used.

* AV link mode 2:
      Same as AV link mode CEC.

* AV link mode 3:
      logicaldevices: not used.

      reserved: for future use.


VIDIOC_AV_LINK_CMD:
-------------------
The command ioctl is used both for configuration and to receive/transmit 
data.

/* mode 1 */
struct avl_mode1_conf {
        __u32 enable;
        __u32 upstream_Qty;
        __u32 downstream_Qty;
};
struct avl_mode1 {
        __u32 head;
        __u32 Qty;
        __u32 tx_status;
        __u32 tx_status_Qty;
};

/* mode 2, 3 and CEC */
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

|-----------------------------------------------------|
|    Av link Mode     |  CEC  |   1   |   2   |   3   |
|-----------------------------------------------------|
|      Status         |       |       |       |       |
|-----------------------------------------------------|
|      TX_OK          |   a   |  n/a  |   a   |  n/a  |
|-----------------------------------------------------|
|  TX_ARB_LOST        |   a   |  n/a  |   a   |   a   |
|-----------------------------------------------------|
| TX_RETRY_TIMEOUT    |   a   |  n/a  |   a   |   a   |
|-----------------------------------------------------|
| TX_BROADCAST_REJECT |   a   |  n/a  |   a   |  n/a  |
|-----------------------------------------------------|
Table 1: tx status versus mode.
          a:   applicable
          n/a: not applicable


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
      In mode 1 the frame length is fixed to 21 bits (including the 
start sequence).
      Some of these bits (Qty 1 - 6) can be arbitrated by the receiver 
to signal
      supported formats/standards.
      conf:
          enable: true/false
          upstream_Qty: QTY bits 1-6
          downstream_Qty: QTY bits 1-6
              |------------------------------------------------|
              | Bits:     | 31 - 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
              |------------------------------------------------|
              | Qty bits  |   x    | x | 6 | 5 | 4 | 3 | 2 | 1 |
              |------------------------------------------------|
              Qty bits 1-6 mapping (x: not used)


* AV link mode 2:
      Same as AV link mode CEC.


* AV link mode 3:  TBD. Chances are that nobody ever used this
      conf:
          index: 0 (not used)
          enable: true/false
          addr: 0 (not used)

Tx/Rx command:
--------------

* AV link mode CEC:
      len:    length of message in bytes (data + header).
      msg:    the raw message received/transmitted.
      tx_status: tx status in blocking mode.


* AV link mode 1:
      Frame received/transmitted:
      head:
          |-------------------------------------------------|
          | Bits:       | 31 - 4 |  3  |   2  |   1  |  0   |
          |-------------------------------------------------|
          | head bits:  |    x   | DIR | /PAS | /NAS | /DES |
          |-------------------------------------------------|
      Qty: Quality bits 1 - 16;
          |---------------------------------------|
          | Bits:     | 31 - 16 | 15 | 14 - 1 | 0 |
          |---------------------------------------|
          | Qty bits  |    x    | 16 | 15 - 2 | 1 |
          |---------------------------------------|
          x: not used

      In blocking mode only:
         tx_status: tx status.
         tx_status_Qty: which Qty bits 1 - 6 bits was arbitrated during 
transmit.


* AV link mode 2:
      len:    length of message in bytes (data + command block).
      msg:    the raw message received/transmitted (without the start 
sequence).
      tx_status: tx status in blocking mode.


* AV link mode 3: TBD. Chances are that nobody ever used this
      len: length of message in bits, maximum 96 bits.
      msg: the raw message received/transmitted. (without the start 
sequence).
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
        __u32 tx_status_mode1_Qty;
};
  * The status field is the same as in blocking mode described above.
  * tx_status_mode1_Qty apply only to mode 1.


V4L2_EVENT_AV_LINK_RX
-----------------
  * received a complete message
    Use the VIDIOC_AV_LINK_CMD to read the message.


Comments ?

            Martin Bugge

--
Martin Bugge - Tandberg (now a part of Cisco)
--


