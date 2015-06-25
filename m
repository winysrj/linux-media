Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:49626 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751922AbbFYJbN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 05:31:13 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: HDMI and Composite capture on Lager, for kernel 4.1, version 4
Date: Thu, 25 Jun 2015 10:30:54 +0100
Message-Id: <1435224669-23672-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


  Version 4. Obsoletes version 3, as seen at:
	http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/91931

  This version has the bus_info field set in rcar_vin.c, where the
value used can be constructed uniquely. Elsewhere a number of small
optimisations have been made, and some redundant initialisation code
has been removed.

To follow:
	[PATCH 01/15] ARM: shmobile: lager dts: Add entries for VIN HDMI
	[PATCH 02/15] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
	[PATCH 03/15] media: adv7180: add of match table
	[PATCH 04/15] media: adv7604: chip info and formats for ADV7612
	[PATCH 05/15] media: adv7604: document support for ADV7612 dual HDMI
	[PATCH 06/15] media: adv7604: ability to read default input port
	[PATCH 07/15] ARM: shmobile: lager dts: specify default-input for
	[PATCH 08/15] v4l: subdev: Add pad config allocator and init
	[PATCH 09/15] media: soc_camera pad-aware driver initialisation
	[PATCH 10/15] media: rcar_vin: Use correct pad number in try_fmt
	[PATCH 11/15] media: soc_camera: soc_scale_crop: Use correct pad
	[PATCH 12/15] media: soc_camera: Fill std field in enum_input
	[PATCH 13/15] media: soc_camera: Fix error reporting in expbuf
	[PATCH 14/15] media: rcar_vin: fill in bus_info field
	[PATCH 15/15] media: rcar_vin: Reject videobufs that are too small

Cheers,
  Wills.
