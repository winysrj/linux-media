Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61299 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaK0BZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 20:25:09 -0500
Received: by mail-pd0-f178.google.com with SMTP id g10so3854355pdj.37
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 17:25:08 -0800 (PST)
From: Takanari Hayama <taki@igel.co.jp>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 0/2] v4l: vsp1: crop and a single input issues
Date: Thu, 27 Nov 2014 10:25:00 +0900
Message-Id: <1417051502-30169-1-git-send-email-taki@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've updated patches to reflect comments from Geert and Sergei.
Hope this version could be given a go.

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

