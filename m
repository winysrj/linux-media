Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39359 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbaCERa6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 12:30:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, sakari.ailus@iki.fi
Subject: [PATCH/RFC v2 0/5] media-ctl API changes to prepare for device enumeration library
Date: Wed,  5 Mar 2014 18:32:16 +0100
Message-Id: <1394040741-22503-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's the second version of the patch set that make libmediactl usable by the
upcoming media device enumeration library. In order to do so I need to change
the libmediactl API and add support for emulated media devices.

In order to avoid further API/ABI breakages I've decided to make the
media_device and media_entity structures private and provide accessors for the
fields that need to be read. I'm open to suggestions on whether I should make
the media_pad and media_link structures private now as well, or on any other
aspect of these changes.

For reference the (work in progress) media device enumeration library is
available at

	http://git.ideasonboard.org/media-enum.git

Changes since v1:

- Made struct media_entity private

Laurent Pinchart (5):
  Split media_device creation and opening
  Make the media_device structure private
  Make the media_entity structure private
  Expose default devices
  Add support for emulated devices

 src/main.c          | 137 +++++++++++++---------
 src/mediactl-priv.h |  64 ++++++++++
 src/mediactl.c      | 330 +++++++++++++++++++++++++++++++++++++++++++++-------
 src/mediactl.h      | 281 ++++++++++++++++++++++++++++++++++----------
 src/v4l2subdev.c    |   1 +
 5 files changed, 652 insertions(+), 161 deletions(-)
 create mode 100644 src/mediactl-priv.h

-- 
Regards,

Laurent Pinchart

