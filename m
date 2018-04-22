Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60240 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755110AbeDVPm5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 11:42:57 -0400
Date: Sun, 22 Apr 2018 23:41:41 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/4] media: radio: allow building ISA drivers with
 COMPILE_TEST
Message-ID: <201804222216.QZDMUFK0%fengguang.wu@intel.com>
References: <333f43d5373f6f821c424ccabce3b9b1fa180921.1524227382.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <333f43d5373f6f821c424ccabce3b9b1fa180921.1524227382.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.17-rc1 next-20180420]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/media-radio-allow-building-ISA-drivers-with-COMPILE_TEST/20180422-180508
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/radio/radio-isa.c:108:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-isa.c:108:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-isa.c:108:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-isa.c:108:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-isa.c:108:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-isa.c:108:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-isa.c:108:16: sparse: expression using sizeof(void)
--
>> drivers/media/radio/radio-sf16fmi.c:123:24: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-sf16fmi.c:123:24: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-sf16fmi.c:123:24: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-sf16fmi.c:123:24: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-sf16fmi.c:123:24: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-sf16fmi.c:123:24: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-sf16fmi.c:123:24: sparse: expression using sizeof(void)
--
>> drivers/media/radio/radio-sf16fmr2.c:169:25: sparse: expression using sizeof(void)
   drivers/media/radio/radio-sf16fmr2.c:171:24: sparse: expression using sizeof(void)
--
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-cadet.c:219:16: sparse: expression using sizeof(void)

vim +108 drivers/media/radio/radio-isa.c

137c579c Hans Verkuil 2012-02-03   98  
137c579c Hans Verkuil 2012-02-03   99  static int radio_isa_s_frequency(struct file *file, void *priv,
b530a447 Hans Verkuil 2013-03-19  100  				const struct v4l2_frequency *f)
137c579c Hans Verkuil 2012-02-03  101  {
137c579c Hans Verkuil 2012-02-03  102  	struct radio_isa_card *isa = video_drvdata(file);
b530a447 Hans Verkuil 2013-03-19  103  	u32 freq = f->frequency;
137c579c Hans Verkuil 2012-02-03  104  	int res;
137c579c Hans Verkuil 2012-02-03  105  
137c579c Hans Verkuil 2012-02-03  106  	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
137c579c Hans Verkuil 2012-02-03  107  		return -EINVAL;
b530a447 Hans Verkuil 2013-03-19 @108  	freq = clamp(freq, FREQ_LOW, FREQ_HIGH);
b530a447 Hans Verkuil 2013-03-19  109  	res = isa->drv->ops->s_frequency(isa, freq);
137c579c Hans Verkuil 2012-02-03  110  	if (res == 0)
b530a447 Hans Verkuil 2013-03-19  111  		isa->freq = freq;
137c579c Hans Verkuil 2012-02-03  112  	return res;
137c579c Hans Verkuil 2012-02-03  113  }
137c579c Hans Verkuil 2012-02-03  114  

:::::: The code at line 108 was first introduced by commit
:::::: b530a447bb588fdf43fdf4eb909e4ee1921d47ac [media] v4l2: add const to argument of write-only s_frequency ioctl

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
