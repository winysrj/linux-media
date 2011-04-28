Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:43320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760532Ab1D1QFX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 12:05:23 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p3SG5Ngr011407
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Apr 2011 12:05:23 -0400
Date: Thu, 28 Apr 2011 12:05:22 -0400
From: Jarod Wilson <jarod@redhat.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL REQ] Late-breaking IR fixes for 2.6.39
Message-ID: <20110428160522.GA9001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

Please pull in these four changes (against Linus' tree) for 2.6.39. The
critical piece here is the imon patch, which fixes a nasty deadlock that
triggers when change_protocol is initiated from userspace (i.e., by
ir-keytable), followed by use of an imon device's display (or simply a
second change_protocol command).

The following changes since commit 97ddec65ff85a3226fb2856b4d93ebbcf097c28f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 (2011-04-19 12:46:32 -0700)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-ir.git/ for-2.6.39

Jarod Wilson (4):
      [media] mceusb: add Dell transceiver ID
      [media] ite-cir: modular build on ppc requires delay.h include
      [media] rc: show RC_TYPE_OTHER in sysfs
      [media] imon: add conditional locking in change_protocol

 drivers/media/rc/imon.c    |   31 +++++++++++++++++++++++++++----
 drivers/media/rc/ite-cir.c |    1 +
 drivers/media/rc/mceusb.c  |    2 ++
 drivers/media/rc/rc-main.c |    1 +
 4 files changed, 31 insertions(+), 4 deletions(-)

-- 
Jarod Wilson
jarod@redhat.com

