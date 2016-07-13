Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46436
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbcGMKZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 06:25:07 -0400
Date: Wed, 13 Jul 2016 07:25:02 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL for v4.7] media fixes
Message-ID: <20160713072502.54cf9698@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.7-2

For two regression fixes:

  - A regression when handling VIDIOC_CROPCAP at the media core;
  - A regression at adv7604 that was ignoring pad number in subdev ops.

Thanks!
Mauro


The following changes since commit af8c34ce6ae32addda3788d54a7e340cad22516b:

  Linux 4.7-rc2 (2016-06-05 14:31:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.7-2

for you to fetch changes up to 6519c3d7b8621c9f4333c98ed4b703029b51ba79:

  [media] adv7604: Don't ignore pad number in subdev DV timings pad operations (2016-06-07 15:33:54 -0300)

----------------------------------------------------------------
media fixes for v4.7-rc7

----------------------------------------------------------------
Hans Verkuil (1):
      [media] v4l2-ioctl: fix stupid mistake in cropcap condition

Laurent Pinchart (1):
      [media] adv7604: Don't ignore pad number in subdev DV timings pad operations

Mauro Carvalho Chehab (1):
      Merge tag 'v4.7-rc2' into v4l_for_linus

 drivers/media/i2c/adv7604.c          | 46 +++++++++++++++++++++++++++---------
 drivers/media/v4l2-core/v4l2-ioctl.c |  2 +-
 2 files changed, 36 insertions(+), 12 deletions(-)




Thanks,
Mauro
