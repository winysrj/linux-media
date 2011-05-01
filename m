Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43681 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab1EAJRQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 05:17:16 -0400
Date: Sun, 1 May 2011 04:17:10 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dan Carpenter <error27@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Andi Huber <hobrom@gmx.at>,
	Marlon de Boer <marlon@hyves.nl>,
	Damien Churchill <damoxc@gmail.com>
Subject: [PATCH v2.6.38 resend 0/7] cx88 deadlock and data races
Message-ID: <20110501091710.GA18263@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Since v2.6.37 (BKL removal), trying to open a cx88-blackbird driven
MPEG device would hang.  Ben Hutchings provided an initial patch[1] to
fix that, and Andi Huber helped a lot in finding races that patch had
missed.  Ben requested that I take authorship of the series, so I've
done so.

These patches have visited the list twice before[2], towards the
beginning of this month.  No feedback from maintainers or reviewers
--- I'm beginning to wonder if I have the right list.  Luckily two
people[3][4] experiencing this problem on bugzilla were kind enough to
test the series and found it worked okay.

Patches are against v2.6.38 (but they do not conflict with anything in
media-tree/staging/for_v2.6.40).  The intent is to include them in
v2.6.40 if possible.  A copy of these patches is also available for
convenient fetching from

  git://repo.or.cz/linux-2.6/jrn.git cx88-locking

Thoughts?

Jonathan Nieder (7):
  [media] cx88: protect per-device driver list with device lock
  [media] cx88: fix locking of sub-driver operations
  [media] cx88: hold device lock during sub-driver initialization
  [media] cx88: protect cx8802_devlist with a mutex
  [media] cx88: gracefully reject attempts to use unregistered
    cx88-blackbird driver
  [media] cx88: don't use atomic_t for core->mpeg_users
  [media] cx88: don't use atomic_t for core->users

 drivers/media/video/cx88/cx88-blackbird.c |   41 +++++++++++++++-------------
 drivers/media/video/cx88/cx88-dvb.c       |    2 +
 drivers/media/video/cx88/cx88-mpeg.c      |   40 ++++++++++++++++++----------
 drivers/media/video/cx88/cx88-video.c     |    5 ++-
 drivers/media/video/cx88/cx88.h           |   11 +++++--
 5 files changed, 61 insertions(+), 38 deletions(-)

[1] http://bugs.debian.org/619827
[2] http://thread.gmane.org/gmane.linux.kernel/1118815
[3] https://bugzilla.kernel.org/show_bug.cgi?id=31792
[4] https://bugzilla.kernel.org/show_bug.cgi?id=31962
