Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1301 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2EFPXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 11:23:54 -0400
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215] (may be forged))
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id q46FNqTH008074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sun, 6 May 2012 17:23:54 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 05D63FB40007
	for <linux-media@vger.kernel.org>; Sun,  6 May 2012 17:23:52 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.5] update the pms driver to the latest V4L2 frameworks
Date: Sun, 6 May 2012 17:23:51 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205061723.52017.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch updates the pms driver to use the latest V4L2 frameworks.

I could run v4l2-compliance to check that everything is working API-wise.
Unfortunately I can no longer actually capture any video. The last time
I tested it I had a very very old and very slow PC that I rescued from the
scrapheap. That PC is long gone and I'm now testing on a Pentium 4 on what
is probably one of the last motherboards that still supported ISA slots.

Frankly, I think this pms card can only capture on very old PCs.

I would like to get this update in so that this at least is not lost. And
perhaps we should finally retire this driver for 3.6. The only use it still
has for me is that I can probably use it to test the saa7191 driver when I
update that one. Too bad I can't actually capture any video anymore.

Regards,

	Hans

The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:

  [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git pms

for you to fetch changes up to fc9745b2820f731f3b066e6c9fe4ce4819c78ebd:

  pms: update to the latest V4L2 frameworks. (2012-05-06 15:41:54 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      pms: update to the latest V4L2 frameworks.

 drivers/media/video/pms.c |  237 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------
 1 file changed, 123 insertions(+), 114 deletions(-)
