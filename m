Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:56863 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226AbbAPMXx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 07:23:53 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B29DD2A002F
	for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 13:23:35 +0100 (CET)
Message-ID: <54B902C7.1040507@xs4all.nl>
Date: Fri, 16 Jan 2015 13:23:35 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v3.19] Fixes for 3.19
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 99f3cd52aee21091ce62442285a68873e3be833f:

  [media] vb2-vmalloc: Protect DMA-specific code by #ifdef CONFIG_HAS_DMA (2014-12-23 16:28:09 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19a

for you to fetch changes up to f490fe1a4b4cd0a6454db02e8459d30a2ff02c49:

  Fix Mygica T230 support (2015-01-16 13:07:28 +0100)

----------------------------------------------------------------
Jim Davis (1):
      media: tlg2300: disable building the driver

Jonathan McDowell (1):
      Fix Mygica T230 support

Matthias Schwarzott (1):
      cx23885: Split Hauppauge WinTV Starburst from HVR4400 card entry

 drivers/media/pci/cx23885/cx23885-cards.c | 23 +++++++++++++++++------
 drivers/media/pci/cx23885/cx23885-dvb.c   | 11 +++++++++++
 drivers/media/pci/cx23885/cx23885.h       |  1 +
 drivers/media/usb/dvb-usb/cxusb.c         |  2 +-
 drivers/staging/media/tlg2300/Kconfig     |  1 +
 5 files changed, 31 insertions(+), 7 deletions(-)
