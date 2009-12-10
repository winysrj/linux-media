Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:35852 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761551AbZLJTGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 14:06:24 -0500
Received: by gxk4 with SMTP id 4so211828gxk.8
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 11:06:31 -0800 (PST)
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
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Thu, 10 Dec 2009 11:06:29 -0800
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155C806EE@dlee06.ent.ti.com> (Muralidharan Karicheri's message of "Wed\, 9 Dec 2009 14\:33\:07 -0600")
Message-ID: <87ws0ups22.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:

> Kevin,
>
> I think I have figured it out...
>
> First issue was that I was adding my entry at the end of dm644x_clks[]
> array. I need to add it before the CLK(NULL, NULL, NULL)
>
> secondly, your suggestion didn't work as is. This is what I had to
> do to get it working...
>
> static struct clk ccdc_master_clk = {
> 	.name = "dm644x_ccdc",
> 	.parent = &vpss_master_clk,
> };
>
> static struct clk ccdc_slave_clk = {
> 	.name = "dm644x_ccdc",
> 	.parent = &vpss_slave_clk,
> };

You should not need to add new clocks with new names.  I don't thinke
the name field of the struct clk is used anywhere in the matching.
I think it's only used in /proc/davinci_clocks

> static struct davinci_clk dm365_clks = {
> ....
> ....
> CLK("dm644x_ccdc", "master", &ccdc_master_clk),
> CLK("dm644x_ccdc", "slave", &ccdc_slave_clk),

Looks like the drivers name is 'dm644x_ccdc', not 'isif'.  I'm
guessing just this should work without having to add new clock names.

CLK("dm644x_ccdc", "master", &vpss_master_clk),
CLK("dm644x_ccdc", "slave", &vpss_slave_clk),

> CLK(NULL, NULL, NULL); 
>
> Let me know if you think there is anything wrong with the above scheme.

Kevin
