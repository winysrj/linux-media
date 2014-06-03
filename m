Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44655 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaFCAo3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jun 2014 20:44:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 0/2] v4l-utils: Add missing v4l2-mediabus.h header
Date: Tue,  3 Jun 2014 02:44:50 +0200
Message-Id: <1401756292-27676-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set adds the missing v4l2-mediabus.h header, required by media-ctl.
Please see individual patches for details, they're pretty straightforward.

Laurent Pinchart (2):
  Use installed kernel headers instead of raw kernel headers
  Add the missing v4l2-mediabus.h kernel header

 include/linux/dvb/dmx.h       |   8 +--
 include/linux/dvb/frontend.h  |   4 --
 include/linux/dvb/video.h     |  12 ++--
 include/linux/fb.h            |   8 +--
 include/linux/ivtv.h          |   6 +-
 include/linux/v4l2-mediabus.h | 147 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/videodev2.h     |  16 ++---
 7 files changed, 168 insertions(+), 33 deletions(-)
 create mode 100644 include/linux/v4l2-mediabus.h

-- 
Regards,

Laurent Pinchart

