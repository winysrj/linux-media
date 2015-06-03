Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:50700 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756000AbbFCOAM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 10:00:12 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>,
	hans verkuil <hverkuil@xs4all.nl>
Subject: HDMI and Composite capture on Lager, for kernel 4.1, version 3
Date: Wed,  3 Jun 2015 14:59:47 +0100
Message-Id: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Version 3. Obsoletes version 2, as seen at:
	http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/91668

  Key changes in this version: this has some reworking of the adv7604
driver probe and soc_camera initialisation functions. In addition,
we give rcar_vin.c a dependency on CONFIG_MEDIA_CONTROLLER in line with
the drivers used with it.

Cheers,
  Wills.

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
	[PATCH 14/15] media: soc_camera: fill in bus_info field
	[PATCH 15/15] media: rcar_vin: Reject videobufs that are too small
