Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from anchor-post-35.mail.demon.net ([194.217.242.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1KizDr-0002qn-C5
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 00:22:08 +0200
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-35.mail.demon.net with esmtp (Exim 4.67)
	id 1KizDn-0003Bb-In
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 22:22:03 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1KizDj-0005Ua-5S
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 23:22:03 +0100
Date: Thu, 25 Sep 2008 23:13:13 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-dvb@linuxtv.org
Message-ID: <4FE9FCB5B4%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <766065.22236.qm@web52911.mail.re2.yahoo.com>
References: <766065.22236.qm@web52911.mail.re2.yahoo.com>
MIME-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] Add remote control support to Nova-TD
	(52009)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

[text wrapped to <80 columns]

I demand that Chris Rankin may or may not have written...

[snip]
> Aren't we opening the door to "remote control wars" by just concatenating
> the codes from several different remotes into one big list called
> dib0700_rc_keys[]? Wouldn't it be better to allow the user to pick just one
> of the available remotes somehow? Maybe we need an array of dvb_usb_rc_key
> structures instead?

It needs to be converted to use the IR input helper code
(drivers/media/common/ir-{functions,keymaps}.c & <media/ir-common.h>).

[snip]
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Lobby friends, family, business, government.    WE'RE KILLING THE PLANET.

Are you addicted to taglines? Call Tagliners Anonymous *now*!

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
