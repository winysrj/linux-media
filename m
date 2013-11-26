Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62596 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3KZOPa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 09:15:30 -0500
Received: by mail-ie0-f174.google.com with SMTP id at1so9223466iec.33
        for <linux-media@vger.kernel.org>; Tue, 26 Nov 2013 06:15:29 -0800 (PST)
From: Mauro Dreissig <mukadr@gmail.com>
To: linux-media@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
	Mauro Dreissig <mukadr@gmail.com>
Subject: [PATCH 0/2] staging: as102: Cleanups for the as102 driver
Date: Tue, 26 Nov 2013 09:15:19 -0500
Message-Id: <1385475321-4245-1-git-send-email-mukadr@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first patch cleans sparse warnings and the second one removes
useless code.

Mauro Dreissig (2):
  staging: as102: Declare local variables as static
  staging: as102: Remove ENTER/LEAVE debugging macros

 drivers/staging/media/as102/as102_drv.c        | 10 ----------
 drivers/staging/media/as102/as102_drv.h        |  8 --------
 drivers/staging/media/as102/as102_fe.c         | 26 -------------------------
 drivers/staging/media/as102/as102_fw.c         | 16 +++++----------
 drivers/staging/media/as102/as102_usb_drv.c    | 27 +-------------------------
 drivers/staging/media/as102/as10x_cmd.c        | 21 --------------------
 drivers/staging/media/as102/as10x_cmd_cfg.c    |  9 ---------
 drivers/staging/media/as102/as10x_cmd_stream.c | 12 ------------
 8 files changed, 6 insertions(+), 123 deletions(-)

-- 
1.8.5.rc3

