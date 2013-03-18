Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2545 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3CRQif (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 12:38:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Frank Schaefer <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFC PATCH 0/6] Add VIDIOC_DBG_G_CHIP_NAME ioctl.
Date: Mon, 18 Mar 2013 17:38:14 +0100
Message-Id: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a patch series implementing this proposal:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/61539

It keeps the old CHIP_IDENT around for now. My plan is to start removing
support for VIDIOC_G_CHIP_IDENT and the match types V4L2_CHIP_MATCH_I2C_DRIVER,
V4L2_CHIP_MATCH_I2C_ADDR and V4L2_CHIP_MATCH_AC97 for 3.11. Once it's all
removed we can also ditch the v4l2-chip-ident.h header.

These debugging ioctls have always been a bit problematic, but sub-devices
are a much better fit and greatly simplify the implementation.

Comments are welcome!

Regards,

	Hans

