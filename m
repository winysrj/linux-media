Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44742 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbaKEKeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 05:34:12 -0500
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 87EA12A0432
	for <linux-media@vger.kernel.org>; Wed,  5 Nov 2014 11:34:06 +0100 (CET)
Message-ID: <5459FD11.1000903@xs4all.nl>
Date: Wed, 05 Nov 2014 11:33:53 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] Sparse warning fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:

  [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git sparse

for you to fetch changes up to acccdfd5898bfc3047febd3275015796874c760c:

  ti-vpe: fix sparse warnings (2014-11-05 11:32:58 +0100)

----------------------------------------------------------------
Hans Verkuil (6):
      bttv: fix sparse warning
      videobuf: fix sparse warnings
      smipcie: fix sparse warnings
      stk1160: fix sparse warning
      cxusb: fix sparse warnings
      ti-vpe: fix sparse warnings

 drivers/media/pci/bt8xx/bttv-cards.c    | 6 +++---
 drivers/media/pci/smipcie/smipcie.c     | 4 ++--
 drivers/media/platform/ti-vpe/csc.c     | 2 +-
 drivers/media/platform/ti-vpe/sc.c      | 2 +-
 drivers/media/usb/dvb-usb/cxusb.c       | 4 ++--
 drivers/media/usb/stk1160/stk1160-v4l.c | 2 +-
 drivers/media/v4l2-core/videobuf-core.c | 6 ++++--
 7 files changed, 14 insertions(+), 12 deletions(-)
