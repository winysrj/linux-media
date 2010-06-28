Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0F1RAX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 13:00:23 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5SH0N9c031254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 13:00:23 -0400
Received: from pedra (vpn-9-119.rdu.redhat.com [10.11.9.119])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o5SH0HGJ008891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 13:00:22 -0400
Date: Mon, 28 Jun 2010 14:00:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] IR improvements to sysfs interface
Message-ID: <20100628140001.07a7f203@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes a few issues I noticed with the new /protocols syfs node.
The hole idea of having an unique node to control the protocols is a
good idea, but there are a few implementation troubles on it, that I
noticed when writing the userspace interface, at ir-keytable.

This patch series fixes those troubles, and are in-sync with the needed
userspace changes needed to support the new sysfs way.

Mauro Carvalho Chehab (4):
  ir-core: Remove magic numbers at the sysfs logic
  ir-core: Rename sysfs protocols nomenclature to rc-5 and rc-6
  ir-core: Add support for disabling all protocols
  ir-core: allow specifying multiple protocols at one open/write

 drivers/media/IR/ir-sysfs.c |  152 ++++++++++++++++++++-----------------------
 1 files changed, 71 insertions(+), 81 deletions(-)

