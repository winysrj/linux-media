Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34924 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbcFSMby (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2016 08:31:54 -0400
Received: by mail-wm0-f68.google.com with SMTP id a66so2753066wme.2
        for <linux-media@vger.kernel.org>; Sun, 19 Jun 2016 05:31:53 -0700 (PDT)
From: Mathias Krause <minipli@googlemail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Brad Spengler <spender@grsecurity.net>,
	PaX Team <pageexec@freemail.hu>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/3] dma-buf: debugfs fixes
Date: Sun, 19 Jun 2016 14:31:28 +0200
Message-Id: <1466339491-12639-1-git-send-email-minipli@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This small series is the v2 of the patch posted initially here:

  http://www.spinics.net/lists/linux-media/msg101347.html

It not only fixes the type mix-up and addresses Daniel's remark (patch 1),
it also smoothes out the error handling in dma_buf_init_debugfs() (patch 2)
and removes the then unneeded function dma_buf_debugfs_create_file() (patch
3).

Please apply!

Mathias Krause (3):
  dma-buf: propagate errors from dma_buf_describe() on debugfs read
  dma-buf: remove dma_buf directory on bufinfo file creation errors
  dma-buf: remove dma_buf_debugfs_create_file()

 drivers/dma-buf/dma-buf.c |   44 ++++++++++++++------------------------------
 include/linux/dma-buf.h   |    2 --
 2 files changed, 14 insertions(+), 32 deletions(-)

-- 
1.7.10.4

