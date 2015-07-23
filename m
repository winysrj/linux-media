Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:61642 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752219AbbGWMVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2015 08:21:48 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: HDMI and Composite capture on Lager, for kernel 4.1, version 5
Date: Thu, 23 Jul 2015 13:21:30 +0100
Message-Id: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Version 5. Some successful upstreaming and some further modification
means this obsoletes version 4, as seen at:
	http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/92832

  This version of the patch series contains a fix for probing the
ADV7611/ADV7612 chips, a reduced (and renamed) "chip info and formats"
patch intended to pave the way for better ADV7612 support, and updates
to rcar_vin_try_fmt() in line with the latest feedback.

Cheers,
  Wills.

To follow:
	[PATCH 01/13] ARM: shmobile: lager dts: Add entries for VIN HDMI
	[PATCH 02/13] ARM: shmobile: lager dts: specify default-input for
	[PATCH 03/13] media: adv7604: fix probe of ADV7611/7612
	[PATCH 04/13] media: adv7604: reduce support to first (digital)
	[PATCH 05/13] v4l: subdev: Add pad config allocator and init
	[PATCH 06/13] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
	[PATCH 07/13] media: soc_camera pad-aware driver initialisation
	[PATCH 08/13] media: rcar_vin: Use correct pad number in try_fmt
	[PATCH 09/13] media: soc_camera: soc_scale_crop: Use correct pad
	[PATCH 10/13] media: soc_camera: Fill std field in enum_input
	[PATCH 11/13] media: soc_camera: Fix error reporting in expbuf
	[PATCH 12/13] media: rcar_vin: fill in bus_info field
	[PATCH 13/13] media: rcar_vin: Reject videobufs that are too small
