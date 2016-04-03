Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60235 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbcDCTmx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2016 15:42:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund+renesas@ragnatech.se
Subject: [PATCH 0/2] v4l2-rect.h: struct v4l2_rect helper functions
Date: Sun,  3 Apr 2016 12:42:41 -0700
Message-Id: <1459712563-8796-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series splits off the v4l2_rect helper functions from the vivid driver
into a new v4l2-rect.h header. This makes them available for reuse in other drivers.

Regards,

	Hans

Hans Verkuil (2):
  v4l2-rect.h: new header with struct v4l2_rect helper functions.
  vivid: use new v4l2-rect.h header

 Documentation/DocBook/device-drivers.tmpl        |   1 +
 drivers/media/platform/vivid/vivid-kthread-cap.c |  13 +-
 drivers/media/platform/vivid/vivid-vid-cap.c     | 101 ++++++-------
 drivers/media/platform/vivid/vivid-vid-common.c  |  97 -------------
 drivers/media/platform/vivid/vivid-vid-common.h  |   9 --
 drivers/media/platform/vivid/vivid-vid-out.c     | 103 ++++++-------
 include/media/v4l2-rect.h                        | 175 +++++++++++++++++++++++
 7 files changed, 286 insertions(+), 213 deletions(-)
 create mode 100644 include/media/v4l2-rect.h

-- 
2.8.0.rc3

