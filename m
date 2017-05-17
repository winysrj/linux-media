Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34637 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752796AbdEQRc5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 13:32:57 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] sir_ir fixes and update todo
Date: Wed, 17 May 2017 18:32:49 +0100
Message-Id: <cover.1495035457.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just some minor cleanups.

Sean Young (5):
  [media] sir_ir: attempt to free already free_irq
  [media] sir_ir: use dev managed resources
  [media] sir_ir: remove init_port and drop_port functions
  [media] sir_ir: remove init_chrdev and init_sir_ir functions
  [media] staging: remove todo and replace with lirc_zilog todo

 drivers/media/rc/sir_ir.c                  | 90 ++++++++++--------------------
 drivers/staging/media/lirc/TODO            | 47 ++++++++++++----
 drivers/staging/media/lirc/TODO.lirc_zilog | 36 ------------
 3 files changed, 63 insertions(+), 110 deletions(-)
 delete mode 100644 drivers/staging/media/lirc/TODO.lirc_zilog

-- 
2.9.4
