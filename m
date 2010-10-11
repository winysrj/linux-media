Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:61777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab0JKPjS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:39:18 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9BFdHSg001660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 11:39:17 -0400
Received: from pedra (vpn-225-124.phx2.redhat.com [10.3.225.124])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9BFdDOV032640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 11:39:16 -0400
Date: Mon, 11 Oct 2010 12:37:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] tm6000 locking fixes
Message-ID: <20101011123720.6a99b316@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There are a number of locking issues at tm6000 driver.

This series fixes those locking issues. After them, both mplayer and tvtime
are not causing panic/oops, even if I call it via a remote machine.

Unfortunately, my HVR-900H died (probably due to overheat), so I can't 
test anymore the tm6010 alsa fixes, but, on the tests I did with tm6000, the
start/stop of audio is not causing OOPS/Panic anymore (yet, some extra init
is needed for tm6000 to have audio).

Mauro Carvalho Chehab (4):
  tm6000: don't use BKL at the driver
  V4L/DVB: tm6000-alsa: fix some locking issues
  V4L/DVB: Use just one lock for devlist
  V4L/DVB: tm6000: fix resource locking

 drivers/media/video/cx231xx/cx231xx-cards.c |    2 +
 drivers/staging/tm6000/tm6000-alsa.c        |   46 +++++++++++++---
 drivers/staging/tm6000/tm6000-cards.c       |    3 -
 drivers/staging/tm6000/tm6000-core.c        |   15 ++----
 drivers/staging/tm6000/tm6000-video.c       |   77 +++++++++++++++++----------
 drivers/staging/tm6000/tm6000.h             |    7 ++-
 6 files changed, 98 insertions(+), 52 deletions(-)

