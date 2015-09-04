Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36102 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbbIDUEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2015 16:04:33 -0400
Received: by lbcao8 with SMTP id ao8so16987879lbc.3
        for <linux-media@vger.kernel.org>; Fri, 04 Sep 2015 13:04:32 -0700 (PDT)
From: Maciek Borzecki <maciek.borzecki@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: maciek.borzecki@gmail.com
Subject: [PATCH 0/3] [media] staging: lirc: mostly checkpatch cleanups
Date: Fri,  4 Sep 2015 22:04:02 +0200
Message-Id: <cover.1441396162.git.maciek.borzecki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A tiny patch series that addresses warnings or errors identified by
checkpatch.

The patches were first submitted to driver-devel sometime in June.
While on driver-devel, Sudip Mukherjee helped to cleanup all
issues. I'm resending the set to linux-media so that they can be
picked up for the media tree.

The first patch fixes minor warning with unnecessary brakes around
single statement block. The second fixes non-tab indentation. The
third patch does away with a custom dprintk() in favor of dev_dbg and
pr_debug().


Maciek Borzecki (3):
  [media] staging: lirc: remove unnecessary braces
  [media] staging: lirc: fix indentation
  [media] staging: lirc: lirc_serial: use dynamic debugs

 drivers/staging/media/lirc/lirc_imon.c   |  8 ++++----
 drivers/staging/media/lirc/lirc_sasem.c  |  4 ++--
 drivers/staging/media/lirc/lirc_serial.c | 32 ++++++++++----------------------
 3 files changed, 16 insertions(+), 28 deletions(-)

-- 
2.5.1

