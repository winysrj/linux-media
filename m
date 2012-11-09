Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39229 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab2KILSv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Nov 2012 06:18:51 -0500
Message-ID: <509CE687.7060501@ti.com>
Date: Fri, 9 Nov 2012 16:48:31 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: LMML <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR v3.8] Davinci VPBE feature enhancement and fixes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Can you please pull the following patches for Davinci VPBE driver.
The first patch fixes the build warnings for readl/writel, the second
patch migrates the driver to videobuf2 usage and the third patch set's
device caps.

Thanks and Regards,
--Prabhakar Lad


The following changes since commit 2cb654fd281e1929aa3b9f5f54f492135157a613:

  MAINTAINERS: add support for tea5761/tea5767 tuners (2012-11-02
12:09:00 -0200)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for_mauro

Lad, Prabhakar (3):
      media: davinci: vpbe: fix build warning
      media: davinci: vpbe: migrate driver to videobuf2
      media: davinci: vpbe: set device capabilities

 drivers/media/platform/davinci/Kconfig        |    2 +-
 drivers/media/platform/davinci/vpbe_display.c |  305
+++++++++++++++----------
 drivers/media/platform/davinci/vpbe_osd.c     |    9 +-
 include/media/davinci/vpbe_display.h          |   15 +-
 include/media/davinci/vpbe_osd.h              |    2 +-
 5 files changed, 199 insertions(+), 134 deletions(-)
