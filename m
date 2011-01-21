Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:34460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab1AUEal (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 23:30:41 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0L4UesO031307
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 23:30:40 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 0/3] i2c IR fixups
Date: Thu, 20 Jan 2011 23:30:22 -0500
Message-Id: <1295584225-21210-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

After these patches, both ir-kbd-i2c and lirc_zilog behave considerably
better with the HD-PVR and HVR-1950. I'd call the behavior of the 1950
perfect. The HD-PVR needs a touch more work, but these changes make
both RX and TX usable, its just a bit quirky still.

Jarod Wilson (3):
  hdpvr: fix up i2c device registration
  lirc_zilog: z8 on usb doesn't like back-to-back i2c_master_send
  ir-kbd-i2c: improve remote behavior with z8 behind usb

 drivers/media/video/hdpvr/hdpvr-core.c         |   21 ++++++++++++---
 drivers/media/video/hdpvr/hdpvr-i2c.c          |   28 +++++++++++++++------
 drivers/media/video/hdpvr/hdpvr.h              |    6 +++-
 drivers/media/video/ir-kbd-i2c.c               |   13 +++++++++
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    1 -
 drivers/staging/lirc/lirc_zilog.c              |   32 +++++++++++++++++++----
 6 files changed, 81 insertions(+), 20 deletions(-)

-- 
1.7.3.4

