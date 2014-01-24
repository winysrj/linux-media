Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56142 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaAXNHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 08:07:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, sakari.ailus@iki.fi
Subject: [PATCH/RFC 0/4] media-ctl API changes to prepare for device enumeration library
Date: Fri, 24 Jan 2014 14:08:05 +0100
Message-Id: <1390568889-1508-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've postponed merging media-ctl to v4l-utils for too long due to pending
patches that I haven't had time to complete yet. It's time to fix this, so
here are the patches for review.

The goal of this patch set is to make libmediactl usable by the upcoming media
device enumeration library. In order to do so I need to change the libmediactl
API and add support for emulated media devices.

In order to avoid further API/ABI breakages I've decided to make the
media_device structure private and provide accessors for the fields that need
to be read. I'm open to suggestions on whether I should make the media_pad,
media_link and media_entity structures private now as well.

For reference the (work in progress) media device enumeration library is
available at

	http://git.ideasonboard.org/media-enum.git

Laurent Pinchart (4):
  Split media_device creation and opening
  Make the media_device structure private
  Expose default devices
  Add support for emulated devices

 src/main.c          |  53 ++++++----
 src/mediactl-priv.h |  52 +++++++++
 src/mediactl.c      | 296 ++++++++++++++++++++++++++++++++++++++++++++--------
 src/mediactl.h      | 209 ++++++++++++++++++++++++++++---------
 src/v4l2subdev.c    |   1 +
 5 files changed, 497 insertions(+), 114 deletions(-)
 create mode 100644 src/mediactl-priv.h

-- 
Regards,

Laurent Pinchart

