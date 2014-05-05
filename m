Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28219 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaEETDX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 May 2014 15:03:23 -0400
Date: Mon, 5 May 2014 22:02:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [linuxtv-samsung:for-v3.16 45/81]
 drivers/media/dvb-frontends/si2168.c:47 si2168_cmd_execute() warn: add some
 parenthesis here?
Message-ID: <20140505190256.GP4963@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


tree:   git://linuxtv.org/snawrocki/samsung.git for-v3.16
head:   13b46c7a03adbcc347b77a13ed27066bc92d515c
commit: 192292403147877c7d5f737a3cc751ded397aef7 [45/81] [media] em28xx: add [2013:025f] PCTV tripleStick (292e)

drivers/media/dvb-frontends/si2168.c:47 si2168_cmd_execute() warn: add some parenthesis here?
drivers/media/dvb-frontends/si2168.c:47 si2168_cmd_execute() warn: maybe use && instead of &
drivers/media/tuners/si2157.c:44 si2157_cmd_execute() warn: add some parenthesis here?
drivers/media/tuners/si2157.c:44 si2157_cmd_execute() warn: maybe use && instead of &

git remote add linuxtv-samsung git://linuxtv.org/snawrocki/samsung.git
git remote update linuxtv-samsung
git checkout 192292403147877c7d5f737a3cc751ded397aef7
vim +47 drivers/media/dvb-frontends/si2168.c

845f3505 Antti Palosaari 2014-04-10  31  				goto err_mutex_unlock;
845f3505 Antti Palosaari 2014-04-10  32  			} else if (ret != cmd->rlen) {
845f3505 Antti Palosaari 2014-04-10  33  				ret = -EREMOTEIO;
845f3505 Antti Palosaari 2014-04-10  34  				goto err_mutex_unlock;
845f3505 Antti Palosaari 2014-04-10  35  			}
845f3505 Antti Palosaari 2014-04-10  36  
845f3505 Antti Palosaari 2014-04-10  37  			/* firmware ready? */
845f3505 Antti Palosaari 2014-04-10  38  			if ((cmd->args[0] >> 7) & 0x01)
845f3505 Antti Palosaari 2014-04-10  39  				break;
845f3505 Antti Palosaari 2014-04-10  40  		}
845f3505 Antti Palosaari 2014-04-10  41  
845f3505 Antti Palosaari 2014-04-10  42  		dev_dbg(&s->client->dev, "%s: cmd execution took %d ms\n",
845f3505 Antti Palosaari 2014-04-10  43  				__func__,
845f3505 Antti Palosaari 2014-04-10  44  				jiffies_to_msecs(jiffies) -
845f3505 Antti Palosaari 2014-04-10  45  				(jiffies_to_msecs(timeout) - TIMEOUT));
845f3505 Antti Palosaari 2014-04-10  46  
845f3505 Antti Palosaari 2014-04-10 @47  		if (!(cmd->args[0] >> 7) & 0x01) {

This should be:						if (!((md->args[0] >> 7) & 0x01)) {
Otherwise it is a precedence error where it does the negate before the
bitwise AND.

845f3505 Antti Palosaari 2014-04-10  48  			ret = -ETIMEDOUT;
845f3505 Antti Palosaari 2014-04-10  49  			goto err_mutex_unlock;
845f3505 Antti Palosaari 2014-04-10  50  		}
845f3505 Antti Palosaari 2014-04-10  51  	}
845f3505 Antti Palosaari 2014-04-10  52  
845f3505 Antti Palosaari 2014-04-10  53  	ret = 0;
845f3505 Antti Palosaari 2014-04-10  54  
845f3505 Antti Palosaari 2014-04-10  55  err_mutex_unlock:

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
