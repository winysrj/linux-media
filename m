Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3990 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3CAJIa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 04:08:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] s2255: v4l2-compliance + bug-endian fixes
Date: Fri, 1 Mar 2013 10:08:13 +0100
Cc: Pete Eberlein <pete@sensoray.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303011008.13397.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request updates the s2255 driver with the usual v4l2-compliance and
big-endian fixes.

Tested on my s2255 device, generously supplied by Sensoray.

The patches in this pull request are unchanged from my review patch series
posted Tuesday.

Regards,

	Hans

The following changes since commit ed72d37a33fdf43dc47787fe220532cdec9da528:                                           
                                                                                                                       
  [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff) (2013-02-13 18:05:29 -0200)                          
                                                                                                                       
are available in the git repository at:                                                                                
                                                                                                                       
  git://linuxtv.org/hverkuil/media_tree.git s2255                                                                      
                                                                                                                       
for you to fetch changes up to 73aace6ab8b80cfda30fa99a1bd02f359b7dad1f:                                               
                                                                                                                       
  s2255: fix big-endian support. (2013-02-26 18:32:04 +0100)                                                           
                                                                                                                       
----------------------------------------------------------------                                                       
Hans Verkuil (11):                                                                                                     
      s2255: convert to the control framework.                                                                         
      s2255: add V4L2_CID_JPEG_COMPRESSION_QUALITY
      s2255: add support for control events and prio handling.
      s2255: add device_caps support to querycap.
      s2255: fixes in the way standards are handled.
      s2255: zero priv and set colorspace.
      s2255: fix field handling
      s2255: don't zero struct v4l2_streamparm
      s2255: Add ENUM_FRAMESIZES support.
      s2255: choose YUYV as the default format, not YUV422P
      s2255: fix big-endian support.

 drivers/media/usb/s2255/s2255drv.c |  439 ++++++++++++++++++++++++++++++++++++---------------------------------------
 include/uapi/linux/v4l2-controls.h |    4 +
 2 files changed, 215 insertions(+), 228 deletions(-)
