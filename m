Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:42961 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaCYFxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 01:53:22 -0400
Received: by mail-ve0-f180.google.com with SMTP id jz11so6921092veb.11
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 22:53:22 -0700 (PDT)
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 25 Mar 2014 11:22:52 +0530
Message-ID: <CA+V-a8tgUc3SFQYg3zjScE0opPx2d_zzK9KXeqjYQ4B+bUWkKg@mail.gmail.com>
Subject: [GIT PULL FOR v3.15] Davinci media fixes
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull the following patches which are fixes for various davinci
media drivers.

Thanks,
--Prabhakar Lad

The following changes since commit 8432164ddf7bfe40748ac49995356ab4dfda43b7:

  [media] Sensoray 2255 uses videobuf2 (2014-03-24 17:23:43 -0300)

are available in the git repository at:

  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for_mauro

for you to fetch changes up to ef981f26167ec6afc8c9038a99ed28a149bac819:

  staging: media: davinci: vpfe: make sure all the buffers are
released (2014-03-25 11:08:24 +0530)

----------------------------------------------------------------
Lad, Prabhakar (5):
      media: davinci: vpif_capture: fix releasing of active buffers
      media: davinci: vpif_display: fix releasing of active buffers
      media: davinci: vpbe_display: fix releasing of active buffers
      media: davinci: vpfe: make sure all the buffers unmapped and released
      staging: media: davinci: vpfe: make sure all the buffers are released

 drivers/media/platform/davinci/vpbe_display.c   |   16 ++++++++++-
 drivers/media/platform/davinci/vpfe_capture.c   |    2 ++
 drivers/media/platform/davinci/vpif_capture.c   |   34 +++++++++++++++-------
 drivers/media/platform/davinci/vpif_display.c   |   35 +++++++++++++++--------
 drivers/staging/media/davinci_vpfe/vpfe_video.c |   13 +++++++--
 5 files changed, 74 insertions(+), 26 deletions(-)
