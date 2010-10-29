Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:25109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab0J2DFq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 23:05:46 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9T35jfP018367
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:05:46 -0400
Date: Thu, 28 Oct 2010 23:05:45 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] mceusb cleanups and new device support
Message-ID: <20101029030545.GA17238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Another round of mceusb patches...

Jarod Wilson (3):
      mceusb: add support for Conexant Hybrid TV RDU253S
      mceusb: fix up reporting of trailing space
      mceusb: buffer parsing fixups for 1st-gen device

 drivers/media/IR/mceusb.c               |   82  +++++++++++++++++++++----------
 1 files changed, 55 insertions(+), 27 deletions(-)

-- 
Jarod Wilson
jarod@redhat.com

