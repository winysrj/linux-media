Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:57596 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0IHVMW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 17:12:22 -0400
Date: Wed, 8 Sep 2010 23:12:17 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] rc-code: merge and rename ir-core
Message-ID: <20100908211217.GA13938@hardeman.nu>
References: <dciu6r836199wbxqd3ppo8xr.1283957431820@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dciu6r836199wbxqd3ppo8xr.1283957431820@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 11:10:40AM -0400, Andy Walls wrote:
> Tag files and a decent editor are all one needs for full code 
> navigation.  The kernel makefile already has a tags target to make the 
> tags file.  

If you like to use tags, it won't be affected by many or few files so 
it's not an argument for either approach. 

> Smaller files make for better logical isolation of functions,limiting 
> visibilty/scope, 

Limiting visibility so that you'll have to add explicit declarations to 
ir-core-priv.h for inter-file function calls and functions that would 
otherwise be unnecessary (ir_raw_get_allowed_protocols() for example) 
doesn't sound like an advantage to me.

> and faster compilation of a file (but maybe at the expense of link 
> time).  

*sigh* compile times on my laptop:

rc-core.o		0.558s

ir-functions.o		0.321s
ir-sysfs.o		0.251s
ir-raw-event.o		0.397s
rc-map.o		0.265s

> That sort of isolation of functionality into smaller files also makes 
> the code more digestable for someone new looking at it, IMO. 

First of all, I personally find it much easier to grok a new subsystem 
if the relevant parts are gathered into one file, both when I'm new to a 
subsystem and when I'm used to it. drivers/input/input.c and 
drivers/input/evdev.c come to mind as good examples.

But more importantly, how about focusing on the people actually writing 
patches for ir-core rather than hypotetical people?

-- 
David Härdeman
