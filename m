Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4150 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab0LaPhC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 10:37:02 -0500
Received: from durdane.localnet (marune.xs4all.nl [82.95.89.49])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBVFatuJ083973
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 31 Dec 2010 16:37:00 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.38] Compile warning fixes
Date: Fri, 31 Dec 2010 16:36:55 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012311636.56040.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This should make the daily build give us some OKs.

Regards,

	Hans

The following changes since commit 187134a5875df20356f4dca075db29f294115a47:
  David Henningsson (1):
        [media] DVB: IR support for TechnoTrend CT-3650

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git compile-fixes

Hans Verkuil (4):
      ngene: fix compile warning
      tda18218: fix compile warning
      zoran: fix compiler warning
      v4l2-compat-ioctl32: fix compile warning

 drivers/media/common/tuners/tda18218.c    |    2 +-
 drivers/media/dvb/ngene/ngene-core.c      |    3 ++-
 drivers/media/video/v4l2-compat-ioctl32.c |    4 ----
 drivers/media/video/zoran/zoran_driver.c  |    1 +
 4 files changed, 4 insertions(+), 6 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
