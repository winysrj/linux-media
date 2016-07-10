Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38717 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753584AbcGJNL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 09:11:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: lars@opdenkamp.eu
Subject: [PATCH 0/5] Pulse-Eight USB CEC driver
Date: Sun, 10 Jul 2016 15:11:16 +0200
Message-Id: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This adds support for the Pulse-Eight USB CEC dongle. It has been tested
with both v4 and v5 firmware.

It is still in staging because 1) the CEC framework it depends on is still in 
staging, 2) the code needs to be refactored a bit and 3) it needs more testing.

That said, it's in pretty decent shape. It's pretty neat, but I do wish it
would support a CEC bus snooping mode: that would make it an ideal CEC bus
sniffer. But I don't see any support for it, unfortunately.

If anyone knows how this can be achieved then please let me know!

Please note that this needs support from inputattach (part of linuxconsoletools),
a patch is included in the TODO file.

Regards,

	Hans

Hans Verkuil (5):
  cec: add check if adapter is unregistered.
  serio.h: add new define for the Pulse-Eight USB-CEC Adapter
  pulse8-cec: new driver for the Pulse-Eight USB-CEC Adapter
  MAINTAINERS: add entry for the pulse8-cec driver
  pulse8-cec: add TODO file

 MAINTAINERS                                   |   7 +
 drivers/staging/media/Kconfig                 |   2 +
 drivers/staging/media/Makefile                |   1 +
 drivers/staging/media/cec/cec-adap.c          |   5 +-
 drivers/staging/media/pulse8-cec/Kconfig      |  10 +
 drivers/staging/media/pulse8-cec/Makefile     |   1 +
 drivers/staging/media/pulse8-cec/TODO         |  35 ++
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 502 ++++++++++++++++++++++++++
 include/uapi/linux/serio.h                    |   1 +
 9 files changed, 563 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/media/pulse8-cec/Kconfig
 create mode 100644 drivers/staging/media/pulse8-cec/Makefile
 create mode 100644 drivers/staging/media/pulse8-cec/TODO
 create mode 100644 drivers/staging/media/pulse8-cec/pulse8-cec.c

-- 
2.8.1

