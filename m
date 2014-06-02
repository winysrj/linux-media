Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41752 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaFBPJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jun 2014 11:09:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 0/3] v4l-utils: media-ctl: Add DV timings support
Date: Mon,  2 Jun 2014 17:10:01 +0200
Message-Id: <1401721804-30133-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set adds support for the subdev DV timings ioctls to the media-ctl
utility, allowing DV timings to be configured in media controller pipelines.

The first patch adds wrappers around the DV timings ioctls to libv4l2subdev in
a pretty straightforward way. The second patch refactors the media-ctl flag
printing code to avoid later duplication. The third patch is the interesting
part, adding DV timings support to the media-ctl utility.

With this series applied DV timings are added to the output when printing
formats with the existing -p argument. A new --set-dv argument allows
configuring DV timings on a pad, by querying the current timings and applying
them unmodified. This is enough to configure pipelines that include HDMI
receivers with the timings detected at the HDMI input. Support for fully
manual timings configuration from the command line can be added later when
needed.

Laurent Pinchart (3):
  media-ctl: libv4l2subdev: Add DV timings support
  media-ctl: Move flags printing code to a new print_flags function
  media-ctl: Add DV timings support

 utils/media-ctl/libv4l2subdev.c |  72 +++++++++++++
 utils/media-ctl/media-ctl.c     | 222 ++++++++++++++++++++++++++++++++++++----
 utils/media-ctl/options.c       |   9 +-
 utils/media-ctl/options.h       |   3 +-
 utils/media-ctl/v4l2subdev.h    |  53 ++++++++++
 5 files changed, 338 insertions(+), 21 deletions(-)

-- 
Regards,

Laurent Pinchart

