Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:34620 "EHLO
	omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752964AbbLVKqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 05:46:31 -0500
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: next-20151222 - compile failure in drivers/media/usb/uvc/uvc_driver.c
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 22 Dec 2015 05:18:36 -0500
Message-ID: <75073.1450779516@turing-police.cc.vt.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

next-20151222 fails to build for me:

  CC      drivers/media/usb/uvc/uvc_driver.o
drivers/media/usb/uvc/uvc_driver.c: In function 'uvc_probe':
drivers/media/usb/uvc/uvc_driver.c:1941:32: error: 'struct uvc_device' has no member named 'mdev'
  if (media_device_register(&dev->mdev) < 0)
                                ^
scripts/Makefile.build:258: recipe for target 'drivers/media/usb/uvc/uvc_driver.o' failed

'git blame' points at that line being added in:

commit 1590ad7b52714fddc958189103c95541b49b1dae
Author: Javier Martinez Canillas <javier@osg.samsung.com>
Date:   Fri Dec 11 20:57:08 2015 -0200

    [media] media-device: split media initialization and registration

Not sure what went wrong here.
