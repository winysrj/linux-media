Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:51303 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbcGMMqU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 08:46:20 -0400
From: weiyj_lk@163.com
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH -next] [media] pulse8-cec: fix non static symbol warning
Date: Wed, 13 Jul 2016 12:45:00 +0000
Message-Id: <1468413900-2677-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/staging/media/pulse8-cec/pulse8-cec.c:427:27: warning:
 symbol 'pulse8_cec_adap_ops' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
index 7d6d5ee..94f8590 100644
--- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
+++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
@@ -424,7 +424,7 @@ static int pulse8_received(struct cec_adapter *adap, struct cec_msg *msg)
 	return -ENOMSG;
 }
 
-const struct cec_adap_ops pulse8_cec_adap_ops = {
+static const struct cec_adap_ops pulse8_cec_adap_ops = {
 	.adap_enable = pulse8_cec_adap_enable,
 	.adap_log_addr = pulse8_cec_adap_log_addr,
 	.adap_transmit = pulse8_cec_adap_transmit,


