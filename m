Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38737 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab0IJIXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 04:23:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L8I00456VAPUT80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Sep 2010 09:23:13 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8I007NXVAOAL@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Sep 2010 09:23:12 +0100 (BST)
Received: from [10.89.8.202] (unknown [106.116.37.23])
	by linux.samsung.com (Postfix) with ESMTP id E2E6B27007C	for
 <linux-media@vger.kernel.org>; Fri, 10 Sep 2010 10:19:47 +0200 (CEST)
Date: Fri, 10 Sep 2010 17:21:10 +0900
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [GIT FIXES FOR 2.6.36] mem2mem_testdev fixes
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-id: <4C89EA76.1020704@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Mauro,
please pull the below fixes for 2.6.36:

The following changes since commit 7e0e8c4f78e93136a2fb44cf46366e868fb75a10:

   v4l: radio: si470x: fix unneeded free_irq() call (2010-09-06 15:24:33 
+0900)

are available in the git repository at:
   git://git.infradead.org/users/kmpark/linux-2.6-samsung 
v4l/fixes_for_v2.6.36

Pawel Osciak (2):
       v4l: mem2mem_testdev: fix errorenous comparison
       v4l: mem2mem_testdev: add missing release for video_device

  drivers/media/video/mem2mem_testdev.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)


-- 
Best regards,
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
