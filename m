Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab1G0U3w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 16:29:52 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6RKTq7w017670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 16:29:52 -0400
Received: from localhost.localdomain (vpn-227-4.phx2.redhat.com [10.3.227.4])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6RKTkxx009397
	for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 16:29:51 -0400
Date: Wed, 27 Jul 2011 17:29:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] A few DRX-K fixes
Message-ID: <20110727172934.11f95919@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first patch fixes a bug when DVB-K registration fails, potentially
causing an OOPS at the caller driver.
The second one is a debug printk message fix.
The last one fixes a typo a the driver.

All patches are trivial.

Mauro Carvalho Chehab (3):
  [media] drxk: Fix error return code during drxk init
  [media] drxk: Fix read debug message
  [media] drxk: Fix the logic that selects between DVB-C annex A and C

 drivers/media/dvb/frontends/drxk_hard.c |   73 ++++++++++++++-----------------
 1 files changed, 33 insertions(+), 40 deletions(-)

