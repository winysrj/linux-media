Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24543 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbbEAPi5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2015 11:38:57 -0400
Date: Fri, 1 May 2015 23:38:49 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [linuxtv-media:master 834/883]
 drivers/media/pci/saa7164/saa7164-i2c.c:45:33: sparse: Using plain integer
 as NULL pointer
Message-ID: <201505012348.QEB7o0DP%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   ebf984bb151e9952cccd060d3aba0b4d30a87e81
commit: 5f954b5be4bf42e85e0a204518499bda8ee2f419 [834/883] [media] saa7164: I2C improvements for upcoming HVR2255/2205 boards
reproduce:
  # apt-get install sparse
  git checkout 5f954b5be4bf42e85e0a204518499bda8ee2f419
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/pci/saa7164/saa7164-i2c.c:45:33: sparse: Using plain integer as NULL pointer

vim +45 drivers/media/pci/saa7164/saa7164-i2c.c

    29	
    30	static int i2c_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs, int num)
    31	{
    32		struct saa7164_i2c *bus = i2c_adap->algo_data;
    33		struct saa7164_dev *dev = bus->dev;
    34		int i, retval = 0;
    35	
    36		dprintk(DBGLVL_I2C, "%s(num = %d)\n", __func__, num);
    37	
    38		for (i = 0 ; i < num; i++) {
    39			dprintk(DBGLVL_I2C, "%s(num = %d) addr = 0x%02x  len = 0x%x\n",
    40				__func__, num, msgs[i].addr, msgs[i].len);
    41			if (msgs[i].flags & I2C_M_RD) {
    42				retval = saa7164_api_i2c_read(bus,
    43					msgs[i].addr,
    44					0 /* reglen */,
  > 45					0 /* reg */, msgs[i].len, msgs[i].buf);
    46			} else if (i + 1 < num && (msgs[i + 1].flags & I2C_M_RD) &&
    47				   msgs[i].addr == msgs[i + 1].addr) {
    48				/* write then read from same address */
    49	
    50				retval = saa7164_api_i2c_read(bus, msgs[i].addr,
    51					msgs[i].len, msgs[i].buf,
    52					msgs[i+1].len, msgs[i+1].buf
    53					);

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
