Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4036 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaEMRdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 13:33:14 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id s4DHXAn6043379
	for <linux-media@vger.kernel.org>; Tue, 13 May 2014 19:33:13 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id EAA782A19A4
	for <linux-media@vger.kernel.org>; Tue, 13 May 2014 19:32:58 +0200 (CEST)
Message-ID: <5372574A.7010902@xs4all.nl>
Date: Tue, 13 May 2014 19:32:58 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] saa7134 fixes and vb2 conversion (with bisect
 fix)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Updated and rebased, fixing the embarrassing bisect problem, otherwise unchanged.

Regards,

	Hans


The following changes since commit 7ffd58ddab76969019098e97d687711451d32a3d:

  [media] v4l: Add 12-bit YUV 4:2:2 media bus pixel codes (2014-05-13 13:48:29 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.16f

for you to fetch changes up to 3581ec3e87ffaa9cda258948410528c807c4a2d7:

  saa7134: add saa7134_userptr module option to enable USERPTR (2014-05-13 19:30:05 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      saa7134: rename vbi/cap to vbi_vbq/cap_vbq
      saa7134: move saa7134_pgtable to saa7134_dmaqueue
      saa7134: convert to vb2
      saa7134: add saa7134_userptr module option to enable USERPTR

 drivers/media/pci/saa7134/Kconfig           |   4 +-
 drivers/media/pci/saa7134/saa7134-core.c    |  90 ++++++------
 drivers/media/pci/saa7134/saa7134-dvb.c     |  43 +++---
 drivers/media/pci/saa7134/saa7134-empress.c | 175 +++++++++--------------
 drivers/media/pci/saa7134/saa7134-ts.c      | 184 ++++++++++++++----------
 drivers/media/pci/saa7134/saa7134-vbi.c     | 114 +++++++--------
 drivers/media/pci/saa7134/saa7134-video.c   | 612 +++++++++++++++++++++++++++++---------------------------------------------------
 drivers/media/pci/saa7134/saa7134.h         | 100 +++++++------
 8 files changed, 578 insertions(+), 744 deletions(-)
