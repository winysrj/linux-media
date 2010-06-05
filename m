Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab0FEAVa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 20:21:30 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o550LUO5015176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:30 -0400
Received: from pedra (vpn-10-9.rdu.redhat.com [10.11.10.9])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o550LI7o015252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:28 -0400
Date: Fri, 4 Jun 2010 21:21:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/6] tm6000: avoid unknown symbol tm6000_debug
Message-ID: <20100604212104.5a17276b@pedra>
In-Reply-To: <cover.1275696910.git.mchehab@redhat.com>
References: <cover.1275696910.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported by Stefan Ringel.

Thanks-to: Stefan Ringel <stefan.ringel@arcor.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index c0d6f6a..34e8ef5 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -56,6 +56,7 @@ static int video_nr = -1;		/* /dev/videoN, -1 for autodetect */
 
 /* Debug level */
 int tm6000_debug;
+EXPORT_SYMBOL_GPL(tm6000_debug);
 
 /* supported controls */
 static struct v4l2_queryctrl tm6000_qctrl[] = {
-- 
1.7.1

