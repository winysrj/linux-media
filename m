Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:19023 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750759AbeEOEYC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 00:24:02 -0400
Date: Tue, 15 May 2018 12:23:33 +0800
From: kbuild test robot <lkp@intel.com>
To: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: Re: [PATCH] media: dvb-frontends: add Socionext SC1501A ISDB-S/T
 demodulator driver
Message-ID: <201805151022.Jp9guzZj%fengguang.wu@intel.com>
References: <20180515003749.9980-1-suzuki.katsuhiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180515003749.9980-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Katsuhiro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.17-rc5 next-20180514]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Katsuhiro-Suzuki/media-dvb-frontends-add-Socionext-SC1501A-ISDB-S-T-demodulator-driver/20180515-091453
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/dvb-frontends/sc1501a.c:313:47: sparse: constant 211243671486 is so big it is long

vim +313 drivers/media/dvb-frontends/sc1501a.c

   258	
   259	static int sc1501a_s_read_status(struct sc1501a_priv *chip,
   260					 struct dtv_frontend_properties *c,
   261					 enum fe_status *status)
   262	{
   263		struct regmap *r_s = chip->regmap_s;
   264		u32 cpmon, tmpu, tmpl, flg;
   265		u64 tmp;
   266	
   267		/* Sync detection */
   268		regmap_read(r_s, CPMON1_S, &cpmon);
   269	
   270		*status = 0;
   271		if (cpmon & CPMON1_S_FSYNC)
   272			*status |= FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
   273		if (cpmon & CPMON1_S_W2LOCK)
   274			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
   275	
   276		/* Signal strength */
   277		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
   278	
   279		if (*status & FE_HAS_SIGNAL) {
   280			u32 agc;
   281	
   282			regmap_read(r_s, AGCREAD_S, &tmpu);
   283			agc = tmpu << 8;
   284	
   285			c->strength.len = 1;
   286			c->strength.stat[0].scale = FE_SCALE_RELATIVE;
   287			c->strength.stat[0].uvalue = agc;
   288		}
   289	
   290		/* C/N rate */
   291		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
   292	
   293		if (*status & FE_HAS_VITERBI) {
   294			u32 cnr = 0, x, y, d;
   295			u64 d_3 = 0;
   296	
   297			regmap_read(r_s, CNRDXU_S, &tmpu);
   298			regmap_read(r_s, CNRDXL_S, &tmpl);
   299			x = (tmpu << 8) | tmpl;
   300			regmap_read(r_s, CNRDYU_S, &tmpu);
   301			regmap_read(r_s, CNRDYL_S, &tmpl);
   302			y = (tmpu << 8) | tmpl;
   303	
   304			/* CNR[dB]: 10 * log10(D) - 30.74 / D^3 - 3 */
   305			/*   D = x^2 / (2^15 * y - x^2) */
   306			d = (y << 15) - x * x;
   307			if (d > 0) {
   308				/* (2^4 * D)^3 = 2^12 * D^3 */
   309				/* 3.074 * 2^(12 + 24) = 211243671486 */
   310				d_3 = div_u64(16 * x * x, d);
   311				d_3 = d_3 * d_3 * d_3;
   312				if (d_3)
 > 313					d_3 = div_u64(211243671486, d_3);
   314			}
   315	
   316			if (d_3) {
   317				/* 0.3 * 2^24 = 5033164 */
   318				tmp = (s64)2 * intlog10(x) - intlog10(abs(d)) - d_3
   319					- 5033164;
   320				cnr = div_u64(tmp * 10000, 1 << 24);
   321			}
   322	
   323			if (cnr) {
   324				c->cnr.len = 1;
   325				c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
   326				c->cnr.stat[0].uvalue = cnr;
   327			}
   328		}
   329	
   330		/* BER */
   331		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
   332		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
   333	
   334		regmap_read(r_s, BERCNFLG_S, &flg);
   335	
   336		if ((*status & FE_HAS_VITERBI) && (flg & BERCNFLG_S_BERVRDY)) {
   337			u32 bit_err, bit_cnt;
   338	
   339			regmap_read(r_s, BERVRDU_S, &tmpu);
   340			regmap_read(r_s, BERVRDL_S, &tmpl);
   341			bit_err = (tmpu << 8) | tmpl;
   342			bit_cnt = (1 << 13) * 204;
   343	
   344			if (bit_cnt) {
   345				c->post_bit_error.len = 1;
   346				c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
   347				c->post_bit_error.stat[0].uvalue = bit_err;
   348				c->post_bit_count.len = 1;
   349				c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
   350				c->post_bit_count.stat[0].uvalue = bit_cnt;
   351			}
   352		}
   353	
   354		return 0;
   355	}
   356	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
