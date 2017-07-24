Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:63918 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751799AbdGXFCx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 01:02:53 -0400
Date: Mon, 24 Jul 2017 07:02:50 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Daniel Scheller <d.scheller@gmx.net>
cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [ragnatech:media-tree 2075/2144] drivers/media/dvb-frontends/stv0910.c:1185:2-8:
 preceding lock on line 1176 (fwd)
Message-ID: <alpine.DEB.2.20.1707240700321.3169@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is a lock release needed before line 1185?  Is the !enable in line 1189
correct?  If the code is correct as is, perhaps it could be good to add
some comments.

julia

---------- Forwarded message ----------
Date: Mon, 24 Jul 2017 12:55:30 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [ragnatech:media-tree 2075/2144]
    drivers/media/dvb-frontends/stv0910.c:1185:2-8: preceding lock on line 1176

CC: kbuild-all@01.org
TO: Daniel Scheller <d.scheller@gmx.net>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org

tree:   git://git.ragnatech.se/linux media-tree
head:   0e50e84a11f4854e9a7e3b7f4443ffb99e6be292
commit: cd21b334943719f880e707eb91895fc916a88000 [2075/2144] media: dvb-frontends: add ST STV0910 DVB-S/S2 demodulator frontend driver
:::::: branch date: 3 days ago
:::::: commit date: 4 days ago

>> drivers/media/dvb-frontends/stv0910.c:1185:2-8: preceding lock on line 1176

git remote add ragnatech git://git.ragnatech.se/linux
git remote update ragnatech
git checkout cd21b334943719f880e707eb91895fc916a88000
vim +1185 drivers/media/dvb-frontends/stv0910.c

cd21b334 Daniel Scheller 2017-07-03  1168
cd21b334 Daniel Scheller 2017-07-03  1169
cd21b334 Daniel Scheller 2017-07-03  1170  static int gate_ctrl(struct dvb_frontend *fe, int enable)
cd21b334 Daniel Scheller 2017-07-03  1171  {
cd21b334 Daniel Scheller 2017-07-03  1172  	struct stv *state = fe->demodulator_priv;
cd21b334 Daniel Scheller 2017-07-03  1173  	u8 i2crpt = state->i2crpt & ~0x86;
cd21b334 Daniel Scheller 2017-07-03  1174
cd21b334 Daniel Scheller 2017-07-03  1175  	if (enable)
cd21b334 Daniel Scheller 2017-07-03 @1176  		mutex_lock(&state->base->i2c_lock);
cd21b334 Daniel Scheller 2017-07-03  1177
cd21b334 Daniel Scheller 2017-07-03  1178  	if (enable)
cd21b334 Daniel Scheller 2017-07-03  1179  		i2crpt |= 0x80;
cd21b334 Daniel Scheller 2017-07-03  1180  	else
cd21b334 Daniel Scheller 2017-07-03  1181  		i2crpt |= 0x02;
cd21b334 Daniel Scheller 2017-07-03  1182
cd21b334 Daniel Scheller 2017-07-03  1183  	if (write_reg(state, state->nr ? RSTV0910_P2_I2CRPT :
cd21b334 Daniel Scheller 2017-07-03  1184  		      RSTV0910_P1_I2CRPT, i2crpt) < 0)
cd21b334 Daniel Scheller 2017-07-03 @1185  		return -EIO;
cd21b334 Daniel Scheller 2017-07-03  1186
cd21b334 Daniel Scheller 2017-07-03  1187  	state->i2crpt = i2crpt;
cd21b334 Daniel Scheller 2017-07-03  1188
cd21b334 Daniel Scheller 2017-07-03  1189  	if (!enable)
cd21b334 Daniel Scheller 2017-07-03  1190  		mutex_unlock(&state->base->i2c_lock);
cd21b334 Daniel Scheller 2017-07-03  1191  	return 0;
cd21b334 Daniel Scheller 2017-07-03  1192  }
cd21b334 Daniel Scheller 2017-07-03  1193

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
