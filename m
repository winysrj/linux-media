Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:55510 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754031AbbA2QTw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 11:19:52 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: RFC: supporting adv7604.c under soc_camera/rcar_vin
Date: Thu, 29 Jan 2015 16:19:40 +0000
Message-Id: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  The following constitutes parts of our rcar_vin development branch
beyond the update to our hotfixes published earlier this month.
Similarly, these patches are intended to the mainline 3.18 kernel.
Further development is required, but we would like to highlight the
following issues and discuss them before completing the work.

1. Our internal review has noted that our use of v4l2_subdev_has_op()
is not yet ideal (but but does suffice for the purposes of generating
images as-is). These tests are intended to detect whether or not a
camera whose driver is aware of the pad API is present or not, and
ensure we interact with subdevices accordingly. We think we should be
iterating around all camera(s), and testing each subdevice link in
turn. Is this sound, or is there a better way?

2. Our second problem regards the supported formats list in adv7604.c,
which needs further attention. We believe that having entries that go
on to be rejected by rcar_vin_get_formats() may trigger a failure to
initialise cleanly. Workaround code is marked "Ian Hack"; we intend to
remove this and the list entries that cause this issue.

3. Our third problem concerns detecting the resolution of the stream.
Our code works with the obsoleted driver (adv761x.c) in place, but with
our modifications to adv7604.c we have seen a) recovery of a 640x480
image which is cropped rather than scaled, and/or b) recovery of a
2048x2048 image with the stream content in the top left corner. We
think we understand the former problem, but the latter seems to be
caused by full initialisation of the 'struct v4l2_subdev_format
sd_format' variable, and we only have a partial solution [included
as patch 4/8] so far. Of particular concern here is that potential
consequences of changes in this particular patch are not clear.


  Any advice would be appreciated, particularly regarding the first and
last point above.

Cheers,
  Wills.

  Associated patches:
	[PATCH 1/8] Add ability to read default input port from DT
	[PATCH 2/8] adv7604.c: formats, default colourspace, and IRQs
	[PATCH 3/8] WmT: document "adi,adv7612"
	[PATCH 4/8] WmT: m-5mols_core style pad handling for adv7604
	[PATCH 5/8] media: rcar_vin: Add RGB888_1X24 input format support
	[PATCH 6/8] WmT: adv7604 driver compatibility
	[PATCH 7/8] WmT: rcar_vin new ADV7612 support
	[PATCH 8/8] WmT: dts/i vin0/adv7612 (HDMI)
