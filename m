Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:63735 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3ASN7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 08:59:36 -0500
Received: by mail-ee0-f43.google.com with SMTP id c50so2139955eek.30
        for <linux-media@vger.kernel.org>; Sat, 19 Jan 2013 05:59:35 -0800 (PST)
Message-ID: <50FAA6C4.9020606@gmail.com>
Date: Sat, 19 Jan 2013 14:59:32 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.8] Exynos/s5p driver fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

   Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:
   git://linuxtv.org/snawrocki/samsung.git v3.8-rc5-fixes

Kamil Debski (1):
       s5p-mfc: end-of-stream handling in encoder bug fix

Sylwester Nawrocki (2):
       s5p-fimc: Fix fimc-lite entities deregistration
       s5p-csis: Fix clock handling on error path in probe()

  drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
  drivers/media/platform/s5p-fimc/mipi-csis.c    |    2 +-
  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c   |    2 ++
  3 files changed, 4 insertions(+), 2 deletions(-)


pwclient update -s accepted 16223
pwclient update -s accepted 16206
pwclient update -s accepted 16314

--

Regards,
Sylwester
