Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab0DHV7e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 17:59:34 -0400
Message-ID: <4BBE51C2.8060505@infradead.org>
Date: Thu, 08 Apr 2010 18:59:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: david@hardeman.nu
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [patch 3/3] Convert drivers/media/dvb/ttpci/budget-ci.c to use
 ir-core
References: <20100402185827.425741206@hardeman.nu> <20100402190255.774628605@hardeman.nu>
In-Reply-To: <20100402190255.774628605@hardeman.nu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

david@hardeman.nu wrote:
> This patch converts drivers/media/dvb/ttpci/budget-ci.c to use ir-core
> rather than rolling its own keydown timeout handler and reporting keys
> via drivers/media/IR/ir-functions.c.

Hmm... had you test this patch? It got me an error here:

drivers/media/dvb/ttpci/budget-ci.c: In function ‘msp430_ir_init’:
drivers/media/dvb/ttpci/budget-ci.c:228: error: implicit declaration of function ‘ir_input_init’
drivers/media/dvb/ttpci/budget-ci.c:228: error: ‘struct budget_ci_ir’ has no member named ‘state’

The fix is trivial. Just drop this line:

        ir_input_init(input_dev, &budget_ci->ir.state, IR_TYPE_RC5);

It shouldn't cause any troubles, since the only things this function currently do are:
        ir->ir_type = ir_type;

        if (repeat)
                set_bit(EV_REP, dev->evbit);

As the repeat is inside ir-core, and the ir struct is not used anymore, this removal
should cause no harm.

So, I am dropping the line at the code I'm committing at v4l-dvb.git, to avoid bisect
breakages.

> 
> Signed-off-by: David HÃ¤rdeman <david@hardeman.nu>
> 
> 
> Index: ir/drivers/media/dvb/ttpci/budget-ci.c
> ===================================================================
> --- ir.orig/drivers/media/dvb/ttpci/budget-ci.c	2010-04-02 16:41:15.524206900 +0200
> +++ ir/drivers/media/dvb/ttpci/budget-ci.c	2010-04-02 16:48:15.668239437 +0200
> @@ -35,7 +35,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/input.h>
>  #include <linux/spinlock.h>
> -#include <media/ir-common.h>
> +#include <media/ir-core.h>
>  
>  #include "budget.h"
>  
> @@ -82,12 +82,6 @@
>  #define SLOTSTATUS_READY	8
>  #define SLOTSTATUS_OCCUPIED	(SLOTSTATUS_PRESENT|SLOTSTATUS_RESET|SLOTSTATUS_READY)
>  
> -/*
> - * Milliseconds during which a key is regarded as pressed.
> - * If an identical command arrives within this time, the timer will start over.
> - */
> -#define IR_KEYPRESS_TIMEOUT	250
> -
>  /* RC5 device wildcard */
>  #define IR_DEVICE_ANY		255
>  
> @@ -104,12 +98,9 @@
>  struct budget_ci_ir {
>  	struct input_dev *dev;
>  	struct tasklet_struct msp430_irq_tasklet;
> -	struct timer_list timer_keyup;
>  	char name[72]; /* 40 + 32 for (struct saa7146_dev).name */
>  	char phys[32];
> -	struct ir_input_state state;
>  	int rc5_device;
> -	u32 last_raw;
>  	u32 ir_key;
>  	bool have_command;
>  };
> @@ -124,18 +115,11 @@
>  	u8 tuner_pll_address; /* used for philips_tdm1316l configs */
>  };
>  
> -static void msp430_ir_keyup(unsigned long data)
> -{
> -	struct budget_ci_ir *ir = (struct budget_ci_ir *) data;
> -	ir_input_nokey(ir->dev, &ir->state);
> -}
> -
>  static void msp430_ir_interrupt(unsigned long data)
>  {
>  	struct budget_ci *budget_ci = (struct budget_ci *) data;
>  	struct input_dev *dev = budget_ci->ir.dev;
>  	u32 command = ttpci_budget_debiread(&budget_ci->budget, DEBINOSWAP, DEBIADDR_IR, 2, 1, 0) >> 8;
> -	u32 raw;
>  
>  	/*
>  	 * The msp430 chip can generate two different bytes, command and device
> @@ -171,20 +155,12 @@
>  		return;
>  	budget_ci->ir.have_command = false;
>  
> +	/* FIXME: We should generate complete scancodes with device info */
>  	if (budget_ci->ir.rc5_device != IR_DEVICE_ANY &&
>  	    budget_ci->ir.rc5_device != (command & 0x1f))
>  		return;
>  
> -	/* Is this a repeated key sequence? (same device, command, toggle) */
> -	raw = budget_ci->ir.ir_key | (command << 8);
> -	if (budget_ci->ir.last_raw != raw || !timer_pending(&budget_ci->ir.timer_keyup)) {
> -		ir_input_nokey(dev, &budget_ci->ir.state);
> -		ir_input_keydown(dev, &budget_ci->ir.state,
> -				 budget_ci->ir.ir_key);
> -		budget_ci->ir.last_raw = raw;
> -	}
> -
> -	mod_timer(&budget_ci->ir.timer_keyup, jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT));
> +	ir_keydown(dev, budget_ci->ir.ir_key, (command & 0x20) ? 1 : 0);
>  }
>  
>  static int msp430_ir_init(struct budget_ci *budget_ci)
> @@ -251,11 +227,6 @@
>  
>  	ir_input_init(input_dev, &budget_ci->ir.state, IR_TYPE_RC5);
>  
> -	/* initialise the key-up timeout handler */
> -	init_timer(&budget_ci->ir.timer_keyup);
> -	budget_ci->ir.timer_keyup.function = msp430_ir_keyup;
> -	budget_ci->ir.timer_keyup.data = (unsigned long) &budget_ci->ir;
> -	budget_ci->ir.last_raw = 0xffff; /* An impossible value */
>  	error = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
>  	if (error) {
>  		printk(KERN_ERR "budget_ci: could not init driver for IR device (code %d)\n", error);
> @@ -284,9 +255,6 @@
>  	saa7146_setgpio(saa, 3, SAA7146_GPIO_INPUT);
>  	tasklet_kill(&budget_ci->ir.msp430_irq_tasklet);
>  
> -	del_timer_sync(&dev->timer);
> -	ir_input_nokey(dev, &budget_ci->ir.state);
> -
>  	ir_input_unregister(dev);
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
