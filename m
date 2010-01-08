Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:40491 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab0AHPK3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 10:10:29 -0500
Received: by iwn32 with SMTP id 32so3149609iwn.33
        for <linux-media@vger.kernel.org>; Fri, 08 Jan 2010 07:10:28 -0800 (PST)
To: "Hiremath\, Vaibhav" <hvaibhav@ti.com>
Cc: "Karicheri\, Muralidharan" <m-karicheri2@ti.com>,
	"davinci-linux-open-source\@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting ccdc drivers to platform driver
References: <1260895054-13232-1-git-send-email-m-karicheri2@ti.com>
	<871vi4rv25.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162C23952@dlee06.ent.ti.com>
	<87k4vvkyo7.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162C23A3E@dlee06.ent.ti.com>
	<878wcbkx60.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162D43099@dlee06.ent.ti.com>
	<87r5q1ya2w.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162D43287@dlee06.ent.ti.com>
	<87my0pwpnk.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162D43371@dlee06.ent.ti.com>
	<19F8576C6E063C45BE387C64729E7394044A398045@dbde02.ent.ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Fri, 08 Jan 2010 07:10:26 -0800
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044A398045@dbde02.ent.ti.com> (Vaibhav Hiremath's message of "Fri\, 8 Jan 2010 14\:36\:09 +0530")
Message-ID: <87zl4oskd9.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Hiremath, Vaibhav" <hvaibhav@ti.com> writes:

>> 
> [Hiremath, Vaibhav] Hi Kevin and Murali,
>
> Sorry for jumping into this discussion so late, 
>
> Can we use clk_add_alias() function exported by clkdev.c file here?
> With this board specific file can define aliases for all required
> platform_data keeping CLK() entry generic.

Yes, this would be a good use case clk_add_alias()

Kevin

