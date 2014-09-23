Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679AbaIWXSO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 19:18:14 -0400
Date: Wed, 24 Sep 2014 07:17:17 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Guoxiong Yan <yanguoxiong@huawei.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:devel-3.17-rc6 489/499]
 drivers/media/rc/ir-hix5hd2.c:99:41: sparse: incorrect type in argument 2
 (different address spaces)
Message-ID: <5421ff7d./m9dC40y+pr/iC6w%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel-3.17-rc6
head:   49310ed0ab8da344dece4a543bfcdd14490ccfa0
commit: a84fcdaa905862b09482544d190c94a8436e4334 [489/499] [media] rc: Introduce hix5hd2 IR transmitter driver
reproduce:
  # apt-get install sparse
  git checkout a84fcdaa905862b09482544d190c94a8436e4334
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/rc/ir-hix5hd2.c:99:41: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:99:41:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:99:41:    got void *
>> drivers/media/rc/ir-hix5hd2.c:100:16: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:100:16:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:100:16:    got void *
>> drivers/media/rc/ir-hix5hd2.c:117:40: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:117:40:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:117:40:    got void *
>> drivers/media/rc/ir-hix5hd2.c:119:41: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:119:41:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:119:41:    got void *
>> drivers/media/rc/ir-hix5hd2.c:121:41: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:121:41:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:121:41:    got void *
>> drivers/media/rc/ir-hix5hd2.c:147:18: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:147:18:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:147:18:    got void *
>> drivers/media/rc/ir-hix5hd2.c:155:28: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:155:28:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:155:28:    got void *
>> drivers/media/rc/ir-hix5hd2.c:157:25: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:157:25:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:157:25:    got void *
>> drivers/media/rc/ir-hix5hd2.c:159:61: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:159:61:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:159:61:    got void *
>> drivers/media/rc/ir-hix5hd2.c:167:28: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:167:28:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:167:28:    got void *
>> drivers/media/rc/ir-hix5hd2.c:169:36: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:169:36:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:169:36:    got void *
>> drivers/media/rc/ir-hix5hd2.c:188:64: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:188:64:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:188:64:    got void *
>> drivers/media/rc/ir-hix5hd2.c:190:68: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:190:68:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:190:68:    got void *
>> drivers/media/rc/ir-hix5hd2.c:220:20: sparse: incorrect type in assignment (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:220:20:    expected void *base
   drivers/media/rc/ir-hix5hd2.c:220:20:    got void [noderef] <asn:2>*
>> drivers/media/rc/ir-hix5hd2.c:315:41: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:315:41:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:315:41:    got void *
>> drivers/media/rc/ir-hix5hd2.c:316:41: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:316:41:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:316:41:    got void *
>> drivers/media/rc/ir-hix5hd2.c:317:41: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:317:41:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:317:41:    got void *
>> drivers/media/rc/ir-hix5hd2.c:318:41: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/ir-hix5hd2.c:318:41:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/ir-hix5hd2.c:318:41:    got void *

vim +99 drivers/media/rc/ir-hix5hd2.c

    93	
    94	static int hix5hd2_ir_config(struct hix5hd2_ir_priv *priv)
    95	{
    96		int timeout = 10000;
    97		u32 val, rate;
    98	
    99		writel_relaxed(0x01, priv->base + IR_ENABLE);
   100		while (readl_relaxed(priv->base + IR_BUSY)) {
   101			if (timeout--) {
   102				udelay(1);
   103			} else {
   104				dev_err(priv->dev, "IR_BUSY timeout\n");
   105				return -ETIMEDOUT;
   106			}
   107		}
   108	
   109		/* Now only support raw mode, with symbol start from low to high */
   110		rate = DIV_ROUND_CLOSEST(priv->rate, 1000000);
   111		val = IR_CFG_SYMBOL_MAXWIDTH & IR_CFG_WIDTH_MASK << IR_CFG_WIDTH_SHIFT;
   112		val |= IR_CFG_SYMBOL_FMT & IR_CFG_FORMAT_MASK << IR_CFG_FORMAT_SHIFT;
   113		val |= (IR_CFG_INT_THRESHOLD - 1) & IR_CFG_INT_LEVEL_MASK
   114		       << IR_CFG_INT_LEVEL_SHIFT;
   115		val |= IR_CFG_MODE_RAW;
   116		val |= (rate - 1) & IR_CFG_FREQ_MASK << IR_CFG_FREQ_SHIFT;
   117		writel_relaxed(val, priv->base + IR_CONFIG);
   118	
   119		writel_relaxed(0x00, priv->base + IR_INTM);
   120		/* write arbitrary value to start  */
   121		writel_relaxed(0x01, priv->base + IR_START);
   122		return 0;
   123	}
   124	
   125	static int hix5hd2_ir_open(struct rc_dev *rdev)
   126	{
   127		struct hix5hd2_ir_priv *priv = rdev->priv;
   128	
   129		hix5hd2_ir_enable(priv, true);
   130		return hix5hd2_ir_config(priv);
   131	}
   132	
   133	static void hix5hd2_ir_close(struct rc_dev *rdev)
   134	{
   135		struct hix5hd2_ir_priv *priv = rdev->priv;
   136	
   137		hix5hd2_ir_enable(priv, false);
   138	}
   139	
   140	static irqreturn_t hix5hd2_ir_rx_interrupt(int irq, void *data)
   141	{
   142		u32 symb_num, symb_val, symb_time;
   143		u32 data_l, data_h;
   144		u32 irq_sr, i;
   145		struct hix5hd2_ir_priv *priv = data;
   146	
   147		irq_sr = readl_relaxed(priv->base + IR_INTS);
   148		if (irq_sr & INTMS_OVERFLOW) {
   149			/*
   150			 * we must read IR_DATAL first, then we can clean up
   151			 * IR_INTS availably since logic would not clear
   152			 * fifo when overflow, drv do the job
   153			 */
   154			ir_raw_event_reset(priv->rdev);
   155			symb_num = readl_relaxed(priv->base + IR_DATAH);
   156			for (i = 0; i < symb_num; i++)
   157				readl_relaxed(priv->base + IR_DATAL);
   158	
   159			writel_relaxed(INT_CLR_OVERFLOW, priv->base + IR_INTC);
   160			dev_info(priv->dev, "overflow, level=%d\n",
   161				 IR_CFG_INT_THRESHOLD);
   162		}
   163	
   164		if ((irq_sr & INTMS_SYMBRCV) || (irq_sr & INTMS_TIMEOUT)) {
   165			DEFINE_IR_RAW_EVENT(ev);
   166	
   167			symb_num = readl_relaxed(priv->base + IR_DATAH);
   168			for (i = 0; i < symb_num; i++) {
   169				symb_val = readl_relaxed(priv->base + IR_DATAL);
   170				data_l = ((symb_val & 0xffff) * 10);
   171				data_h =  ((symb_val >> 16) & 0xffff) * 10;
   172				symb_time = (data_l + data_h) / 10;
   173	
   174				ev.duration = US_TO_NS(data_l);
   175				ev.pulse = true;
   176				ir_raw_event_store(priv->rdev, &ev);
   177	
   178				if (symb_time < IR_CFG_SYMBOL_MAXWIDTH) {
   179					ev.duration = US_TO_NS(data_h);
   180					ev.pulse = false;
   181					ir_raw_event_store(priv->rdev, &ev);
   182				} else {
   183					ir_raw_event_set_idle(priv->rdev, true);
   184				}
   185			}
   186	
   187			if (irq_sr & INTMS_SYMBRCV)
   188				writel_relaxed(INT_CLR_RCV, priv->base + IR_INTC);
   189			if (irq_sr & INTMS_TIMEOUT)
   190				writel_relaxed(INT_CLR_TIMEOUT, priv->base + IR_INTC);
   191		}
   192	
   193		/* Empty software fifo */
   194		ir_raw_event_handle(priv->rdev);
   195		return IRQ_HANDLED;
   196	}
   197	
   198	static int hix5hd2_ir_probe(struct platform_device *pdev)
   199	{
   200		struct rc_dev *rdev;
   201		struct device *dev = &pdev->dev;
   202		struct resource *res;
   203		struct hix5hd2_ir_priv *priv;
   204		struct device_node *node = pdev->dev.of_node;
   205		const char *map_name;
   206		int ret;
   207	
   208		priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
   209		if (!priv)
   210			return -ENOMEM;
   211	
   212		priv->regmap = syscon_regmap_lookup_by_phandle(node,
   213							       "hisilicon,power-syscon");
   214		if (IS_ERR(priv->regmap)) {
   215			dev_err(dev, "no power-reg\n");
   216			return -EINVAL;
   217		}
   218	
   219		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
   220		priv->base = devm_ioremap_resource(dev, res);
   221		if (IS_ERR(priv->base))
   222			return PTR_ERR(priv->base);
   223	

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
