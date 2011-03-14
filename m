Return-path: <mchehab@pedra>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:64416 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab1CNQal (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 12:30:41 -0400
Message-ID: <4D7E42AE.2080506@cisco.com>
Date: Mon, 14 Mar 2011 17:30:38 +0100
From: "Martin Bugge (marbugge)" <marbugge@cisco.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Preliminary proposal, new APIs for HDMI and DVI control in v4l2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


This is a preliminary proposal for an extension to the v4l2 api.
To be discussed at the  V4L2 'brainstorming' meeting in Warsaw, March 2011


Purpose: Provide basic controls for HDMI and DVI devices.

sink  : HDMI/DVI/VGA receiver
source: HDMI/DVI/VGA transmitter


New Controls:
=============

These controls rely on control events to be able to notify the
application of any change.

The idea is to create an event that will be triggered by the control
framework whenever a control changes value.


TX source:
----------

Control: V4L2_CID_DV_TX_HOTPLUG
         type: bitmask (output), read only
         name: Hotplug
Hotplug is present on each output.

The hotplug is issued by the sink to indicate that an
edid exists and should be read by the source.
Not applicable for VGA connectors.


Control: V4L2_CID_DV_TX_RXSENSE
         type: bitmask (output), read only
         name: Rx Sense
Rx sense is present on each output.

Rx Sense is detection of pull-ups on the TMDS clock lines.
Normally means that the sink has left/entered standby.
Not applicable for VGA connectors.


Control: V4L2_CID_DV_TX_EDID_SEGMENT0_PRESENT
         type: bitmask (output), read only
         name: Edid segment 0

The source driver has read edid segment 0 from the sink.

Control: V4L2_CID_DV_TX_DVI_HDMI_MODE
         type: menu, read and write
         name: Hdmi/Dvi mode

     Settings:
         "HDMI"
         "DVI-D"

RX sink:
--------

Control: V4L2_CID_DV_RX_5V
         type: bitmask (input), read only
         name: Rx 5V

The source must supply the sink with a +5v via the HDMI/DVI cable.
This is often used to power an eeprom which contains edid information,
such that the source can read the edid even if the sink
is in standby/power off.


Control: V4L2_CID_DV_CABLE_DETECT
         type: bitmask (input), read only
         name: Cable detect

This is not a part of the HDMI/DVI standards.
But many sinks (read monitors) uses a + 5v pull-up on a
ground pin (typically pin 15 on dvi) to detect if a cable is
is connected and terminated at the source end.


Control: V4L2_CID_DV_FORMAT_STATUS
         type: menu, read only
         name: Format status

Format status for the current selected input.
     Statuses:
         "No signal"
         "Unknown"
         "Unsupported"
         "Encrypted"
         "Valid/supported"

The input signal has changed format or status.
In the case of a valid signal use the
vidioc_query_dv_preset to read the new format.

Alternatively this could also be implemented as a bitmask with bits
for: 'signal present', 'encrypted', 'supported format'.

Or as three separate boolean controls.


New Events:
===========

V4L2_EVENT_TX_EDID
        struct v4l2_event_tx_edid {
               __u32 output;
               __u32 present;
               __u32 segment;
        }

The source driver has read an edid segment from the sink.
One segment is 256 bytes and will contain one or two 128
bytes blocks. Most HDMI and DVI sinks will have only segment 0.

The driver should read segment 0 when hotplug is detected and
report this to userspace. The application can then use the
V4L2_G_EDID ioctl to get the actual edid data.

If the EDID data indicates the presence of further extension blocks the
userspace application can use the V4L2_REQ_EDID ioctl to trigger a read.
When the driver has read that extended segment it will generate a
V4L2_EVENT_TX_EDID event.


New Ioctls:
===========

TX source:
----------

V4L2_REQ_EDID
        struct v4l2_req_edid {
               __u32 output;
               __u32 segment;
         }
Trigger a read of a 256 bytes segment. Normally the driver will
read segment 0 by itself when hotplug is detected, But this ioctl
may also be used to trigger a re-read of segment 0.


V4L2_G_EDID
        struct v4l2_g_edid {
               __u32 output;
               __u32 segment;
               __u8 edid[256];
         }
Get the edid segment indicated in the V4L2_EVENT_TX_EDID


RX sink:
--------

V4L2_S_EDID
        struct v4l2_s_edid {
               __u32 input;
               __u32 segment;
               __u8 _edid[256];
         }
Set the edid information in the source.


Additional Controls and Status:
===============================

Controls and statuses we want to add.
Currently based on HDMI version 1.3a, must be updated

 From Info frames

*  Y0, Y1           RGB or YCBCR indicator.
* A0                Active Information Present. Indicates whether field 
R0...R3 is valid. See
                         CEA-861-D table 8 for details.
* B0, B1            Bar Info data valid. See CEA-861-D table 8 for details.
                       HDMI Licensing, LLC Page 113 of 156
                       High-Definition Multimedia Interface 
Specification Version 1.3a
* S0, S1            Scan Information (i.e. overscan, underscan). See 
CEA-861-D table 8 for
                         details.
* C0, C1            Colorimetry (ITU BT.601, BT.709 etc.). See CEA-861-D 
table 9 for
                         details.
* EC0, EC1, EC2     Extended Colorimetry (IEC 61966-2-4 etc.). See 
CEA-861-D table 11 for
                         details.
* Q1, Q0            Quantization range (Full vs. Limited, etc.). See 
CEA-861-D table 11 for
                         details.
* ITC               IT Content. See CEA-861-D table 11 for details.
* M0, M1            Picture Aspect Ratio (4:3, 16:9). See CEA-861-D 
table 9 for details.
* R0...R3           Active Format Aspect Ratio. See CEA-861-D table 10 
and Annex H for
                         details.
* VIC0...VIC6       Video Format Identification Code. When transmitting 
any video format in
                         section 6.2.4, above, an HDMI Source shall set 
the VIC field to the Video
                         Code for that format. See CEA-861-D section 6.4 
for details.
* PR0...PR3         Pixel Repetition factor. See CEA-861-D table 13 for 
details.
* SC1, SC0          Non-uniform Picture Scaling. See CEA-861-D table 11.

A lot of these handle colorspace information. It is not clear yet 
whether this
should be set up using S_FMT/mediabus APIs, or by explicit controls.


Martin Bugge

