Return-path: <mchehab@localhost.localdomain>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3495 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab0ILU03 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 16:26:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] Remove V4L1 support from the pwc driver
Date: Sun, 12 Sep 2010 22:26:11 +0200
Cc: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009122226.11970.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Thanks to Hans de Goede for supplying me with a Philips webcam to test this
driver with!

And other news on the V4L1 front:

I have since learned that the stradis driver has only ever worked for kernel 2.2.
I did contact the company and unless they want to work on it this driver can be
removed soon.

I'm waiting for test results on the cpia2 driver. If it works, then the V4L1
support can be removed from that driver as well.

Regards,

	Hans

The following changes since commit 57fef3eb74a04716a8dd18af0ac510ec4f71bc05:
  Richard Zidlicky (1):
        V4L/DVB: dvb: fix smscore_getbuffer() logic

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git pwc

Hans Verkuil (1):
      pwc: fully convert driver to V4L2

 drivers/media/video/pwc/Kconfig          |    2 +-
 drivers/media/video/pwc/pwc-ctrl.c       |   20 +-
 drivers/media/video/pwc/pwc-if.c         |   23 +-
 drivers/media/video/pwc/pwc-misc.c       |    4 +-
 drivers/media/video/pwc/pwc-uncompress.c |    2 +-
 drivers/media/video/pwc/pwc-v4l.c        |  322 +-----------------------------
 drivers/media/video/pwc/pwc.h            |    6 +-
 7 files changed, 40 insertions(+), 339 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
