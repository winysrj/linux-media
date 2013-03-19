Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225Ab3CSQue (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:34 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 00/46] Add sms2270 support to siano driver
Date: Tue, 19 Mar 2013 13:48:49 -0300
Message-Id: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Back in September, 2011, Doron Cohen <doronc@siano-ms.com> submitted
a series of patches meant to add support for newer siano chipsets.

That series of patches had several pointed issues:
	- It were just a diff from Siano's internal git tree and
	  upstreamed one. Due to that, applying it would cause
	  regressions;

	- Among the regressions, the newer code would break
	  rc_core support, causing regressions for IR;

	- It also breaks support for Hauppauge devices with old
	  firmware (version 2.1);

	- It added support for a Siano proprietary API.

On that time, I waited for Doron to submit a newer patch series.
Unfortunately, this never happened.

As I received a sms2270 device, I decided to take some time
to understand the changes proposed by Dohen, port the ones that
are pertinent to upstream, and make it to work. I also took
care to fix it for older devices.

I also did a few clean ups on some bad things on it, and added
an experimental debugfs support, to allow displaying the complete
data inside the device's statistics reports. That helped to port
it to use the new DVBv5 stats.

There are still plenty of space to clean it up, like removing
the CamelCase and cleaning its structures. I won't doubt that
there are lots of unused stuff there at the core.

Anyway, with this patchset, both Hauppauge model 55009 Rev B1F7-02D
and an unbranded Siano Rio (187f:0600) device are working fine
on a x86, via USB interface. I didn't test it with arm or with
a big endian system.

As nobody is currently maintaining this driver, I'm also adding
a MAINTAINERS entry on this series, with "Odd fixes".

Mauro Carvalho Chehab (46):
  [media] siano: Change GPIO voltage setting names
  [media] siano: Add the new voltage definitions for GPIO
  [media] siano: remove a duplicated structure definition
  [media] siano: update message macros
  [media] siano: better debug send/receive messages
  [media] siano: add the remaining new defines from new driver
  [media] siano: Properly initialize board information
  [media] siano: add additional attributes to cards entries
  [media] siano: use USB endpoint descriptors for in/out endp
  [media] siano: store firmware version
  [media] siano: make load firmware logic to work with newer firmwares
  [media] siano: report the choosed firmware in debug
  [media] siano: fix the debug message
  [media] siano: always load smsdvb
  [media] siano: cleanups at smscoreapi.c
  [media] siano: add some new messages to the smscoreapi
  [media] siano: use a separate completion for stats
  [media] siano: add support for ISDB-T full-seg
  [media] siano: add support for LNA on ISDB-T
  [media] siano: use the newer stats message for recent firmwares
  [media] siano: add new devices to the Siano Driver
  [media] siano: Configure board's mtu and xtal
  [media] siano: call MSG_SMS_INIT_DEVICE_REQ
  [media] siano: simplify message endianness logic
  [media] siano: split get_frontend into per-std functions
  [media] siano: split debug logic from the status update routine
  [media] siano: Convert it to report DVBv5 stats
  [media] siano: fix start of statistics
  [media] siano: allow showing the complete statistics via debugfs
  [media] siano: split debugfs code into a separate file
  [media] siano: add two missing fields to ISDB-T stats debugfs
  [media] siano: don't request statistics too fast
  [media] siano: fix signal strength and CNR stats measurements
  [media] siano: fix PER/BER report on DVBv5
  [media] siano: Fix bandwidth report
  [media] siano: Only feed DVB data when there's a feed
  [media] siano: fix status report with old firmware and ISDB-T
  [media] siano: add support for .poll on debugfs
  [media] siano: simplify firmware lookup logic
  [media] siano: honour per-card default mode
  [media] siano: remove the bogus firmware lookup code
  [media] siano: reorder smscore_get_fw_filename() function
  [media] siano: add a MAINTAINERS entry for it
  [media] siano: remove a bogus printk line
  [media] siano: remove doubled new line
  [media] siano: Remove bogus complain about MSG_SMS_DVBT_BDA_DATA

 MAINTAINERS                                 |   11 +
 drivers/media/common/siano/Kconfig          |   12 +
 drivers/media/common/siano/Makefile         |    5 +
 drivers/media/common/siano/sms-cards.c      |   99 ++-
 drivers/media/common/siano/sms-cards.h      |   14 +
 drivers/media/common/siano/smscoreapi.c     |  918 +++++++++++++++-----
 drivers/media/common/siano/smscoreapi.h     |  607 ++++++++++---
 drivers/media/common/siano/smsdvb-debugfs.c |  554 ++++++++++++
 drivers/media/common/siano/smsdvb-main.c    | 1226 +++++++++++++++++++++++++++
 drivers/media/common/siano/smsdvb.c         | 1078 -----------------------
 drivers/media/common/siano/smsdvb.h         |  129 +++
 drivers/media/mmc/siano/smssdio.c           |   13 +
 drivers/media/usb/siano/smsusb.c            |  130 ++-
 13 files changed, 3373 insertions(+), 1423 deletions(-)
 create mode 100644 drivers/media/common/siano/smsdvb-debugfs.c
 create mode 100644 drivers/media/common/siano/smsdvb-main.c
 delete mode 100644 drivers/media/common/siano/smsdvb.c
 create mode 100644 drivers/media/common/siano/smsdvb.h

-- 
1.8.1.4

