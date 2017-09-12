Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:17578 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbdILP44 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 11:56:56 -0400
Subject: Re: IR driver support for tango platforms
To: Sean Young <sean@mess.org>, Mans Rullgard <mans@mansr.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
References: <6076a18d-c5ba-cb83-ac36-8eda965c7eb8@free.fr>
 <20170911211210.a7a2st4hfn7leec3@gofer.mess.org>
From: Mason <slash.tmp@free.fr>
Message-ID: <7942dc9f-e7a2-e088-e843-f013ac1b0302@free.fr>
Date: Tue, 12 Sep 2017 17:56:11 +0200
MIME-Version: 1.0
In-Reply-To: <20170911211210.a7a2st4hfn7leec3@gofer.mess.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/09/2017 23:12, Sean Young wrote:

> On Sep 11, 2017 at 04:37, Mason wrote:
>
>> I'm confused. Does this mean a keymap is mandatory?
>> I thought it was possible to handle the "scancode to keycode"
>> step in user-space?
> 
> The handling could be better here, but for nec repeats, yes a matching
> keycode is required here.
> 
> 
>> B) Currently, the driver doesn't seem to allow selective protocol
>> enabling/disabling. It just silently enables all protocols at init.
>>
>> It would seem useful to add support for that, so that the HW
>> doesn't fire spurious RC5 interrupts for NEC events.
>>
>> What do you think?
> 
> That could be useful. In order to that, have to implement the
> rc_dev->change_protocol function; in that function, you have to tell
> the hardware to not generate interrupts for protocols which aren't
> disabled. So, in order to implement that you'll need to know how
> to do that. Is there a datasheet available?

