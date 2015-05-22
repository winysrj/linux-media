Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51875 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbbEVN7v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 09:59:51 -0400
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 78DC42A0085
	for <linux-media@vger.kernel.org>; Fri, 22 May 2015 15:59:45 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/11] cobalt bug fixes, fixes for compiler/sparse warnings
Date: Fri, 22 May 2015 15:59:33 +0200
Message-Id: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series fixes two bugs in the cobalt driver and a pile of
compiler and sparse fixes (mostly in cobalt as well).

Regards,

	Hans

Hans Verkuil (11):
  cobalt: fix irqs used for the adv7511 transmitter
  cobalt: fix 64-bit division link error
  cobalt: fix compiler warnings on 32 bit OSes
  e4000: fix compiler warning
  cobalt: fix sparse warnings
  cobalt: fix sparse warnings
  cobalt: fix sparse warnings
  cobalt: fix sparse warnings
  cobalt: fix sparse warnings
  cx24120: fix sparse warning
  saa7164: fix sparse warning

 drivers/media/dvb-frontends/cx24120.c     |   2 +-
 drivers/media/pci/cobalt/cobalt-cpld.c    |   6 +-
 drivers/media/pci/cobalt/cobalt-driver.c  |  18 ++-
 drivers/media/pci/cobalt/cobalt-driver.h  |  22 +--
 drivers/media/pci/cobalt/cobalt-flash.c   |  18 +--
 drivers/media/pci/cobalt/cobalt-i2c.c     |  56 +++----
 drivers/media/pci/cobalt/cobalt-irq.c     |  58 ++++----
 drivers/media/pci/cobalt/cobalt-omnitek.c |  12 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c    | 235 ++++++++++++++++--------------
 drivers/media/pci/saa7164/saa7164-i2c.c   |   2 +-
 drivers/media/tuners/e4000.c              |   2 +-
 11 files changed, 229 insertions(+), 202 deletions(-)

-- 
2.1.4

