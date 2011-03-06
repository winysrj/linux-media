Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2575 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1CFMnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 07:43:40 -0500
Received: from tschai.localnet (105.84-48-119.nextgentel.com [84.48.119.105])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id p26Chc9f028202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 6 Mar 2011 13:43:39 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.39] Fix compile error/warnings
Date: Sun, 6 Mar 2011 13:43:32 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103061343.32705.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A bunch of trivial compile fixes for 2.6.39.

Regards,

	Hans

The following changes since commit 88a763df226facb74fdb254563e30e9efb64275c:

  [media] dw2102: prof 1100 corrected (2011-03-02 16:56:54 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git fixes

Hans Verkuil (6):
      tuner-xc2028.c: fix compile warning
      stv0367.c: fix compiler warning
      altera-ci.c: fix compiler warnings
      fmdrv_common.c: fix compiler warning
      cx88-alsa: fix compiler warning
      mantis_pci.c: fix ARM compile error.

 drivers/media/common/tuners/tuner-xc2028.c |    4 ++--
 drivers/media/dvb/frontends/stv0367.c      |    2 +-
 drivers/media/dvb/mantis/mantis_pci.c      |    1 +
 drivers/media/radio/wl128x/fmdrv_common.c  |    4 ++--
 drivers/media/video/cx23885/altera-ci.c    |    8 ++++----
 drivers/media/video/cx88/cx88-alsa.c       |    2 +-
 6 files changed, 11 insertions(+), 10 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
