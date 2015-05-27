Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:52383 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751771AbbE0QK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 12:10:59 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: HDMI and Composite capture on Lager, for kernel 4.1, version 2
Date: Wed, 27 May 2015 17:10:38 +0100
Message-Id: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Version 2 of the patchset sent last week, ie.
	http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/91423

  In response to comments, this version has: fixes regarding use of
CONFIG_MEDIA_CONTROLLER defines; an additional line for the RGB888
support patch (required by parallel changes); removal of more vestigial
format handling; the set no longer has its debugging changes and now
incorporates the patch at https://patchwork.linuxtv.org/patch/29807/

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
	[PATCH 14/15] media: soc_camera: v4l2-compliance fixes for querycap
	[PATCH 15/15] media: rcar_vin: Reject videobufs that are too small
