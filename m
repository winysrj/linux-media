Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58501 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1LJJ06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 04:26:58 -0500
Received: by eaak14 with SMTP id k14so2076307eaa.19
        for <linux-media@vger.kernel.org>; Sat, 10 Dec 2011 01:26:57 -0800 (PST)
Message-ID: <4EE325DC.50907@gmail.com>
Date: Sat, 10 Dec 2011 10:26:52 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PATCHES FOR 3.2] Samsung driver fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a couple of fixes for samsung v4l2 drivers.
These patches are on top of my previous pull request:

http://patchwork.linuxtv.org/patch/8479/

Please pull for v3.2.

The following changes since commit 0f8fe5e4eb2f764bb04cece78eb58206018e5365:

  m5mols: Fix set_fmt to return proper pixel format code (2011-11-16 13:49:32 +0100)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-samsung v4l_samsung_fixes

Peter Korsgaard (1):
      s5p-mfc: fix s/H264/H263/ typo

Sylwester Nawrocki (2):
      s5p-fimc: Prevent lock up caused by incomplete H/W initialization
      s5p-fimc: Fix camera input configuration in subdev operations

Thomas Jarosch (1):
      m5mols: Fix logic in sanity check

 drivers/media/video/m5mols/m5mols_core.c    |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c |    1 +
 drivers/media/video/s5p-fimc/fimc-core.c    |    5 ++---
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)
---


Thanks,
--
Sylwester
