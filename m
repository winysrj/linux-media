Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.velocitynet.com.au ([203.17.154.21]:56467 "EHLO
	webmail2.velocitynet.com.au" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751702Ab0ATVUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 16:20:23 -0500
MIME-Version: 1.0
Date: Wed, 20 Jan 2010 21:20:20 +0000
From: <paul10@planar.id.au>
To: "Igor M. Liplianin" <liplianin@me.by>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: DM1105: could not attach frontend 195d:1105
In-Reply-To: <8f772b00c9ad2033899eeb1913ee42e0@mail.velocitynet.com.au>
References: <3bf14d196e3bc8717d910d09a623f98e@mail.velocitynet.com.au> <fded4e7b5651846ee885157dff27bf5c@mail.velocitynet.com.au> <8d15809584306ed08401d6b06dccfcaf@mail.velocitynet.com.au> <8f772b00c9ad2033899eeb1913ee42e0@mail.velocitynet.com.au>
Message-ID: <52aaba8d0f6ba9e6928ea68d96565bf4@mail.velocitynet.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Igor wrote:
> Oh, that is wrong. It is registers addresses, Never touch this.
>
> Let's look on that part of code:
>
> /* GPIO's for LNB power control */
> #define DM1105_LNB_MASK                         0x00000000 // later in
code write it to
> DM1105_GPIOCTR, all GPIO's as OUT
> #define DM1105_LNB_OFF                          0x00020000 // later in
code write it to
> DM1105_GPIOVAL, set GPIO17 to HIGH

> But you have not to change this.
> Right way is to write another entry in cards structure and so on.
> Better leave it to me.

> Regards
> Igor

Thanks for all your help, I understand better now.  I have moved to code
like that at the bottom.  It still doesn't work, but feels a lot closer.

Before I keep playing with values, I want to check I'm on the right track.
Does it look right?  Specific questions:
1. I see there is a hw_init function.  Should I be using that?  I put the
logic into fe_attach because there was already card-specific logic in
there.  But this feels like hw initialisation.  

2. Should I set the control to input or output?  I'm assuming input = 1.

3. Would pin 15 be numbered from the left or right - is it 0x4, or 0x2000?

Thanks,

Paul

*** dm1105.c.old        2010-01-13 16:15:00.000000000 +1100
--- dm1105.c    2010-01-21 08:13:14.000000000 +1100
***************
*** 51,56 ****
--- 51,57 ----
  #define DM1105_BOARD_DVBWORLD_2002    1
  #define DM1105_BOARD_DVBWORLD_2004    2
  #define DM1105_BOARD_AXESS_DM05               3
+ #define DM1105_BOARD_UNBRANDED                4
  
  /* ----------------------------------------------- */
  /*
***************
*** 171,176 ****
--- 172,181 ----
  #define DM05_LNB_13V                          0x00020000
  #define DM05_LNB_18V                          0x00030000
  
+ /* GPIO's for demod reset for unbranded 195d:1105 */
+ #define UNBRANDED_DEMOD_MASK                  0x00008000
+ #define UNBRANDED_DEMOD_RESET                 0x00008000
+ 
  static unsigned int card[]  = {[0 ... 3] = UNSET };
  module_param_array(card,  int, NULL, 0444);
  MODULE_PARM_DESC(card, "card type");
***************
*** 206,211 ****
--- 211,219 ----
        [DM1105_BOARD_AXESS_DM05] = {
                .name           = "Axess/EasyTv DM05",
        },
+       [DM1105_BOARD_UNBRANDED] = {
+               .name           = "Unbranded 195d:1105",
+         },
  };
  
  static const struct dm1105_subid dm1105_subids[] = {
***************
*** 229,234 ****
--- 237,246 ----
                .subvendor = 0x195d,
                .subdevice = 0x1105,
                .card      = DM1105_BOARD_AXESS_DM05,
+       }, {
+               .subvendor = 0x195d,
+               .subdevice = 0x1105,
+               .card      = DM1105_BOARD_UNBRANDED,
        },
  };
  
***************
*** 698,703 ****
--- 710,727 ----
                        dm1105dvb->fe->ops.set_voltage =
dm1105dvb_set_voltage;
  
                break;
+       case DM1105_BOARD_UNBRANDED:
+                 printk(KERN_ERR "Attaching as board_unbranded\n");
+               outl(UNBRANDED_DEMOD_MASK, dm_io_mem(DM1105_GPIOCTR));
+               outl(UNBRANDED_DEMOD_RESET , dm_io_mem(DM1105_GPIOVAL));
+               dm1105dvb->fe = dvb_attach(
+                       si21xx_attach, &serit_config,
+                       &dm1105dvb->i2c_adap);
+                       if (dm1105dvb->fe)
+                               dm1105dvb->fe->ops.set_voltage =
+                                       dm1105dvb_set_voltage;
+ 
+               break;
        case DM1105_BOARD_DVBWORLD_2002:
        case DM1105_BOARD_AXESS_DM05:
        default:

