Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40401 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbbCTRFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 13:05:13 -0400
Received: from durdane.fritz.box (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 5293D2A009F
	for <linux-media@vger.kernel.org>; Fri, 20 Mar 2015 18:05:00 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] v4l2_dv_timings: add V4L2_DV_FL_IS_CE_VIDEO flag
Date: Fri, 20 Mar 2015 18:05:01 +0100
Message-Id: <1426871106-31914-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series improves the V4L2_DV_FL_HALF_LINE documentation and
adds a new V4L2_DV_FL_IS_CE_VIDEO flag to tell whether this particular
timing format is a CE video format or not.

Previously V4L2_DV_BT_STD_CEA861 was used for that, but that fails
with the CEA-861 640x480p49.94 format, which is not a CE format.

I considered just removing V4L2_DV_BT_STD_CEA861 from the 640x480p
format, but that's just a hack, and in the future new formats might
be added to CEA-861 that also aren't CE formats. Just do this right
and add a new flag for this.

Regards,

	Hans

