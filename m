Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56737 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932194AbbEUJDd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:03:33 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: HDMI and Composite capture on Lager, for kernel 4.1
Date: Wed, 20 May 2015 17:39:20 +0100
Message-Id: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This is our latest test branch for video support on Lager, ported
to kernel 4.1 as per commit 9cae84b32dd52768cf2fd2fcb214c3f570676c4b
("[media] DocBook/media: fix syntax error") on the media-tree master
branch last week.

  Single frame and video capture is working with appropriate test
cases for gstreamer, some (minor) quirks notwithstanding.
Functionally, this is in more or less the state we need it to be; for
the rest of the world we hope we have enhanced the ability to do any
necessary debugging on it. The intention is to upstream this version
as soon as possible, subject to feedback.

  NB: for single frame capture, images of appropriate resolutions are
created from both composite and HDMI inputs. For best quality video
capture we have found that gst-launch-1.0 needs a pipeline specifying
width, height, format ("=YUY2" in particular has an appropriate
turnaround time for smooth results), and framerate.

  Enclosed are:
	[PATCH 01/20] ARM: shmobile: lager dts: Add entries for VIN HDMI
	[PATCH 02/20] media: adv7180: add of match table
	[PATCH 03/20] media: adv7604: chip info and formats for ADV7612
	[PATCH 04/20] media: adv7604: document support for ADV7612 dual HDMI
	[PATCH 05/20] media: adv7604: ability to read default input port
	[PATCH 06/20] ARM: shmobile: lager dts: specify default-input for
	[PATCH 07/20] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
	[PATCH 08/20] media: soc_camera pad-aware driver initialisation
	[PATCH 09/20] media: rcar_vin: Use correct pad number in try_fmt
	[PATCH 10/20] media: soc_camera: soc_scale_crop: Use correct pad
	[PATCH 11/20] media: soc_camera: Fill std field in enum_input
	[PATCH 12/20] media: soc_camera: Fix error reporting in expbuf
	[PATCH 13/20] media: soc_camera: v4l2-compliance fixes for querycap
	[PATCH 14/20] media: rcar_vin: Reject videobufs that are too small
	[PATCH 15/20] media: rcar_vin: Don't advertise support for USERPTR
	[PATCH 16/20] media: adv7180: Fix set_pad_format() passing wrong
	[PATCH 17/20] media: adv7604: Support V4L_FIELD_INTERLACED
	[PATCH 18/20] media: adv7604: Always query_dv_timings in
	[PATCH 19/20] media: rcar_vin: Clean up format debugging statements
	[PATCH 20/20] media: soc_camera: Add debugging for get_formats

"Phew!"
Cheers,
  Wills.
