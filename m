Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20008 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab0GLJfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 05:35:10 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L5F00E2BUMKG520@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Jul 2010 10:35:08 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L5F00IQ8UMJT3@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Jul 2010 10:35:08 +0100 (BST)
Date: Mon, 12 Jul 2010 11:33:52 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [RFC/PATCH v2 7/7] v4l: subdev: Generic ioctl support
In-reply-to: <1278689512-30849-8-git-send-email-laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Message-id: <001001cb21a5$56f41bb0$04dc5310$%osciak@samsung.com>
Content-language: pl
References: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1278689512-30849-8-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Laurent Pinchart wrote:
>Sent: Friday, July 09, 2010 5:32 PM
>To: linux-media@vger.kernel.org
>Cc: sakari.ailus@maxwell.research.nokia.com
>Subject: [RFC/PATCH v2 7/7] v4l: subdev: Generic ioctl support
>
>Instead of returning an error when receiving an ioctl call with an
>unsupported command, forward the call to the subdev core::ioctl handler.
>
>Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>---
> Documentation/video4linux/v4l2-framework.txt |    5 +++++
> drivers/media/video/v4l2-subdev.c            |    2 +-
> 2 files changed, 6 insertions(+), 1 deletions(-)
>
>diff --git a/Documentation/video4linux/v4l2-framework.txt
>b/Documentation/video4linux/v4l2-framework.txt
>index 89bd881..581e7db 100644
>--- a/Documentation/video4linux/v4l2-framework.txt
>+++ b/Documentation/video4linux/v4l2-framework.txt
>@@ -365,6 +365,11 @@ VIDIOC_UNSUBSCRIBE_EVENT
> 	To properly support events, the poll() file operation is also
> 	implemented.
>
>+Private ioctls
>+
>+	All ioctls not in the above list are passed directly to the sub-device
>+	driver through the core::ioctl operation.
>+
>
> I2C sub-device drivers
> ----------------------
>diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-
>subdev.c
>index 31bec67..ce47772 100644
>--- a/drivers/media/video/v4l2-subdev.c
>+++ b/drivers/media/video/v4l2-subdev.c
>@@ -120,7 +120,7 @@ static long subdev_do_ioctl(struct file *file, unsigned
>int cmd, void *arg)
> 		return v4l2_subdev_call(sd, core, unsubscribe_event, fh, arg);
>
> 	default:
>-		return -ENOIOCTLCMD;
>+		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
> 	}
>
> 	return 0;

Hi,
one remark about this:

(@Laurent: this is what've been discussing on Saturday on IRC)

It looks to me that with this, a subdev will only be able to have either
kernel or userspace-callable ioctls, not both. Note, that I don't mean one
ioctl callable from both, but 2 ioctls, where one is kernel-callable and
the other is userspace-callable. Technically that would work, but would
become a security risk. Malicious userspace would be able to call the
kernel-only ioctl.

So a driver has to be careful not to expose a node to the userspace if
it has kernel-callable subdev ioctls.

As long as drivers obey that rule and we do not require both types of
ioctls in one subdev, there is no problem.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





