Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:6623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138Ab1GKSpp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 14:45:45 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6BIjjf5002147
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 11 Jul 2011 14:45:45 -0400
Date: Mon, 11 Jul 2011 14:45:44 -0400
From: Jarod Wilson <jarod@redhat.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL] last-minute IR fixes for 3.0
Message-ID: <20110711184544.GA7245@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hey Mauro,

I know its late in the game, but after a weekend of testing here, and
feedback from other folks testing, I'd like to see if we can sneak a few
more minor changes into kernel 3.0. If not, these can probably all go in
via the stable tree later, but here they are... These changes greatly
improve the reliability of IR functionality for cx23885, mceusb and
nuvoton-cir users (the latter two primarily when using non-stock remotes
and lirc userspace decode -- RC5 and RC6 both work fine w/o this change).

The following changes since commit e3bbfa78bab125f58b831b5f7f45b5a305091d72:

  Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging (2011-07-10 10:24:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-ir.git/ for-3.0

Jarod Wilson (2):
      Revert "V4L/DVB: cx23885: Enable Message Signaled Interrupts(MSI)"
      [media] nuvoton-cir: make idle timeout more sane

Rafi Rubin (2):
      [media] mceusb: Timeout unit corrections
      [media] mceusb: increase default timeout to 100ms

 drivers/media/rc/mceusb.c                  |    9 +++++----
 drivers/media/rc/nuvoton-cir.c             |    2 +-
 drivers/media/video/cx23885/cx23885-core.c |    9 ++-------
 3 files changed, 8 insertions(+), 12 deletions(-)

-- 
Jarod Wilson
jarod@redhat.com

