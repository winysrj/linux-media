Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:43139 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbbCIWLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 18:11:10 -0400
Received: by wevl61 with SMTP id l61so13696594wev.10
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2015 15:11:09 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] media: sh_vou: trivial cleanups
Date: Mon,  9 Mar 2015 22:10:50 +0000
Message-Id: <1425939052-6375-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Hi,

This series is trivial cleanup for sh_vou driver.

Cheers,
--Prabhakar Lad

Lad, Prabhakar (2):
  media: sh_vou: embed video_device
  media: sh_vou: use devres api

 drivers/media/platform/sh_vou.c | 72 ++++++++++-------------------------------
 1 file changed, 17 insertions(+), 55 deletions(-)

-- 
2.1.0

