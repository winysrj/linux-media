Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49899 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab2AKLkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 06:40:14 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: [GIT PULL] davinci vpif pull request
Date: Wed, 11 Jan 2012 11:39:59 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F7501B481@DBDE01.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
  Can you please pull the following patch which removes some unnecessary inclusion
  of machine specific header files from the main driver files?
 
  This patch has undergone sufficient review already. It is just a cleanup patch and I don't
  expect any functionality to break because of this. The reason I did not club this with the
  3 previous patches was because one of the previous patches on which this is dependent,
  is now pulled in by Arnd.

 Thanks and Regards,
-Manju

 
The following changes since commit e343a895a9f342f239c5e3c5ffc6c0b1707e6244:
  Linus Torvalds (1):
        Merge tag 'for-linus' of git://git.kernel.org/.../mst/vhost

are available in the git repository at:

  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for-mauro-v3.3

Manjunath Hadli (1):
      davinci: vpif: remove machine specific header file inclusion from the driver

 drivers/media/video/davinci/vpif.h         |    2 --
 drivers/media/video/davinci/vpif_display.c |    2 --
 include/media/davinci/vpif_types.h         |    2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)
