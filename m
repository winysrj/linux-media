Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50263 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbZCDON7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 09:13:59 -0500
From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Subject: identifying camera sensor
Date: Wed, 4 Mar 2009 16:12:54 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"camera@ok.research.nokia.com" <camera@ok.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903041612.54557.tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am writing a generic driver for SMIA-compatible sensors.
SMIA-sensors have registers containing:
  u16 model_id
  u16 revision_number
  u8 manufacturer_id
which could be used to detect the sensor.
However, since the driver is generic, it is not interested
of these values.

Nevertheless, in some cases user space applications want
to know the exact chip. For example, to get the highest
possible image quality, user space application might capture
an image and postprocess it using sensor-specific filtering
algorithms (which don't belong into kernel driver).

I am planning to export the chip identification information
to user space using VIDIOC_DBG_G_CHIP_IDENT.
Here's a sketch:
  #define V4L2_IDENT_SMIA_BASE	(0x53 << 24)
then in sensor driver's VIDIOC_DBG_G_CHIP_IDENT ioctl handler:
  struct v4l2_dbg_chip_ident id;
  id.ident = V4L2_IDENT_SMIA_BASE | (manufacturer_id << 16) | model_id;
  id.revision = revision_number;

Do you think this is acceptable?

Alternatively, VIDIOC_QUERYCAP could be used to identify the sensor.
Would it make more sense if it would return something like
  capability.card:  `omap3/smia-sensor-12-1234-5678//'
where 12 would be manufacturer_id, 1234 model_id, and
5678 revision_number?

I'll start writing a patch as soon as you let me know
which would be the best alternative. Thanks!

- Tuukka
