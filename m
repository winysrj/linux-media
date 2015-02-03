Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40011 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbbBCMsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 07:48:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, isely@isely.net,
	pali.rohar@gmail.com
Subject: [PATCH 0/5] Remove .ioctl from v4l2_file_operations
Date: Tue,  3 Feb 2015 13:47:21 +0100
Message-Id: <1422967646-12223-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All V4L2 drivers should use .unlocked_ioctl instead of .ioctl. There are
only three drivers left that do not do that: pvrusb2, radio-bcm2048 and
the uvc gadget driver.

The pvrusb2 driver does its own locking as far as I can tell, so it can
just switch to unlocked_ioctl. Ditto for radio-bcm2048.

The uvc gadget driver uses a lock for the queuing ioctls, but not for
g/s_format, so a new lock was added for that. In addition querycap
didn't set device_caps, so that was added as well (this will cause a
warning otherwise).

The last patch removes the old .ioctl op completely.

Regards,

	Hans

