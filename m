Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:35944 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaBTGvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 01:51:43 -0500
Received: by mail-vc0-f175.google.com with SMTP id ij19so1450366vcb.6
        for <linux-media@vger.kernel.org>; Wed, 19 Feb 2014 22:51:40 -0800 (PST)
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 20 Feb 2014 12:21:20 +0530
Message-ID: <CA+V-a8tq8AV+8dr07gE2nXywRnk1EY0VLxQ1ONZdv4hx6gEscQ@mail.gmail.com>
Subject: [GIT PULL FOR v3.15] Davinci VPFE Patches
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull the following patch for davinci vpfe driver.

Regards,
--Prabhakar Lad

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

  [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for_mauro

for you to fetch changes up to 01275d96c4a59e37835c345006fbaf2a02c04ccf:

  staging: davinci_vpfe: fix error check (2014-02-20 12:10:06 +0530)

----------------------------------------------------------------
Levente Kurusa (1):
      staging: davinci_vpfe: fix error check

 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
