Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:50232 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3CQL4z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Mar 2013 07:56:55 -0400
Received: by mail-ea0-f182.google.com with SMTP id q15so2099936ead.27
        for <linux-media@vger.kernel.org>; Sun, 17 Mar 2013 04:56:54 -0700 (PDT)
Message-ID: <5145AF83.3010403@gmail.com>
Date: Sun, 17 Mar 2013 12:56:51 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.9 v2] Samsung media driver fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 9f225788cc047fb7c2ef2326eb4f86dee890e2ef:

   Merge branch 'merge' of 
git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2013-03-05 
18:56:22 -0800)

are available in the git repository at:

   git://linuxtv.org/snawrocki/samsung.git v3.9-fixes

Andrzej Hajda (1):
       m5mols: Fix bug in stream on handler

Arun Kumar K (2):
       s5p-mfc: Fix frame skip bug
       s5p-mfc: Fix encoder control 15 issue

Shaik Ameer Basha (4):
       fimc-lite: Initialize 'step' field in fimc_lite_ctrl structure
       fimc-lite: Fix the variable type to avoid possible crash
       exynos-gsc: send valid m2m ctx to gsc_m2m_job_finish
       s5p-fimc: send valid m2m ctx to fimc_m2m_job_finish

Sylwester Nawrocki (1):
       s5p-fimc: Do not attempt to disable not enabled media pipeline

  drivers/media/i2c/m5mols/m5mols_core.c          |    2 +-
  drivers/media/platform/exynos-gsc/gsc-core.c    |    8 +++--
  drivers/media/platform/s5p-fimc/fimc-core.c     |    6 ++-
  drivers/media/platform/s5p-fimc/fimc-lite-reg.c |    8 ++--
  drivers/media/platform/s5p-fimc/fimc-lite.c     |    1 +
  drivers/media/platform/s5p-fimc/fimc-mdevice.c  |   39 
+++++++++++------------
  drivers/media/platform/s5p-mfc/s5p_mfc.c        |    2 +-
  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |    1 +
  8 files changed, 36 insertions(+), 31 deletions(-)

The pwclient commands:

pwclient update -s accepted 17149
pwclient update -s accepted 16930
pwclient update -s accepted 16931
pwclient update -s superseded 17153
pwclient update -s accepted 16652
pwclient update -s accepted 16653
pwclient update -s accepted 16954
pwclient update -s accepted 17134
pwclient update -s accepted 17150

---

Thanks,
Sylwester
