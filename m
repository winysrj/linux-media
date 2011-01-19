Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60158 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab1ASRGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 12:06:50 -0500
Received: by qwa26 with SMTP id 26so1051498qwa.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 09:06:49 -0800 (PST)
References: <1295205650.2400.27.camel@localhost>  <1295234982.2407.38.camel@localhost>  <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com> <1295439718.2093.17.camel@morgan.silverblock.net> <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net> <399CBB46-ACEB-403F-BAD5-87FD286D057B@wilsonet.com> <alpine.DEB.1.10.1101191050560.22872@cnc.isely.net>
In-Reply-To: <alpine.DEB.1.10.1101191050560.22872@cnc.isely.net>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <7E3BC710-2BEA-4492-9EF5-D7E531609202@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Date: Wed, 19 Jan 2011 12:07:02 -0500
To: Mike Isely <isely@isely.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 19, 2011, at 11:57 AM, Mike Isely wrote:

> On Wed, 19 Jan 2011, Jarod Wilson wrote:
> 
>> On Jan 19, 2011, at 8:20 AM, Mike Isely wrote:
>> 
>>> This probing behavior does not happen for HVR-1950 (or HVR-1900) since 
>>> there's only one possible IR configuration there.
>> 
>> Just to be 100% clear, the device I'm poking it is definitely an
>> HVR-1950, using ir_scheme PVR2_IR_SCHEME_ZILOG, so the probe bits
>> shouldn't coming into play with anything I'm doing. Only just now
>> started looking at the pvrusb2 code. Wow, there's a LOT of it. ;)
> 
> Yes, and yes :-)
> 
> The standalone driver version (which is loaded with ifdef's that allow 
> compilation back to 2.6.11) makes the in-kernel driver look small by 
> comparison.
> 
> There is a fair degree of compartmentalization between the modules.  
> The roadmap to what it does for just HVR-1950 you can find by first 
> looking at the declarations in pvrusb2-devattr.h and then the 
> device-specific configurations in pvrusb2-devattr.c.  From there you can 
> usually grep your way around to see how those configuration bits affect 
> the rest of the driver.  Most of the really fun stuff is in 
> pvrusb2-hdw.c.  Pretty much everything else supports or uses that 
> central component.
> 
> The actual stuff which deals with I2C is not that large.  Beyond making 
> the access possible at all, the driver largely just tries to stay out of 
> the way of external logic that needs to reach the bus.

Cool, thanks much for the pointers, that does help. Based on just
looking at pvrusb2-i2c-core.c's pvr2_i2c_register_ir() versus the
hdpvr's register function, I think I already see how to make the
IR part co-operate with lirc_zilog, and have hacked up a quick patch
to test that theory out...

Basically, rather than calling i2c_new_device() independently for
each address (0x70 and 0x71), call it a single time with an
i2c_board_info struct that looks similar to what's in the hdpvr
driver now. The -EIO I was seeing from lirc_zilog, from what I can
recall, is identical to what was happening with the hdpvr prior to
commit 37634d7308c5c1bdde03ab703a3cac3f0fb12453 (in media_tree.git).

Should be able to test this after lunch.

-- 
Jarod Wilson
jarod@wilsonet.com



