Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41250 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab2KIMJE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Nov 2012 07:09:04 -0500
Message-ID: <509CF251.7060904@ti.com>
Date: Fri, 9 Nov 2012 17:38:49 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: LMML <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR v3.8] Davinci media: migration to common clock framework
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Can you please pull the following patch which migrates the media
drivers for Davinci to common clock framework usage.

Thanks and Regards,
--Prabhakar Lad


The following changes since commit 2cb654fd281e1929aa3b9f5f54f492135157a613:

  MAINTAINERS: add support for tea5761/tea5767 tuners (2012-11-02
12:09:00 -0200)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git davinci_media

Murali Karicheri (1):
      media:davinci: clk - {prepare/unprepare} for common clk

 drivers/media/platform/davinci/dm355_ccdc.c  |    8 ++++++--
 drivers/media/platform/davinci/dm644x_ccdc.c |   16 ++++++++++------
 drivers/media/platform/davinci/isif.c        |    5 ++++-
 drivers/media/platform/davinci/vpbe.c        |   10 +++++++---
 drivers/media/platform/davinci/vpif.c        |    8 ++++----
 5 files changed, 31 insertions(+), 16 deletions(-)
