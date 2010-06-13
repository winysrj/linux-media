Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:46112 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab0FMU3a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 16:29:30 -0400
Subject: [PATCH 0/2] ir-core: raw decoder framework changes
To: jarod@wilsonet.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@redhat.com, linux-media@vger.kernel.org, mchehab@redhat.com,
	linux-input@vger.kernel.org
Date: Sun, 13 Jun 2010 22:29:25 +0200
Message-ID: <20100613202718.6044.29599.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following two patches implement the same ir raw decoder centralization
changes I've proposed before, but now with some changes (client register
and unregister callbacks have been fixed wrt. module load order and
kept around) for lirc "decoding"...

---

David Härdeman (2):
      ir-core: centralize sysfs raw decoder enabling/disabling
      ir-core: move decoding state to ir_raw_event_ctrl


 drivers/media/IR/ir-core-priv.h    |   41 ++++++
 drivers/media/IR/ir-jvc-decoder.c  |  152 +---------------------
 drivers/media/IR/ir-nec-decoder.c  |  151 +---------------------
 drivers/media/IR/ir-raw-event.c    |  166 +++++++++++++-----------
 drivers/media/IR/ir-rc5-decoder.c  |  165 ++----------------------
 drivers/media/IR/ir-rc6-decoder.c  |  154 +---------------------
 drivers/media/IR/ir-sony-decoder.c |  155 ++--------------------
 drivers/media/IR/ir-sysfs.c        |  252 +++++++++++++++++++++---------------
 8 files changed, 334 insertions(+), 902 deletions(-)

-- 
David Härdeman
