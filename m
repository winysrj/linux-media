Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4911 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab2JZIzT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Oct 2012 04:55:19 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id q9Q8tGnn084952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 26 Oct 2012 10:55:18 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id C2C8C5CE000B
	for <linux-media@vger.kernel.org>; Fri, 26 Oct 2012 10:55:15 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.7] adv7604: sync with the latest Cisco internal code
Date: Fri, 26 Oct 2012 10:55:14 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210261055.14654.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These patches are for 3.7: they fix a number of bugs that were fixed in the
internal Cisco tree since I posted the initial adv7604 driver.

This pull request contains the same code as the RFC patches:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg53949.html

Regards,

	Hans

The following changes since commit d92462401dde1effa04a51d0a15000e6246d2a43:

  [media] v4l2-ioctl: fix W=1 warnings (2012-10-07 10:19:50 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git adv

for you to fetch changes up to 59d24d5e73d30301c6f978b7f5608c8beb12ca8c:

  adv7604: restart STDI once if format is not found (2012-10-16 15:14:27 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      adv7604: cleanup references
      adv7604: Replace prim_mode by mode
      adv7604: use presets where possible.
      adv7604: restart STDI once if format is not found

 drivers/media/i2c/adv7604.c |  377 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------
 include/media/adv7604.h     |   21 ++++---
 2 files changed, 282 insertions(+), 116 deletions(-)
