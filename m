Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37517 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbbLKRQx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:16:53 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 00/10] [media] Some cleanup and fixes for MC next gen patches
Date: Fri, 11 Dec 2015 14:16:26 -0300
Message-Id: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This series contains some cleanup and fixes for the MC next gen patches [0].

These addresses all the issues pointed out by Laurent and Sakari in patches
authored by me:

d125aeaa74da [media] media: don't try to empty links list in media_entity_cleanup()
46b30ba56a89 [media] uvcvideo: create pad links after subdev registration
eb9e99898333 [media] v4l: vsp1: separate links creation from entities init
5929e3a39544 [media] staging: omap4iss: separate links creation from entities init
f7cc083b0f0d [media] omap3isp: create links after all subdevs have been bound
bc36b30fe06b [media] omap3isp: separate links creation from entities init

and also for one issue in patch (authored by Mauro):

86ee417578a2 [media] media: convert links from array to list

The sha-1 ids are from the media_tree's media-controller branch [1].

This is not the full of the fixes since Mauro is going to post his patches
too but I tested rebasing on top of his media-controller-rc3 branch [3] and
there are no conflicts so it should be safe to post separately.

The patches were tested on an OMAP3 IGEPv2 that has a TVP5151 video encoder
and an Exynos5800 Peach Pi Chromebook that contains a UVC WebCam. For each
patch, the topology was retrieved with media-ctl -p and video capture was
tested using the yavta tool.

NOTE: I'm leaving for holidays tonight and I'll be back on December 20th so
I may not be able to answer and address any feedback before that day, sorry
about that.

[0]: https://www.mail-archive.com/linux-media@vger.kernel.org/msg94222.html
[1]: http://git.linuxtv.org/media_tree.git/log/?h=media-controller
[2]: http://git.linuxtv.org/mchehab/experimental.git/log/?h=media-controller-rc3

Best regards,
Javier


Javier Martinez Canillas (10):
  [media] omap3isp: remove per ISP module link creation functions
  [media] omap3isp: remove pads prefix from isp_create_pads_links()
  [media] omap3isp: rename single labels to just error
  [media] omap3isp: consistently use v4l2_dev var in complete notifier
  [media] staging: omap4iss: remove pads prefix from
    *_create_pads_links()
  [media] v4l: vsp1: remove pads prefix from *_create_pads_links()
  [media] v4l: vsp1: use else if instead of continue when creating links
  [media] uvcvideo: remove pads prefix from uvc_mc_create_pads_links()
  [media] uvcvideo: register entity subdev on init
  [media] media-entity: remove unneded enclosing parenthesis

 drivers/media/media-entity.c                 |  4 +-
 drivers/media/platform/omap3isp/isp.c        | 70 +++++++++++++++++-----------
 drivers/media/platform/omap3isp/ispccdc.c    | 18 +------
 drivers/media/platform/omap3isp/ispccdc.h    |  1 -
 drivers/media/platform/omap3isp/ispccp2.c    | 18 +------
 drivers/media/platform/omap3isp/ispccp2.h    |  1 -
 drivers/media/platform/omap3isp/ispcsi2.c    | 14 ------
 drivers/media/platform/omap3isp/ispcsi2.h    |  1 -
 drivers/media/platform/omap3isp/isppreview.c | 20 --------
 drivers/media/platform/omap3isp/isppreview.h |  1 -
 drivers/media/platform/omap3isp/ispresizer.c | 20 --------
 drivers/media/platform/omap3isp/ispresizer.h |  1 -
 drivers/media/platform/vsp1/vsp1_drv.c       | 18 +++----
 drivers/media/platform/vsp1/vsp1_rpf.c       |  4 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h      |  4 +-
 drivers/media/platform/vsp1/vsp1_wpf.c       |  4 +-
 drivers/media/usb/uvc/uvc_entity.c           | 39 +++++-----------
 drivers/staging/media/omap4iss/iss.c         | 12 ++---
 drivers/staging/media/omap4iss/iss_csi2.c    |  4 +-
 drivers/staging/media/omap4iss/iss_csi2.h    |  2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c |  4 +-
 drivers/staging/media/omap4iss/iss_ipipeif.h |  2 +-
 drivers/staging/media/omap4iss/iss_resizer.c |  4 +-
 drivers/staging/media/omap4iss/iss_resizer.h |  2 +-
 24 files changed, 90 insertions(+), 178 deletions(-)

-- 
2.4.3

