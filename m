Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:60920 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab1ANNaw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 08:30:52 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v14 0/2] platform changes for DM6446 VPBE v4l2 driver
Date: Fri, 14 Jan 2011 19:00:44 +0530
Message-Id: <1295011844-891-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

version14 : addressed Shekhar's comments
on:
1. Implemetation of single io_remap of system module base address
2. Minor changes in the GPL comments

cover letter addition:
Need the 6 main driver patches for DM6446 VPBE v4l2 driver for build.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Manjunath Hadli (2):
  davinci vpbe: platform specific additions
  davinci vpbe: board specific additions

 arch/arm/mach-davinci/board-dm644x-evm.c      |   84 ++++++++++---
 arch/arm/mach-davinci/devices.c               |   11 +-
 arch/arm/mach-davinci/dm355.c                 |    3 +
 arch/arm/mach-davinci/dm365.c                 |    3 +
 arch/arm/mach-davinci/dm644x.c                |  167 +++++++++++++++++++++++--
 arch/arm/mach-davinci/dm646x.c                |    3 +
 arch/arm/mach-davinci/include/mach/dm644x.h   |   10 ++
 arch/arm/mach-davinci/include/mach/hardware.h |    5 +
 8 files changed, 253 insertions(+), 33 deletions(-)

