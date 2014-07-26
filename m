Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1843 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaGZOlv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 10:41:51 -0400
Date: Sat, 26 Jul 2014 22:41:36 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 499/499]
 drivers/media/dvb-frontends/drx39xyj/drxj.c:12072:21: warning: unused
 variable 'uio_data'
Message-ID: <53d3be20.4G4/o+pELwn6NubW%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   b601fe5688ae285693c64e833003c14acb38378a
commit: b601fe5688ae285693c64e833003c14acb38378a [499/499] [media] media: drx39xyj - use drxj_set_lna_state() and remove duplicate LNA code
config: make ARCH=i386 allyesconfig

All warnings:

   drivers/media/dvb-frontends/drx39xyj/drxj.c: In function 'drx39xxj_set_frontend':
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:12072:21: warning: unused variable 'uio_data' [-Wunused-variable]
     struct drxuio_data uio_data;
                        ^
   drivers/media/dvb-frontends/drx39xyj/drxj.c: In function 'drx39xxj_set_lna':
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:12230:21: warning: unused variable 'uio_data' [-Wunused-variable]
     struct drxuio_data uio_data;
                        ^
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:12229:20: warning: unused variable 'uio_cfg' [-Wunused-variable]
     struct drxuio_cfg uio_cfg;
                       ^
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:12224:6: warning: unused variable 'result' [-Wunused-variable]
     int result;
         ^

vim +/uio_data +12072 drivers/media/dvb-frontends/drx39xyj/drxj.c

