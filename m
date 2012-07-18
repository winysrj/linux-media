Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:53220 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab2GRJGs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 05:06:48 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, device-drivers-devel@blackfin.uclinux.org
Subject: [RFCv2 PATCH 0/7] Add adv7604/ad9389b drivers
Date: Wed, 18 Jul 2012 11:06:13 +0200
Message-Id: <1342602380-5854-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the second version of this patch series.

The only changes since the first version are in the adv7604 and ad9389b
drivers themselves:

- adv7604: fixed some incorrect error codes (-1 instead of -EIO)
- ad9389b+adv7604: fixed incorrect v4l2_ctrl_new_std_menu arguments.
- ad9389b+adv7604: don't set v4l2_ctrl_ops for status controls, there is
  nothing to do for the ops.
- ad9389b+adv7604: zero the reserved array of enum_dv_timings.
- ad9389b: make DVI-D the default connector mode as that will also work if
  the HDMI connector is hooked up to a DVI-D connector through an adapter.

The original text of this patch series follows below.

If there are no more comments, then I want to make the final pull request
early next week.

Regards,

	Hans


Text from the first version of the patch series:


This RFC patch series builds on an earlier RFC patch series (posted only to
linux-media) that adds support for DVI/HDMI/DP connectors to the V4L2 API.

This earlier patch series is here:

        http://www.spinics.net/lists/linux-media/msg48529.html

The first 3 patches are effectively unchanged compared to that patch series,
patch 4 adds support for the newly defined controls to the V4L2 control framework
and patch 5 adds helper functions to v4l2-common.c to help in detecting VESA
CVT and GTF formats.

Finally, two Analog Devices drivers are added to actually use this new API.
The adv7604 is an HDMI/DVI receiver and the ad9389b is an HDMI transmitter.

Another tree of mine also contains preliminary drivers for the adv7842
and adv7511:

        http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/hdmi

However, I want to start with adv7604 and ad9389b since those have had the most
testing.

As the commit message of says these drivers do not implement the full
functionality of these devices, but that can be added later, either
by Cisco or by others.

A lot of work has been put into the V4L2 subsystem to reach this point,
particularly the control framework, the VIDIOC_G/S/ENUM/QUERY_DV_TIMINGS
ioctls, and the V4L2 event mechanism. So I'm very pleased to be able to finally
post this code.

Comments are welcome!

Regards,

        Hans Verkuil

