Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab0FEAV2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 20:21:28 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o550LS7W018680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:28 -0400
Received: from pedra (vpn-10-9.rdu.redhat.com [10.11.10.9])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o550LI7n015252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:26 -0400
Date: Fri, 4 Jun 2010 21:21:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/6] tm6000: some fixes plus alsa improvements
Message-ID: <20100604212110.6654d25b@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes a few compilation troubles with tm6000, caused by
recent patches, and adds an alsa callback to allow it to fill the audio
buffers.

The current code there is just a printk code, but finishing it should be
trivial (assuming that the audio buffers are properly filled).

Mauro Carvalho Chehab (6):
  tm6000: Fix compilation breakages
  tm6000: Avoid OOPS when loading tm6000-alsa module
  tm6000-alsa: rework audio buffer allocation/deallocation
  tm6000: Use an emum for extension type
  tm6000: Add a callback code for buffer fill
  tm6000: avoid unknown symbol tm6000_debug

 drivers/staging/tm6000/tm6000-alsa.c        |   81 +++++++++++++++++----------
 drivers/staging/tm6000/tm6000-cards.c       |    1 -
 drivers/staging/tm6000/tm6000-core.c        |   20 ++++++-
 drivers/staging/tm6000/tm6000-dvb.c         |   12 ++--
 drivers/staging/tm6000/tm6000-video.c       |    3 +-
 drivers/staging/tm6000/tm6000.h             |   19 +++---
 6 files changed, 86 insertions(+), 50 deletions(-)
 mode change 100644 => 100755 Documentation/video4linux/extract_xc3028.pl

