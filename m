Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:40365 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab0AFQEL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2010 11:04:11 -0500
Received: by iwn32 with SMTP id 32so1667506iwn.33
        for <linux-media@vger.kernel.org>; Wed, 06 Jan 2010 08:04:10 -0800 (PST)
To: "Karicheri\, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil\@xs4all.nl" <hverkuil@xs4all.nl>,
	"davinci-linux-open-source\@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting ccdc drivers to platform driver
References: <1260895054-13232-1-git-send-email-m-karicheri2@ti.com>
	<871vi4rv25.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162C23952@dlee06.ent.ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Wed, 06 Jan 2010 08:04:08 -0800
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40162C23952@dlee06.ent.ti.com> (Muralidharan Karicheri's message of "Wed\, 6 Jan 2010 08\:44\:53 -0600")
Message-ID: <87k4vvkyo7.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:

>>>  	CLK(NULL, "rto", &rto_clk),
>>>  	CLK(NULL, "usb", &usb_clk),
>>> +	CLK("dm355_ccdc", "master", &vpss_master_clk),
>>> +	CLK("dm355_ccdc", "slave", &vpss_slave_clk),
>>
>>I still don't understand why you have to add new entries here and
>>can't simply rename the existing CLK nodes using vpss_*_clk.
>>
>
> [MK] This will allow multiple drivers define their own clocks derived from
> these. ccdc driver is not the only driver using these clocks. 

OK, but that still doesn't answer why you need multiple CLK() nodes.

Who else is using the clocks?

> Your earlier suggestion was to use as follows :-
>
> -	CLK(NULL, "vpss_master", &vpss_master_clk),
> -	CLK(NULL, "vpss_slave", &vpss_slave_clk),
> +	CLK("vpfe-capture", "master", &vpss_master_clk),
> +	CLK("vpfe-capture", "slave", &vpss_slave_clk),
>
> I am not sure if the following will work so that it can be used across
> multiple drivers.
>
> +	CLK(NULL, "master", &vpss_master_clk),
> +	CLK(NULL, "slave", &vpss_slave_clk),
>
> If yes, I can re-do this patch. Please confirm.

No, this will not work.  You need a dev_id field so that matching
is done using the struct device.

My original suggestion was when you had the VPFE driver doing the
clk_get().  Now that it's in CCDC, maybe it should look like this.

-	CLK(NULL, "vpss_master", &vpss_master_clk),
-	CLK(NULL, "vpss_slave", &vpss_slave_clk),
+	CLK("ccdc", "master", &vpss_master_clk),
+	CLK("ccdc", "slave", &vpss_slave_clk),

Kevin
