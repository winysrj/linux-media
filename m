Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:51666 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1AQOMx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 09:12:53 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
	Kevin Hilman <khilman@deeprootsystems.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v15 0/3] davinci vpbe: dm6446 v4l2 driver
Date: Mon, 17 Jan 2011 19:42:15 +0530
Message-Id: <1295273535-14036-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

version15 : addressed Sergei and Shekhar's comments
on:
1. Moving the ioremap of DAVINCI_SYSTEM_MODULE_BASE to common.c
2. Moving the DM644X #defines to Dm644x.c
3. Removed the initializer for field inversion parameter.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Manjunath Hadli (3):
  davinci vpbe: platform specific additions
  davinci vpbe: board specific additions
  davinci vpbe: changes to common files

 arch/arm/mach-davinci/board-dm644x-evm.c      |   84 ++++++++++---
 arch/arm/mach-davinci/common.c                |    4 +-
 arch/arm/mach-davinci/devices.c               |   10 +-
 arch/arm/mach-davinci/dm644x.c                |  169 +++++++++++++++++++++++--
 arch/arm/mach-davinci/include/mach/dm644x.h   |    5 +
 arch/arm/mach-davinci/include/mach/hardware.h |    5 +
 6 files changed, 244 insertions(+), 33 deletions(-)

