Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:57983 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325AbcHKVXs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:23:48 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: [PATCH 0/6] staging: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:23:37 +0200
Message-Id: <1470950624-26455-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This per-subsystem series is part of a tree wide cleanup. usb_alloc_urb() uses
kmalloc which already prints enough information on failure. So, let's simply
remove those "allocation failed" messages from drivers like we did already for
other -ENOMEM cases. gkh acked this approach when we talked about it at LCJ in
Tokyo a few weeks ago.


Wolfram Sang (6):
  staging: comedi: drivers: usbduxfast: don't print error when
    allocating urb fails
  staging: media: lirc: lirc_imon: don't print error when allocating urb
    fails
  staging: media: lirc: lirc_sasem: don't print error when allocating
    urb fails
  staging: most: hdm-usb: hdm_usb: don't print error when allocating urb
    fails
  staging: rtl8192u: r8192U_core: don't print error when allocating urb
    fails
  staging: vt6656: main_usb: don't print error when allocating urb fails

 drivers/staging/comedi/drivers/usbduxfast.c |  4 +---
 drivers/staging/media/lirc/lirc_imon.c      |  9 ++-------
 drivers/staging/media/lirc/lirc_sasem.c     |  5 -----
 drivers/staging/most/hdm-usb/hdm_usb.c      |  4 +---
 drivers/staging/rtl8192u/r8192U_core.c      |  5 +----
 drivers/staging/vt6656/main_usb.c           | 12 +++---------
 6 files changed, 8 insertions(+), 31 deletions(-)

-- 
2.8.1

