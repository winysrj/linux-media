Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42642 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750705AbdLZFfR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 00:35:17 -0500
Date: Tue, 26 Dec 2017 13:34:40 +0800
From: kbuild test robot <lkp@intel.com>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: kbuild-all@01.org, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, ddl@rock-chips.com, tfiga@chromium.org,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: Re: [PATCH 1/4] media: ov5695: add support for OV5695 sensor
Message-ID: <201712261322.41FrM4CI%fengguang.wu@intel.com>
References: <1514211086-13440-1-git-send-email-zhengsq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514211086-13440-1-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shunqian,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.15-rc5 next-20171222]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Shunqian-Zheng/media-ov5695-add-support-for-OV5695-sensor/20171226-110821
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


vim +713 drivers/media/i2c/ov5695.c

   697	
   698	/* Write registers up to 4 at a time */
   699	static int ov5695_write_reg(struct i2c_client *client, u16 reg,
   700				    unsigned int len, u32 val)
   701	{
   702		int buf_i;
   703		int val_i;
   704		u8 buf[6];
   705		u8 *val_p;
   706	
   707		if (len > 4)
   708			return -EINVAL;
   709	
   710		buf[0] = reg >> 8;
   711		buf[1] = reg & 0xff;
   712	
 > 713		val = cpu_to_be32(val);
   714		val_p = (u8 *)&val;
   715		buf_i = 2;
   716		val_i = 4 - len;
   717	
   718		while (val_i < 4)
   719			buf[buf_i++] = val_p[val_i++];
   720	
   721		if (i2c_master_send(client, buf, len + 2) != len + 2)
   722			return -EIO;
   723	
   724		return 0;
   725	}
   726	
   727	static int ov5695_write_array(struct i2c_client *client,
   728				      const struct regval *regs)
   729	{
   730		int i, ret = 0;
   731	
   732		for (i = 0; ret == 0 && regs[i].addr != REG_NULL; i++)
   733			ret = ov5695_write_reg(client, regs[i].addr,
   734					       OV5695_REG_VALUE_08BIT, regs[i].val);
   735	
   736		return ret;
   737	}
   738	
   739	/* Read registers up to 4 at a time */
   740	static int ov5695_read_reg(struct i2c_client *client, u16 reg, unsigned int len,
   741				   u32 *val)
   742	{
   743		struct i2c_msg msgs[2];
   744		u8 *data_be_p;
   745		u32 data_be = 0;
 > 746		u16 reg_addr_be = cpu_to_be16(reg);
   747		int ret;
   748	
   749		if (len > 4)
   750			return -EINVAL;
   751	
   752		data_be_p = (u8 *)&data_be;
   753		/* Write register address */
   754		msgs[0].addr = client->addr;
   755		msgs[0].flags = 0;
   756		msgs[0].len = 2;
   757		msgs[0].buf = (u8 *)&reg_addr_be;
   758	
   759		/* Read data from register */
   760		msgs[1].addr = client->addr;
   761		msgs[1].flags = I2C_M_RD;
   762		msgs[1].len = len;
   763		msgs[1].buf = &data_be_p[4 - len];
   764	
   765		ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
   766		if (ret != ARRAY_SIZE(msgs))
   767			return -EIO;
   768	
 > 769		*val = be32_to_cpu(data_be);
   770	
   771		return 0;
   772	}
   773	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
