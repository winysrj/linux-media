Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([213.240.235.226]:44699 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZCDOpd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2009 09:45:33 -0500
From: "ribrishimov" <ribrishimov@mm-sol.com>
To: "'Tuukka.O Toivonen'" <tuukka.o.toivonen@nokia.com>
Cc: <camera@ok.research.nokia.com>, <linux-media@vger.kernel.org>,
	"'ext Hans Verkuil'" <hverkuil@xs4all.nl>
References: <200903041612.54557.tuukka.o.toivonen@nokia.com>
Subject: RE: [Camera] identifying camera sensor
Date: Wed, 4 Mar 2009 16:43:36 +0200
Message-ID: <011401c99cd7$9d20bd40$020014ac@ribrishimov>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <200903041612.54557.tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Some sensor ID is definitely needed at least for Camera daemon and iCapture
to load the appropriate tuning data.

Ivan can comment which the preferable approach.

Best regards,

RADO

-----Original Message-----
From: camera-bounces@ok.research.nokia.com
[mailto:camera-bounces@ok.research.nokia.com] On Behalf Of Tuukka.O Toivonen
Sent: Wednesday, March 04, 2009 4:13 PM
To: ext Hans Verkuil
Cc: camera@ok.research.nokia.com; linux-media@vger.kernel.org
Subject: [Camera] identifying camera sensor

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
_______________________________________________
Camera mailing list
Camera@ok.research.nokia.com
http://ok.research.nokia.com/cgi-bin/mailman/listinfo/camera

