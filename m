Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:42517 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3LKROc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 12:14:32 -0500
Received: by mail-we0-f175.google.com with SMTP id t60so6870920wes.34
        for <linux-media@vger.kernel.org>; Wed, 11 Dec 2013 09:14:30 -0800 (PST)
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 11 Dec 2013 22:44:10 +0530
Message-ID: <CA+V-a8uuS=cDFK2698OrAqKTZD3Uhuty6QUNgRdMQDmxuTCVeg@mail.gmail.com>
Subject: [GIT PULL FOR v3.14] DaVinci VPFE trivial fixes
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull the following patches for davinci vpfe driver.

Regards,
--Prabhakar Lad


The following changes since commit 989af88339db26345e23271dae1089d949c4a0f1:

  [media] v4l: vsp1: Add LUT support (2013-12-11 09:25:20 -0200)

are available in the git repository at:

  http://linuxtv.org/git/mhadli/v4l-dvb-davinci_devices.git for_mauro

for you to fetch changes up to 189ac0f9249a6d4856531ecc60b65f77f50210a0:

  staging: media: davinci_vpfe: Rewrite return statement in
vpfe_video.c (2013-12-11 22:32:12 +0530)

----------------------------------------------------------------
Lisa Nguyen (2):
      staging: media: davinci_vpfe: Remove spaces before semicolons
      staging: media: davinci_vpfe: Rewrite return statement in vpfe_video.c

 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    2 +-
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |    4 ++--
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)
