Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab2HERon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 13:44:43 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q75HihCC015363
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 5 Aug 2012 13:44:43 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] Some additional az6007 cleanup patches
Date: Sun,  5 Aug 2012 14:44:36 -0300
Message-Id: <1344188679-8247-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those are mostly cleanup patches. With regards to suspend/resume,
this is not working properly yet. I suspect that it is due to the lack
of dvb-usb-v2 support for reset_resume. So, document it.

Mauro Carvalho Chehab (3):
  [media] az6007: rename "st" to "state" at az6007_power_ctrl()
  [media] az6007: make all functions static
  [media] az6007: handle CI during suspend/resume

 drivers/media/dvb/dvb-usb-v2/az6007.c | 37 +++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

-- 
1.7.11.2

