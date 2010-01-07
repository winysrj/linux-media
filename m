Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49369 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab0AGSSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jan 2010 13:18:22 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 7 Jan 2010 12:18:18 -0600
Subject: RE: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting ccdc drivers
 to platform driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40162D43099@dlee06.ent.ti.com>
References: <1260895054-13232-1-git-send-email-m-karicheri2@ti.com>
	<871vi4rv25.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162C23952@dlee06.ent.ti.com>
	<87k4vvkyo7.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162C23A3E@dlee06.ent.ti.com>
 <878wcbkx60.fsf@deeprootsystems.com>
In-Reply-To: <878wcbkx60.fsf@deeprootsystems.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin,

>
>OK, I'm not extremely familar with the whole video architecture here,
>but are all of these drivers expected to be doing clk_get() and
>clk_enable()?
>

[MK]Many IPs on DaVinci VPFE would require vpss master clock. So
it is better to do the way I have done in my patch. So it is expected
that clk_get, clk_enable etc are called from other drivers as well.

>I thought the point of moving the clocks into the CCDC driver was so that
>the clock management was done in a single, shared space.
>

[MK] No. The CCDC IP is used across DaVinci and OMAP SOCs. The clock is named differently on OMAP, but the IP requires two clocks. So we named
them as "master" and "slave" as a generic name. OMAP, patform code will be mapping master and slave clocks to their respective clocks. We had discussed this in the email chain.

Murali
>Kevin
>
>>>> Your earlier suggestion was to use as follows :-
>>>>
>>>> -	CLK(NULL, "vpss_master", &vpss_master_clk),
>>>> -	CLK(NULL, "vpss_slave", &vpss_slave_clk),
>>>> +	CLK("vpfe-capture", "master", &vpss_master_clk),
>>>> +	CLK("vpfe-capture", "slave", &vpss_slave_clk),
>>>>
>>>> I am not sure if the following will work so that it can be used across
>>>> multiple drivers.
>>>>
>>>> +	CLK(NULL, "master", &vpss_master_clk),
>>>> +	CLK(NULL, "slave", &vpss_slave_clk),
>>>>
>>>> If yes, I can re-do this patch. Please confirm.
>>>
>>>No, this will not work.  You need a dev_id field so that matching
>>>is done using the struct device.
>>>
>>>My original suggestion was when you had the VPFE driver doing the
>>>clk_get().  Now that it's in CCDC, maybe it should look like this.
>>>
>>>-	CLK(NULL, "vpss_master", &vpss_master_clk),
>>>-	CLK(NULL, "vpss_slave", &vpss_slave_clk),
>>>+	CLK("ccdc", "master", &vpss_master_clk),
>>>+	CLK("ccdc", "slave", &vpss_slave_clk),
>>>
>>>Kevin