19013747 Mauro Carvalho Chehab 2014-01-24  12066  	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
19013747 Mauro Carvalho Chehab 2014-01-24  12067  	struct drx39xxj_state *state = fe->demodulator_priv;
19013747 Mauro Carvalho Chehab 2014-01-24  12068  	struct drx_demod_instance *demod = state->demod;
19013747 Mauro Carvalho Chehab 2014-01-24  12069  	enum drx_standard standard = DRX_STANDARD_8VSB;
19013747 Mauro Carvalho Chehab 2014-01-24  12070  	struct drx_channel channel;
19013747 Mauro Carvalho Chehab 2014-01-24  12071  	int result;
19013747 Mauro Carvalho Chehab 2014-01-24 @12072  	struct drxuio_data uio_data;
19013747 Mauro Carvalho Chehab 2014-01-24  12073  	static const struct drx_channel def_channel = {
19013747 Mauro Carvalho Chehab 2014-01-24  12074  		/* frequency      */ 0,
19013747 Mauro Carvalho Chehab 2014-01-24  12075  		/* bandwidth      */ DRX_BANDWIDTH_6MHZ,
19013747 Mauro Carvalho Chehab 2014-01-24  12076  		/* mirror         */ DRX_MIRROR_NO,
19013747 Mauro Carvalho Chehab 2014-01-24  12077  		/* constellation  */ DRX_CONSTELLATION_AUTO,
19013747 Mauro Carvalho Chehab 2014-01-24  12078  		/* hierarchy      */ DRX_HIERARCHY_UNKNOWN,
19013747 Mauro Carvalho Chehab 2014-01-24  12079  		/* priority       */ DRX_PRIORITY_UNKNOWN,
19013747 Mauro Carvalho Chehab 2014-01-24  12080  		/* coderate       */ DRX_CODERATE_UNKNOWN,
19013747 Mauro Carvalho Chehab 2014-01-24  12081  		/* guard          */ DRX_GUARD_UNKNOWN,
19013747 Mauro Carvalho Chehab 2014-01-24  12082  		/* fftmode        */ DRX_FFTMODE_UNKNOWN,
19013747 Mauro Carvalho Chehab 2014-01-24  12083  		/* classification */ DRX_CLASSIFICATION_AUTO,
19013747 Mauro Carvalho Chehab 2014-01-24  12084  		/* symbolrate     */ 5057000,
19013747 Mauro Carvalho Chehab 2014-01-24  12085  		/* interleavemode */ DRX_INTERLEAVEMODE_UNKNOWN,
19013747 Mauro Carvalho Chehab 2014-01-24  12086  		/* ldpc           */ DRX_LDPC_UNKNOWN,
19013747 Mauro Carvalho Chehab 2014-01-24  12087  		/* carrier        */ DRX_CARRIER_UNKNOWN,
19013747 Mauro Carvalho Chehab 2014-01-24  12088  		/* frame mode     */ DRX_FRAMEMODE_UNKNOWN
19013747 Mauro Carvalho Chehab 2014-01-24  12089  	};
19013747 Mauro Carvalho Chehab 2014-01-24  12090  	u32 constellation = DRX_CONSTELLATION_AUTO;
19013747 Mauro Carvalho Chehab 2014-01-24  12091  
19013747 Mauro Carvalho Chehab 2014-01-24  12092  	/* Bring the demod out of sleep */
19013747 Mauro Carvalho Chehab 2014-01-24  12093  	drx39xxj_set_powerstate(fe, 1);
19013747 Mauro Carvalho Chehab 2014-01-24  12094  
19013747 Mauro Carvalho Chehab 2014-01-24  12095  	if (fe->ops.tuner_ops.set_params) {
7abc7a54 Mauro Carvalho Chehab 2014-01-26  12096  		u32 int_freq;
7abc7a54 Mauro Carvalho Chehab 2014-01-26  12097  
19013747 Mauro Carvalho Chehab 2014-01-24  12098  		if (fe->ops.i2c_gate_ctrl)
19013747 Mauro Carvalho Chehab 2014-01-24  12099  			fe->ops.i2c_gate_ctrl(fe, 1);
7abc7a54 Mauro Carvalho Chehab 2014-01-26  12100  
7abc7a54 Mauro Carvalho Chehab 2014-01-26  12101  		/* Set tuner to desired frequency and standard */
19013747 Mauro Carvalho Chehab 2014-01-24  12102  		fe->ops.tuner_ops.set_params(fe);
7abc7a54 Mauro Carvalho Chehab 2014-01-26  12103  
7abc7a54 Mauro Carvalho Chehab 2014-01-26  12104  		/* Use the tuner's IF */
7abc7a54 Mauro Carvalho Chehab 2014-01-26  12105  		if (fe->ops.tuner_ops.get_if_frequency) {
7abc7a54 Mauro Carvalho Chehab 2014-01-26  12106  			fe->ops.tuner_ops.get_if_frequency(fe, &int_freq);
7abc7a54 Mauro Carvalho Chehab 2014-01-26  12107  			demod->my_common_attr->intermediate_freq = int_freq / 1000;
7abc7a54 Mauro Carvalho Chehab 2014-01-26  12108  		}
7abc7a54 Mauro Carvalho Chehab 2014-01-26  12109  
19013747 Mauro Carvalho Chehab 2014-01-24  12110  		if (fe->ops.i2c_gate_ctrl)
19013747 Mauro Carvalho Chehab 2014-01-24  12111  			fe->ops.i2c_gate_ctrl(fe, 0);
19013747 Mauro Carvalho Chehab 2014-01-24  12112  	}
19013747 Mauro Carvalho Chehab 2014-01-24  12113  
19013747 Mauro Carvalho Chehab 2014-01-24  12114  	switch (p->delivery_system) {
19013747 Mauro Carvalho Chehab 2014-01-24  12115  	case SYS_ATSC:
19013747 Mauro Carvalho Chehab 2014-01-24  12116  		standard = DRX_STANDARD_8VSB;
19013747 Mauro Carvalho Chehab 2014-01-24  12117  		break;
19013747 Mauro Carvalho Chehab 2014-01-24  12118  	case SYS_DVBC_ANNEX_B:
19013747 Mauro Carvalho Chehab 2014-01-24  12119  		standard = DRX_STANDARD_ITU_B;
19013747 Mauro Carvalho Chehab 2014-01-24  12120  
19013747 Mauro Carvalho Chehab 2014-01-24  12121  		switch (p->modulation) {
19013747 Mauro Carvalho Chehab 2014-01-24  12122  		case QAM_64:
19013747 Mauro Carvalho Chehab 2014-01-24  12123  			constellation = DRX_CONSTELLATION_QAM64;
19013747 Mauro Carvalho Chehab 2014-01-24  12124  			break;
19013747 Mauro Carvalho Chehab 2014-01-24  12125  		case QAM_256:
19013747 Mauro Carvalho Chehab 2014-01-24  12126  			constellation = DRX_CONSTELLATION_QAM256;
19013747 Mauro Carvalho Chehab 2014-01-24  12127  			break;
19013747 Mauro Carvalho Chehab 2014-01-24  12128  		default:
19013747 Mauro Carvalho Chehab 2014-01-24  12129  			constellation = DRX_CONSTELLATION_AUTO;
19013747 Mauro Carvalho Chehab 2014-01-24  12130  			break;
19013747 Mauro Carvalho Chehab 2014-01-24  12131  		}
19013747 Mauro Carvalho Chehab 2014-01-24  12132  		break;
19013747 Mauro Carvalho Chehab 2014-01-24  12133  	default:
19013747 Mauro Carvalho Chehab 2014-01-24  12134  		return -EINVAL;
19013747 Mauro Carvalho Chehab 2014-01-24  12135  	}
c4dc6f92 Mauro Carvalho Chehab 2014-01-26  12136  	/* Set the standard (will be powered up if necessary */
c4dc6f92 Mauro Carvalho Chehab 2014-01-26  12137  	result = ctrl_set_standard(demod, &standard);
c4dc6f92 Mauro Carvalho Chehab 2014-01-26  12138  	if (result != 0) {
c4dc6f92 Mauro Carvalho Chehab 2014-01-26  12139  		pr_err("Failed to set standard! result=%02x\n",
c4dc6f92 Mauro Carvalho Chehab 2014-01-26  12140  			result);
c4dc6f92 Mauro Carvalho Chehab 2014-01-26  12141  		return -EINVAL;
19013747 Mauro Carvalho Chehab 2014-01-24  12142  	}
19013747 Mauro Carvalho Chehab 2014-01-24  12143  
19013747 Mauro Carvalho Chehab 2014-01-24  12144  	/* set channel parameters */
19013747 Mauro Carvalho Chehab 2014-01-24  12145  	channel = def_channel;
19013747 Mauro Carvalho Chehab 2014-01-24  12146  	channel.frequency = p->frequency / 1000;
19013747 Mauro Carvalho Chehab 2014-01-24  12147  	channel.bandwidth = DRX_BANDWIDTH_6MHZ;
19013747 Mauro Carvalho Chehab 2014-01-24  12148  	channel.constellation = constellation;
19013747 Mauro Carvalho Chehab 2014-01-24  12149  
19013747 Mauro Carvalho Chehab 2014-01-24  12150  	/* program channel */
b0baeb49 Mauro Carvalho Chehab 2014-01-24  12151  	result = ctrl_set_channel(demod, &channel);
19013747 Mauro Carvalho Chehab 2014-01-24  12152  	if (result != 0) {
19013747 Mauro Carvalho Chehab 2014-01-24  12153  		pr_err("Failed to set channel!\n");
19013747 Mauro Carvalho Chehab 2014-01-24  12154  		return -EINVAL;
19013747 Mauro Carvalho Chehab 2014-01-24  12155  	}
19013747 Mauro Carvalho Chehab 2014-01-24  12156  	/* Just for giggles, let's shut off the LNA again.... */
b601fe56 Shuah Khan            2014-07-24  12157  	drxj_set_lna_state(demod, false);
03fdfbfd Mauro Carvalho Chehab 2014-03-09  12158  
03fdfbfd Mauro Carvalho Chehab 2014-03-09  12159  	/* After set_frontend, except for strength, stats aren't available */
03fdfbfd Mauro Carvalho Chehab 2014-03-09  12160  	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
19013747 Mauro Carvalho Chehab 2014-01-24  12161  
19013747 Mauro Carvalho Chehab 2014-01-24  12162  	return 0;
19013747 Mauro Carvalho Chehab 2014-01-24  12163  }
19013747 Mauro Carvalho Chehab 2014-01-24  12164  
19013747 Mauro Carvalho Chehab 2014-01-24  12165  static int drx39xxj_sleep(struct dvb_frontend *fe)
19013747 Mauro Carvalho Chehab 2014-01-24  12166  {
19013747 Mauro Carvalho Chehab 2014-01-24  12167  	/* power-down the demodulator */
19013747 Mauro Carvalho Chehab 2014-01-24  12168  	return drx39xxj_set_powerstate(fe, 0);
19013747 Mauro Carvalho Chehab 2014-01-24  12169  }
19013747 Mauro Carvalho Chehab 2014-01-24  12170  
19013747 Mauro Carvalho Chehab 2014-01-24  12171  static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
19013747 Mauro Carvalho Chehab 2014-01-24  12172  {
19013747 Mauro Carvalho Chehab 2014-01-24  12173  	struct drx39xxj_state *state = fe->demodulator_priv;
19013747 Mauro Carvalho Chehab 2014-01-24  12174  	struct drx_demod_instance *demod = state->demod;
19013747 Mauro Carvalho Chehab 2014-01-24  12175  	bool i2c_gate_state;
19013747 Mauro Carvalho Chehab 2014-01-24  12176  	int result;
19013747 Mauro Carvalho Chehab 2014-01-24  12177  
19013747 Mauro Carvalho Chehab 2014-01-24  12178  #ifdef DJH_DEBUG
6c955b8b Shuah Khan            2014-02-28  12179  	pr_debug("i2c gate call: enable=%d state=%d\n", enable,
19013747 Mauro Carvalho Chehab 2014-01-24  12180  	       state->i2c_gate_open);
19013747 Mauro Carvalho Chehab 2014-01-24  12181  #endif
19013747 Mauro Carvalho Chehab 2014-01-24  12182  
19013747 Mauro Carvalho Chehab 2014-01-24  12183  	if (enable)
19013747 Mauro Carvalho Chehab 2014-01-24  12184  		i2c_gate_state = true;
19013747 Mauro Carvalho Chehab 2014-01-24  12185  	else
19013747 Mauro Carvalho Chehab 2014-01-24  12186  		i2c_gate_state = false;
19013747 Mauro Carvalho Chehab 2014-01-24  12187  
19013747 Mauro Carvalho Chehab 2014-01-24  12188  	if (state->i2c_gate_open == enable) {
19013747 Mauro Carvalho Chehab 2014-01-24  12189  		/* We're already in the desired state */
19013747 Mauro Carvalho Chehab 2014-01-24  12190  		return 0;
19013747 Mauro Carvalho Chehab 2014-01-24  12191  	}
19013747 Mauro Carvalho Chehab 2014-01-24  12192  
b0baeb49 Mauro Carvalho Chehab 2014-01-24  12193  	result = ctrl_i2c_bridge(demod, &i2c_gate_state);
19013747 Mauro Carvalho Chehab 2014-01-24  12194  	if (result != 0) {
19013747 Mauro Carvalho Chehab 2014-01-24  12195  		pr_err("drx39xxj: could not open i2c gate [%d]\n",
19013747 Mauro Carvalho Chehab 2014-01-24  12196  		       result);
19013747 Mauro Carvalho Chehab 2014-01-24  12197  		dump_stack();
19013747 Mauro Carvalho Chehab 2014-01-24  12198  	} else {
19013747 Mauro Carvalho Chehab 2014-01-24  12199  		state->i2c_gate_open = enable;
19013747 Mauro Carvalho Chehab 2014-01-24  12200  	}
19013747 Mauro Carvalho Chehab 2014-01-24  12201  	return 0;
19013747 Mauro Carvalho Chehab 2014-01-24  12202  }
19013747 Mauro Carvalho Chehab 2014-01-24  12203  
19013747 Mauro Carvalho Chehab 2014-01-24  12204  static int drx39xxj_init(struct dvb_frontend *fe)
19013747 Mauro Carvalho Chehab 2014-01-24  12205  {
998819d2 Shuah Khan            2014-07-24  12206  	struct drx39xxj_state *state = fe->demodulator_priv;
998819d2 Shuah Khan            2014-07-24  12207  	struct drx_demod_instance *demod = state->demod;
998819d2 Shuah Khan            2014-07-24  12208  	int rc = 0;
19013747 Mauro Carvalho Chehab 2014-01-24  12209  
998819d2 Shuah Khan            2014-07-24  12210  	if (fe->exit == DVB_FE_DEVICE_RESUME) {
998819d2 Shuah Khan            2014-07-24  12211  		/* so drxj_open() does what it needs to do */
998819d2 Shuah Khan            2014-07-24  12212  		demod->my_common_attr->is_opened = false;
998819d2 Shuah Khan            2014-07-24  12213  		rc = drxj_open(demod);
998819d2 Shuah Khan            2014-07-24  12214  		if (rc != 0)
998819d2 Shuah Khan            2014-07-24  12215  			pr_err("drx39xxj_init(): DRX open failed rc=%d!\n", rc);
998819d2 Shuah Khan            2014-07-24  12216  	} else
998819d2 Shuah Khan            2014-07-24  12217  		drx39xxj_set_powerstate(fe, 1);
998819d2 Shuah Khan            2014-07-24  12218  
998819d2 Shuah Khan            2014-07-24  12219  	return rc;
19013747 Mauro Carvalho Chehab 2014-01-24  12220  }
19013747 Mauro Carvalho Chehab 2014-01-24  12221  
ea8f3c2c Mauro Carvalho Chehab 2014-02-16  12222  static int drx39xxj_set_lna(struct dvb_frontend *fe)
ea8f3c2c Mauro Carvalho Chehab 2014-02-16  12223  {
ea8f3c2c Mauro Carvalho Chehab 2014-02-16 @12224  	int result;
ea8f3c2c Mauro Carvalho Chehab 2014-02-16  12225  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
ea8f3c2c Mauro Carvalho Chehab 2014-02-16  12226  	struct drx39xxj_state *state = fe->demodulator_priv;
ea8f3c2c Mauro Carvalho Chehab 2014-02-16  12227  	struct drx_demod_instance *demod = state->demod;
ea8f3c2c Mauro Carvalho Chehab 2014-02-16  12228  	struct drxj_data *ext_attr = demod->my_ext_attr;
ea8f3c2c Mauro Carvalho Chehab 2014-02-16 @12229  	struct drxuio_cfg uio_cfg;
ea8f3c2c Mauro Carvalho Chehab 2014-02-16 @12230  	struct drxuio_data uio_data;
ea8f3c2c Mauro Carvalho Chehab 2014-02-16  12231  
ea8f3c2c Mauro Carvalho Chehab 2014-02-16  12232  	if (c->lna) {
ea8f3c2c Mauro Carvalho Chehab 2014-02-16  12233  		if (!ext_attr->has_lna) {

:::::: The code at line 12072 was first introduced by commit
:::::: 190137478fb1e2487e8b7865c88c9747a16d0f9c [media] drx-j: move drx39xxj into drxj.c

:::::: TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
