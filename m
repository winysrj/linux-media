Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab1GMV0O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 17:26:14 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6DLQD9g013275
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 13 Jul 2011 17:26:14 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 0/3] redrat3 driver updates for 3.1
Date: Wed, 13 Jul 2011 17:26:04 -0400
Message-Id: <1310592367-11501-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These changes make the redrat3 driver cooperate better with both in-kernel
and lirc userspace decoding of signals, tested with RC5, RC6 and NEC.
There's probably more we can do to make this a bit less hackish, but its
working quite well here for me right now.

Jarod Wilson (3):
  [media] redrat3: sending extra trailing space was useless
  [media] redrat3: cap duration in the right place
  [media] redrat3: improve compat with lirc userspace decode

 drivers/media/rc/redrat3.c |   61 ++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 33 deletions(-)

