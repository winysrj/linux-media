Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:48895 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934360AbbHLHO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 03:14:58 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 741F22A0097
	for <linux-media@vger.kernel.org>; Wed, 12 Aug 2015 09:14:28 +0200 (CEST)
Message-ID: <55CAF254.50808@xs4all.nl>
Date: Wed, 12 Aug 2015 09:14:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] horus3a: fix compiler warning
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Shut up this compiler warning that I get during the daily build:

horus3a.c: In function 'horus3a_set_params':
horus3a.c:308:24: warning: 'rolloff' may be used uninitialized in this function [-Wmaybe-uninitialized]
     symbol_rate * (100 + rolloff), 200000) + 5;
                        ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/dvb-frontends/horus3a.c b/drivers/media/dvb-frontends/horus3a.c
index 5074305..000606a 100644
--- a/drivers/media/dvb-frontends/horus3a.c
+++ b/drivers/media/dvb-frontends/horus3a.c
@@ -285,6 +285,7 @@ static int horus3a_set_params(struct dvb_frontend *fe)
 			rolloff = 20;
 			break;
 		case ROLLOFF_AUTO:
+		default:
 			dev_err(&priv->i2c->dev,
 				"horus3a: auto roll-off is not supported\n");
 			return -EINVAL;
