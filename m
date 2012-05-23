Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:46735 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2EWJkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:40:10 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-43.cisco.com [10.54.92.43])
	by ams-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id q4N9e9nn029274
	for <linux-media@vger.kernel.org>; Wed, 23 May 2012 09:40:09 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.5] Fix a few compiler warnings
Date: Wed, 23 May 2012 11:39:20 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205231139.20864.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some more fixes for compiler warnings. It's for 3.5, but you can also postpone
it to 3.6.

Regards,

	Hans

The following changes since commit abed623ca59a7d1abed6c4e7459be03e25a90a1e:

  [media] radio-sf16fmi: add support for SF16-FMD (2012-05-20 16:10:05 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git warnings

for you to fetch changes up to 2e1ee67410000f4b5ec308e3d820034634381f5b:

  vino: fix compiler warnings (2012-05-23 11:36:56 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      saa7146_fops: remove unused variable.
      cx24110: fix compiler warning
      vino: fix compiler warnings

 drivers/media/common/saa7146_fops.c   |    5 -----
 drivers/media/dvb/frontends/cx24110.c |    4 ++--
 drivers/media/video/vino.c            |    4 ++--
 3 files changed, 4 insertions(+), 9 deletions(-)
