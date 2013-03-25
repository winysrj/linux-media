Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4969 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab3CYMDu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 08:03:50 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id r2PC3kZ7038523
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 13:03:49 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 322C711E0164
	for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 13:03:45 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] Two fixes
Date: Mon, 25 Mar 2013 13:03:45 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251303.45719.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two patches were part of this patch series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg59894.html

But I decided to split them off since they have nothing to do with the new
chip_name ioctl.

Regards,

	Hans

The following changes since commit c535cc6c714bd21b3afad35baa926b3b9eb51361:

  [media] staging: lirc_sir: remove dead code (2013-03-25 08:21:20 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git fixes

for you to fetch changes up to 54957d2a4225d22cf6014399f88e91b794f44522:

  DocBook media: fix syntax problems in dvbproperty.xml (2013-03-25 12:50:42 +0100)

----------------------------------------------------------------
Hans Verkuil (2):
      v4l2-common: remove obsolete check for ' at the end of a driver name.
      DocBook media: fix syntax problems in dvbproperty.xml

 Documentation/DocBook/media/dvb/dvbproperty.xml |   46 ++++++++++++++++++++++------------------------
 drivers/media/v4l2-core/v4l2-common.c           |    3 ---
 2 files changed, 22 insertions(+), 27 deletions(-)
