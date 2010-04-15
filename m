Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52179 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab0DOVqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 17:46:40 -0400
Subject: [PATCH 8/8] ir-core: fix some confusing comments
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Date: Thu, 15 Apr 2010 23:46:35 +0200
Message-ID: <20100415214635.14142.52670.stgit@localhost.localdomain>
In-Reply-To: <20100415214520.14142.56114.stgit@localhost.localdomain>
References: <20100415214520.14142.56114.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix some confusing comments in drivers/media/IR/*

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/ir-keytable.c |    2 +-
 drivers/media/IR/ir-sysfs.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index b8baf8f..de923fc 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -1,4 +1,4 @@
-/* ir-register.c - handle IR scancode->keycode tables
+/* ir-keytable.c - handle IR scancode->keycode tables
  *
  * Copyright (C) 2009 by Mauro Carvalho Chehab <mchehab@redhat.com>
  *
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 876baae..501dc2f 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -1,4 +1,4 @@
-/* ir-register.c - handle IR scancode->keycode tables
+/* ir-sysfs.c - sysfs interface for RC devices (/sys/class/rc)
  *
  * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
  *

