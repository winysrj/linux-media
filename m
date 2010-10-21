Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:64635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab0JUOLg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 10:11:36 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9LEBZUt022089
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 10:11:35 -0400
Received: from pedra (vpn-225-164.phx2.redhat.com [10.3.225.164])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9LE9S5C022469
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 10:11:34 -0400
Date: Thu, 21 Oct 2010 12:07:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] Some cx231xx IR fixes
Message-ID: <20101021120749.5efa51fc@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series fix the remaining issues with IR for Polaris (cx231xx).
Basically, it adds another parser at mceusb, that works better with Polaris.
I think that the same parser may also work well for other devices.

Mauro Carvalho Chehab (4):
  [media] cx231xx: Fix compilation breakage if DVB is not selected
  [media] ir-raw-event: Fix a stupid error at a printk
  [media] mceusb: Improve parser to get codes sent together with IR RX data
  [media] mceusb: Fix parser for Polaris

 drivers/media/IR/ir-raw-event.c       |    2 +-
 drivers/media/IR/mceusb.c             |  300 +++++++++++++++++++++++----------
 drivers/media/video/cx231xx/cx231xx.h |    3 -
 3 files changed, 212 insertions(+), 93 deletions(-)

