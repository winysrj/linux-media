Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030307Ab3FTOLc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 10:11:32 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5KEBW0w004471
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 10:11:32 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] Fix a few troubles with the media subsystem
Date: Thu, 20 Jun 2013 11:11:26 -0300
Message-Id: <1371737488-14395-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After the change to use IS_ENABLED() everywhere, we started to notice
some troubles with randconfigs, that weren't that trivial to discover
what actually caused them.

Today, I finally found some time to dig into it. I found actually
two problems.

This small patch series should fix them. Those patches should go
to Kernel 3.10, as they solve some issues there.

Mauro Carvalho Chehab (2):
  [media] s5p makefiles: don't override other selections on obj-[ym]
  [media] Fix build when drivers are builtin and frontend modules

 drivers/media/Kconfig                    | 12 +++++++++---
 drivers/media/platform/s5p-jpeg/Makefile |  2 +-
 drivers/media/platform/s5p-mfc/Makefile  |  2 +-
 drivers/media/tuners/Kconfig             | 20 --------------------
 4 files changed, 11 insertions(+), 25 deletions(-)

-- 
1.8.1.4

