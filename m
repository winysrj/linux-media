Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43586 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752933AbdI1NEG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 09:04:06 -0400
Date: Thu, 28 Sep 2017 16:03:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mats Randgaard <matrandg@cisco.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: tc358743: remove an unneeded condition
Message-ID: <20170928130354.jzh2tawjkymd4xri@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We can remove the check for if "state->cec_adap" is NULL.  The
cec_allocate_adapter() function never returns NULL and also we verified
that "state->cec_adap" is an error pointer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index e1d8eef7055e..6bbe112be267 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -2122,7 +2122,7 @@ static int tc358743_probe(struct i2c_client *client,
 		state, dev_name(&client->dev),
 		CEC_CAP_DEFAULTS | CEC_CAP_MONITOR_ALL, CEC_MAX_LOG_ADDRS);
 	if (IS_ERR(state->cec_adap)) {
-		err = state->cec_adap ? PTR_ERR(state->cec_adap) : -ENOMEM;
+		err = PTR_ERR(state->cec_adap);
 		goto err_hdl;
 	}
 	irq_mask |= MASK_CEC_RMSK | MASK_CEC_TMSK;
