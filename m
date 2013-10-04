Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3798 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3JDKle (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 06:41:34 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id r94AfVnZ067438
	for <linux-media@vger.kernel.org>; Fri, 4 Oct 2013 12:41:33 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E0ECA2A0769
	for <linux-media@vger.kernel.org>; Fri,  4 Oct 2013 12:41:26 +0200 (CEST)
Message-ID: <524E9B56.5050008@xs4all.nl>
Date: Fri, 04 Oct 2013 12:41:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.12] Various fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The following changes since commit d10e8280c4c2513d3e7350c27d8e6f0fa03a5f71:

  [media] cx24117: use hybrid_tuner_request/release_state to share state between multiple instances (2013-10-03 07:40:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.12

for you to fetch changes up to 28b5399a1cee08c790d51896b53bc8a08c26edd5:

  saa7134: Fix crash when device is closed before streamoff (2013-10-04 12:40:56 +0200)

----------------------------------------------------------------
Gianluca Gennari (4):
      adv7842: fix compilation with GCC < 4.4.6
      adv7511: fix compilation with GCC < 4.4.6
      ad9389b: fix compilation with GCC < 4.4.6
      ths8200: fix compilation with GCC < 4.4.6

Simon Farnsworth (1):
      saa7134: Fix crash when device is closed before streamoff

Wei Yongjun (1):
      adv7511: fix error return code in adv7511_probe()

 drivers/media/i2c/ad9389b.c               | 15 ++++++---------
 drivers/media/i2c/adv7511.c               | 18 +++++++++---------
 drivers/media/i2c/adv7842.c               | 30 ++++++++++++------------------
 drivers/media/i2c/ths8200.c               | 12 ++++--------
 drivers/media/pci/saa7134/saa7134-video.c |  1 +
 5 files changed, 32 insertions(+), 44 deletions(-)
