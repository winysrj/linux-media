Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab3D1Pr5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 11:47:57 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3SFluhs002331
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 11:47:57 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/9] drxk cleanups
Date: Sun, 28 Apr 2013 12:47:42 -0300
Message-Id: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While checking for log10 implementations at DVB code, I noticed
that drxk had its own implementation for it.

So, I decided to do a cleanup there, using the existing
implementation.

I also took some time to cleanup (most of) the remaining
checkpatch.pl compliants, as it really sucks to work on a
code that it is too polluted.

No functional changes should be noticed after applying
this patch series.

Assuming that 3.9-rc8 will be the final one, the patches on
this series are meant to be applied for Kernel 3.11.

Mauro Carvalho Chehab (9):
  [media] drxk_hard: don't re-implement log10
  [media] drxk_hard: Don't use CamelCase
  [media] drxk_hard: use pr_info/pr_warn/pr_err/... macros
  [media] drxk_hard: don't split strings across lines
  [media] drxk_hard: use usleep_range()
  [media] drxk_hard.h: Remove some alien comment markups
  [media] drxk_hard.h: don't use more than 80 columns
  [media] drxk_hard: remove needless parenthesis
  [media] drxk_hard: Remove most 80-cols checkpatch warnings

 drivers/media/dvb-frontends/drxk.h      |    2 +-
 drivers/media/dvb-frontends/drxk_hard.c | 3154 ++++++++++++++++---------------
 drivers/media/dvb-frontends/drxk_hard.h |  277 +--
 3 files changed, 1745 insertions(+), 1688 deletions(-)

-- 
1.8.1.4

