Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:60570 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbZLIUdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 15:33:03 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 9 Dec 2009 14:33:07 -0600
Subject: RE: [PATCH - v1 1/2] V4L - vpfe capture - make clocks configurable
Message-ID: <A69FA2915331DC488A831521EAE36FE40155C806EE@dlee06.ent.ti.com>
References: <1259687940-31435-1-git-send-email-m-karicheri2@ti.com>
	<87hbs0xhlx.fsf@deeprootsystems.com>
 <A69FA2915331DC488A831521EAE36FE40155C805C3@dlee06.ent.ti.com>
 <A69FA2915331DC488A831521EAE36FE40155C805F7@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155C805F7@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin,

I think I have figured it out...

First issue was that I was adding my entry at the end of dm644x_clks[]
array. I need to add it before the CLK(NULL, NULL, NULL)

secondly, your suggestion didn't work as is. This is what I had to
do to get it working...

static struct clk ccdc_master_clk = {
	.name = "dm644x_ccdc",
	.parent = &vpss_master_clk,
};

static struct clk ccdc_slave_clk = {
	.name = "dm644x_ccdc",
	.parent = &vpss_slave_clk,
};

static struct davinci_clk dm365_clks = {
....
....
CLK("dm644x_ccdc", "master", &ccdc_master_clk),
CLK("dm644x_ccdc", "slave", &ccdc_slave_clk),
CLK(NULL, NULL, NULL); 

Let me know if you think there is anything wrong with the above scheme.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Karicheri, Muralidharan
>Sent: Wednesday, December 09, 2009 1:22 PM
>To: Karicheri, Muralidharan; Kevin Hilman
>Cc: davinci-linux-open-source@linux.davincidsp.com; linux-
>media@vger.kernel.org
>Subject: RE: [PATCH - v1 1/2] V4L - vpfe capture - make clocks configurable
>
>Kevin,
>
>I tried the following and I get error in clk_enable(). Do you know what
>might be wrong?
>
>in DM365.c
>
>CLK("isif", "master", &vpss_master_clk)
>
>The driver name is isif. I call clk_get(&pdev->dev, "master") from isif
>driver. The platform device name is "isif". This call succeeds, but
>clk_enable() fails...
>
>clk_ptr = clk_get(&pdev->dev, "master");
>clk_enable(clk_ptr);
>
>root@dm355-evm:~# cat /proc/davinci_clocks
>ref_clk           users= 7      24000000 Hz
>  pll1            users= 6 pll 486000000 Hz
>    pll1_aux_clk  users= 3 pll  24000000 Hz
>      uart0       users= 1 psc  24000000 Hz
>      i2c         users= 1 psc  24000000 Hz
>      spi4        users= 0 psc  24000000 Hz
>      pwm0        users= 0 psc  24000000 Hz
>      pwm1        users= 0 psc  24000000 Hz
>      pwm2        users= 0 psc  24000000 Hz
>      timer0      users= 1 psc  24000000 Hz
>      timer1      users= 0 psc  24000000 Hz
>      timer2      users= 1 psc  24000000 Hz
>      timer3      users= 0 psc  24000000 Hz
>      usb         users= 0 psc  24000000 Hz
>    pll1_sysclkbp users= 0 pll  24000000 Hz
>    clkout0       users= 0 pll  24000000 Hz
>    pll1_sysclk1  users= 0 pll 486000000 Hz
>    pll1_sysclk2  users= 0 pll 243000000 Hz
>    pll1_sysclk3  users= 0 pll 243000000 Hz
>      vpss_dac    users= 0 psc 243000000 Hz
>      mjcp        users= 0 psc 243000000 Hz
>    pll1_sysclk4  users= 3 pll 121500000 Hz
>      uart1       users= 0 psc 121500000 Hz
>      mmcsd1      users= 0 psc 121500000 Hz
>      spi0        users= 0 psc 121500000 Hz
>      spi1        users= 0 psc 121500000 Hz
>      spi2        users= 0 psc 121500000 Hz
>      spi3        users= 0 psc 121500000 Hz
>      gpio        users= 1 psc 121500000 Hz
>      aemif       users= 1 psc 121500000 Hz
>      emac        users= 1 psc 121500000 Hz
>      asp0        users= 0 psc 121500000 Hz
>      rto         users= 0 psc 121500000 Hz
>    pll1_sysclk5  users= 0 pll 243000000 Hz
>      vpss_master users= 0 psc 243000000 Hz
>    pll1_sysclk6  users= 0 pll  27000000 Hz
>    pll1_sysclk7  users= 0 pll 486000000 Hz
>    pll1_sysclk8  users= 0 pll 121500000 Hz
>      mmcsd0      users= 0 psc 121500000 Hz
>    pll1_sysclk9  users= 0 pll 243000000 Hz
>  pll2            users= 1 pll 594000000 Hz
>    pll2_aux_clk  users= 0 pll  24000000 Hz
>    clkout1       users= 0 pll  24000000 Hz
>    pll2_sysclk1  users= 0 pll 594000000 Hz
>    pll2_sysclk2  users= 1 pll 297000000 Hz
>      arm_clk     users= 1 psc 297000000 Hz
>    pll2_sysclk3  users= 0 pll 594000000 Hz
>    pll2_sysclk4  users= 0 pll  20482758 Hz
>      voice_codec users= 0 psc  20482758 Hz
>    pll2_sysclk5  users= 0 pll  74250000 Hz
>    pll2_sysclk6  users= 0 pll 594000000 Hz
>    pll2_sysclk7  users= 0 pll 594000000 Hz
>    pll2_sysclk8  users= 0 pll 594000000 Hz
>    pll2_sysclk9  users= 0 pll 594000000 Hz
>  pwm3            users= 0 psc  24000000 Hz
>root@dm355-evm:~#
>
>
>
>Murali Karicheri
>Software Design Engineer
>Texas Instruments Inc.
>Germantown, MD 20874
>phone: 301-407-9583
>email: m-karicheri2@ti.com
>
>>-----Original Message-----
>>From: davinci-linux-open-source-bounces@linux.davincidsp.com
>>[mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On Behalf
>>Of Karicheri, Muralidharan
>>Sent: Wednesday, December 09, 2009 12:45 PM
>>To: Kevin Hilman
>>Cc: davinci-linux-open-source@linux.davincidsp.com; linux-
>>media@vger.kernel.org
>>Subject: RE: [PATCH - v1 1/2] V4L - vpfe capture - make clocks
>configurable
>>
>>Kevin,
>>
>>>> +/**
>>>> + * vpfe_disable_clock() - Disable clocks for vpfe capture driver
>>>> + * @vpfe_dev - ptr to vpfe capture device
>>>> + *
>>>> + * Disables clocks defined in vpfe configuration.
>>>> + */
>>>>  static void vpfe_disable_clock(struct vpfe_device *vpfe_dev)
>>>>  {
>>>>  	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
>>>> +	int i;
>>>>
>>>> -	clk_disable(vpfe_cfg->vpssclk);
>>>> -	clk_put(vpfe_cfg->vpssclk);
>>>> -	clk_disable(vpfe_cfg->slaveclk);
>>>> -	clk_put(vpfe_cfg->slaveclk);
>>>> -	v4l2_info(vpfe_dev->pdev->driver,
>>>> -		 "vpfe vpss master & slave clocks disabled\n");
>>>> +	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
>>>> +		clk_disable(vpfe_dev->clks[i]);
>>>> +		clk_put(vpfe_dev->clks[i]);
>>>
>>>While cleaning this up, you should move the clk_put() to module
>>>disable/unload time.
>>
>>[MK] vpfe_disable_clock() is called from remove(). In the new
>>patch, from ccdc driver remove() function, clk_put() will be called.
>>Why do you think it should be moved to exit() function of the module?
>>
>>>You dont' need to put he clock on every disable.
>>>The same for clk_get(). You don't need to get the clock for every
>>>enable.  Just do a clk_get() at init time.
>>
>>Are you suggesting to call clk_get() during init() and call clk_put()
>>from exit()? What is wrong with calling clk_get() from probe()?
>>I thought following is correct:-
>>Probe()
>>clk_get() followed by clk_enable()
>>Remove()
>>clk_disable() followed by clk_put()
>>Suspend()
>>clk_disable()
>>Resume()
>>clk_enable()
>>Please confirm.
>>_______________________________________________
>>Davinci-linux-open-source mailing list
>>Davinci-linux-open-source@linux.davincidsp.com
>>http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
