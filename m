Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:43987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1AFT5b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jan 2011 14:57:31 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p06JvUix007319
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 6 Jan 2011 14:57:31 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 0/6] First round of IR fixes for 2.6.38
Date: Thu,  6 Jan 2011 14:57:13 -0500
Message-Id: <1294343839-31784-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Mostly relatively small, but also fairly important, fixups for 2.6.38.
The ene_ir and imon driver are both prone to probe oops following the
rc dev interface refactoring, and there are ugly little bugs in each of
the mceusb and imon drivers, which I'll send off for 2.6.37 stable as
well...

Patches are against linuxtv.org media_tree staging/for_2.6.38-rc1 branch.

Jarod Wilson (5):
  rc/imon: fix ffdc device detection oops
  rc/imon: need to submit urb before ffdc type check
  rc/imon: default to key mode instead of mouse mode
  rc: fix up and genericize some time unit conversions
  rc/mceusb: timeout should be in ns, not us

Kyle McMartin (1):
  rc/ene_ir: fix oops on module load

 drivers/media/rc/ene_ir.c |   23 ++++++++++------
 drivers/media/rc/ene_ir.h |    2 -
 drivers/media/rc/imon.c   |   60 +++++++++++++++++++-------------------------
 drivers/media/rc/mceusb.c |    3 +-
 include/media/rc-core.h   |    3 ++
 5 files changed, 44 insertions(+), 47 deletions(-)

-- 
1.7.3.4

