Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33441 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753727AbZLCVjB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 16:39:01 -0500
Date: Thu, 3 Dec 2009 22:39:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Marek Vasut <marek.vasut@gmail.com>
Subject: soc-camera: what's in the queue for 2.6.33
Message-ID: <Pine.LNX.4.64.0912032226000.4328@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

while waiting for (hopefully) an approval from Hans of my last mediabus 
version, and taking into account the freshly released 2.6.32, here are 
patches pending for 2.6.33:

Guennadi Liakhovetski (14):
      soc-camera: remove no longer needed struct members
      v4l: add new v4l2-subdev sensor operations, use g_skip_top_lines in soc-camera
      soc-camera: fix multi-line comment coding style
      sh_mobile_ceu_camera: do not mark host occupied, when adding a client fails
      v4l: Add a 10-bit monochrome and missing 8- and 10-bit Bayer fourcc codes
      soc-camera: add a private field to struct soc_camera_link
      soc-camera: switch drivers and platforms to use .priv in struct soc_camera_link
      sh_mobile_ceu_camera: document the scaling and cropping algorithm
      mx3: add support for the mt9v022 camera sensor to pcm037 platform
      v4l: add a media-bus API for configuring v4l2 subdev pixel and frame formats
      soc-camera: convert to the new mediabus API
      rj54n1cb0c: Add cropping, auto white balance, restrict sizes, add platform data
      mt9t031: make the use of the soc-camera client API optional
      soc-camera: Add mt9t112 camera driver

Kuninori Morimoto (14):
      tw9910: The driver can also handle revision 1 of the chip
      tw9910: Add revision control
      tw9910: simplify chip ID calculation
      tw9910: Tri-state pins when idle
      tw9910: Add power control
      tw9910: tw9910_set_hsync clean up
      tw9910: Add revision control to tw9910_set_hsync
      sh_mobile_ceu: Add V4L2_FIELD_INTERLACED_BT/TB support
      tw9910: use V4L2_FIELD_INTERLACED_BT
      sh_mobile_ceu_camera: Add support for sync polarity selection
      tw9910: modify V/H outpit pin setting to use VALID
      tw9910: modify output format
      tw9910: remove cropping
      tw9910: Add sync polarity support

Please, everybody, have a look and let me know if anything is missing. The 
stack is also available for download from 
http://download.open-technology.de/soc-camera/20091203/ based on 
linux-next of today.

Morimoto-san: I modified a bit your mt9t112 driver, apart from just 
porting it to the current mediabus version. Please check, if you agree 
with all changes and if it still works:-)

Marek, I enabled the RGB555 and RGB565 formats in your ov9640 driver, 
would be cool if you could test it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
