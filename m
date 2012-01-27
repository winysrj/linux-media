Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:46924 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab2A0KNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 05:13:08 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: [GIT PULL] davinci vpif pull request
Date: Fri, 27 Jan 2012 10:12:59 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F7531744F4D@DBDE01.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
 Can you please pull the following patch for v3.3-rc1 which removes some unnecessary inclusion
 of machine specific header files from the main driver files?

 This patch has undergone sufficient review already. It is just a cleanup patch and I don't
 expect any functionality to break because of this. 

 Thanks and Regards,
-Manju


The following changes since commit 74ea15d909b31158f9b63190a95b52bc05586d4b:
  Linus Torvalds (1):
        Merge branch 'v4l_for_linus' of git://git.kernel.org/.../mchehab/linux-media


are available in the git repository at:


  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for-mauro-v3.3

Manjunath Hadli (1):
      davinci: vpif: remove machine specific header file inclusion from the driver


 drivers/media/video/davinci/vpif.h         |    2 --
 drivers/media/video/davinci/vpif_display.c |    2 --
 include/media/davinci/vpif_types.h         |    2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)
