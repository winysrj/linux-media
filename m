Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:61550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab1BONev (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 08:34:51 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1FDYppH008703
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 08:34:51 -0500
Received: from pedra (vpn-239-107.phx2.redhat.com [10.3.239.107])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1FDXmP0005481
	for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 08:34:50 -0500
Date: Tue, 15 Feb 2011 11:33:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] Additional cleanups to tuner-core
Message-ID: <20110215113337.42919870@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans Verkuils gave me some feedback about the last series at the
ML, and, due to that, I've added a few more cleanup patches at
the series.

Basically, he poined me two issues: 

- DIGITAL_TV is not used at tuner core;
- tuner_lookup shouldn't touch at t->standby.

This series cleans the code to address the above issues, and also
do a few other cleanups to better document the code, without changing
any functionality.

I also extended my tests with some other devices. The tuner-core was
tested with:
	- cx88: Pixelview Ultra Pro: A TNF analog tuner + tea5767;
	- em28xx: WinTV USB2: an analog tuner with tda9887;
	- em28xx: HVR950: xc2028 based tuner;
	- cx231xx: Pixelview SBTVD Hybrid: tda18271 tuner.

On all the tests, tuner-core behave well. So, I'm committing the entire
tuner-core series of patches, for people to test them with other devices,
but, based on my tests, I don't think that the changes would cause any
regressions.

Mauro Carvalho Chehab (4):
  [media] tuner-core: remove usage of DIGITAL_TV
  [media] tuner-core: Improve function documentation
  [media] tuner-core: Rearrange some functions to better document
  [media] tuner-core: Don't touch at standby during tuner_lookup

 drivers/media/video/au0828/au0828-cards.c   |    3 +-
 drivers/media/video/bt8xx/bttv-cards.c      |    2 +-
 drivers/media/video/cx88/cx88-cards.c       |    4 +-
 drivers/media/video/saa7134/saa7134-cards.c |    4 +-
 drivers/media/video/tuner-core.c            |  310 ++++++++++++++++++---------
 5 files changed, 209 insertions(+), 114 deletions(-)

