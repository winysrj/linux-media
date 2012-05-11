Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1738 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322Ab2EKJEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 05:04:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: RFC: Add missing controls/ioctls needed to support VGA/DVI/HDMI/DisplayPort receivers/transmitters
Date: Fri, 11 May 2012 11:03:50 +0200
Cc: Scott Jiang <scott.jiang.linux@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	"Martin Bugge (marbugge)" <marbugge@cisco.com>,
	mats.randgaard@cisco.com,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205111103.50697.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This RFC specifies some controls and two subdev ioctls that add the missing pieces
needed to support receivers/transmitters for VGA/DVI/HDMI/DisplayPort. This RFC
builds on top of the Timings API that is currently waiting to be merged (see
http://patchwork.linuxtv.org/patch/10950/).

When we have the controls/ioctls described here we (Cisco) can begin to upstream
our Analog Devices drivers for the adv7604, ad9389b and adv7842 (and likely a
another transmitter as well).

This RFC is based on Martin Bugge's preliminary proposal:

http://www.spinics.net/lists/linux-media/msg30265.html

And some feedback from the Warsaw brainstorm meeting last year:

http://www.spinics.net/lists/linux-media/msg30472.html


Part 1: New controls
====================


#define V4L2_CID_DV_TX_HOTPLUG                  (V4L2_CID_DV_CLASS_BASE + 1)

Type: bitmask, read-only

Description: many connectors (DVI, HDMI, DisplayPort) have a hotplug pin which is high
if EDID information is available from the source. This control shows the state of the
hotplug pin as seen by the transmitter.

Applicable to: DVI-D, HDMI, DisplayPort.


#define V4L2_CID_DV_TX_RXSENSE                  (V4L2_CID_DV_CLASS_BASE + 2)

Type: bitmask, read-only

Description: Rx Sense is the detection of pull-ups on the TMDS clock lines. This normally
means that the sink has left/entered standby (i.e. the transmitter can sense that the
receiver is ready to receive video).

Applicable to: DVI-D, HDMI.


#define V4L2_CID_DV_TX_EDID_PRESENT             (V4L2_CID_DV_CLASS_BASE + 3)

Type: bitmask, read-only

Description: When the transmitter sees the hotplug signal from the receiver it will attempt
to read the EDID. If true, then the transmitter has read at least the first block (= 128 bytes).

Applicable to: VGA, DVI-A/D, HDMI, DisplayPort.


#define V4L2_CID_DV_TX_MODE                     (V4L2_CID_DV_CLASS_BASE + 4)
enum v4l2_dv_tx_mode {
        V4L2_DV_TX_MODE_DVI_D   = 0,
        V4L2_DV_TX_MODE_HDMI    = 1,
};

Type: menu

Description: HDMI transmitters can transmit in DVI-D mode (just video) or in HDMI mode (video +
audio + auxiliary data). This control selects which mode to use.

Applicable to: HDMI.


#define V4L2_CID_DV_TX_RGB_RANGE   		(V4L2_CID_DV_CLASS_BASE + 5)
enum v4l2_dv_quantization_range {
	V4L2_DV_RANGE_AUTO    = 0,
	V4L2_DV_RANGE_LIMITED = 1,
	V4L2_DV_RANGE_FULL    = 2,
};

Type: menu

Description: Select the quantization range for RGB output. RANGE_AUTO follows the RGB
quantization range specified in the standard for the video-interface (ie. CEA-861 for
HDMI). RANGE_LIMITED and RANGE_FULL override the standard to be compatible with sources and
sinks that have not implemented the standard correctly (unfortunately quite usual for
HDMI/DVI).

Applicable to: VGA, DVI-A/D, HDMI, DisplayPort.


#define V4L2_CID_DV_RX_POWER_PRESENT            (V4L2_CID_DV_CLASS_BASE + 100)

Type: bitmask, read-only

Description: Detects which ports of the receiver (one bit per port) receive power from the
source (e.g. HDMI carries 5V on one of the pins). This is often used to power an eeprom
which contains edid information, such that the source can read the edid even if the sink
is in standby/power off.

Applicable to: DVI-D, HDMI, DisplayPort.


#define V4L2_CID_DV_RX_RGB_RANGE   		(V4L2_CID_DV_CLASS_BASE + 101)

Type: menu

Description: Select the quantization range for RGB input. RANGE_AUTO follows the RGB
quantization range specified in the standard for the video-interface (ie. CEA-861 for
HDMI). RANGE_LIMITED and RANGE_FULL override the standard to be compatible with sources and
sinks that have not implemented the standard correctly (unfortunately quite usual for
HDMI/DVI).

Applicable to: VGA, DVI-A/D, HDMI, DisplayPort.


Some remarks:

These controls are implemented by receiver/transmitter subdevs. Whether they are exposed
on the main V4L2 device node is up to the bridge/platform drivers. I think they should
be private controls.


Part 2: New subdev ioctls
=========================

Note: EDID is used by VGA/DVI/HDMI/DisplayPort. This API does not do any parsing and it
is specific to embedded systems that want to set/get the EDID themselves. So these ioctls
are for subdevs, not for the main V4L2 API.

struct v4l2_edid {
        __u32 port;
        __u32 blocks;
	__u32 reserved[6];
        __u8 __user *edid;	/* blocks * 128 bytes */
};

#define VIDIOC_SUBDEV_G_EDID    _IOWR('V', 64, struct v4l2_edid)

Get EDID blocks.

For a receiver (aka sink) this ioctl will get the EDID that is currently in use by the
receiver. If there is none, then -ENODATA is returned.

For a transmitter (aka source) this ioctl will get the EDID that the transmitter received
from the sink (note that the EDID information goes in the opposite direction of the video).
It is up to the driver to decide whether to load all blocks at the beginning (i.e. when the
sink provides the source with the first EDID block), or whether to load blocks on demand.
In the latter case this call will block until the blocks have been retrieved from the receiver.
In the future this ioctl might also support non-blocking mode and send an event when the
requested EDID blocks have been read, but I think we shouldn't attempt this for the first
version.

If there is no EDID then -ENODATA is returned.

If there are fewer blocks than requested, then the driver will update blocks with the actual
number of read blocks. If blocks == 0 or blocks is unreasonably large (suggest 256 for now
since the EDID standard sets a maximum of 32 kB on the EDID) or the port is invalid then
-EINVAL is returned.


#define VIDIOC_SUBDEV_S_EDID    _IOWR('V', 65, struct v4l2_edid)

Set the EDID blocks. Only valid for receivers (sinks). The driver assumes that the full EDID
is passed in. If there are more EDID blocks than the hardware can handle then -E2BIG is
returned and blocks is set to the maximum that the hardware supports. If blocks == 0 or port
is invalid then -EINVAL is returned.


Comments? Did I miss anything?

Regards,

	Hans
