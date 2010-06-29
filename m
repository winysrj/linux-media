Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60894 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab0F2Mop (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 08:44:45 -0400
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [media-ctl RFC][PATCH 0/5] Exported headers to userspace fixes
Date: Tue, 29 Jun 2010 07:43:05 -0500
Message-Id: <1277815390-24681-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

While trying to generate kernel headers by doing 'make headers_install',
I noticed that the headers weren't actually copied into the filesystem.

So, here's some fixes I have come across. This is the baseline I use:

http://gitorious.org/omap3camera/mainline/commits/devel

Any feedback is greatly appreciated.

Regards,
Sergio

Sergio Aguirre (5):
  media: Add media.h to headers_install
  v4l: Add v4l2-subdev.h to headers_install
  v4l: Add v4l2-mediabus.h to headers_install
  media: Add missing linux/types.h include
  v4l: Add missing linux/types.h include

 include/linux/Kbuild          |    3 +++
 include/linux/media.h         |    2 ++
 include/linux/v4l2-mediabus.h |    1 +
 include/linux/v4l2-subdev.h   |    1 +
 4 files changed, 7 insertions(+), 0 deletions(-)

