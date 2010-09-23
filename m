Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0IWEgN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 00:36:13 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8N4aDkW018758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 23 Sep 2010 00:36:13 -0400
Received: from pedra (vpn-239-203.phx2.redhat.com [10.3.239.203])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o8N4X3mg018821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 23 Sep 2010 00:36:12 -0400
Date: Thu, 23 Sep 2010 01:32:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] get rid of i2c_adapter.id on ir-kbd-i2c
Message-ID: <20100923013257.299fceb9@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

ir-kdb-i2c needs to check what device called it, just because of two
places where this information is used:

1) to fill the structs for Hauppauge XDR remotes on cx88 driver;
2) to set the polling interval for one saa7134 board.

On both cases, the better is to just move the initialization to the
caller driver.

While on it, move PV951 to bttv driver, as only bttv driver defines
a board with this name, and put the RC init code inside bttv-input,
for bttv driver, and on cx88-input, for cx88 driver, in order to
have all RC code together.

This will help when porting the drivers to RC core, as we won't forget
the ir-kbd-i2c case.

Mauro Carvalho Chehab (3):
  V4L/DVB: bttv: Move PV951 IR to the right driver
  V4L/DVB: Remove the usage of I2C_HW_B_CX2388x on ir-kbd-i2c.c
  V4L/DVB: saa7134: get rid of I2C_HW_SAA7134

 drivers/media/video/bt8xx/bttv-i2c.c        |   38 ------------
 drivers/media/video/bt8xx/bttv-input.c      |   84 ++++++++++++++++++++++++--
 drivers/media/video/bt8xx/bttv.h            |    1 -
 drivers/media/video/bt8xx/bttvp.h           |   13 +++-
 drivers/media/video/cx88/cx88-i2c.c         |   38 ------------
 drivers/media/video/cx88/cx88-input.c       |   51 +++++++++++++++--
 drivers/media/video/cx88/cx88.h             |   15 ++---
 drivers/media/video/ir-kbd-i2c.c            |   60 ++-----------------
 drivers/media/video/saa7134/saa7134-i2c.c   |    1 -
 drivers/media/video/saa7134/saa7134-input.c |    5 ++
 include/media/ir-kbd-i2c.h                  |   10 ++-
 11 files changed, 155 insertions(+), 161 deletions(-)

