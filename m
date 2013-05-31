Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3052 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3EaIsk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 04:48:40 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id r4V8mSgv025150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 31 May 2013 10:48:30 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 1CC6335E0400
	for <linux-media@vger.kernel.org>; Fri, 31 May 2013 10:48:21 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] Two fixes
Date: Fri, 31 May 2013 10:48:22 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305311048.22356.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 7eac97d7e714429f7ef1ba5d35f94c07f4c34f8e:

  [media] media: pci: remove duplicate checks for EPERM (2013-05-27 09:34:56 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.10c

for you to fetch changes up to 401d80f1829075f7073bb947f66472c6da719e12:

  cx88: fix NULL pointer dereference (2013-05-31 10:46:18 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      DocBook/media/v4l: update version number.
      cx88: fix NULL pointer dereference

 Documentation/DocBook/media/v4l/v4l2.xml |    2 +-
 drivers/media/pci/cx88/cx88-alsa.c       |    7 +++----
 drivers/media/pci/cx88/cx88-video.c      |    8 +++-----
 3 files changed, 7 insertions(+), 10 deletions(-)
