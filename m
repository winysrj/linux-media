Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:23525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab0L0Qbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 11:31:52 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGVqoE000532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:31:52 -0500
Received: from gaivota (vpn-11-243.rdu.redhat.com [10.11.11.243])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGNDpK028091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:31:50 -0500
Date: Mon, 27 Dec 2010 14:22:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/8] Fix V4L/DVB/RC warnings
Message-ID: <20101227142250.48704ffe@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


There were several warnings at the subsystem, that were catched with
gcc version 4.5.1. All of them are fixed on those patches by a 
trivial patch. So, let's fix them ;)

Now, the only remaining patches are the ones we want to be there:

drivers/staging/lirc/lirc_i2c.c: In function ‘ir_probe’:
drivers/staging/lirc/lirc_i2c.c:431:3: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
drivers/staging/lirc/lirc_i2c.c:450:3: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
drivers/staging/lirc/lirc_i2c.c:479:9: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
drivers/staging/lirc/lirc_zilog.c: In function ‘ir_probe’:
drivers/staging/lirc/lirc_zilog.c:1199:2: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
drivers/media/video/cx88/cx88-i2c.c: In function ‘cx88_i2c_init’:
drivers/media/video/cx88/cx88-i2c.c:149:2: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)
drivers/media/video/cx88/cx88-vp3054-i2c.c: In function ‘vp3054_i2c_probe’:
drivers/media/video/cx88/cx88-vp3054-i2c.c:128:2: warning: ‘id’ is deprecated (declared at include/linux/i2c.h:356)

They are basically caused by lirc_i2c and lirc_zilog, that still needs
to use the legacy .id field at the I2C structs. Somebody with those
hardware, please fix it.

Thanks,
Mauro

-

Mauro Carvalho Chehab (8):
  [media] dmxdev: Fix a compilation warning due to a bad type
  [media] radio-wl1273: Fix two warnings
  [media] lirc_zilog: Fix a warning
  [media] dib7000m/dib7000p: Add support for TRANSMISSION_MODE_4K
  [media] gspca: Fix a warning for using len before filling it
  [media] stv090x: Fix some compilation warnings
  [media] af9013: Fix a compilation warning
  [media] streamzap: Fix a compilation warning when compiled builtin

 drivers/media/dvb/dvb-core/dmxdev.c    |    4 ++--
 drivers/media/dvb/frontends/af9013.c   |    2 +-
 drivers/media/dvb/frontends/dib7000m.c |   10 +++++-----
 drivers/media/dvb/frontends/dib7000p.c |   10 +++++-----
 drivers/media/dvb/frontends/stv090x.c  |    6 +++---
 drivers/media/radio/radio-wl1273.c     |    3 +--
 drivers/media/rc/streamzap.c           |    2 +-
 drivers/media/video/gspca/gspca.c      |    2 +-
 drivers/staging/lirc/lirc_zilog.c      |    1 -
 9 files changed, 19 insertions(+), 21 deletions(-)

-- 
1.7.3.4

