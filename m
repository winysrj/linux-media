Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbbKPRz0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 12:55:26 -0500
From: Vladis Dronov <vdronov@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH 0/1] patch version fixing crash in usbvision driver
Date: Mon, 16 Nov 2015 18:55:10 +0100
Message-Id: <1447696511-17704-1-git-send-email-vdronov@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is a version of the patch which fixes issues mentioned in the
message "[PATCH] usbvision fix overflow of interfaces array"
(http://www.spinics.net/lists/linux-media/msg94434.html) posted on
this list earlier.

Unfortunately, there are some concerns about that patch and probable
problems with it (please, see that patch thread), so here is the patch
which covers these issues and concerns.

 drivers/media/usb/usbvision/usbvision-video.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

Best regards,
Vladis Dronov <vdronov@redhat.com>
