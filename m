Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:40342 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876Ab0LWNkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 08:40:10 -0500
Subject: [GIT PULL for 2.6.38] ivtv and cx18 fixes
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 08:40:45 -0500
Message-ID: <1293111645.4900.6.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Mauro,

Please PULL what few changes I have presently for 2.6.38.  Any patches I
work over the Holidays, I don't think I can reasonably target for
2.6.38.

Merry Christmas.

Regards,
Andy
 

The following changes since commit dedb94adebe0fbdd9cafdbb170337810d8638bc9:

  [media] timblogiw: Fix a merge conflict with v4l2_i2c_new_subdev_board changes (2010-12-11 09:07:52 -0200)

are available in the git repository at:
  ssh://linuxtv.org/git/awalls/media_tree.git ivtv-cx18-for-38

Andy Walls (4):
      ivtv, cx18: Make ioremap failure messages more useful for users
      cx18: Only allocate a struct cx18_dvb for the DVB TS stream
      ivtv: ivtv_write_vbi() should use copy_from_user() for user data buffers
      ivtv: Return EFAULT when copy_from_user() fails in ivtv_write_vbi_from_user()

 drivers/media/video/cx18/cx18-driver.c  |    9 ++-
 drivers/media/video/cx18/cx18-driver.h  |    9 ++-
 drivers/media/video/cx18/cx18-dvb.c     |   32 +++++----
 drivers/media/video/cx18/cx18-mailbox.c |    6 +-
 drivers/media/video/cx18/cx18-streams.c |   45 ++++++++----
 drivers/media/video/cx18/cx18-streams.h |    3 +-
 drivers/media/video/ivtv/ivtv-driver.c  |   28 ++++++--
 drivers/media/video/ivtv/ivtv-fileops.c |    4 +-
 drivers/media/video/ivtv/ivtv-vbi.c     |  115 +++++++++++++++++++++----------
 drivers/media/video/ivtv/ivtv-vbi.h     |    5 +-
 10 files changed, 174 insertions(+), 82 deletions(-)



