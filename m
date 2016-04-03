Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57555 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbcDCUo1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2016 16:44:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: awalls@md.metrocast.net
Subject: [PATCH 0/2] v4l2-device: add mask variants of v4l2_device_call_
Date: Sun,  3 Apr 2016 13:44:15 -0700
Message-Id: <1459716257-1542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It's a little thing that has annoyed me for, well, years, and since I had some
time and I think it will be useful for an upcoming driver as well, I finally
fixed this. Now we have variants of the v4l2_device_call_* defines that treat
the grp_id as a bitmask.

Updated ivtv and cx18 accordingly, as those two where already treating grp_id
as a bitmask.

Regards,

	Hans

Hans Verkuil (2):
  v4l2-device.h: add v4l2_device_mask_ variants
  ivtv/cx18: use the new mask variants of the v4l2_device_call_* defines

 drivers/media/pci/cx18/cx18-driver.h   | 13 ++------
 drivers/media/pci/ivtv/ivtv-driver.h   | 13 ++------
 drivers/media/usb/go7007/go7007-v4l2.c |  2 +-
 include/media/v4l2-device.h            | 55 +++++++++++++++++++++++++++++++++-
 4 files changed, 59 insertions(+), 24 deletions(-)

-- 
2.8.0.rc3

