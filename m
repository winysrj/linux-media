Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab0BLGwu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 01:52:50 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1C6qnp9018149
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Feb 2010 01:52:50 -0500
Received: from [10.11.9.28] (vpn-9-28.rdu.redhat.com [10.11.9.28])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o1C6qlPW031982
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 12 Feb 2010 01:52:49 -0500
Message-ID: <4B74FABE.90703@redhat.com>
Date: Fri, 12 Feb 2010 04:52:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] tm6000: fix unlock unbalance
References: <4B74FA7F.5080507@redhat.com>
In-Reply-To: <4B74FA7F.5080507@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/staging/tm6000/tm6000-cards.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 8297801..c0159a1 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -496,6 +496,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 		}
 #endif
 	}
+	mutex_unlock(&dev->lock);
 	return 0;
 
 err2:
-- 
1.6.6.1


