Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49454 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732639AbeHGRnU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 13:43:20 -0400
To: linux-media <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] Documentation: add ioctl number entry for v4l2-subdev.h
Message-ID: <7f05c67a-c8a7-e3a0-c76f-3b8acffdf41f@infradead.org>
Date: Tue, 7 Aug 2018 08:28:25 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Update ioctl-number.txt for ioctl's that are defined in
<media/v4l2-subdev.h>.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 1 file changed, 1 insertion(+)

--- lnx-418-rc8.orig/Documentation/ioctl/ioctl-number.txt
+++ lnx-418-rc8/Documentation/ioctl/ioctl-number.txt
@@ -274,6 +274,7 @@ Code  Seq#(hex)	Include File		Comments
 'v'	00-1F	linux/ext2_fs.h		conflict!
 'v'	00-1F	linux/fs.h		conflict!
 'v'	00-0F	linux/sonypi.h		conflict!
+'v'	00-0F	media/v4l2-subdev.h	conflict!
 'v'	C0-FF	linux/meye.h		conflict!
 'w'	all				CERN SCI driver
 'y'	00-1F				packet based user level communications
