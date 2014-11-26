Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40048 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaKZGT7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 01:19:59 -0500
Received: by mail-pa0-f41.google.com with SMTP id rd3so2196301pab.28
        for <linux-media@vger.kernel.org>; Tue, 25 Nov 2014 22:19:58 -0800 (PST)
From: Takanari Hayama <taki@igel.co.jp>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 0/2] v4l: vsp1: crop and a single input issues
Date: Wed, 26 Nov 2014 15:19:50 +0900
Message-Id: <1416982792-11917-1-git-send-email-taki@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

We've found a couple of issues in VSP1 driver. Each issue is described
in each patch. They can be applied separetely.

Takanari Hayama (2):
  v4l: vsp1: Reset VSP1 RPF source address
  v4l: vsp1: Always enable virtual RPF when BRU is in use

 drivers/media/platform/vsp1/vsp1_rpf.c  | 15 +++++++++++++++
 drivers/media/platform/vsp1/vsp1_rwpf.h |  2 ++
 drivers/media/platform/vsp1/vsp1_wpf.c  | 11 ++++++-----
 3 files changed, 23 insertions(+), 5 deletions(-)

Best Regards,
Takanari Hayama
-- 
1.8.0

