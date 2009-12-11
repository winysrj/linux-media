Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53874 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394AbZLKSea (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 13:34:30 -0500
Received: by pwj9 with SMTP id 9so746943pwj.21
        for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 10:34:37 -0800 (PST)
To: "Karicheri\, Muralidharan" <m-karicheri2@ti.com>
Cc: "davinci-linux-open-source\@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH - v1 1/2] V4L - vpfe capture - make clocks configurable
References: <1259687940-31435-1-git-send-email-m-karicheri2@ti.com>
	<87hbs0xhlx.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40155C805C3@dlee06.ent.ti.com>
	<A69FA2915331DC488A831521EAE36FE40155C805F7@dlee06.ent.ti.com>
	<A69FA2915331DC488A831521EAE36FE40155C806EE@dlee06.ent.ti.com>
	<87ws0ups22.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40155C80BFC@dlee06.ent.ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Fri, 11 Dec 2009 10:34:34 -0800
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155C80BFC@dlee06.ent.ti.com> (Muralidharan Karicheri's message of "Thu\, 10 Dec 2009 14\:02\:22 -0600")
Message-ID: <871vj1iclh.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:

>>> Kevin,
>>>
>>> I think I have figured it out...
>>>
>>> First issue was that I was adding my entry at the end of dm644x_clks[]
>>> array. I need to add it before the CLK(NULL, NULL, NULL)
>>>
>>> secondly, your suggestion didn't work as is. This is what I had to
>>> do to get it working...
>>>
>>> static struct clk ccdc_master_clk = {
>>> 	.name = "dm644x_ccdc",
>>> 	.parent = &vpss_master_clk,
>>> };
>>>
>>> static struct clk ccdc_slave_clk = {
>>> 	.name = "dm644x_ccdc",
>>> 	.parent = &vpss_slave_clk,
>>> };
>
> It doesn't work with out doing this. The cat /proc/davinci_clocks hangs with
> your suggestion implemented...

Can you track down the hang.  It sounds like a bug in the walking of
the clock tree for davinci_clocks.

>>
>>You should not need to add new clocks with new names.  I don't thinke
>>the name field of the struct clk is used anywhere in the matching.
>>I think it's only used in /proc/davinci_clocks
>>
>>> static struct davinci_clk dm365_clks = {
>>> ....
>>> ....
>>> CLK("dm644x_ccdc", "master", &ccdc_master_clk),
>>> CLK("dm644x_ccdc", "slave", &ccdc_slave_clk),
>>
>>Looks like the drivers name is 'dm644x_ccdc', not 'isif'.  I'm
>>guessing just this should work without having to add new clock names.
>>
> No. I have mixed up the names. ISIF is for the new ISIF driver on DM365.
> Below are for DM644x ccdc driver. With just these entries added, two
> things observed....
>
> 1) Only one clock is shown disabled (usually many are shown disabled) during bootup
> 2) cat /proc/davinci_clocks hangs.
>
> So this is the only way I got it working.

Hmm, it worked just fine for me without any of these side effects.  I
applied the simple patch below on top of current master branch.  It booted
fine showing all the unused clocks being disabled, and I was able to 
see davinci_clocks just fine:


diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index e65e29e..e6f3570 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -293,8 +293,8 @@ struct davinci_clk dm644x_clks[] = {
        CLK(NULL, "dsp", &dsp_clk),
        CLK(NULL, "arm", &arm_clk),
        CLK(NULL, "vicp", &vicp_clk),
-       CLK(NULL, "vpss_master", &vpss_master_clk),
-       CLK(NULL, "vpss_slave", &vpss_slave_clk),
+       CLK("dm644x_ccdc", "master", &vpss_master_clk),
+       CLK("dm644x_ccdc", "slave", &vpss_slave_clk),
        CLK(NULL, "arm", &arm_clk),
        CLK(NULL, "uart0", &uart0_clk),
        CLK(NULL, "uart1", &uart1_clk),


[...]
Clocks: disable unused uart1                                                    
Clocks: disable unused uart2                                                    
Clocks: disable unused emac                                                     
Clocks: disable unused ide                                                      
Clocks: disable unused asp0                                                     
Clocks: disable unused mmcsd                                                    
Clocks: disable unused spi                                                      
Clocks: disable unused usb                                                      
Clocks: disable unused vlynq                                                    
Clocks: disable unused pwm0                                                     
Clocks: disable unused pwm1                                                     
Clocks: disable unused pwm2                                                     
Clocks: disable unused timer1    
[...]

root@DM644x:~# uname -r                                                         
2.6.32-arm-davinci-default-06873-g1a7277b-dirty                                 
root@DM644x:~# cat /debug/davinci_clocks                                        
ref_clk           users= 8      27000000 Hz                                     
  pll1            users= 8 pll 594000000 Hz                                     
    pll1_sysclk1  users= 0 pll 594000000 Hz                                     
      dsp         users= 1 psc 594000000 Hz                                     
    pll1_sysclk2  users= 2 pll 297000000 Hz                                     
      arm         users= 2 psc 297000000 Hz                                     
    pll1_sysclk3  users= 0 pll 198000000 Hz                                     
      vpss_master users= 0 psc 198000000 Hz                                     
      vpss_slave  users= 0 psc 198000000 Hz                                     
    pll1_sysclk5  users= 3 pll  99000000 Hz                                     
      emac        users= 1 psc  99000000 Hz                                     
      ide         users= 0 psc  99000000 Hz                                     
      asp0        users= 0 psc  99000000 Hz                                     
      mmcsd       users= 0 psc  99000000 Hz                                     
      spi         users= 0 psc  99000000 Hz                                     
      gpio        users= 1 psc  99000000 Hz                                     
      usb         users= 0 psc  99000000 Hz                                     
      vlynq       users= 0 psc  99000000 Hz                                     
      aemif       users= 1 psc  99000000 Hz                                     
    pll1_aux_clk  users= 3 pll  27000000 Hz                                     
      uart0       users= 1 psc  27000000 Hz                                     
      uart1       users= 0 psc  27000000 Hz                                     
      uart2       users= 0 psc  27000000 Hz                                     
      i2c         users= 1 psc  27000000 Hz                                     
      pwm0        users= 0 psc  27000000 Hz                                     
      pwm1        users= 0 psc  27000000 Hz                                     
      pwm2        users= 0 psc  27000000 Hz                                     
      timer0      users= 1 psc  27000000 Hz                                     
      timer1      users= 0 psc  27000000 Hz                                     
      timer2      users= 1 psc  27000000 Hz                                     
    pll1_sysclkbp users= 0 pll  27000000 Hz                                     
  pll2            users= 0 pll 648000000 Hz                                     
    pll2_sysclk1  users= 0 pll  54000000 Hz                                     
    pll2_sysclk2  users= 0 pll 324000000 Hz                                     
    pll2_sysclkbp users= 0 pll  13500000 Hz                                     
root@DM644x:~# 

