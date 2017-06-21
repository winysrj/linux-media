Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:14218
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750823AbdFULaM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 07:30:12 -0400
Date: Wed, 21 Jun 2017 13:30:07 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Daniel Scheller <d.scheller@gmx.net>
cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [ragnatech:media-tree 1869/1907] drivers/media/dvb-frontends/stv0367.c:3127:3-16:
 duplicated argument to & or | (fwd)
Message-ID: <alpine.DEB.2.20.1706211329160.3050@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that some of the constants on lines 3127 and on are the same as
the ones on lines 3134 and on.

julia

---------- Forwarded message ----------
Date: Wed, 21 Jun 2017 18:20:03 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [ragnatech:media-tree 1869/1907]
    drivers/media/dvb-frontends/stv0367.c:3127:3-16: duplicated argument to & or
     |

CC: kbuild-all@01.org
TO: Daniel Scheller <d.scheller@gmx.net>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org

tree:   git://git.ragnatech.se/linux media-tree
head:   76724b30f222067faf00874dc277f6c99d03d800
commit: dbbac11e1de1250ad39bbc15490c8614ac7f9def [1869/1907] [media] dvb-frontends/stv0367: add Digital Devices compatibility
:::::: branch date: 20 hours ago
:::::: commit date: 22 hours ago

>> drivers/media/dvb-frontends/stv0367.c:3127:3-16: duplicated argument to & or |
   drivers/media/dvb-frontends/stv0367.c:3128:3-16: duplicated argument to & or |
   drivers/media/dvb-frontends/stv0367.c:3128:19-33: duplicated argument to & or |
   drivers/media/dvb-frontends/stv0367.c:3129:3-17: duplicated argument to & or |
   drivers/media/dvb-frontends/stv0367.c:3129:20-35: duplicated argument to & or |

git remote add ragnatech git://git.ragnatech.se/linux
git remote update ragnatech
git checkout dbbac11e1de1250ad39bbc15490c8614ac7f9def
vim +3127 drivers/media/dvb-frontends/stv0367.c

dbbac11e Daniel Scheller 2017-03-29  3111
dbbac11e Daniel Scheller 2017-03-29  3112  	return 0;
dbbac11e Daniel Scheller 2017-03-29  3113  }
dbbac11e Daniel Scheller 2017-03-29  3114
dbbac11e Daniel Scheller 2017-03-29  3115  static const struct dvb_frontend_ops stv0367ddb_ops = {
dbbac11e Daniel Scheller 2017-03-29  3116  	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBT },
dbbac11e Daniel Scheller 2017-03-29  3117  	.info = {
dbbac11e Daniel Scheller 2017-03-29  3118  		.name			= "ST STV0367 DDB DVB-C/T",
dbbac11e Daniel Scheller 2017-03-29  3119  		.frequency_min		= 47000000,
dbbac11e Daniel Scheller 2017-03-29  3120  		.frequency_max		= 865000000,
dbbac11e Daniel Scheller 2017-03-29  3121  		.frequency_stepsize	= 166667,
dbbac11e Daniel Scheller 2017-03-29  3122  		.frequency_tolerance	= 0,
dbbac11e Daniel Scheller 2017-03-29  3123  		.symbol_rate_min	= 870000,
dbbac11e Daniel Scheller 2017-03-29  3124  		.symbol_rate_max	= 11700000,
dbbac11e Daniel Scheller 2017-03-29  3125  		.caps = /* DVB-C */
dbbac11e Daniel Scheller 2017-03-29  3126  			0x400 |/* FE_CAN_QAM_4 */
dbbac11e Daniel Scheller 2017-03-29 @3127  			FE_CAN_QAM_16 | FE_CAN_QAM_32  |
dbbac11e Daniel Scheller 2017-03-29  3128  			FE_CAN_QAM_64 | FE_CAN_QAM_128 |
dbbac11e Daniel Scheller 2017-03-29  3129  			FE_CAN_QAM_256 | FE_CAN_FEC_AUTO |
dbbac11e Daniel Scheller 2017-03-29  3130  			/* DVB-T */
dbbac11e Daniel Scheller 2017-03-29  3131  			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
dbbac11e Daniel Scheller 2017-03-29  3132  			FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
dbbac11e Daniel Scheller 2017-03-29  3133  			FE_CAN_FEC_AUTO |
dbbac11e Daniel Scheller 2017-03-29  3134  			FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
dbbac11e Daniel Scheller 2017-03-29  3135  			FE_CAN_QAM_128 | FE_CAN_QAM_256 | FE_CAN_QAM_AUTO |

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
