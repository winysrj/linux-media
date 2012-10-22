Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41156 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2JVM1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 08:27:30 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH RESEND 0/2] Davinci VPBE migration to vb2 and setting the device caps
Date: Mon, 22 Oct 2012 17:57:12 +0530
Message-Id: <1350908834-11619-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.lad@ti.com>

The first patch of the series migrates the VPBE driver to usage of
videobuf2 framework. Second patch sets the device caps.

Resending the series, since it didn't reach the DLOS mailing list.

Lad, Prabhakar (2):
  media: davinci: vpbe: migrate driver to videobuf2
  media: davinci: vpbe: set device capabilities

 drivers/media/platform/davinci/Kconfig        |    2 +-
 drivers/media/platform/davinci/vpbe_display.c |  305 +++++++++++++++----------
 include/media/davinci/vpbe_display.h          |   15 +-
 3 files changed, 194 insertions(+), 128 deletions(-)

-- 
1.7.4.1

