Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:6481 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750705AbdLZGX3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 01:23:29 -0500
Date: Tue, 26 Dec 2017 14:22:25 +0800
From: kbuild test robot <lkp@intel.com>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: kbuild-all@01.org, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, ddl@rock-chips.com, tfiga@chromium.org,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: Re: [PATCH 3/4] media: ov2685: add support for OV2685 sensor
Message-ID: <201712261417.LVKcMMgw%fengguang.wu@intel.com>
References: <1514211086-13440-3-git-send-email-zhengsq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514211086-13440-3-git-send-email-zhengsq@rock-chips.com>
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


vim +248 drivers/media/i2c/ov2685.c

   232	
   233	/* Write registers up to 4 at a time */
   234	static int ov2685_write_reg(struct i2c_client *client, u16 reg,
   235				    unsigned int len, u32 val)
   236	{
   237		int buf_i;
   238		int val_i;
   239		u8 buf[6];
   240		u8 *val_p;
   241	
   242		if (len > 4)
   243			return -EINVAL;
   244	
   245		buf[0] = reg >> 8;
   246		buf[1] = reg & 0xff;
   247	
 > 248		val = cpu_to_be32(val);
   249		val_p = (u8 *)&val;
   250		buf_i = 2;
   251		val_i = 4 - len;
   252	
   253		while (val_i < 4)
   254			buf[buf_i++] = val_p[val_i++];
   255	
   256		if (i2c_master_send(client, buf, len + 2) != len + 2)
   257			return -EIO;
   258	
   259		return 0;
   260	}
   261	
   262	static int ov2685_write_array(struct i2c_client *client,
   263				      const struct regval *regs)
   264	{
   265		int i, ret = 0;
   266	
   267		for (i = 0; ret == 0 && regs[i].addr != REG_NULL; i++)
   268			ret = ov2685_write_reg(client, regs[i].addr,
   269					       OV2685_REG_VALUE_08BIT, regs[i].val);
   270	
   271		return ret;
   272	}
   273	
   274	/* Read registers up to 4 at a time */
   275	static int ov2685_read_reg(struct i2c_client *client, u16 reg,
   276				   unsigned int len, u32 *val)
   277	{
   278		struct i2c_msg msgs[2];
   279		u8 *data_be_p;
   280		u32 data_be = 0;
 > 281		u16 reg_addr_be = cpu_to_be16(reg);
   282		int ret;
   283	
   284		if (len > 4)
   285			return -EINVAL;
   286	
   287		data_be_p = (u8 *)&data_be;
   288		/* Write register address */
   289		msgs[0].addr = client->addr;
   290		msgs[0].flags = 0;
   291		msgs[0].len = 2;
   292		msgs[0].buf = (u8 *)&reg_addr_be;
   293	
   294		/* Read data from register */
   295		msgs[1].addr = client->addr;
   296		msgs[1].flags = I2C_M_RD;
   297		msgs[1].len = len;
   298		msgs[1].buf = &data_be_p[4 - len];
   299	
   300		ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
   301		if (ret != ARRAY_SIZE(msgs))
   302			return -EIO;
   303	
 > 304		*val = be32_to_cpu(data_be);
   305	
   306		return 0;
   307	}
   308	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
