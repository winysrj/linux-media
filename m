Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56791 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbZLJUCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 15:02:18 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 10 Dec 2009 14:02:22 -0600
Subject: RE: [PATCH - v1 1/2] V4L - vpfe capture - make clocks configurable
Message-ID: <A69FA2915331DC488A831521EAE36FE40155C80BFC@dlee06.ent.ti.com>
References: <1259687940-31435-1-git-send-email-m-karicheri2@ti.com>
	<87hbs0xhlx.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40155C805C3@dlee06.ent.ti.com>
	<A69FA2915331DC488A831521EAE36FE40155C805F7@dlee06.ent.ti.com>
	<A69FA2915331DC488A831521EAE36FE40155C806EE@dlee06.ent.ti.com>
 <87ws0ups22.fsf@deeprootsystems.com>
In-Reply-To: <87ws0ups22.fsf@deeprootsystems.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> Kevin,
>>
>> I think I have figured it out...
>>
>> First issue was that I was adding my entry at the end of dm644x_clks[]
>> array. I need to add it before the CLK(NULL, NULL, NULL)
>>
>> secondly, your suggestion didn't work as is. This is what I had to
>> do to get it working...
>>
>> static struct clk ccdc_master_clk = {
>> 	.name = "dm644x_ccdc",
>> 	.parent = &vpss_master_clk,
>> };
>>
>> static struct clk ccdc_slave_clk = {
>> 	.name = "dm644x_ccdc",
>> 	.parent = &vpss_slave_clk,
>> };

It doesn't work with out doing this. The cat /proc/davinci_clocks hangs with
your suggestion implemented...

>
>You should not need to add new clocks with new names.  I don't thinke
>the name field of the struct clk is used anywhere in the matching.
>I think it's only used in /proc/davinci_clocks
>
>> static struct davinci_clk dm365_clks = {
>> ....
>> ....
>> CLK("dm644x_ccdc", "master", &ccdc_master_clk),
>> CLK("dm644x_ccdc", "slave", &ccdc_slave_clk),
>
>Looks like the drivers name is 'dm644x_ccdc', not 'isif'.  I'm
>guessing just this should work without having to add new clock names.
>
No. I have mixed up the names. ISIF is for the new ISIF driver on DM365.
Below are for DM644x ccdc driver. With just these entries added, two
things observed....

1) Only one clock is shown disabled (usually many are shown disabled) during bootup
2) cat /proc/davinci_clocks hangs.

So this is the only way I got it working.

>CLK("dm644x_ccdc", "master", &vpss_master_clk),
>CLK("dm644x_ccdc", "slave", &vpss_slave_clk),
>
>> CLK(NULL, NULL, NULL);
>>
>> Let me know if you think there is anything wrong with the above scheme.
>
>Kevin
