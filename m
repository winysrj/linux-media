Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:62867 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761205AbZLJTCB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 14:02:01 -0500
Received: by ywh6 with SMTP id 6so97804ywh.4
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 11:02:07 -0800 (PST)
To: "Karicheri\, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil\@xs4all.nl" <hverkuil@xs4all.nl>,
	"davinci-linux-open-source\@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"Hiremath\, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH - v1 1/2] V4L - vpfe capture - make clocks configurable
References: <1259687940-31435-1-git-send-email-m-karicheri2@ti.com>
	<87hbs0xhlx.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40155C805C3@dlee06.ent.ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Thu, 10 Dec 2009 11:02:04 -0800
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155C805C3@dlee06.ent.ti.com> (Muralidharan Karicheri's message of "Wed\, 9 Dec 2009 11\:45\:10 -0600")
Message-ID: <877hsur6tv.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:

> Kevin,
>
>>> +/**
>>> + * vpfe_disable_clock() - Disable clocks for vpfe capture driver
>>> + * @vpfe_dev - ptr to vpfe capture device
>>> + *
>>> + * Disables clocks defined in vpfe configuration.
>>> + */
>>>  static void vpfe_disable_clock(struct vpfe_device *vpfe_dev)
>>>  {
>>>  	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
>>> +	int i;
>>>
>>> -	clk_disable(vpfe_cfg->vpssclk);
>>> -	clk_put(vpfe_cfg->vpssclk);
>>> -	clk_disable(vpfe_cfg->slaveclk);
>>> -	clk_put(vpfe_cfg->slaveclk);
>>> -	v4l2_info(vpfe_dev->pdev->driver,
>>> -		 "vpfe vpss master & slave clocks disabled\n");
>>> +	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
>>> +		clk_disable(vpfe_dev->clks[i]);
>>> +		clk_put(vpfe_dev->clks[i]);
>>
>>While cleaning this up, you should move the clk_put() to module
>>disable/unload time. 
>
> [MK] vpfe_disable_clock() is called from remove(). In the new
> patch, from ccdc driver remove() function, clk_put() will be called.
> Why do you think it should be moved to exit() function of the module?
>
>>You dont' need to put he clock on every disable.
>>The same for clk_get(). You don't need to get the clock for every
>>enable.  Just do a clk_get() at init time.
>
> Are you suggesting to call clk_get() during init() and call clk_put()
> from exit()? What is wrong with calling clk_get() from probe()?
> I thought following is correct:-
> Probe()
> clk_get() followed by clk_enable()  
> Remove()
> clk_disable() followed by clk_put()
> Suspend()
> clk_disable()
> Resume()
> clk_enable()

Yes, that is correct.

I didn't look at the whole driver.  My concern was that if the driver
was enhanced to more aggressive clock management, you shouldn't do a
clk_get() every time you do a clk_enable(), same for put.

Kevin
