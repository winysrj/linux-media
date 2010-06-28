Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0F1RA2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 13:00:28 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5SH0S3i000505
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 13:00:28 -0400
Received: from pedra (vpn-9-119.rdu.redhat.com [10.11.9.119])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o5SH0HGM008891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 13:00:27 -0400
Date: Mon, 28 Jun 2010 13:59:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] ir-core: Rename sysfs protocols nomenclature to rc-5
 and rc-6
Message-ID: <20100628135959.4b5c3137@pedra>
In-Reply-To: <cover.1277744236.git.mchehab@redhat.com>
References: <cover.1277744236.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While rc-5 and rc-6 protocols are generally abreviated as "rc5" and "rc6",
previous sysfs nodes uses rc-5 and rc-6 for the Philips protocols. This is
consistent with the protocol nomenclature given by the original Philips
spec: "Remote control system RC-5" (doc. Nr. 9398 706 23011).
Also, rc5 is the name of a widely known cryptography protocol.

So, the better is to keep referring to those protocols as "rc-5" and "rc-6".

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 2b1a9d2..9a464a3 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -38,9 +38,9 @@ static struct {
 	char	*name;
 } proto_names[] = {
 	{ IR_TYPE_UNKNOWN,	"unknown"	},
-	{ IR_TYPE_RC5,		"rc5"		},
+	{ IR_TYPE_RC5,		"rc-5"		},
 	{ IR_TYPE_NEC,		"nec"		},
-	{ IR_TYPE_RC6,		"rc6"		},
+	{ IR_TYPE_RC6,		"rc-6"		},
 	{ IR_TYPE_JVC,		"jvc"		},
 	{ IR_TYPE_SONY,		"sony"		},
 };
-- 
1.7.1


