Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:17958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab0L3Lqb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 06:46:31 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBUBkV2I018671
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 06:46:31 -0500
Received: from gaivota (vpn-8-93.rdu.redhat.com [10.11.8.93])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBUBjLCl031659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 06:46:30 -0500
Date: Thu, 30 Dec 2010 09:45:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] Remove lirc_i2c driver
Message-ID: <20101230094512.3c29ad71@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This series remove lirc_i2c driver. The first patch just
adds a note to bttv-input. The next patches add two
parsers for two devices that are supported by lirc_i2c, but
not by ir-kbd-i2c. The last one finally drops lirc_i2c.

Mauro Carvalho Chehab (4):
  [media] bttv-input: Add a note about PV951 RC
  [media] cx88: Add RC logic for Leadtek PVR 2000
  [media] ivtv: Add Adaptec Remote Controller
  [media] Remove staging/lirc/lirc_i2c driver

 drivers/media/video/bt8xx/bttv-input.c |   12 +
 drivers/media/video/cx88/cx88-input.c  |   49 +++-
 drivers/media/video/ivtv/ivtv-i2c.c    |   34 ++-
 drivers/staging/lirc/Kconfig           |    7 -
 drivers/staging/lirc/Makefile          |    1 -
 drivers/staging/lirc/lirc_i2c.c        |  536 --------------------------------
 6 files changed, 93 insertions(+), 546 deletions(-)
 delete mode 100644 drivers/staging/lirc/lirc_i2c.c

-- 
1.7.3.4

