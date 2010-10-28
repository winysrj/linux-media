Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab0J1Tqv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 15:46:51 -0400
Message-ID: <4CC9D31F.4080404@redhat.com>
Date: Thu, 28 Oct 2010 17:46:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Huang Shijie <shijie8@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Firmware for Telgent 2300 V4L/DVB driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi David,

Huang sent me a firmware file for Telgent 2300 some time ago, with the proper
redistribution rights from the manufacturer. Not sure why, but it seems that 
I forgot to add on my linux-next tree and to ask you to pull from it.

So, please pull it from my tree:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-firmware.git master

Thanks,
Mauro

---

The following changes since commit e9f9e3a9b7d780e93ae869c1b8502c843bfd93a4:

  wimax: update WiMAX firmwares for 2.6.35 (2010-09-29 12:02:34 +0900)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-firmware.git master

Mauro Carvalho Chehab (1):
      Add firmware for Telgent 2300 V4L/DVB driver

 WHENCE               |   16 ++++++++++++++++
 tlg2300_firmware.bin |  Bin 0 -> 51972 bytes
 2 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 tlg2300_firmware.bin
