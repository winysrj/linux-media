Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1L3RhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 12:37:24 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUHbOJf025588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 12:37:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] tda18271c2dd: fix support for DVB-C
Date: Fri, 30 Dec 2011 15:37:13 -0200
Message-Id: <1325266633-7818-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <4EFDF1E4.9060703@googlemail.com>
References: <4EFDF1E4.9060703@googlemail.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Hartmut <e9hack@googlemail.com>:

> A break is missing before the default statement. Delivery systems for DVB-C result always
> in an error.

Reported-by: Hartmut <e9hack@googlemail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/tda18271c2dd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
index 0f8e962..f8933cf 100644
--- a/drivers/media/dvb/frontends/tda18271c2dd.c
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -1159,6 +1159,7 @@ static int set_params(struct dvb_frontend *fe,
 			Standard = HF_DVBC_7MHZ;
 		else
 			Standard = HF_DVBC_8MHZ;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.7.8.352.g876a6

