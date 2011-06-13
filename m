Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3136 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1FMMx1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 08:53:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>
Subject: [RFCv5 PATCH 0/9] tuner-core: fix g_freq/s_std and g/s_tuner
Date: Mon, 13 Jun 2011 14:53:11 +0200
Message-Id: <1307969600-31536-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Changes from RFCv4:

- Removed the controversial first two patches that changed/renamed
  check_mode and set_mode_freq.
- Added documentation to tuner-core.c and v4l2-subdev.h
- Added feature-removal-schedule entries.
- Added a small patch to remove the now unused tuner s_mode op in v4l2-subdev.h.

The first five patches are the actual bug fixes and should also go into
v3.0. The feature-removal-schedule patch should also go into v3.0 to give
people an early heads-up (not that anyone ever reads that stuff...)

Regards,

	Hans