I have access to some documentation, but I was told I cannot share
it publically :-(

I've made some progress. I'd like to run the code by you (and Mans,
the original author), to make sure it is in an acceptable state.
I tested the driver using ir-keytable and a NEC remote control.
(RC-5 and RC-6 are untested, for now.)

# ir-keytable -p nec
Protocols changed to nec

# ir-keytable -c
Old keytable cleared

# ir-keytable -w sigma.rc
Wrote 35 keycode(s) to driver

# ir-keytable -r
scancode 0x4cb01 = KEY_RIGHT (0x6a)
scancode 0x4cb02 = KEY_OK (0x160)
scancode 0x4cb03 = KEY_2 (0x03)
scancode 0x4cb06 = KEY_UP (0x67)
scancode 0x4cb07 = KEY_5 (0x06)
scancode 0x4cb0a = KEY_DOWN (0x6c)
scancode 0x4cb0f = KEY_SETUP (0x8d)
scancode 0x4cb16 = KEY_ANGLE (0x173)
scancode 0x4cb17 = KEY_8 (0x09)
scancode 0x4cb19 = KEY_ZOOM (0x174)
scancode 0x4cb1a = KEY_AUDIO (0x188)
scancode 0x4cb1b = KEY_0 (0x0b)
scancode 0x4cb1d = KEY_BLUE (0x191)
scancode 0x4cb1e = KEY_GREEN (0x18f)
scancode 0x4cb41 = KEY_1 (0x02)
scancode 0x4cb42 = KEY_3 (0x04)
scancode 0x4cb43 = KEY_LEFT (0x69)
scancode 0x4cb44 = KEY_EJECTCD (0xa1)
scancode 0x4cb45 = KEY_4 (0x05)
scancode 0x4cb46 = KEY_6 (0x07)
scancode 0x4cb47 = KEY_BACK (0x9e)
scancode 0x4cb4a = KEY_POWER (0x74)
scancode 0x4cb4b = KEY_INFO (0x166)
scancode 0x4cb4c = KEY_STOP (0x80)
scancode 0x4cb4f = KEY_TITLE (0x171)
scancode 0x4cb50 = KEY_PLAY (0xcf)
scancode 0x4cb51 = KEY_MUTE (0x71)
scancode 0x4cb53 = KEY_MENU (0x8b)
scancode 0x4cb54 = KEY_PAUSE (0x77)
scancode 0x4cb55 = KEY_7 (0x08)
scancode 0x4cb56 = KEY_9 (0x0a)
scancode 0x4cb58 = KEY_SUBTITLE (0x172)
scancode 0x4cb59 = KEY_DELETE (0x6f)
scancode 0x4cb5c = KEY_YELLOW (0x190)
scancode 0x4cb5f = KEY_RED (0x18e)
Enabled protocols: nec

# ir-keytable -t -v
Found device /sys/class/rc/rc0/
Input sysfs node is /sys/class/rc/rc0/input0/
Event sysfs node is /sys/class/rc/rc0/input0/event0/
Parsing uevent /sys/class/rc/rc0/input0/event0/uevent
/sys/class/rc/rc0/input0/event0/uevent uevent MAJOR=13
/sys/class/rc/rc0/input0/event0/uevent uevent MINOR=64
/sys/class/rc/rc0/input0/event0/uevent uevent DEVNAME=input/event0
Parsing uevent /sys/class/rc/rc0/uevent
/sys/class/rc/rc0/uevent uevent NAME=rc-empty
/sys/class/rc/rc0/uevent uevent DRV_NAME=tango-ir
input device is /dev/input/event0
/sys/class/rc/rc0/protocols protocol rc-5 (disabled)
/sys/class/rc/rc0/protocols protocol nec (enabled)
/sys/class/rc/rc0/protocols protocol rc-6 (disabled)
Opening /dev/input/event0
Input Protocol version: 0x00010001
Testing events. Please, press CTRL-C to abort.
122.327942: event type EV_MSC(0x04): scancode = 0x4cb41
122.327942: event type EV_KEY(0x01) key_down: KEY_1(0x0002)
122.327942: event type EV_SYN(0x00).
122.381794: event type EV_MSC(0x04): scancode = 0x4cb41
122.381794: event type EV_SYN(0x00).
122.489565: event type EV_MSC(0x04): scancode = 0x4cb41
122.489565: event type EV_SYN(0x00).
122.597335: event type EV_MSC(0x04): scancode = 0x4cb41
122.597335: event type EV_SYN(0x00).
122.705110: event type EV_MSC(0x04): scancode = 0x4cb41
122.705110: event type EV_SYN(0x00).
122.812883: event type EV_MSC(0x04): scancode = 0x4cb41
122.812883: event type EV_SYN(0x00).
122.853335: event type EV_KEY(0x01) key_down: KEY_1(0x0002)
122.853335: event type EV_SYN(0x00).
122.920659: event type EV_MSC(0x04): scancode = 0x4cb41
122.920659: event type EV_SYN(0x00).
122.983335: event type EV_KEY(0x01) key_down: KEY_1(0x0002)
122.983335: event type EV_SYN(0x00).
123.028428: event type EV_MSC(0x04): scancode = 0x4cb41
123.028428: event type EV_SYN(0x00).
123.113334: event type EV_KEY(0x01) key_down: KEY_1(0x0002)
123.113334: event type EV_SYN(0x00).
123.243333: event type EV_KEY(0x01) key_down: KEY_1(0x0002)
123.243333: event type EV_SYN(0x00).
123.280000: event type EV_KEY(0x01) key_up: KEY_1(0x0002)
123.280000: event type EV_SYN(0x00).
134.743698: event type EV_MSC(0x04): scancode = 0x4cb50
134.743698: event type EV_KEY(0x01) key_down: KEY_PLAY(0x00cf)
134.743698: event type EV_SYN(0x00).
134.797577: event type EV_MSC(0x04): scancode = 0x4cb50
134.797577: event type EV_SYN(0x00).
134.905349: event type EV_MSC(0x04): scancode = 0x4cb50
134.905349: event type EV_SYN(0x00).
135.013123: event type EV_MSC(0x04): scancode = 0x4cb50
135.013123: event type EV_SYN(0x00).
135.120896: event type EV_MSC(0x04): scancode = 0x4cb50
135.120896: event type EV_SYN(0x00).
135.228670: event type EV_MSC(0x04): scancode = 0x4cb50
135.228670: event type EV_SYN(0x00).
135.253332: event type EV_KEY(0x01) key_down: KEY_PLAY(0x00cf)
135.253332: event type EV_SYN(0x00).
135.336443: event type EV_MSC(0x04): scancode = 0x4cb50
135.336443: event type EV_SYN(0x00).
135.383332: event type EV_KEY(0x01) key_down: KEY_PLAY(0x00cf)
135.383332: event type EV_SYN(0x00).
135.444215: event type EV_MSC(0x04): scancode = 0x4cb50
135.444215: event type EV_SYN(0x00).
135.513332: event type EV_KEY(0x01) key_down: KEY_PLAY(0x00cf)
135.513332: event type EV_SYN(0x00).
135.551989: event type EV_MSC(0x04): scancode = 0x4cb50
135.551989: event type EV_SYN(0x00).
135.643332: event type EV_KEY(0x01) key_down: KEY_PLAY(0x00cf)
135.643332: event type EV_SYN(0x00).
135.659762: event type EV_MSC(0x04): scancode = 0x4cb50
135.659762: event type EV_SYN(0x00).
135.767537: event type EV_MSC(0x04): scancode = 0x4cb50
135.767537: event type EV_SYN(0x00).
135.773331: event type EV_KEY(0x01) key_down: KEY_PLAY(0x00cf)
135.773331: event type EV_SYN(0x00).
135.875309: event type EV_MSC(0x04): scancode = 0x4cb50
135.875309: event type EV_SYN(0x00).
135.903331: event type EV_KEY(0x01) key_down: KEY_PLAY(0x00cf)
135.903331: event type EV_SYN(0x00).
135.983083: event type EV_MSC(0x04): scancode = 0x4cb50
135.983083: event type EV_SYN(0x00).
136.033332: event type EV_KEY(0x01) key_down: KEY_PLAY(0x00cf)
136.033332: event type EV_SYN(0x00).
136.090857: event type EV_MSC(0x04): scancode = 0x4cb50
136.090857: event type EV_SYN(0x00).
136.163331: event type EV_KEY(0x01) key_down: KEY_PLAY(0x00cf)
136.163331: event type EV_SYN(0x00).
136.198628: event type EV_MSC(0x04): scancode = 0x4cb50
136.198628: event type EV_SYN(0x00).
136.293332: event type EV_KEY(0x01) key_down: KEY_PLAY(0x00cf)
136.293332: event type EV_SYN(0x00).
136.423332: event type EV_KEY(0x01) key_down: KEY_PLAY(0x00cf)
136.423332: event type EV_SYN(0x00).
136.453333: event type EV_KEY(0x01) key_up: KEY_PLAY(0x00cf)
136.453333: event type EV_SYN(0x00).


Everything seems to work as expected... Right?


The code for the driver is below:
If it looks good, I'll make a formal submission.


/*
  * Copyright (C) 2015 Mans Rullgard <mans@mansr.com>
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
  */

#include <linux/input.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/interrupt.h>
#include <linux/io.h>
#include <linux/clk.h>
#include <linux/of.h>
#include <media/rc-core.h>

#define IR_NEC_CTRL	0x00
#define IR_NEC_DATA	0x04
#define IR_CTRL		0x08
#define IR_RC5_CLK_DIV	0x0c
#define IR_RC5_DATA	0x10
#define IR_INT		0x14

#define NEC_TIME_BASE	560
#define RC5_TIME_BASE	1778

#define RC6_CTRL	0x00
#define RC6_CLKDIV	0x04
#define RC6_DATA0	0x08
#define RC6_DATA1	0x0c
#define RC6_DATA2	0x10
#define RC6_DATA3	0x14
#define RC6_DATA4	0x18

#define RC6_CARRIER	36000
#define RC6_TIME_BASE	16

struct tango_ir {
	void __iomem *rc5_base;
	void __iomem *rc6_base;
	struct rc_dev *rc;
	struct clk *clk;
};

static void tango_ir_handle_nec(struct tango_ir *ir)
{
	unsigned int data;
	unsigned int addr;
	unsigned int naddr;
	unsigned int key;
	unsigned int nkey;

	data = readl(ir->rc5_base + IR_NEC_DATA);

	if (!data) {
		rc_repeat(ir->rc);
		return;
	}

	addr = data & 0xff;
	naddr = data >> 8 & 0xff;
	key = data >> 16 & 0xff;
	nkey = data >> 24 & 0xff;

	if ((addr ^ naddr) != 255)
		addr = addr << 8 | naddr;

	if ((key ^ nkey) != 255)
		return;

	rc_keydown(ir->rc, RC_TYPE_NEC, RC_SCANCODE_NEC(addr, key), 0);
}

static void tango_ir_handle_rc5(struct tango_ir *ir)
{
	unsigned int data;
	unsigned int field;
	unsigned int toggle;
	unsigned int addr;
	unsigned int cmd;

	data = readl(ir->rc5_base + IR_RC5_DATA);

	if (data & BIT(31))
		return;

	field = data >> 12 & 1;
	toggle = data >> 11 & 1;
	addr = data >> 6 & 0x1f;
	cmd = (data & 0x3f) | (field ^ 1) << 6;

	rc_keydown(ir->rc, RC_TYPE_RC5, RC_SCANCODE_RC5(addr, cmd), toggle);
}

static void tango_ir_handle_rc6(struct tango_ir *ir)
{
	unsigned int data0, data1;
	unsigned int toggle;
	unsigned int mode;
	unsigned int addr;
	unsigned int cmd;

	data0 = readl(ir->rc6_base + RC6_DATA0);
	data1 = readl(ir->rc6_base + RC6_DATA1);

	mode = data0 >> 1 & 7;

	if (mode != 0)
		return;

	toggle = data0 & 1;
	addr = data0 >> 16;
	cmd = data1;

	rc_keydown(ir->rc, RC_TYPE_RC6_0, RC_SCANCODE_RC6_0(addr, cmd), toggle);
}

static irqreturn_t tango_ir_irq(int irq, void *dev_id)
{
	struct tango_ir *ir = dev_id;
	unsigned int rc5_stat;
	unsigned int rc6_stat;

	rc5_stat = readl(ir->rc5_base + IR_INT);
	writel(rc5_stat, ir->rc5_base + IR_INT);

	rc6_stat = readl(ir->rc6_base + RC6_CTRL);
	writel(rc6_stat, ir->rc6_base + RC6_CTRL);

	if (!(rc5_stat & 3) && !(rc6_stat & BIT(31)))
		return IRQ_NONE;

	if (rc5_stat & 1)
		tango_ir_handle_rc5(ir);

	if (rc5_stat & 2)
		tango_ir_handle_nec(ir);

	if (rc6_stat & BIT(31))
		tango_ir_handle_rc6(ir);

	return IRQ_HANDLED;
}

#define DISABLE_NEC	(BIT(4) | BIT(8))
#define ENABLE_RC5	(BIT(0) | BIT(9))
#define ENABLE_RC6	(BIT(0) | BIT(7))

static int tango_change_protocol(struct rc_dev *dev, u64 *rc_type)
{
	struct tango_ir *ir = dev->priv;
	u32 rc5_ctrl = DISABLE_NEC;
	u32 rc6_ctrl = 0;

	if (*rc_type & RC_BIT_NEC)
		rc5_ctrl = 0;

	if (*rc_type & RC_BIT_RC5)
		rc5_ctrl |= ENABLE_RC5;

	if (*rc_type & RC_BIT_RC6_0)
		rc6_ctrl = ENABLE_RC6;

	writel_relaxed(rc5_ctrl, ir->rc5_base + IR_CTRL);
	writel_relaxed(rc6_ctrl, ir->rc6_base + RC6_CTRL);

	return 0;
}

static int tango_ir_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct rc_dev *rc;
	struct tango_ir *ir;
	struct resource *rc5_res;
	struct resource *rc6_res;
	unsigned long clkrate;
	u64 clkdiv;
	int irq;
	int err;

	rc5_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (!rc5_res)
		return -EINVAL;

	rc6_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
	if (!rc6_res)
		return -EINVAL;

	irq = platform_get_irq(pdev, 0);
	if (irq <= 0)
		return -EINVAL;

	ir = devm_kzalloc(dev, sizeof(*ir), GFP_KERNEL);
	if (!ir)
		return -ENOMEM;

	ir->rc5_base = devm_ioremap_resource(dev, rc5_res);
	if (IS_ERR(ir->rc5_base))
		return PTR_ERR(ir->rc5_base);

	ir->rc6_base = devm_ioremap_resource(dev, rc6_res);
	if (IS_ERR(ir->rc6_base))
		return PTR_ERR(ir->rc6_base);

	ir->clk = devm_clk_get(dev, NULL);
	if (IS_ERR(ir->clk))
		return PTR_ERR(ir->clk);

	err = clk_prepare_enable(ir->clk);
	if (err)
		return err;

	clkrate = clk_get_rate(ir->clk);

	rc = rc_allocate_device();
	if (!rc) {
		err = -ENOMEM;
		goto err_clk;
	}

	rc->dev.parent = dev;
	rc->input_name = "tango-ir";
	rc->input_phys = "tango-ir/input0";
	rc->driver_name = "tango-ir";
	rc->map_name = RC_MAP_EMPTY;
	rc->driver_type = RC_DRIVER_SCANCODE;
	rc->allowed_protocols = RC_BIT_RC5 | RC_BIT_NEC | RC_BIT_RC6_0;
	rc->change_protocol = tango_change_protocol;

	rc->priv = ir;
	ir->rc = rc;

	clkdiv = (u64)clkrate * NEC_TIME_BASE;
	do_div(clkdiv, 1000000);

	writel(31 << 24 | 12 << 16 | clkdiv, ir->rc5_base + IR_NEC_CTRL);

	clkdiv = (u64)clkrate * RC5_TIME_BASE;
	do_div(clkdiv, 1000000);

	writel(0x110, ir->rc5_base + IR_CTRL);
	writel(clkdiv, ir->rc5_base + IR_RC5_CLK_DIV);
	writel(0x3, ir->rc5_base + IR_INT);

	clkdiv = (u64)clkrate * RC6_TIME_BASE;
	do_div(clkdiv, RC6_CARRIER);

	writel(0xc0000000, ir->rc6_base + RC6_CTRL);
	writel((clkdiv >> 2) << 18 | clkdiv, ir->rc6_base + RC6_CLKDIV);

	err = devm_request_irq(dev, irq, tango_ir_irq, IRQF_SHARED,
			       dev_name(dev), ir);
	if (err)
		goto err_rc;

	dev_info(dev, "SMP86xx IR decoder at 0x%x/0x%x IRQ %d\n",
		 rc5_res->start, rc6_res->start, irq);

	err = rc_register_device(rc);
	if (err)
		goto err_rc;

	platform_set_drvdata(pdev, ir);

	return 0;

err_rc:
	rc_free_device(rc);
err_clk:
	clk_disable_unprepare(ir->clk);

	return err;
}

static int tango_ir_remove(struct platform_device *pdev)
{
	struct tango_ir *ir = platform_get_drvdata(pdev);

	rc_unregister_device(ir->rc);
	rc_free_device(ir->rc);
	clk_disable_unprepare(ir->clk);

	return 0;
}

static const struct of_device_id tango_ir_dt_ids[] = {
	{ .compatible = "sigma,smp8642-ir" },
	{ }
};
MODULE_DEVICE_TABLE(of, tango_ir_dt_ids);

static struct platform_driver tango_ir_driver = {
	.probe	= tango_ir_probe,
	.remove	= tango_ir_remove,
	.driver	= {
		.name		= "tango-ir",
		.of_match_table	= tango_ir_dt_ids,
	},
};
module_platform_driver(tango_ir_driver);

MODULE_DESCRIPTION("SMP86xx IR decoder driver");
MODULE_AUTHOR("Mans Rullgard <mans@mansr.com>");
MODULE_LICENSE("GPL");
