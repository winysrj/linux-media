Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759016Ab2DZSfg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 14:35:36 -0400
Message-ID: <4F999572.8040102@redhat.com>
Date: Thu, 26 Apr 2012 15:35:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manoel PN <pinusdtv@hotmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media next v3.4] Add support for TBS-Tech ISDB-T Full Seg DTB08
References: <BLU157-W6519D7CC9237EFB29FB24ED8230@phx.gbl>
In-Reply-To: <BLU157-W6519D7CC9237EFB29FB24ED8230@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-04-2012 00:56, Manoel PN escreveu:
> 
>>> +static u8 mb86a20s_soft_reset[] = {
>>> + 0x70, 0xf0, 0x70, 0xff, 0x08, 0x01, 0x08, 0x00
>>> +};
>>
>> Huh? Why do you need to add mb86 stuff here? That sounds wrong.
>>
> 
> Need?  Don't need.
> 
> The device tbs_dtb08 does not work with the configurations that are in the
> mb86a20s module, but various suggestions submitted were rejected.

[resending message, as it were not c/c to the linux-media ML]

Yes, because you didn't just add there what it were needed for your driver.
You did several other changes that weren't needed.

That made very hard to discover what you really changed there.

I had to manually dig into each change you've proposed, at the string
initialization, in order to double check what was there, and manually
apply each change using the current struct. Anyway, I did it back in
January, and tested that the changes there didn't break for the existing
devices using mb86a20s:

commit ebe967492c681da781dbc0f7c0d6a1b5c1977d45
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Wed Jan 11 11:00:28 2012 -0200

    mb86a20s: Add a few more register settings at the init seq
    
    Some time ago, Manoel sent us a patch adding more stuff
    to the init sequence. However, his patch were also doing
    non-related stuff, by changing the init logic without
    any good reason. So, it was asked for him to submit a
    patch with just the data that has changed, in order to
    allow us to better analyze it.
    
    As he didn't what it was requested, I finally found some
    time to dig into his init sequence and add it here.
    
    Basically, new stuff is added there. There are a few changes:
    
    1) The removal of the extra (duplicated) logic that puts
       the chip into the serial mode;
    2) Some Viterbi VBER measurement init data was changed from
       0x00 to 0xff for layer A, to match what was done for
       layers B and C.
    
    None of those caused any regressions and both make sense
    on my eyes.
    
    The other parameters additions actually increased the
    tuning quality for some channels. Yet, some channels that
    were previously discovered with scan disappered, while
    others appeared instead. This were tested in Brasilia,
    with an external antena.
    
    At the overall, it is now a little better. So, better to
    add these, and then try to figure out a configuration that
    would get even better scanning results.
    
    Reported-by: Manoel Pinheiro <pinusdtv@hotmail.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> The idea is to allow individual configuration of the mb86a20s registers.
> And these modifications here make exactly this.
> Besides adding/modifying functions that do not work on this device.
> 
> For example:
> 
> static struct mb86a20s_reg_subreg_val mb86a20s_regs_val[] = {
> ...
>   { 0x28, 0x20, 0x04, 0x33dfa9 },
> ...
> };
> 
> static struct mb86a20s_reg_subreg_config dtb08_a20s_config_regs[] = {
>     { 0x28, 0x20, 0x33dd00 },  /* modif reg 0x28 sub 0x20 to 0x33dfa9 */
>     { 0x3C, 0x00, 0x38 }       /* modif reg 0x3c to 0x38 */
> };
> 
> struct mb86a20s_state *state;
> ...
> state->config_size = ARRAY_SIZE(dtb08_a20s_config_regs);
> state->config_regs = dtb08_a20s_config_regs;
> 
> if (mb86a20s_init_regs(state) != 0)
>     return -ENODEV;
> ...
> 

Individual configuration for the registers is a very bad idea. No driver
does that, as it becomes a maintenance nightmare. 

What drivers do, instead, is to have a config struct with the options that
are different. In the case of mb8a20s, there are currently only two options:

struct mb86a20s_config {
	u8 demod_address;
	bool is_serial;
};

But other drivers, like DRX-K (with supports both DVB-C and DVB-T) have
much more parameters to configure:

struct drxk_config {
	u8	adr;
	bool	single_master;
	bool	no_i2c_bridge;
	bool	parallel_ts;
	bool	dynamic_clk;
	bool	enable_merr_cfg;

	bool	antenna_dvbt;
	u16	antenna_gpio;

	u8	mpeg_out_clk_strength;
	int	chunk_size;

	const char *microcode_name;
};

So, if two devices require to set different configurations, it is clear for
reviewers and other developers that may be working with the same chipset for
what those changes are.

>>> +MODULE_AUTHOR("Manoel Pinheiro <pinusdtv@hotmail.com>");
>>> +MODULE_DESCRIPTION("Driver for TBS-Tech ISDB-T USB2.0 Receiver (DTB08 Full Seg)");
>>> +MODULE_LICENSE("GPL");
>>
> 
> Well I will send the last modification and stop here because no one else besides me have this device.

There aren't many Brazilian people reading this ML. That may explain why there's not much
comments about that. 

Regards,
Mauro
