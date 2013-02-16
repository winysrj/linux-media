Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:56726 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab3BPVZs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 16:25:48 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 0/3] [media] redrat3: cleanup driver
Date: Sat, 16 Feb 2013 21:25:42 +0000
Message-Id: <cover.1361020108.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver has various minor issues and could be simpler.

Sean Young (3):
  [media] redrat3: limit periods to hardware limits
  [media] redrat3: remove memcpys and fix unaligned memory access
  [media] redrat3: missing endian conversions and warnings

 drivers/media/rc/redrat3.c |  457 +++++++++++++-------------------------------
 1 files changed, 130 insertions(+), 327 deletions(-)

-- 
1.7.2.5

