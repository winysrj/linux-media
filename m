Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:49470 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab1ARNjI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 08:39:08 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
	Kevin Hilman <khilman@deeprootsystems.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v16 0/3] davinci vpbe: dm6446 v4l2 driver
Date: Tue, 18 Jan 2011 19:08:28 +0530
Message-Id: <1295357908-17478-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

version16 : addressed Sergei's comments
on:
1. Minor code change.
2. Interchanged the sequence of patches.

Signed-off-by: Manjunath Hadli <manjunath.hadli@xxxxxx>
Acked-by: Muralidharan Karicheri <m-karicheri2@xxxxxx>
Acked-by: Hans Verkuil <hverkuil@xxxxxxxxx>

Manjunath Hadli (3):
  davinci vpbe: changes to common files
  davinci vpbe: platform specific additions
  davinci vpbe: board specific additions

 arch/arm/mach-davinci/board-dm644x-evm.c      |   84 ++++++++++---
 arch/arm/mach-davinci/common.c                |    4 +-
 arch/arm/mach-davinci/devices.c               |   10 +-
 arch/arm/mach-davinci/dm644x.c                |  169 +++++++++++++++++++++++--
 arch/arm/mach-davinci/include/mach/dm644x.h   |    5 +
 arch/arm/mach-davinci/include/mach/hardware.h |    5 +
 6 files changed, 244 insertions(+), 33 deletions(-)

