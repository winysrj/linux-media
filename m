Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38366 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932954AbbBQIoe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 03:44:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCHv2 0/6] Remove .ioctl from v4l2_file_operations
Date: Tue, 17 Feb 2015 09:44:03 +0100
Message-Id: <1424162649-17249-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes in v1:
- use core locking in the uvc gadget driver

All V4L2 drivers should use .unlocked_ioctl instead of .ioctl. There are
only three drivers left that do not do that: pvrusb2, radio-bcm2048 and
the uvc gadget driver.

The pvrusb2 driver does its own locking as far as I can tell, so it can
just switch to unlocked_ioctl. Ditto for radio-bcm2048.

The uvc gadget driver uses a lock for the queuing ioctls, but not for
g/s_format. Laurent suggested to just use core locking here, so that's
what I did. Compile tested only. In addition querycap didn't set
device_caps, so that was added as well (this will cause a warning
otherwise).

The last patch removes the old .ioctl op completely.

Regards,

	Hans

