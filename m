Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:17250 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbaIZNB0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 09:01:26 -0400
Date: Fri, 26 Sep 2014 20:59:45 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [next:master 9126/9273] drivers/media/rc/ir-hix5hd2.c:99:2:
 warning: passing argument 2 of 'writel' discards 'volatile' qualifier from
 pointer target type
Message-ID: <54256341.3MSJycDXF20ytNxh%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_54256341.viqxbTIwldqkc2qkniCmYomajatC0lj7ROEnOKM6SpQ6Po91"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=_54256341.viqxbTIwldqkc2qkniCmYomajatC0lj7ROEnOKM6SpQ6Po91
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   4d8426f9ac601db2a64fa7be64051d02b9c9fe01
commit: 773a6bc73f9d2ac6afd18e091b5bb98c5db221a7 [9126/9273] Merge remote-tracking branch 'v4l-dvb/master'
config: s390-allmodconfig (attached as .config)
reproduce:
  wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
  chmod +x ~/bin/make.cross
  git checkout 773a6bc73f9d2ac6afd18e091b5bb98c5db221a7
  # save the attached .config to linux build tree
  make.cross ARCH=s390 

All warnings:

   drivers/media/rc/ir-hix5hd2.c: In function 'hix5hd2_ir_config':
>> drivers/media/rc/ir-hix5hd2.c:99:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel_relaxed(0x01, priv->base + IR_ENABLE);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/ir-hix5hd2.c:100:9: warning: passing argument 1 of 'readl' discards 'volatile' qualifier from pointer target type
     while (readl_relaxed(priv->base + IR_BUSY)) {
            ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:126:90: note: expected 'const void *' but argument is of type 'volatile void *'
    static inline u32 readl(const void __iomem *addr)
                                                                                             ^
>> drivers/media/rc/ir-hix5hd2.c:117:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel_relaxed(val, priv->base + IR_CONFIG);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/ir-hix5hd2.c:119:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel_relaxed(0x00, priv->base + IR_INTM);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/ir-hix5hd2.c:121:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel_relaxed(0x01, priv->base + IR_START);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
   drivers/media/rc/ir-hix5hd2.c: In function 'hix5hd2_ir_rx_interrupt':
>> drivers/media/rc/ir-hix5hd2.c:147:11: warning: passing argument 1 of 'readl' discards 'volatile' qualifier from pointer target type
     irq_sr = readl_relaxed(priv->base + IR_INTS);
              ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:126:90: note: expected 'const void *' but argument is of type 'volatile void *'
    static inline u32 readl(const void __iomem *addr)
                                                                                             ^
>> drivers/media/rc/ir-hix5hd2.c:155:14: warning: passing argument 1 of 'readl' discards 'volatile' qualifier from pointer target type
      symb_num = readl_relaxed(priv->base + IR_DATAH);
                 ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:126:90: note: expected 'const void *' but argument is of type 'volatile void *'
    static inline u32 readl(const void __iomem *addr)
                                                                                             ^
>> drivers/media/rc/ir-hix5hd2.c:157:4: warning: passing argument 1 of 'readl' discards 'volatile' qualifier from pointer target type
       readl_relaxed(priv->base + IR_DATAL);
       ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:126:90: note: expected 'const void *' but argument is of type 'volatile void *'
    static inline u32 readl(const void __iomem *addr)
                                                                                             ^
>> drivers/media/rc/ir-hix5hd2.c:159:3: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
      writel_relaxed(INT_CLR_OVERFLOW, priv->base + IR_INTC);
      ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/ir-hix5hd2.c:167:14: warning: passing argument 1 of 'readl' discards 'volatile' qualifier from pointer target type
      symb_num = readl_relaxed(priv->base + IR_DATAH);
                 ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:126:90: note: expected 'const void *' but argument is of type 'volatile void *'
    static inline u32 readl(const void __iomem *addr)
                                                                                             ^
>> drivers/media/rc/ir-hix5hd2.c:169:15: warning: passing argument 1 of 'readl' discards 'volatile' qualifier from pointer target type
       symb_val = readl_relaxed(priv->base + IR_DATAL);
                  ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:126:90: note: expected 'const void *' but argument is of type 'volatile void *'
    static inline u32 readl(const void __iomem *addr)
                                                                                             ^
>> drivers/media/rc/ir-hix5hd2.c:188:4: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
       writel_relaxed(INT_CLR_RCV, priv->base + IR_INTC);
       ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/ir-hix5hd2.c:190:4: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
       writel_relaxed(INT_CLR_TIMEOUT, priv->base + IR_INTC);
       ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
   drivers/media/rc/ir-hix5hd2.c: In function 'hix5hd2_ir_resume':
>> drivers/media/rc/ir-hix5hd2.c:315:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel_relaxed(0x01, priv->base + IR_ENABLE);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/ir-hix5hd2.c:316:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel_relaxed(0x00, priv->base + IR_INTM);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/ir-hix5hd2.c:317:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel_relaxed(0xff, priv->base + IR_INTC);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/ir-hix5hd2.c:318:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel_relaxed(0x01, priv->base + IR_START);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/ir-hix5hd2.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
--
   drivers/media/rc/st_rc.c: In function 'st_rc_rx_interrupt':
>> drivers/media/rc/st_rc.c:107:11: warning: passing argument 1 of 'readl' discards 'volatile' qualifier from pointer target type
     status  = readl(dev->rx_base + IRB_RX_STATUS);
              ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:126:90: note: expected 'const void *' but argument is of type 'volatile void *'
    static inline u32 readl(const void __iomem *addr)
                                                                                             ^
>> drivers/media/rc/st_rc.c:110:20: warning: passing argument 1 of 'readl' discards 'volatile' qualifier from pointer target type
      u32 int_status = readl(dev->rx_base + IRB_RX_INT_STATUS);
                       ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:126:90: note: expected 'const void *' but argument is of type 'volatile void *'
    static inline u32 readl(const void __iomem *addr)
                                                                                             ^
>> drivers/media/rc/st_rc.c:115:4: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
       writel(IRB_RX_OVERRUN_INT,
       ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/st_rc.c:120:12: warning: passing argument 1 of 'readl' discards 'volatile' qualifier from pointer target type
      symbol = readl(dev->rx_base + IRB_RX_SYS);
               ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:126:90: note: expected 'const void *' but argument is of type 'volatile void *'
    static inline u32 readl(const void __iomem *addr)
                                                                                             ^
>> drivers/media/rc/st_rc.c:121:10: warning: passing argument 1 of 'readl' discards 'volatile' qualifier from pointer target type
      mark = readl(dev->rx_base + IRB_RX_ON);
             ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:126:90: note: expected 'const void *' but argument is of type 'volatile void *'
    static inline u32 readl(const void __iomem *addr)
                                                                                             ^
>> drivers/media/rc/st_rc.c:150:12: warning: passing argument 1 of 'readl' discards 'volatile' qualifier from pointer target type
      status  = readl(dev->rx_base + IRB_RX_STATUS);
               ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:126:90: note: expected 'const void *' but argument is of type 'volatile void *'
    static inline u32 readl(const void __iomem *addr)
                                                                                             ^
>> drivers/media/rc/st_rc.c:153:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel(IRB_RX_INTS, dev->rx_base + IRB_RX_INT_CLEAR);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
   drivers/media/rc/st_rc.c: In function 'st_rc_hardware_init':
>> drivers/media/rc/st_rc.c:174:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel(1, dev->rx_base + IRB_RX_POLARITY_INV);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/st_rc.c:177:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel(rx_sampling_freq_div, dev->base + IRB_SAMPLE_RATE_COMM);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/st_rc.c:187:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel(rx_max_symbol_per, dev->rx_base + IRB_MAX_SYM_PERIOD);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
   drivers/media/rc/st_rc.c: In function 'st_rc_open':
>> drivers/media/rc/st_rc.c:204:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel(IRB_RX_INTS, dev->rx_base + IRB_RX_INT_EN);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/st_rc.c:205:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel(0x01, dev->rx_base + IRB_RX_EN);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
   drivers/media/rc/st_rc.c: In function 'st_rc_close':
>> drivers/media/rc/st_rc.c:215:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel(0x00, dev->rx_base + IRB_RX_EN);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/st_rc.c:216:2: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
     writel(0x00, dev->rx_base + IRB_RX_INT_EN);
     ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
   drivers/media/rc/st_rc.c: In function 'st_rc_suspend':
>> drivers/media/rc/st_rc.c:349:3: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
      writel(0x00, rc_dev->rx_base + IRB_RX_EN);
      ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/st_rc.c:350:3: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
      writel(0x00, rc_dev->rx_base + IRB_RX_INT_EN);
      ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
   drivers/media/rc/st_rc.c: In function 'st_rc_resume':
>> drivers/media/rc/st_rc.c:371:4: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
       writel(IRB_RX_INTS, rc_dev->rx_base + IRB_RX_INT_EN);
       ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
>> drivers/media/rc/st_rc.c:372:4: warning: passing argument 2 of 'writel' discards 'volatile' qualifier from pointer target type
       writel(0x01, rc_dev->rx_base + IRB_RX_EN);
       ^
   In file included from arch/s390/include/asm/io.h:71:0,
                    from include/linux/scatterlist.h:10,
                    from include/linux/kfifo.h:56,
                    from include/media/rc-core.h:20,
                    from drivers/media/rc/st_rc.c:17:
   include/asm-generic/io.h:160:91: note: expected 'void *' but argument is of type 'volatile void *'
    static inline void writel(u32 value, void __iomem *addr)
                                                                                              ^
..

vim +99 drivers/media/rc/ir-hix5hd2.c

a84fcdaa Guoxiong Yan          2014-08-30   11  #include <linux/delay.h>
a84fcdaa Guoxiong Yan          2014-08-30   12  #include <linux/interrupt.h>
a84fcdaa Guoxiong Yan          2014-08-30   13  #include <linux/mfd/syscon.h>
a84fcdaa Guoxiong Yan          2014-08-30   14  #include <linux/module.h>
a84fcdaa Guoxiong Yan          2014-08-30   15  #include <linux/of_device.h>
a84fcdaa Guoxiong Yan          2014-08-30   16  #include <linux/regmap.h>
a84fcdaa Guoxiong Yan          2014-08-30   17  #include <media/rc-core.h>
a84fcdaa Guoxiong Yan          2014-08-30   18  
a84fcdaa Guoxiong Yan          2014-08-30   19  /* Allow the driver to compile on all architectures */
a84fcdaa Guoxiong Yan          2014-08-30   20  #ifndef writel_relaxed
a84fcdaa Guoxiong Yan          2014-08-30   21  # define writel_relaxed writel
a84fcdaa Guoxiong Yan          2014-08-30   22  #endif
a84fcdaa Guoxiong Yan          2014-08-30   23  
a84fcdaa Guoxiong Yan          2014-08-30   24  #define IR_ENABLE		0x00
a84fcdaa Guoxiong Yan          2014-08-30   25  #define IR_CONFIG		0x04
a84fcdaa Guoxiong Yan          2014-08-30   26  #define CNT_LEADS		0x08
a84fcdaa Guoxiong Yan          2014-08-30   27  #define CNT_LEADE		0x0c
a84fcdaa Guoxiong Yan          2014-08-30   28  #define CNT_SLEADE		0x10
a84fcdaa Guoxiong Yan          2014-08-30   29  #define CNT0_B			0x14
a84fcdaa Guoxiong Yan          2014-08-30   30  #define CNT1_B			0x18
a84fcdaa Guoxiong Yan          2014-08-30   31  #define IR_BUSY			0x1c
a84fcdaa Guoxiong Yan          2014-08-30   32  #define IR_DATAH		0x20
a84fcdaa Guoxiong Yan          2014-08-30   33  #define IR_DATAL		0x24
a84fcdaa Guoxiong Yan          2014-08-30   34  #define IR_INTM			0x28
a84fcdaa Guoxiong Yan          2014-08-30   35  #define IR_INTS			0x2c
a84fcdaa Guoxiong Yan          2014-08-30   36  #define IR_INTC			0x30
a84fcdaa Guoxiong Yan          2014-08-30   37  #define IR_START		0x34
a84fcdaa Guoxiong Yan          2014-08-30   38  
a84fcdaa Guoxiong Yan          2014-08-30   39  /* interrupt mask */
a84fcdaa Guoxiong Yan          2014-08-30   40  #define INTMS_SYMBRCV		(BIT(24) | BIT(8))
a84fcdaa Guoxiong Yan          2014-08-30   41  #define INTMS_TIMEOUT		(BIT(25) | BIT(9))
a84fcdaa Guoxiong Yan          2014-08-30   42  #define INTMS_OVERFLOW		(BIT(26) | BIT(10))
a84fcdaa Guoxiong Yan          2014-08-30   43  #define INT_CLR_OVERFLOW	BIT(18)
a84fcdaa Guoxiong Yan          2014-08-30   44  #define INT_CLR_TIMEOUT		BIT(17)
a84fcdaa Guoxiong Yan          2014-08-30   45  #define INT_CLR_RCV		BIT(16)
a84fcdaa Guoxiong Yan          2014-08-30   46  #define INT_CLR_RCVTIMEOUT	(BIT(16) | BIT(17))
a84fcdaa Guoxiong Yan          2014-08-30   47  
a84fcdaa Guoxiong Yan          2014-08-30   48  #define IR_CLK			0x48
a84fcdaa Guoxiong Yan          2014-08-30   49  #define IR_CLK_ENABLE		BIT(4)
a84fcdaa Guoxiong Yan          2014-08-30   50  #define IR_CLK_RESET		BIT(5)
a84fcdaa Guoxiong Yan          2014-08-30   51  
a84fcdaa Guoxiong Yan          2014-08-30   52  #define IR_CFG_WIDTH_MASK	0xffff
a84fcdaa Guoxiong Yan          2014-08-30   53  #define IR_CFG_WIDTH_SHIFT	16
a84fcdaa Guoxiong Yan          2014-08-30   54  #define IR_CFG_FORMAT_MASK	0x3
a84fcdaa Guoxiong Yan          2014-08-30   55  #define IR_CFG_FORMAT_SHIFT	14
a84fcdaa Guoxiong Yan          2014-08-30   56  #define IR_CFG_INT_LEVEL_MASK	0x3f
a84fcdaa Guoxiong Yan          2014-08-30   57  #define IR_CFG_INT_LEVEL_SHIFT	8
a84fcdaa Guoxiong Yan          2014-08-30   58  /* only support raw mode */
a84fcdaa Guoxiong Yan          2014-08-30   59  #define IR_CFG_MODE_RAW		BIT(7)
a84fcdaa Guoxiong Yan          2014-08-30   60  #define IR_CFG_FREQ_MASK	0x7f
a84fcdaa Guoxiong Yan          2014-08-30   61  #define IR_CFG_FREQ_SHIFT	0
a84fcdaa Guoxiong Yan          2014-08-30   62  #define IR_CFG_INT_THRESHOLD	1
a84fcdaa Guoxiong Yan          2014-08-30   63  /* symbol start from low to high, symbol stream end at high*/
a84fcdaa Guoxiong Yan          2014-08-30   64  #define IR_CFG_SYMBOL_FMT	0
a84fcdaa Guoxiong Yan          2014-08-30   65  #define IR_CFG_SYMBOL_MAXWIDTH	0x3e80
a84fcdaa Guoxiong Yan          2014-08-30   66  
a84fcdaa Guoxiong Yan          2014-08-30   67  #define IR_HIX5HD2_NAME		"hix5hd2-ir"
a84fcdaa Guoxiong Yan          2014-08-30   68  
a84fcdaa Guoxiong Yan          2014-08-30   69  struct hix5hd2_ir_priv {
a84fcdaa Guoxiong Yan          2014-08-30   70  	int			irq;
98a52fad Mauro Carvalho Chehab 2014-09-24   71  	void volatile __iomem	*base;
a84fcdaa Guoxiong Yan          2014-08-30   72  	struct device		*dev;
a84fcdaa Guoxiong Yan          2014-08-30   73  	struct rc_dev		*rdev;
a84fcdaa Guoxiong Yan          2014-08-30   74  	struct regmap		*regmap;
a84fcdaa Guoxiong Yan          2014-08-30   75  	struct clk		*clock;
a84fcdaa Guoxiong Yan          2014-08-30   76  	unsigned long		rate;
a84fcdaa Guoxiong Yan          2014-08-30   77  };
a84fcdaa Guoxiong Yan          2014-08-30   78  
a84fcdaa Guoxiong Yan          2014-08-30   79  static void hix5hd2_ir_enable(struct hix5hd2_ir_priv *dev, bool on)
a84fcdaa Guoxiong Yan          2014-08-30   80  {
a84fcdaa Guoxiong Yan          2014-08-30   81  	u32 val;
a84fcdaa Guoxiong Yan          2014-08-30   82  
a84fcdaa Guoxiong Yan          2014-08-30   83  	regmap_read(dev->regmap, IR_CLK, &val);
a84fcdaa Guoxiong Yan          2014-08-30   84  	if (on) {
a84fcdaa Guoxiong Yan          2014-08-30   85  		val &= ~IR_CLK_RESET;
a84fcdaa Guoxiong Yan          2014-08-30   86  		val |= IR_CLK_ENABLE;
a84fcdaa Guoxiong Yan          2014-08-30   87  	} else {
a84fcdaa Guoxiong Yan          2014-08-30   88  		val &= ~IR_CLK_ENABLE;
a84fcdaa Guoxiong Yan          2014-08-30   89  		val |= IR_CLK_RESET;
a84fcdaa Guoxiong Yan          2014-08-30   90  	}
a84fcdaa Guoxiong Yan          2014-08-30   91  	regmap_write(dev->regmap, IR_CLK, val);
a84fcdaa Guoxiong Yan          2014-08-30   92  }
a84fcdaa Guoxiong Yan          2014-08-30   93  
a84fcdaa Guoxiong Yan          2014-08-30   94  static int hix5hd2_ir_config(struct hix5hd2_ir_priv *priv)
a84fcdaa Guoxiong Yan          2014-08-30   95  {
a84fcdaa Guoxiong Yan          2014-08-30   96  	int timeout = 10000;
a84fcdaa Guoxiong Yan          2014-08-30   97  	u32 val, rate;
a84fcdaa Guoxiong Yan          2014-08-30   98  
a84fcdaa Guoxiong Yan          2014-08-30   99  	writel_relaxed(0x01, priv->base + IR_ENABLE);
a84fcdaa Guoxiong Yan          2014-08-30  100  	while (readl_relaxed(priv->base + IR_BUSY)) {
a84fcdaa Guoxiong Yan          2014-08-30  101  		if (timeout--) {
a84fcdaa Guoxiong Yan          2014-08-30  102  			udelay(1);
a84fcdaa Guoxiong Yan          2014-08-30  103  		} else {
a84fcdaa Guoxiong Yan          2014-08-30  104  			dev_err(priv->dev, "IR_BUSY timeout\n");
a84fcdaa Guoxiong Yan          2014-08-30  105  			return -ETIMEDOUT;
a84fcdaa Guoxiong Yan          2014-08-30  106  		}
a84fcdaa Guoxiong Yan          2014-08-30  107  	}
a84fcdaa Guoxiong Yan          2014-08-30  108  
a84fcdaa Guoxiong Yan          2014-08-30  109  	/* Now only support raw mode, with symbol start from low to high */
a84fcdaa Guoxiong Yan          2014-08-30  110  	rate = DIV_ROUND_CLOSEST(priv->rate, 1000000);
a84fcdaa Guoxiong Yan          2014-08-30  111  	val = IR_CFG_SYMBOL_MAXWIDTH & IR_CFG_WIDTH_MASK << IR_CFG_WIDTH_SHIFT;
a84fcdaa Guoxiong Yan          2014-08-30  112  	val |= IR_CFG_SYMBOL_FMT & IR_CFG_FORMAT_MASK << IR_CFG_FORMAT_SHIFT;
a84fcdaa Guoxiong Yan          2014-08-30  113  	val |= (IR_CFG_INT_THRESHOLD - 1) & IR_CFG_INT_LEVEL_MASK
a84fcdaa Guoxiong Yan          2014-08-30  114  	       << IR_CFG_INT_LEVEL_SHIFT;
a84fcdaa Guoxiong Yan          2014-08-30  115  	val |= IR_CFG_MODE_RAW;
a84fcdaa Guoxiong Yan          2014-08-30  116  	val |= (rate - 1) & IR_CFG_FREQ_MASK << IR_CFG_FREQ_SHIFT;
a84fcdaa Guoxiong Yan          2014-08-30  117  	writel_relaxed(val, priv->base + IR_CONFIG);
a84fcdaa Guoxiong Yan          2014-08-30  118  
a84fcdaa Guoxiong Yan          2014-08-30  119  	writel_relaxed(0x00, priv->base + IR_INTM);
a84fcdaa Guoxiong Yan          2014-08-30  120  	/* write arbitrary value to start  */
a84fcdaa Guoxiong Yan          2014-08-30  121  	writel_relaxed(0x01, priv->base + IR_START);
a84fcdaa Guoxiong Yan          2014-08-30  122  	return 0;
a84fcdaa Guoxiong Yan          2014-08-30  123  }
a84fcdaa Guoxiong Yan          2014-08-30  124  
a84fcdaa Guoxiong Yan          2014-08-30  125  static int hix5hd2_ir_open(struct rc_dev *rdev)
a84fcdaa Guoxiong Yan          2014-08-30  126  {
a84fcdaa Guoxiong Yan          2014-08-30  127  	struct hix5hd2_ir_priv *priv = rdev->priv;
a84fcdaa Guoxiong Yan          2014-08-30  128  
a84fcdaa Guoxiong Yan          2014-08-30  129  	hix5hd2_ir_enable(priv, true);
a84fcdaa Guoxiong Yan          2014-08-30  130  	return hix5hd2_ir_config(priv);
a84fcdaa Guoxiong Yan          2014-08-30  131  }
a84fcdaa Guoxiong Yan          2014-08-30  132  
a84fcdaa Guoxiong Yan          2014-08-30  133  static void hix5hd2_ir_close(struct rc_dev *rdev)
a84fcdaa Guoxiong Yan          2014-08-30  134  {
a84fcdaa Guoxiong Yan          2014-08-30  135  	struct hix5hd2_ir_priv *priv = rdev->priv;
a84fcdaa Guoxiong Yan          2014-08-30  136  
a84fcdaa Guoxiong Yan          2014-08-30  137  	hix5hd2_ir_enable(priv, false);
a84fcdaa Guoxiong Yan          2014-08-30  138  }
a84fcdaa Guoxiong Yan          2014-08-30  139  
a84fcdaa Guoxiong Yan          2014-08-30  140  static irqreturn_t hix5hd2_ir_rx_interrupt(int irq, void *data)
a84fcdaa Guoxiong Yan          2014-08-30  141  {
a84fcdaa Guoxiong Yan          2014-08-30  142  	u32 symb_num, symb_val, symb_time;
a84fcdaa Guoxiong Yan          2014-08-30  143  	u32 data_l, data_h;
a84fcdaa Guoxiong Yan          2014-08-30  144  	u32 irq_sr, i;
a84fcdaa Guoxiong Yan          2014-08-30  145  	struct hix5hd2_ir_priv *priv = data;
a84fcdaa Guoxiong Yan          2014-08-30  146  
a84fcdaa Guoxiong Yan          2014-08-30  147  	irq_sr = readl_relaxed(priv->base + IR_INTS);
a84fcdaa Guoxiong Yan          2014-08-30  148  	if (irq_sr & INTMS_OVERFLOW) {
a84fcdaa Guoxiong Yan          2014-08-30  149  		/*
a84fcdaa Guoxiong Yan          2014-08-30  150  		 * we must read IR_DATAL first, then we can clean up
a84fcdaa Guoxiong Yan          2014-08-30  151  		 * IR_INTS availably since logic would not clear
a84fcdaa Guoxiong Yan          2014-08-30  152  		 * fifo when overflow, drv do the job
a84fcdaa Guoxiong Yan          2014-08-30  153  		 */
a84fcdaa Guoxiong Yan          2014-08-30  154  		ir_raw_event_reset(priv->rdev);
a84fcdaa Guoxiong Yan          2014-08-30  155  		symb_num = readl_relaxed(priv->base + IR_DATAH);
a84fcdaa Guoxiong Yan          2014-08-30  156  		for (i = 0; i < symb_num; i++)
a84fcdaa Guoxiong Yan          2014-08-30  157  			readl_relaxed(priv->base + IR_DATAL);
a84fcdaa Guoxiong Yan          2014-08-30  158  
a84fcdaa Guoxiong Yan          2014-08-30  159  		writel_relaxed(INT_CLR_OVERFLOW, priv->base + IR_INTC);
a84fcdaa Guoxiong Yan          2014-08-30  160  		dev_info(priv->dev, "overflow, level=%d\n",
a84fcdaa Guoxiong Yan          2014-08-30  161  			 IR_CFG_INT_THRESHOLD);
a84fcdaa Guoxiong Yan          2014-08-30  162  	}
a84fcdaa Guoxiong Yan          2014-08-30  163  
a84fcdaa Guoxiong Yan          2014-08-30  164  	if ((irq_sr & INTMS_SYMBRCV) || (irq_sr & INTMS_TIMEOUT)) {
a84fcdaa Guoxiong Yan          2014-08-30  165  		DEFINE_IR_RAW_EVENT(ev);
a84fcdaa Guoxiong Yan          2014-08-30  166  
a84fcdaa Guoxiong Yan          2014-08-30  167  		symb_num = readl_relaxed(priv->base + IR_DATAH);
a84fcdaa Guoxiong Yan          2014-08-30  168  		for (i = 0; i < symb_num; i++) {
a84fcdaa Guoxiong Yan          2014-08-30  169  			symb_val = readl_relaxed(priv->base + IR_DATAL);
a84fcdaa Guoxiong Yan          2014-08-30  170  			data_l = ((symb_val & 0xffff) * 10);
a84fcdaa Guoxiong Yan          2014-08-30  171  			data_h =  ((symb_val >> 16) & 0xffff) * 10;
a84fcdaa Guoxiong Yan          2014-08-30  172  			symb_time = (data_l + data_h) / 10;
a84fcdaa Guoxiong Yan          2014-08-30  173  
a84fcdaa Guoxiong Yan          2014-08-30  174  			ev.duration = US_TO_NS(data_l);
a84fcdaa Guoxiong Yan          2014-08-30  175  			ev.pulse = true;
a84fcdaa Guoxiong Yan          2014-08-30  176  			ir_raw_event_store(priv->rdev, &ev);
a84fcdaa Guoxiong Yan          2014-08-30  177  
a84fcdaa Guoxiong Yan          2014-08-30  178  			if (symb_time < IR_CFG_SYMBOL_MAXWIDTH) {
a84fcdaa Guoxiong Yan          2014-08-30  179  				ev.duration = US_TO_NS(data_h);
a84fcdaa Guoxiong Yan          2014-08-30  180  				ev.pulse = false;
a84fcdaa Guoxiong Yan          2014-08-30  181  				ir_raw_event_store(priv->rdev, &ev);
a84fcdaa Guoxiong Yan          2014-08-30  182  			} else {
a84fcdaa Guoxiong Yan          2014-08-30  183  				ir_raw_event_set_idle(priv->rdev, true);
a84fcdaa Guoxiong Yan          2014-08-30  184  			}
a84fcdaa Guoxiong Yan          2014-08-30  185  		}
a84fcdaa Guoxiong Yan          2014-08-30  186  
a84fcdaa Guoxiong Yan          2014-08-30  187  		if (irq_sr & INTMS_SYMBRCV)
a84fcdaa Guoxiong Yan          2014-08-30  188  			writel_relaxed(INT_CLR_RCV, priv->base + IR_INTC);
a84fcdaa Guoxiong Yan          2014-08-30  189  		if (irq_sr & INTMS_TIMEOUT)
a84fcdaa Guoxiong Yan          2014-08-30  190  			writel_relaxed(INT_CLR_TIMEOUT, priv->base + IR_INTC);
a84fcdaa Guoxiong Yan          2014-08-30  191  	}
a84fcdaa Guoxiong Yan          2014-08-30  192  
a84fcdaa Guoxiong Yan          2014-08-30  193  	/* Empty software fifo */

:::::: The code at line 99 was first introduced by commit
:::::: a84fcdaa905862b09482544d190c94a8436e4334 [media] rc: Introduce hix5hd2 IR transmitter driver

:::::: TO: Guoxiong Yan <yanguoxiong@huawei.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

--=_54256341.viqxbTIwldqkc2qkniCmYomajatC0lj7ROEnOKM6SpQ6Po91
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=".config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/s390 3.17.0-rc6 Kernel Configuration
#
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_PGSTE=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_KEXEC=y
CONFIG_AUDIT_ARCH=y
CONFIG_NO_IOPORT_MAP=y
CONFIG_PCI_QUIRKS=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_S390=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_COMPILE_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_NATIVE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_EXPERT=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_HAVE_FUTEX_CMPXCHG=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
CONFIG_HAVE_64BIT_ALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HAVE_VIRT_CPU_ACCOUNTING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_CLONE_BACKWARDS2=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
CONFIG_MODULE_SIG_SHA1=y
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha1"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_IBM_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_ARCH_INLINE_SPIN_TRYLOCK=y
CONFIG_ARCH_INLINE_SPIN_TRYLOCK_BH=y
CONFIG_ARCH_INLINE_SPIN_LOCK=y
CONFIG_ARCH_INLINE_SPIN_LOCK_BH=y
CONFIG_ARCH_INLINE_SPIN_LOCK_IRQ=y
CONFIG_ARCH_INLINE_SPIN_LOCK_IRQSAVE=y
CONFIG_ARCH_INLINE_SPIN_UNLOCK=y
CONFIG_ARCH_INLINE_SPIN_UNLOCK_BH=y
CONFIG_ARCH_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE=y
CONFIG_ARCH_INLINE_READ_TRYLOCK=y
CONFIG_ARCH_INLINE_READ_LOCK=y
CONFIG_ARCH_INLINE_READ_LOCK_BH=y
CONFIG_ARCH_INLINE_READ_LOCK_IRQ=y
CONFIG_ARCH_INLINE_READ_LOCK_IRQSAVE=y
CONFIG_ARCH_INLINE_READ_UNLOCK=y
CONFIG_ARCH_INLINE_READ_UNLOCK_BH=y
CONFIG_ARCH_INLINE_READ_UNLOCK_IRQ=y
CONFIG_ARCH_INLINE_READ_UNLOCK_IRQRESTORE=y
CONFIG_ARCH_INLINE_WRITE_TRYLOCK=y
CONFIG_ARCH_INLINE_WRITE_LOCK=y
CONFIG_ARCH_INLINE_WRITE_LOCK_BH=y
CONFIG_ARCH_INLINE_WRITE_LOCK_IRQ=y
CONFIG_ARCH_INLINE_WRITE_LOCK_IRQSAVE=y
CONFIG_ARCH_INLINE_WRITE_UNLOCK=y
CONFIG_ARCH_INLINE_WRITE_UNLOCK_BH=y
CONFIG_ARCH_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_HAVE_MARCH_Z900_FEATURES=y
# CONFIG_HAVE_MARCH_Z990_FEATURES is not set
# CONFIG_HAVE_MARCH_Z9_109_FEATURES is not set
# CONFIG_HAVE_MARCH_Z10_FEATURES is not set
# CONFIG_HAVE_MARCH_Z196_FEATURES is not set
# CONFIG_HAVE_MARCH_ZEC12_FEATURES is not set
CONFIG_MARCH_Z900=y
# CONFIG_MARCH_Z990 is not set
# CONFIG_MARCH_Z9_109 is not set
# CONFIG_MARCH_Z10 is not set
# CONFIG_MARCH_Z196 is not set
# CONFIG_MARCH_ZEC12 is not set
# CONFIG_MARCH_G5_TUNE is not set
CONFIG_MARCH_Z900_TUNE=y
# CONFIG_MARCH_Z990_TUNE is not set
# CONFIG_MARCH_Z9_109_TUNE is not set
# CONFIG_MARCH_Z10_TUNE is not set
# CONFIG_MARCH_Z196_TUNE is not set
# CONFIG_MARCH_ZEC12_TUNE is not set
CONFIG_TUNE_DEFAULT=y
# CONFIG_TUNE_G5 is not set
# CONFIG_TUNE_Z900 is not set
# CONFIG_TUNE_Z990 is not set
# CONFIG_TUNE_Z9_109 is not set
# CONFIG_TUNE_Z10 is not set
# CONFIG_TUNE_Z196 is not set
# CONFIG_TUNE_ZEC12 is not set
CONFIG_64BIT=y
CONFIG_COMPAT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_SMP=y
CONFIG_NR_CPUS=64
CONFIG_HOTPLUG_CPU=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_BOOK=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y

#
# Memory setup
#
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_FORCE_MAX_ZONEORDER=9
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_HAVE_MEMBLOCK_PHYS_MAP=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
CONFIG_CMA_AREAS=7
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=m
CONFIG_ZSMALLOC=m
CONFIG_PGTABLE_MAPPING=y
CONFIG_PACK_STACK=y
CONFIG_CHECK_STACK=y
CONFIG_STACK_GUARD=256
CONFIG_WARN_DYNAMIC_STACK=y

#
# I/O subsystem
#
CONFIG_QDIO=m
CONFIG_PCI=y
CONFIG_PCI_NR_FUNCTIONS=64
CONFIG_PCI_NR_MSI=256
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y

#
# PCI host controller drivers
#
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_SHPC=m
CONFIG_HOTPLUG_PCI_S390=y
CONFIG_PCI_DOMAINS=y
CONFIG_HAS_IOMEM=y
CONFIG_IOMMU_HELPER=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_CHSC_SCH=m
CONFIG_SCM_BUS=y
CONFIG_EADM_SCH=m

#
# Dump support
#
CONFIG_CRASH_DUMP=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=m
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_SECCOMP=y

#
# Power Management
#
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_ARCH_SAVE_PAGE_KEYS=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_DPM_WATCHDOG=y
CONFIG_DPM_WATCHDOG_TIMEOUT=12
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=m
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_IUCV=y
CONFIG_AFIUCV=m
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_QUEUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=m
CONFIG_NFT_EXTHDR=m
CONFIG_NFT_META=m
CONFIG_NFT_CT=m
CONFIG_NFT_RBTREE=m
CONFIG_NFT_HASH=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_NAT=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPCOMP=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_TABLES_IPV4=m
CONFIG_NFT_CHAIN_ROUTE_IPV4=m
CONFIG_NFT_CHAIN_NAT_IPV4=m
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NF_TABLES_ARP=m
CONFIG_NF_NAT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_NF_TABLES_IPV6=m
CONFIG_NFT_CHAIN_ROUTE_IPV6=m
CONFIG_NFT_CHAIN_NAT_IPV6=m
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_NF_NAT_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
CONFIG_NF_TABLES_BRIDGE=m
CONFIG_NFT_BRIDGE_META=m
CONFIG_NFT_BRIDGE_REJECT=m
CONFIG_NF_LOG_BRIDGE=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
CONFIG_NET_SCTPPROBE=m
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=m
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=m
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_MEDIA_IB=y
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=m
CONFIG_LAPB=m
CONFIG_PHONET=m
CONFIG_6LOWPAN=m
CONFIG_IEEE802154=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=m
CONFIG_NET_CLS_BPF=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_EMATCH_CANID=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_MCAST=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=y
CONFIG_OPENVSWITCH_VXLAN=y
CONFIG_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=m
CONFIG_HSR=m
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_TCPPROBE=m
CONFIG_NET_DROP_MONITOR=m
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
CONFIG_CAN_AT91=m
CONFIG_CAN_JANZ_ICAN3=m
CONFIG_PCH_CAN=m
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PLX_PCI=m
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
CONFIG_CAN_CC770_ISA=m
CONFIG_CAN_CC770_PLATFORM=m

#
# CAN SPI interfaces
#
CONFIG_CAN_MCP251X=m

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
CONFIG_CAN_GS_USB=m
CONFIG_CAN_KVASER_USB=m
CONFIG_CAN_PEAK_USB=m
CONFIG_CAN_8DEV_USB=m
CONFIG_CAN_SOFTING=m
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=m
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_RDMA=m
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=m
CONFIG_CAIF_USB=m
CONFIG_CEPH_LIB=m
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
CONFIG_NFC_DIGITAL=m
CONFIG_NFC_NCI=m
CONFIG_NFC_NCI_SPI=y
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=m
CONFIG_NFC_TRF7970A=m
CONFIG_NFC_SIM=m
CONFIG_NFC_PORT100=m
CONFIG_NFC_PN544=m
CONFIG_NFC_PN544_I2C=m
CONFIG_NFC_MICROREAD=m
CONFIG_NFC_MICROREAD_I2C=m
CONFIG_NFC_MRVL=m
CONFIG_NFC_MRVL_USB=m
CONFIG_NFC_ST21NFCA=m
CONFIG_NFC_ST21NFCA_I2C=m
CONFIG_NFC_ST21NFCB=m
CONFIG_NFC_ST21NFCB_I2C=m
CONFIG_HAVE_BPF_JIT=y
# CONFIG_PCMCIA is not set
CONFIG_CCW=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_FENCE_TRACE=y

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m
CONFIG_MTD_SWAP=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MAP_BANK_WIDTH_8=y
CONFIG_MTD_MAP_BANK_WIDTH_16=y
CONFIG_MTD_MAP_BANK_WIDTH_32=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_I4=y
CONFIG_MTD_CFI_I8=y
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
CONFIG_MTD_PCI=m
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_DATAFLASH=m
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_M25P80=m
CONFIG_MTD_SST25L=m
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_PCI=m
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_RICOH=m
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=m
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_NAND_SH_FLCTL=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_SPI_NOR=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_MTD_UBI_BLOCK=y
CONFIG_PARPORT=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
# CONFIG_ZRAM is not set
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_DRBD=m
CONFIG_DRBD_FAULT_INJECTION=y
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_NVME=m
CONFIG_BLK_DEV_SKD=m
CONFIG_BLK_DEV_OSD=m
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=m

#
# S/390 block device drivers
#
CONFIG_BLK_DEV_XPRAM=m
CONFIG_DCSSBLK=m
CONFIG_DASD=m
CONFIG_DASD_PROFILE=y
CONFIG_DASD_ECKD=m
CONFIG_DASD_FBA=m
CONFIG_DASD_DIAG=m
CONFIG_DASD_EER=y
CONFIG_SCM_BLOCK=m
CONFIG_SCM_BLOCK_CLUSTER_WRITE=y
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
CONFIG_BLK_DEV_RSXX=m

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_AD525X_DPOT_SPI=m
CONFIG_DUMMY_IRQ=m
CONFIG_PHANTOM=m
CONFIG_INTEL_MID_PTI=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=m
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_TI_DAC7512=m
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=m
CONFIG_PCH_PHUB=m
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_LATTICE_ECP3_CONFIG=m
CONFIG_SRAM=y
CONFIG_C2PORT=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_SPI=m
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m

#
# Intel MIC Bus Driver
#

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_GENWQE=m
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=m

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=m
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ESAS2R=m
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_UFSHCD_PCI=m
CONFIG_SCSI_UFSHCD_PLATFORM=m
CONFIG_SCSI_HPTIOP=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_TCM_QLA2XXX=m
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_DEBUG=m
CONFIG_ZFCP=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
CONFIG_SCSI_BFA_FC=m
CONFIG_SCSI_VIRTIO=m
CONFIG_SCSI_CHELSIO_FCOE=m
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BCACHE=m
CONFIG_BCACHE_DEBUG=y
CONFIG_BCACHE_CLOSURES_DEBUG=y
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_MQ=m
CONFIG_DM_CACHE_CLEANER=m
CONFIG_DM_ERA=m
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
CONFIG_DM_SWITCH=m
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
CONFIG_SBP_TARGET=m
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_NETDEVICES=y
CONFIG_MII=m
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
CONFIG_EQUALIZER=m
CONFIG_NET_FC=y
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_VXLAN=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
CONFIG_NLMON=m
CONFIG_SUNGEM_PHY=m
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
CONFIG_ATM_ENI_BURST_TX_16W=y
CONFIG_ATM_ENI_BURST_TX_8W=y
CONFIG_ATM_ENI_BURST_TX_4W=y
CONFIG_ATM_ENI_BURST_TX_2W=y
CONFIG_ATM_ENI_BURST_RX_16W=y
CONFIG_ATM_ENI_BURST_RX_8W=y
CONFIG_ATM_ENI_BURST_RX_4W=y
CONFIG_ATM_ENI_BURST_RX_2W=y
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_NICSTAR=m
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=m
CONFIG_ATM_IDT77252_DEBUG=y
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=m
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=m
CONFIG_ATM_IA_DEBUG=y
CONFIG_ATM_FORE200E=m
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_ATM_SOLOS=m

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
CONFIG_CAIF_SPI_SLAVE=m
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=m
CONFIG_CAIF_VIRTIO=m
CONFIG_VHOST_NET=m
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m
CONFIG_ETHERNET=y
CONFIG_MDIO=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_TYPHOON=m
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=m
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_ALTERA_TSE=m
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=m
CONFIG_PCNET32=m
CONFIG_NET_XGENE=m
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=m
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=m
CONFIG_MACB=m
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=m
CONFIG_BNX2X=m
CONFIG_BNX2X_SRIOV=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
CONFIG_NET_CALXEDA_XGMAC=m
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
CONFIG_CHELSIO_T4_DCB=y
CONFIG_CHELSIO_T4VF=m
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
CONFIG_CX_ECAT=m
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=m
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=m
CONFIG_SUNDANCE=m
CONFIG_SUNDANCE_MMIO=y
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_VXLAN=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=m
CONFIG_VXGE=m
CONFIG_VXGE_DEBUG_TRACE_ALL=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=m
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=m
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IGB=m
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=m
CONFIG_IXGB=m
CONFIG_IXGBE=m
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_I40E=m
CONFIG_I40E_VXLAN=y
CONFIG_I40E_DCB=y
CONFIG_I40EVF=m
CONFIG_NET_VENDOR_I825XX=y
CONFIG_IP1000=m
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=m
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=m
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_EN_VXLAN=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_MLX5_CORE=m
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=m
CONFIG_KS8851=m
CONFIG_KS8851_MLL=m
CONFIG_KSZ884X_PCI=m
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_ENC28J60=m
CONFIG_ENC28J60_WRITEVERIFY=y
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
CONFIG_FEALNX=m
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=m
CONFIG_NS83820=m
CONFIG_NET_VENDOR_8390=y
CONFIG_NE2K_PCI=m
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=m
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=m
CONFIG_ETHOC=m
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLCNIC_DCB=y
CONFIG_QLCNIC_VXLAN=y
CONFIG_QLCNIC_HWMON=y
CONFIG_QLGE=m
CONFIG_NETXEN_NIC=m
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=m
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R8169=m
CONFIG_SH_ETH=m
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=m
CONFIG_NET_VENDOR_SAMSUNG=y
CONFIG_SXGBE_ETH=m
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=m
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=m
CONFIG_SIS190=m
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=m
CONFIG_SMSC911X=m
# CONFIG_SMSC911X_ARCH_HOOKS is not set
CONFIG_SMSC9420=m
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
CONFIG_STMMAC_PLATFORM=y
CONFIG_DWMAC_SOCFPGA=y
CONFIG_STMMAC_PCI=y
CONFIG_STMMAC_DEBUG_FS=y
CONFIG_STMMAC_DA=y
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NIU=m
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=m
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=m
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_VELOCITY=m
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=m
CONFIG_WIZNET_W5300=m
# CONFIG_WIZNET_BUS_DIRECT is not set
# CONFIG_WIZNET_BUS_INDIRECT is not set
CONFIG_WIZNET_BUS_ANY=y
CONFIG_FDDI=m
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=m
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_BCM7XXX_PHY=m
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
CONFIG_MDIO_BITBANG=m
CONFIG_MICREL_KS8995MA=m
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y

#
# S/390 network device drivers
#
CONFIG_LCS=m
CONFIG_CTCM=m
CONFIG_NETIUCV=m
CONFIG_SMSGIUCV=m
CONFIG_SMSGIUCV_EVENT=m
CONFIG_CLAW=m
CONFIG_QETH=m
CONFIG_QETH_L2=m
CONFIG_QETH_L3=m
CONFIG_QETH_IPV6=y
CONFIG_CCWGROUP=m

#
# Host-side USB support is needed for USB Network Adapter support
#
CONFIG_USB_NET_DRIVERS=m
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_RTL8152=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SR9700=m
CONFIG_USB_NET_SR9800=m
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_CDC_PHONET=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
CONFIG_LANMEDIA=m
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m
CONFIG_HDLC_X25=m
CONFIG_PCI200SYN=m
CONFIG_WANXL=m
CONFIG_PC300TOO=m
CONFIG_FARSYNC=m
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
CONFIG_DSCC4_PCI_RST=y
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_LAPBETHER=m
CONFIG_X25_ASY=m
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKEHARD=m
CONFIG_IEEE802154_FAKELB=m
CONFIG_IEEE802154_AT86RF230=m
CONFIG_IEEE802154_MRF24J40=m
CONFIG_IEEE802154_CC2520=m
CONFIG_VMXNET3=m

#
# Input device support
#
CONFIG_INPUT=m
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=m
CONFIG_KEYBOARD_QT1070=m
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_ST_KEYSCAN=m
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_SH_KEYSC=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_CROS_EC=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_JOYSTICK_WALKERA0701=m
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_HANWANG=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_SERIAL_WACOM4=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=m
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_AD7879_SPI=m
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP_SPI=m
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=m
CONFIG_TOUCHSCREEN_DA9052=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_WM831X=m
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_TSC2005=m
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_PCAP=m
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_SUN4I=m
CONFIG_TOUCHSCREEN_SUR40=m
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_AD714X_SPI=m
CONFIG_INPUT_ARIZONA_HAPTICS=m
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_KXTJ9=m
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_RETU_PWRBUTTON=m
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_PWM_BEEPER=m
CONFIG_INPUT_DA9052_ONKEY=m
CONFIG_INPUT_WM831X_ON=m
CONFIG_INPUT_PCAP=m
CONFIG_INPUT_ADXL34X=m
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_ADXL34X_SPI=m
CONFIG_INPUT_IMS_PCU=m
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m

#
# Hardware I/O ports
#
CONFIG_SERIO=m
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=m
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
CONFIG_SERIO_OLPC_APSP=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_TTY=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
CONFIG_CYZ_INTR=y
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
CONFIG_ISI=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=m
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CLPS711X=m
CONFIG_SERIAL_MAX3100=m
CONFIG_SERIAL_MAX310X=m
CONFIG_SERIAL_MRST_MAX3110=m
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_SH_SCI=m
CONFIG_SERIAL_SH_SCI_NR_UARTS=2
CONFIG_SERIAL_SH_SCI_DMA=y
CONFIG_SERIAL_CORE=m
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_SC16IS7XX=m
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_PCH_UART=m
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=m
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=m
CONFIG_SERIAL_ST_ASC=m
CONFIG_SERIAL_MEN_Z135=m
CONFIG_TTY_PRINTK=m
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IUCV=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=m
CONFIG_R3964=m
CONFIG_APPLICOM=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_DEVPORT=y

#
# S/390 character device drivers
#
CONFIG_TN3270=m
CONFIG_TN3270_TTY=m
CONFIG_TN3270_FS=m
CONFIG_TN3215=y
CONFIG_TN3215_CONSOLE=y
CONFIG_CCW_CONSOLE=y
CONFIG_SCLP_TTY=y
CONFIG_SCLP_CONSOLE=y
CONFIG_SCLP_VT220_TTY=y
CONFIG_SCLP_VT220_CONSOLE=y
CONFIG_SCLP_CPI=m
CONFIG_SCLP_ASYNC=m
CONFIG_HMC_DRV=m
CONFIG_S390_TAPE=m

#
# S/390 tape hardware support
#
CONFIG_S390_TAPE_34XX=m
CONFIG_S390_TAPE_3590=m
CONFIG_VMLOGRDR=m
CONFIG_VMCP=y
CONFIG_MONREADER=m
CONFIG_MONWRITER=m
CONFIG_S390_VMUR=m

#
# I2C support
#
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=m
CONFIG_I2C_EFM32=m
CONFIG_I2C_EG20T=m
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=m
CONFIG_I2C_SH_MOBILE=m
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_SUN6I_P2WI=m
CONFIG_I2C_XILINX=m
CONFIG_I2C_RCAR=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_ROBOTFUZZ_OSIF=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=m
CONFIG_I2C_STUB=m
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_ATMEL=m
CONFIG_SPI_BCM2835=m
CONFIG_SPI_BCM63XX_HSSPI=m
CONFIG_SPI_BITBANG=m
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_CLPS711X=m
CONFIG_SPI_EP93XX=m
CONFIG_SPI_IMX=m
CONFIG_SPI_LM70_LLP=m
CONFIG_SPI_FSL_DSPI=m
CONFIG_SPI_TI_QSPI=m
CONFIG_SPI_OMAP_100K=m
CONFIG_SPI_ORION=m
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
CONFIG_SPI_RSPI=m
CONFIG_SPI_SC18IS602=m
CONFIG_SPI_SH=m
CONFIG_SPI_SH_HSPI=m
CONFIG_SPI_SUN4I=m
CONFIG_SPI_SUN6I=m
CONFIG_SPI_TEGRA114=m
CONFIG_SPI_TEGRA20_SFLASH=m
CONFIG_SPI_TEGRA20_SLINK=m
CONFIG_SPI_TOPCLIFF_PCH=m
CONFIG_SPI_XCOMM=m
CONFIG_SPI_XILINX=m
CONFIG_SPI_XTENSA_XTFPGA=m
CONFIG_SPI_DESIGNWARE=m
CONFIG_SPI_DW_PCI=m
CONFIG_SPI_DW_MMIO=m

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m
CONFIG_SPMI=m
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=m
CONFIG_PPS_DEBUG=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m
CONFIG_DP83640_PHY=m
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_MXC=m
CONFIG_W1_MASTER_DS1WM=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2406=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=m
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=m
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_SMB347=m
CONFIG_BATTERY_GOLDFISH=m
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7310=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9052_ADC=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_MC13783_ADC=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_POWR1220=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LTC2945=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4222=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4260=m
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_MENF21BMC_HWMON=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_NCT6683=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_TPS40422=m
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_PWM_FAN=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SHTC1=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_ADC128D818=m
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP103=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_RCAR_THERMAL=m

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_DA9052_WATCHDOG=m
CONFIG_MENF21BMC_WATCHDOG=m
CONFIG_WM831X_WATCHDOG=m
CONFIG_XILINX_WATCHDOG=m
CONFIG_DW_WATCHDOG=m
CONFIG_RETU_WATCHDOG=m
CONFIG_TEGRA_WATCHDOG=m
CONFIG_ALIM7101_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_KEMPLD_WDT=m
CONFIG_DIAG288_WATCHDOG=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_BCM590XX=m
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=m
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_KEMPLD=m
CONFIG_MFD_MENF21BMC=m
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_RTSX_PCI=m
CONFIG_MFD_RTSX_USB=m
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=m
CONFIG_ABX500_CORE=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=m
CONFIG_TPS6105X=m
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65218=m
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_ARIZONA_SPI=m
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_ACT8865=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ANATOP=m
CONFIG_REGULATOR_ARIZONA=m
CONFIG_REGULATOR_BCM590XX=m
CONFIG_REGULATOR_DA9052=m
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_DA9211=m
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_LTC3589=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_PBIAS=m
CONFIG_REGULATOR_PCAP=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS6524X=m
CONFIG_REGULATOR_WM831X=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=m
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DMA_CONTIG=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
CONFIG_VIDEOBUF2_DVB=m
CONFIG_DVB_CORE=m
CONFIG_DVB_NET=y
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_XMP_DECODER=m
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
CONFIG_IR_HIX5HD2=m
CONFIG_IR_IMON=m
CONFIG_IR_MCEUSB=m
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_IGUANA=m
CONFIG_IR_TTUSBIR=m
CONFIG_IR_IMG=m
CONFIG_IR_IMG_RAW=y
CONFIG_IR_IMG_HW=y
CONFIG_IR_IMG_NEC=y
CONFIG_IR_IMG_JVC=y
CONFIG_IR_IMG_SONY=y
CONFIG_IR_IMG_SHARP=y
CONFIG_IR_IMG_SANYO=y
CONFIG_RC_LOOPBACK=m
CONFIG_IR_GPIO_CIR=m
CONFIG_RC_ST=m
CONFIG_IR_SUNXI=m
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
CONFIG_USB_GSPCA_DTCS033=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
CONFIG_USB_GSPCA_KINECT=m
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_STK1135=m
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_PWC=m
CONFIG_USB_PWC_DEBUG=y
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_VIDEO_CPIA2=m
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_VIDEO_USBTV=m

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
CONFIG_VIDEO_PVRUSB2_DEBUGIFC=y
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_TLG2300=m
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_STK1160_COMMON=m
CONFIG_VIDEO_STK1160_AC97=y
CONFIG_VIDEO_STK1160=m
CONFIG_VIDEO_GO7007=m
CONFIG_VIDEO_GO7007_USB=m
CONFIG_VIDEO_GO7007_LOADER=m
CONFIG_VIDEO_GO7007_USB_S2250_BOARD=m

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_AU0828_V4L2=y
CONFIG_VIDEO_AU0828_RC=y
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
CONFIG_DVB_USB_DEBUG=y
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_FRIIO=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_AF9035=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_AZ6007=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_USB_RTL28XXU=m
CONFIG_DVB_USB_DVBSKY=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_USB_DRV=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG=y
CONFIG_DVB_AS102=m

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_V4L2=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_EM28XX_RC=m

#
# Software defined radio USB devices
#
CONFIG_USB_AIRSPY=m
CONFIG_USB_HACKRF=m
CONFIG_USB_MSI2500=m
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_IVTV_ALSA=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_SOLO6X10=m
CONFIG_VIDEO_TW68=m

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
CONFIG_VIDEO_CX25821=m
CONFIG_VIDEO_CX25821_ALSA=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_ENABLE_VP3054=y
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_BT848=m
CONFIG_DVB_BT8XX=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_SAA7134_GO7007=m
CONFIG_VIDEO_SAA7164=m

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110_IR=y
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG=y
CONFIG_DVB_PLUTO2=m
CONFIG_DVB_DM1105=m
CONFIG_DVB_PT1=m
CONFIG_DVB_PT3=m
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_VIDEO_DAVINCI_VPIF_DISPLAY=m
CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE=m
CONFIG_VIDEO_DM6446_CCDC=m
CONFIG_VIDEO_DM355_CCDC=m
CONFIG_VIDEO_SH_VOU=m
CONFIG_VIDEO_TIMBERDALE=m
CONFIG_VIDEO_M32R_AR=m
CONFIG_VIDEO_S3C_CAMIF=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_SCALE_CROP=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_VIDEO_RCAR_VIN=m
CONFIG_VIDEO_MX2=m
CONFIG_VIDEO_ATMEL_ISI=m
CONFIG_VIDEO_SAMSUNG_S5P_TV=y
CONFIG_VIDEO_SAMSUNG_S5P_HDMI=m
CONFIG_VIDEO_SAMSUNG_S5P_HDMI_DEBUG=y
CONFIG_VIDEO_SAMSUNG_S5P_HDMIPHY=m
CONFIG_VIDEO_SAMSUNG_S5P_SII9234=m
CONFIG_VIDEO_SAMSUNG_S5P_SDO=m
CONFIG_VIDEO_SAMSUNG_S5P_MIXER=m
CONFIG_VIDEO_SAMSUNG_S5P_MIXER_DEBUG=y
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=m
CONFIG_VIDEO_SAMSUNG_S5P_G2D=m
CONFIG_VIDEO_SAMSUNG_S5P_JPEG=m
CONFIG_VIDEO_SAMSUNG_S5P_MFC=m
CONFIG_VIDEO_MX2_EMMAPRP=m
CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC=m
CONFIG_VIDEO_SH_VEU=m
CONFIG_VIDEO_RENESAS_VSP1=m
CONFIG_VIDEO_TI_VPE=m
CONFIG_VIDEO_TI_VPE_DEBUG=y
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVID=m
CONFIG_VIDEO_MEM2MEM_TESTDEV=m

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
CONFIG_VIDEO_W9966=m
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=m
CONFIG_I2C_SI470X=m
CONFIG_RADIO_SI4713=m
CONFIG_USB_SI4713=m
CONFIG_PLATFORM_SI4713=m
CONFIG_I2C_SI4713=m
CONFIG_RADIO_SI476X=m
CONFIG_USB_MR800=m
CONFIG_USB_DSBR=m
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_SHARK=m
CONFIG_RADIO_SHARK2=m
CONFIG_USB_KEENE=m
CONFIG_USB_RAREMONO=m
CONFIG_USB_MA901=m
CONFIG_RADIO_TEA5764=m
CONFIG_RADIO_SAA7706H=m
CONFIG_RADIO_TEF6862=m
CONFIG_RADIO_WL1273=m

#
# Texas Instruments WL128x FM driver (ST based)
#

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_SMS_SIANO_MDTV=m
CONFIG_SMS_SIANO_RC=y
CONFIG_SMS_SIANO_DEBUGFS=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_UDA1342=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_TW2804=m
CONFIG_VIDEO_TW9903=m
CONFIG_VIDEO_TW9906=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_ADV7343=m

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_MT9V011=m

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=m
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
CONFIG_SOC_CAMERA_IMX074=m
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9M111=m
CONFIG_SOC_CAMERA_MT9T031=m
CONFIG_SOC_CAMERA_MT9T112=m
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_OV2640=m
CONFIG_SOC_CAMERA_OV5642=m
CONFIG_SOC_CAMERA_OV6650=m
CONFIG_SOC_CAMERA_OV772X=m
CONFIG_SOC_CAMERA_OV9640=m
CONFIG_SOC_CAMERA_OV9740=m
CONFIG_SOC_CAMERA_RJ54N1=m
CONFIG_SOC_CAMERA_TW9910=m
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MSI001=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88TS2022=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_MXL301RF=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_RTL2832_SDR=m
CONFIG_DVB_SI2168=m
CONFIG_DVB_AS102_FE=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m
CONFIG_DVB_TC90522=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#

#
# Direct Rendering Manager
#
CONFIG_DRM=m
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_PTN3460=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_MGA=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m

#
# Frame buffer Devices
#
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CLPS711X=m
CONFIG_FB_CYBER2000=m
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_UVESA=m
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=m
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=m
CONFIG_FB_SMSCUFX=m
CONFIG_FB_UDL=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI922X=m
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_LCD_S6E63M0=m
CONFIG_LCD_LD9040=m
CONFIG_LCD_AMS369FG06=m
CONFIG_LCD_LMS501KF03=m
CONFIG_LCD_HX8357=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_DA9052=m
CONFIG_BACKLIGHT_WM831X=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_LM3630A=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_LV5207LP=m
CONFIG_BACKLIGHT_BD6107=m
CONFIG_VGASTATE=m
CONFIG_VIDEOMODE_HELPERS=y
CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_DMAENGINE_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
CONFIG_SND_AW2=m
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5535AUDIO=m
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_ES1968_RADIO=y
CONFIG_SND_FM801=m
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_SPI=y
CONFIG_SND_AT73C213=m
CONFIG_SND_AT73C213_TARGET_BITRATE=48000
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_6FIRE=m
CONFIG_SND_USB_HIFACE=m
CONFIG_SND_BCD2000=m
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
CONFIG_SND_DICE=m
CONFIG_SND_FIREWIRE_SPEAKERS=m
CONFIG_SND_ISIGHT=m
CONFIG_SND_SCS1X=m
CONFIG_SND_FIREWORKS=m
CONFIG_SND_BEBOB=m
CONFIG_SND_SOC=m
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_SOC_ADI=m
CONFIG_SND_SOC_ADI_AXI_I2S=m
CONFIG_SND_SOC_ADI_AXI_SPDIF=m
CONFIG_SND_ATMEL_SOC=m
CONFIG_SND_BCM2835_SOC_I2S=m
CONFIG_SND_EP93XX_SOC=m

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
CONFIG_SND_SOC_FSL_ASRC=m
CONFIG_SND_SOC_FSL_SAI=m
CONFIG_SND_SOC_FSL_SSI=m
CONFIG_SND_SOC_FSL_SPDIF=m
CONFIG_SND_SOC_FSL_ESAI=m
CONFIG_SND_SOC_IMX_PCM_DMA=m
CONFIG_SND_SOC_IMX_AUDMUX=m
CONFIG_SND_IMX_SOC=m

#
# SoC Audio support for Freescale i.MX boards:
#
CONFIG_SND_SOC_IMX_SPDIF=m
CONFIG_SND_JZ4740_SOC=m
CONFIG_SND_JZ4740_SOC_I2S=m
CONFIG_SND_JZ4740_SOC_QI_LB60=m
CONFIG_SND_KIRKWOOD_SOC=m
CONFIG_SND_KIRKWOOD_SOC_ARMADA370_DB=m
CONFIG_SND_SOC_INTEL_SST=m
CONFIG_SND_SOC_ROCKCHIP=m
CONFIG_SND_ROCKCHIP_I2S=m
CONFIG_SND_S6000_SOC=m
CONFIG_SND_SOC_SIRF=m
CONFIG_SND_SOC_SIRF_AUDIO=m
CONFIG_SND_SOC_SIRF_AUDIO_PORT=m
CONFIG_SND_SOC_SIRF_USP=m
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
CONFIG_SND_SOC_ALL_CODECS=m
CONFIG_SND_SOC_ARIZONA=m
CONFIG_SND_SOC_WM_HUBS=m
CONFIG_SND_SOC_WM_ADSP=m
CONFIG_SND_SOC_AB8500_CODEC=m
CONFIG_SND_SOC_AD1836=m
CONFIG_SND_SOC_AD193X=m
CONFIG_SND_SOC_AD193X_SPI=m
CONFIG_SND_SOC_AD193X_I2C=m
CONFIG_SND_SOC_AD73311=m
CONFIG_SND_SOC_ADAU1373=m
CONFIG_SND_SOC_ADAU1701=m
CONFIG_SND_SOC_ADAU17X1=m
CONFIG_SND_SOC_ADAU1761=m
CONFIG_SND_SOC_ADAU1761_I2C=m
CONFIG_SND_SOC_ADAU1761_SPI=m
CONFIG_SND_SOC_ADAU1781=m
CONFIG_SND_SOC_ADAU1781_I2C=m
CONFIG_SND_SOC_ADAU1781_SPI=m
CONFIG_SND_SOC_ADAU1977=m
CONFIG_SND_SOC_ADAU1977_SPI=m
CONFIG_SND_SOC_ADAU1977_I2C=m
CONFIG_SND_SOC_ADAV80X=m
CONFIG_SND_SOC_ADAV801=m
CONFIG_SND_SOC_ADAV803=m
CONFIG_SND_SOC_ADS117X=m
CONFIG_SND_SOC_AK4104=m
CONFIG_SND_SOC_AK4535=m
CONFIG_SND_SOC_AK4554=m
CONFIG_SND_SOC_AK4641=m
CONFIG_SND_SOC_AK4642=m
CONFIG_SND_SOC_AK4671=m
CONFIG_SND_SOC_AK5386=m
CONFIG_SND_SOC_ALC5623=m
CONFIG_SND_SOC_ALC5632=m
CONFIG_SND_SOC_CS42L51=m
CONFIG_SND_SOC_CS42L51_I2C=m
CONFIG_SND_SOC_CS42L52=m
CONFIG_SND_SOC_CS42L56=m
CONFIG_SND_SOC_CS42L73=m
CONFIG_SND_SOC_CS4265=m
CONFIG_SND_SOC_CS4270=m
CONFIG_SND_SOC_CS4271=m
CONFIG_SND_SOC_CS42XX8=m
CONFIG_SND_SOC_CS42XX8_I2C=m
CONFIG_SND_SOC_CX20442=m
CONFIG_SND_SOC_JZ4740_CODEC=m
CONFIG_SND_SOC_L3=m
CONFIG_SND_SOC_DA7210=m
CONFIG_SND_SOC_DA7213=m
CONFIG_SND_SOC_DA732X=m
CONFIG_SND_SOC_DA9055=m
CONFIG_SND_SOC_BT_SCO=m
CONFIG_SND_SOC_HDMI_CODEC=m
CONFIG_SND_SOC_ISABELLE=m
CONFIG_SND_SOC_LM49453=m
CONFIG_SND_SOC_MAX98088=m
CONFIG_SND_SOC_MAX98090=m
CONFIG_SND_SOC_MAX98095=m
CONFIG_SND_SOC_MAX9850=m
CONFIG_SND_SOC_PCM1681=m
CONFIG_SND_SOC_PCM1792A=m
CONFIG_SND_SOC_PCM3008=m
CONFIG_SND_SOC_PCM512x=m
CONFIG_SND_SOC_PCM512x_I2C=m
CONFIG_SND_SOC_PCM512x_SPI=m
CONFIG_SND_SOC_RL6231=m
CONFIG_SND_SOC_RT286=m
CONFIG_SND_SOC_RT5631=m
CONFIG_SND_SOC_RT5640=m
CONFIG_SND_SOC_RT5645=m
CONFIG_SND_SOC_RT5651=m
CONFIG_SND_SOC_RT5670=m
CONFIG_SND_SOC_RT5677=m
CONFIG_SND_SOC_SGTL5000=m
CONFIG_SND_SOC_SI476X=m
CONFIG_SND_SOC_SIGMADSP=m
CONFIG_SND_SOC_SIGMADSP_I2C=m
CONFIG_SND_SOC_SIGMADSP_REGMAP=m
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_SSM2518=m
CONFIG_SND_SOC_SSM2602=m
CONFIG_SND_SOC_SSM2602_SPI=m
CONFIG_SND_SOC_SSM2602_I2C=m
CONFIG_SND_SOC_STA32X=m
CONFIG_SND_SOC_STA350=m
CONFIG_SND_SOC_STA529=m
CONFIG_SND_SOC_TAS2552=m
CONFIG_SND_SOC_TAS5086=m
CONFIG_SND_SOC_TLV320AIC23=m
CONFIG_SND_SOC_TLV320AIC23_I2C=m
CONFIG_SND_SOC_TLV320AIC23_SPI=m
CONFIG_SND_SOC_TLV320AIC26=m
CONFIG_SND_SOC_TLV320AIC31XX=m
CONFIG_SND_SOC_TLV320AIC32X4=m
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_TLV320DAC33=m
CONFIG_SND_SOC_UDA134X=m
CONFIG_SND_SOC_UDA1380=m
CONFIG_SND_SOC_WL1273=m
CONFIG_SND_SOC_WM0010=m
CONFIG_SND_SOC_WM1250_EV1=m
CONFIG_SND_SOC_WM2000=m
CONFIG_SND_SOC_WM2200=m
CONFIG_SND_SOC_WM5100=m
CONFIG_SND_SOC_WM5102=m
CONFIG_SND_SOC_WM5110=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8523=m
CONFIG_SND_SOC_WM8580=m
CONFIG_SND_SOC_WM8711=m
CONFIG_SND_SOC_WM8727=m
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8737=m
CONFIG_SND_SOC_WM8741=m
CONFIG_SND_SOC_WM8750=m
CONFIG_SND_SOC_WM8753=m
CONFIG_SND_SOC_WM8770=m
CONFIG_SND_SOC_WM8776=m
CONFIG_SND_SOC_WM8782=m
CONFIG_SND_SOC_WM8804=m
CONFIG_SND_SOC_WM8900=m
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8904=m
CONFIG_SND_SOC_WM8940=m
CONFIG_SND_SOC_WM8955=m
CONFIG_SND_SOC_WM8960=m
CONFIG_SND_SOC_WM8961=m
CONFIG_SND_SOC_WM8962=m
CONFIG_SND_SOC_WM8971=m
CONFIG_SND_SOC_WM8974=m
CONFIG_SND_SOC_WM8978=m
CONFIG_SND_SOC_WM8983=m
CONFIG_SND_SOC_WM8985=m
CONFIG_SND_SOC_WM8988=m
CONFIG_SND_SOC_WM8990=m
CONFIG_SND_SOC_WM8991=m
CONFIG_SND_SOC_WM8993=m
CONFIG_SND_SOC_WM8995=m
CONFIG_SND_SOC_WM8996=m
CONFIG_SND_SOC_WM8997=m
CONFIG_SND_SOC_WM9081=m
CONFIG_SND_SOC_WM9090=m
CONFIG_SND_SOC_LM4857=m
CONFIG_SND_SOC_MAX9768=m
CONFIG_SND_SOC_MAX9877=m
CONFIG_SND_SOC_MC13783=m
CONFIG_SND_SOC_ML26124=m
CONFIG_SND_SOC_TPA6130A2=m
CONFIG_SND_SIMPLE_CARD=m
CONFIG_SOUND_PRIME=m
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=m
CONFIG_HID_APPLEIR=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
CONFIG_HID_GT683R=m
CONFIG_HID_HUION=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PENMOUNT=m
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_OTG_FSM=m
CONFIG_USB_MON=m
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_XHCI_MVEBU=m
CONFIG_USB_XHCI_RCAR=m
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_FUSBH200_HCD=m
CONFIG_USB_FOTG210_HCD=m
CONFIG_USB_MAX3421_HCD=m
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_RENESAS_USBHS_HCD=m
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USBIP_CORE=m
CONFIG_USBIP_VHCI_HCD=m
CONFIG_USBIP_HOST=m
CONFIG_USBIP_DEBUG=y
CONFIG_USB_MUSB_HDRC=m
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_TUSB6010=m
CONFIG_USB_MUSB_UX500=m
CONFIG_USB_UX500_DMA=y
# CONFIG_MUSB_PIO_ONLY is not set
CONFIG_USB_DWC3=m
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_EXYNOS=m
CONFIG_USB_DWC3_PCI=m
CONFIG_USB_DWC3_KEYSTONE=m

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
CONFIG_DWC3_HOST_USB3_LPM_ENABLE=y
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_HOST=m
CONFIG_USB_DWC2_PLATFORM=y
CONFIG_USB_DWC2_PCI=y

#
# Gadget mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_PERIPHERAL=m
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_HOST=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=m
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_F81232=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_METRO=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MXUPORT=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
CONFIG_USB_SERIAL_WISHBONE=m
CONFIG_USB_SERIAL_ZTE=m
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_LINK_LAYER_TEST=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_KEYSTONE_USB_PHY=m
CONFIG_NOP_USB_XCEIV=m
CONFIG_AM335X_CONTROL_USB=m
CONFIG_AM335X_PHY_USB=m
CONFIG_SAMSUNG_USBPHY=m
CONFIG_SAMSUNG_USB2PHY=m
CONFIG_SAMSUNG_USB3PHY=m
CONFIG_TAHVO_USB=m
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
CONFIG_USB_ISP1301=m
CONFIG_USB_MSM_OTG=m
CONFIG_USB_RCAR_PHY=m
CONFIG_USB_RCAR_GEN2_PHY=m
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_VERBOSE=y
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=m
CONFIG_USB_GR_UDC=m
CONFIG_USB_R8A66597=m
CONFIG_USB_RENESAS_USBHS_UDC=m
CONFIG_USB_PXA27X=m
CONFIG_USB_MV_UDC=m
CONFIG_USB_MV_U3D=m
CONFIG_USB_M66592=m
CONFIG_USB_AMD5536UDC=m
CONFIG_USB_NET2272=m
CONFIG_USB_NET2272_DMA=y
CONFIG_USB_NET2280=m
CONFIG_USB_GOKU=m
CONFIG_USB_EG20T=m
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_PHONET=m
CONFIG_USB_F_EEM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_F_MASS_STORAGE=m
CONFIG_USB_F_FS=m
CONFIG_USB_CONFIGFS=m
CONFIG_USB_CONFIGFS_SERIAL=y
CONFIG_USB_CONFIGFS_ACM=y
CONFIG_USB_CONFIGFS_OBEX=y
CONFIG_USB_CONFIGFS_NCM=y
CONFIG_USB_CONFIGFS_ECM=y
CONFIG_USB_CONFIGFS_ECM_SUBSET=y
CONFIG_USB_CONFIGFS_RNDIS=y
CONFIG_USB_CONFIGFS_EEM=y
CONFIG_USB_CONFIGFS_PHONET=y
CONFIG_USB_CONFIGFS_MASS_STORAGE=y
CONFIG_USB_CONFIGFS_F_LB_SS=y
CONFIG_USB_CONFIGFS_F_FS=y
CONFIG_USB_ZERO=m
CONFIG_USB_ZERO_HNPTEST=y
CONFIG_USB_AUDIO=m
CONFIG_GADGET_UAC1=y
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
CONFIG_USB_FUNCTIONFS=m
CONFIG_USB_FUNCTIONFS_ETH=y
CONFIG_USB_FUNCTIONFS_RNDIS=y
CONFIG_USB_FUNCTIONFS_GENERIC=y
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_GADGET_TARGET=m
CONFIG_USB_G_SERIAL=m
CONFIG_USB_MIDI_GADGET=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_NOKIA=m
CONFIG_USB_G_ACM_MS=m
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y
CONFIG_USB_G_MULTI_CDC=y
CONFIG_USB_G_HID=m
CONFIG_USB_G_DBGP=m
# CONFIG_USB_G_DBGP_PRINTK is not set
CONFIG_USB_G_DBGP_SERIAL=y
CONFIG_USB_G_WEBCAM=m
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_OMAP_HS=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SPI=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_SH_MMCIF=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
CONFIG_MMC_USDHI6ROL0=m
CONFIG_MMC_REALTEK_PCI=m
CONFIG_MMC_REALTEK_USB=m
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_PCI=m
CONFIG_MEMSTICK_REALTEK_USB=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=m
CONFIG_LEDS_MENF21BMC=m

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_QIB=m
CONFIG_INFINIBAND_AMSO1100=m
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_CXGB3=m
CONFIG_INFINIBAND_CXGB3_DEBUG=y
CONFIG_INFINIBAND_CXGB4=m
CONFIG_MLX4_INFINIBAND=m
CONFIG_MLX5_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_INFINIBAND_OCRDMA=m
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
CONFIG_INFINIBAND_ISER=m
CONFIG_INFINIBAND_ISERT=m
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_DW_DMAC_CORE=m
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=m
CONFIG_SH_DMAE_BASE=y
CONFIG_SH_DMAE=m
CONFIG_SUDMAC=m
CONFIG_RCAR_HPB_DMAE=m
CONFIG_RCAR_AUDMAC_PP=m
CONFIG_TIMB_DMA=m
CONFIG_PCH_DMA=m
CONFIG_DMA_SUN6I=m
CONFIG_NBPFAXI_DMA=m
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=m

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_AUXDISPLAY=y
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m
CONFIG_UIO_MF624=m
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
CONFIG_ET131X=m
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
CONFIG_COMEDI_KCOMEDILIB=m
CONFIG_COMEDI_BOND=m
CONFIG_COMEDI_TEST=m
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
CONFIG_COMEDI_SKEL=m
CONFIG_COMEDI_SSV_DNP=m
CONFIG_COMEDI_ISA_DRIVERS=y
CONFIG_COMEDI_PCL711=m
CONFIG_COMEDI_PCL724=m
CONFIG_COMEDI_PCL726=m
CONFIG_COMEDI_PCL730=m
CONFIG_COMEDI_PCM3724=m
CONFIG_COMEDI_AMPLC_DIO200_ISA=m
CONFIG_COMEDI_AMPLC_PC236_ISA=m
CONFIG_COMEDI_AMPLC_PC263_ISA=m
CONFIG_COMEDI_RTI800=m
CONFIG_COMEDI_RTI802=m
CONFIG_COMEDI_DAC02=m
CONFIG_COMEDI_DAS16M1=m
CONFIG_COMEDI_DAS08_ISA=m
CONFIG_COMEDI_DAS800=m
CONFIG_COMEDI_DAS6402=m
CONFIG_COMEDI_DT2801=m
CONFIG_COMEDI_DT2811=m
CONFIG_COMEDI_DT2814=m
CONFIG_COMEDI_DT2815=m
CONFIG_COMEDI_DT2817=m
CONFIG_COMEDI_DMM32AT=m
CONFIG_COMEDI_UNIOXX5=m
CONFIG_COMEDI_FL512=m
CONFIG_COMEDI_AIO_AIO12_8=m
CONFIG_COMEDI_AIO_IIRO_16=m
CONFIG_COMEDI_II_PCI20KC=m
CONFIG_COMEDI_C6XDIGIO=m
CONFIG_COMEDI_MPC624=m
CONFIG_COMEDI_ADQ12B=m
CONFIG_COMEDI_NI_AT_AO=m
CONFIG_COMEDI_NI_ATMIO=m
CONFIG_COMEDI_NI_ATMIO16D=m
CONFIG_COMEDI_NI_LABPC_ISA=m
CONFIG_COMEDI_PCMAD=m
CONFIG_COMEDI_PCMDA12=m
CONFIG_COMEDI_PCMMIO=m
CONFIG_COMEDI_PCMUIO=m
CONFIG_COMEDI_MULTIQ3=m
CONFIG_COMEDI_S526=m
CONFIG_COMEDI_PCI_DRIVERS=y
CONFIG_COMEDI_8255_PCI=m
CONFIG_COMEDI_ADDI_WATCHDOG=m
CONFIG_COMEDI_ADDI_APCI_035=m
CONFIG_COMEDI_ADDI_APCI_1032=m
CONFIG_COMEDI_ADDI_APCI_1500=m
CONFIG_COMEDI_ADDI_APCI_1516=m
CONFIG_COMEDI_ADDI_APCI_1564=m
CONFIG_COMEDI_ADDI_APCI_16XX=m
CONFIG_COMEDI_ADDI_APCI_2032=m
CONFIG_COMEDI_ADDI_APCI_2200=m
CONFIG_COMEDI_ADDI_APCI_3120=m
CONFIG_COMEDI_ADDI_APCI_3501=m
CONFIG_COMEDI_ADDI_APCI_3XXX=m
CONFIG_COMEDI_ADL_PCI6208=m
CONFIG_COMEDI_ADL_PCI7X3X=m
CONFIG_COMEDI_ADL_PCI8164=m
CONFIG_COMEDI_ADL_PCI9111=m
CONFIG_COMEDI_ADL_PCI9118=m
CONFIG_COMEDI_ADV_PCI1710=m
CONFIG_COMEDI_ADV_PCI1723=m
CONFIG_COMEDI_ADV_PCI1724=m
CONFIG_COMEDI_ADV_PCI_DIO=m
CONFIG_COMEDI_AMPLC_DIO200_PCI=m
CONFIG_COMEDI_AMPLC_PC236_PCI=m
CONFIG_COMEDI_AMPLC_PC263_PCI=m
CONFIG_COMEDI_AMPLC_PCI224=m
CONFIG_COMEDI_AMPLC_PCI230=m
CONFIG_COMEDI_CONTEC_PCI_DIO=m
CONFIG_COMEDI_DAS08_PCI=m
CONFIG_COMEDI_DT3000=m
CONFIG_COMEDI_DYNA_PCI10XX=m
CONFIG_COMEDI_GSC_HPDI=m
CONFIG_COMEDI_MF6X4=m
CONFIG_COMEDI_ICP_MULTI=m
CONFIG_COMEDI_DAQBOARD2000=m
CONFIG_COMEDI_JR3_PCI=m
CONFIG_COMEDI_KE_COUNTER=m
CONFIG_COMEDI_CB_PCIDAS64=m
CONFIG_COMEDI_CB_PCIDAS=m
CONFIG_COMEDI_CB_PCIDDA=m
CONFIG_COMEDI_CB_PCIMDAS=m
CONFIG_COMEDI_CB_PCIMDDA=m
CONFIG_COMEDI_ME4000=m
CONFIG_COMEDI_ME_DAQ=m
CONFIG_COMEDI_NI_6527=m
CONFIG_COMEDI_NI_65XX=m
CONFIG_COMEDI_NI_660X=m
CONFIG_COMEDI_NI_670X=m
CONFIG_COMEDI_NI_LABPC_PCI=m
CONFIG_COMEDI_NI_PCIDIO=m
CONFIG_COMEDI_NI_PCIMIO=m
CONFIG_COMEDI_RTD520=m
CONFIG_COMEDI_S626=m
CONFIG_COMEDI_MITE=m
CONFIG_COMEDI_NI_TIOCMD=m
CONFIG_COMEDI_USB_DRIVERS=y
CONFIG_COMEDI_DT9812=m
CONFIG_COMEDI_USBDUX=m
CONFIG_COMEDI_USBDUXFAST=m
CONFIG_COMEDI_USBDUXSIGMA=m
CONFIG_COMEDI_VMK80XX=m
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_AMPLC_PC236=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_TIO=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
CONFIG_RTS5208=m
CONFIG_RTS5208_DEBUG=y
CONFIG_LINE6_USB=m
CONFIG_LINE6_USB_IMPULSE_RESPONSE=y

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=m
CONFIG_ADIS16203=m
CONFIG_ADIS16204=m
CONFIG_ADIS16209=m
CONFIG_ADIS16220=m
CONFIG_ADIS16240=m
CONFIG_SCA3000=m

#
# Analog to digital converters
#
CONFIG_AD7192=m
CONFIG_AD7280=m
CONFIG_LPC32XX_ADC=m
CONFIG_MXS_LRADC=m
CONFIG_SPEAR_ADC=m

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#
CONFIG_AD5930=m
CONFIG_AD9832=m
CONFIG_AD9834=m
CONFIG_AD9850=m
CONFIG_AD9852=m
CONFIG_AD9910=m
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_ISL29028=m
CONFIG_TSL2583=m
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m
CONFIG_SENSORS_HMC5843_I2C=m
CONFIG_SENSORS_HMC5843_SPI=m

#
# Active energy metering IC
#
CONFIG_ADE7753=m
CONFIG_ADE7754=m
CONFIG_ADE7758=m
CONFIG_ADE7759=m
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m
CONFIG_ADE7854_SPI=m

#
# Resolver to digital converters
#
CONFIG_AD2S90=m

#
# Triggers - standalone
#
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_FB_XGI=m
CONFIG_BCM_WIMAX=m
CONFIG_FT1000=m
CONFIG_FT1000_USB=m

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y
CONFIG_I2C_BCM2048=m
CONFIG_DVB_CXD2099=m
CONFIG_VIDEO_DT3155=m
CONFIG_DT3155_CCIR=y
CONFIG_DT3155_STREAMING=y
CONFIG_VIDEO_V4L2_INT_DEVICE=m
CONFIG_VIDEO_TCM825X=m
CONFIG_LIRC_STAGING=y
CONFIG_LIRC_BT829=m
CONFIG_LIRC_IGORPLUGUSB=m
CONFIG_LIRC_IMON=m
CONFIG_LIRC_PARALLEL=m
CONFIG_LIRC_SASEM=m
CONFIG_LIRC_SERIAL=m
CONFIG_LIRC_SERIAL_TRANSMITTER=y
CONFIG_LIRC_SIR=m
CONFIG_LIRC_ZILOG=m

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=m
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_SYNC=y
CONFIG_SW_SYNC=y
CONFIG_SW_SYNC_USER=y
CONFIG_ION=y
CONFIG_ION_TEST=m
CONFIG_ION_DUMMY=y
CONFIG_USB_WPAN_HCD=m
CONFIG_WIMAX_GDM72XX=m
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
CONFIG_WIMAX_GDM72XX_USB_PM=y
CONFIG_LTE_GDM724X=m
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
CONFIG_MTD_SPINAND_MT29F=m
CONFIG_MTD_SPINAND_ONDIEECC=y
CONFIG_LUSTRE_FS=m
CONFIG_LUSTRE_OBD_MAX_IOCTL_BUFFER=8192
CONFIG_LUSTRE_DEBUG_EXPENSIVE_CHECK=y
CONFIG_LUSTRE_TRANSLATE_ERRNOS=y
CONFIG_LUSTRE_LLITE_LLOOP=m
CONFIG_LNET=m
CONFIG_LNET_MAX_PAYLOAD=1048576
CONFIG_LNET_SELFTEST=m
CONFIG_LNET_XPRT_IB=m
CONFIG_XILLYBUS=m
CONFIG_XILLYBUS_PCIE=m
CONFIG_DGNC=m
CONFIG_DGAP=m
CONFIG_GS_FPGABOOT=m

#
# SOC (System On Chip) specific Drivers
#
CONFIG_SOC_TI=y

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
# CONFIG_ATMEL_PIT is not set
CONFIG_SH_TIMER_CMT=y
CONFIG_SH_TIMER_MTU2=y
CONFIG_SH_TIMER_TMU=y
CONFIG_EM_TIMER_STI=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
CONFIG_DEVFREQ_GOV_PERFORMANCE=m
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=m
CONFIG_EXTCON_ARIZONA=m
CONFIG_EXTCON_SM5502=m
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=m
CONFIG_HID_SENSOR_ACCEL_3D=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=m
CONFIG_KXSD9=m
CONFIG_MMA8452=m
CONFIG_KXCJK1013=m

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
CONFIG_AD7266=m
CONFIG_AD7291=m
CONFIG_AD7298=m
CONFIG_AD7476=m
CONFIG_AD7791=m
CONFIG_AD7793=m
CONFIG_AD7887=m
CONFIG_AD7923=m
CONFIG_AD799X=m
CONFIG_MAX1027=m
CONFIG_MAX1363=m
CONFIG_MCP320X=m
CONFIG_MCP3422=m
CONFIG_MEN_Z188_ADC=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
CONFIG_TI_AM335X_ADC=m
CONFIG_VIPERBOARD_ADC=m
CONFIG_XILINX_XADC=m

#
# Amplifiers
#
CONFIG_AD8366=m

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_SPI=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5360=m
CONFIG_AD5380=m
CONFIG_AD5421=m
CONFIG_AD5446=m
CONFIG_AD5449=m
CONFIG_AD5504=m
CONFIG_AD5624R_SPI=m
CONFIG_AD5686=m
CONFIG_AD5755=m
CONFIG_AD5764=m
CONFIG_AD5791=m
CONFIG_AD7303=m
CONFIG_MAX517=m
CONFIG_MCP4725=m
CONFIG_MCP4922=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=m

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=m
CONFIG_ADIS16130=m
CONFIG_ADIS16136=m
CONFIG_ADIS16260=m
CONFIG_ADXRS450=m
CONFIG_HID_SENSOR_GYRO_3D=m
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_IIO_ST_GYRO_SPI_3AXIS=m
CONFIG_ITG3200=m

#
# Humidity sensors
#
CONFIG_SI7005=m

#
# Inertial measurement units
#
CONFIG_ADIS16400=m
CONFIG_ADIS16480=m
CONFIG_INV_MPU6050_IIO=m
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=m
CONFIG_CM32181=m
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=m
CONFIG_ISL29125=m
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
CONFIG_SENSORS_LM3533=m
CONFIG_LTR501=m
CONFIG_TCS3414=m
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
CONFIG_AK09911=m
CONFIG_MAG3110=m
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
CONFIG_IIO_ST_MAGN_SPI_3AXIS=m

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
CONFIG_HID_SENSOR_DEVICE_ROTATION=m

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=m
CONFIG_MPL115=m
CONFIG_MPL3115=m
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_IIO_ST_PRESS_SPI=m
CONFIG_T5403=m

#
# Lightning sensors
#
CONFIG_AS3935=m

#
# Temperature sensors
#
CONFIG_MLX90614=m
CONFIG_TMP006=m
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=m
CONFIG_VME_TSI148=m

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m

#
# VME Device Drivers
#
CONFIG_VME_USER=m
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_CLPS711X=m
CONFIG_PWM_LP3943=m
CONFIG_PWM_RENESAS_TPU=m
CONFIG_IPACK_BUS=m
CONFIG_BOARD_TPCI200=m
CONFIG_SERIAL_IPOCTAL=m
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=m
CONFIG_OMAP_CONTROL_PHY=m
CONFIG_BCM_KONA_USB2_PHY=m
CONFIG_PHY_SAMSUNG_USB2=m
# CONFIG_PHY_EXYNOS4210_USB2 is not set
# CONFIG_PHY_EXYNOS4X12_USB2 is not set
# CONFIG_PHY_EXYNOS5250_USB2 is not set
CONFIG_PHY_ST_SPEAR1310_MIPHY=m
CONFIG_PHY_ST_SPEAR1340_MIPHY=m
CONFIG_POWERCAP=y
CONFIG_MCB=m
CONFIG_MCB_PCI=m
CONFIG_RAS=y
CONFIG_THUNDERBOLT=m

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=m
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_MINIX_FS_NATIVE_ENDIAN=y
CONFIG_OMFS_FS=m
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=m
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_EXOFS_FS=m
CONFIG_EXOFS_DEBUG=y
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
CONFIG_F2FS_CHECK_FS=y
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V2=m
CONFIG_NFS_V3=m
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
CONFIG_NFS_SWAP=y
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_OBJLAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_NFS_V4_1_MIGRATION=y
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_NFS_FSCACHE=y
CONFIG_NFS_USE_LEGACY_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_NFSD_FAULT_INJECTION=y
CONFIG_GRACE_PERIOD=m
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_SUNRPC_SWAP=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_SUNRPC_DEBUG=y
CONFIG_SUNRPC_XPRT_RDMA_CLIENT=m
CONFIG_SUNRPC_XPRT_RDMA_SERVER=m
CONFIG_CEPH_FS=m
CONFIG_CEPH_FSCACHE=y
CONFIG_CEPH_FS_POSIX_ACL=y
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
CONFIG_CIFS_DEBUG=y
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_SMB2=y
CONFIG_CIFS_FSCACHE=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=m
CONFIG_9P_FSCACHE=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_9P_FS_SECURITY=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
CONFIG_DEBUG_KMEMLEAK_TEST=m
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_VMACACHE=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_KOBJECT=y
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
CONFIG_TRACEPOINT_BENCHMARK=y
CONFIG_RING_BUFFER_BENCHMARK=m
CONFIG_RING_BUFFER_STARTUP_TEST=y

#
# Runtime Testing
#
CONFIG_LKDTM=m
CONFIG_TEST_LIST_SORT=y
CONFIG_KPROBES_SANITY_TEST=y
CONFIG_BACKTRACE_SELF_TEST=m
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=m
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=m
CONFIG_TEST_RHASHTABLE=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DMA_API_DEBUG=y
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_UDELAY=m
# CONFIG_SAMPLES is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_S390_PTDUMP=y
CONFIG_DEBUG_SET_MODULE_RONX=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
CONFIG_SECURITY_SMACK=y
CONFIG_SECURITY_TOMOYO=y
CONFIG_SECURITY_TOMOYO_MAX_ACCEPT_ENTRY=2048
CONFIG_SECURITY_TOMOYO_MAX_AUDIT_LOG=1024
CONFIG_SECURITY_TOMOYO_OMIT_USERSPACE_LOADER=y
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_AUDIT=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_TRUSTED_KEYRING=y
CONFIG_EVM=y

#
# EVM options
#
CONFIG_EVM_ATTR_FSUUID=y
CONFIG_EVM_EXTRA_SMACK_XATTRS=y
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=m
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_ZCRYPT=m
CONFIG_CRYPTO_SHA1_S390=m
CONFIG_CRYPTO_SHA256_S390=m
CONFIG_CRYPTO_SHA512_S390=m
CONFIG_CRYPTO_DES_S390=m
CONFIG_CRYPTO_AES_S390=m
CONFIG_S390_PRNG=m
CONFIG_CRYPTO_GHASH_S390=m
CONFIG_CRYPTO_DEV_QCE=m
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=m
CONFIG_PKCS7_TEST_KEY=m
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_IO=y
CONFIG_STMP_DEVICE=y
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=m
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=m
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y
CONFIG_ARCH_HAS_SG_CHAIN=y

#
# Virtualization
#
CONFIG_PFAULT=y
CONFIG_CMM=m
CONFIG_CMM_IUCV=y
CONFIG_APPLDATA_BASE=y
CONFIG_APPLDATA_MEM=m
CONFIG_APPLDATA_OS=m
CONFIG_APPLDATA_NET_SUM=m
CONFIG_S390_HYPFS_FS=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_KVM_ASYNC_PF_SYNC=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_S390_UCONTROL=y
CONFIG_S390_GUEST=y

--=_54256341.viqxbTIwldqkc2qkniCmYomajatC0lj7ROEnOKM6SpQ6Po91--
