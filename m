Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3F3VCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jun 2013 17:02:03 -0400
Date: Sun, 30 Jun 2013 18:01:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "P. van Gaans" <w3ird_n3rd@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: A few wiki ideas (please comment!)
Message-ID: <20130630180159.14d0c7dd@infradead.org>
In-Reply-To: <51D07A27.80509@gmx.net>
References: <51D07A27.80509@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 30 Jun 2013 20:34:15 +0200
"P. van Gaans" <w3ird_n3rd@gmx.net> escreveu:

> Hi,
> 
> I have a few ideas for the wiki. They go a bit further than fixing a 
> typo, so I'd first like to discuss the ideas before messing up wiki 
> pages and doing lots of unwanted work.
> 
> The first is to add a ==Users== section to each device, just above the 
> external links section. For this I already made the following template 
> to use (may need some tweaking, but it's a start):
> 
> http://www.linuxtv.org/wiki/index.php/Template:Users_who_own_this_device
> 
> The idea is primarily that whenever a patch is written for the device or 
> another patch that might influence this device it's easier to find 
> contact details for a few users who are willing to test the patch so 
> they can be contacted directly. Most people don't read every message on 
> the mailing list.
> 
> ---
> 
> The second idea is a bit more complicated and I'm not even sure the wiki 
> is the right place to do it. While searching for support information for 
> various devices, I noticed that I kept stumbling upon abandoned patches, 
> mostly on the mailing list, for devices that are currently unsupported 
> in v4l-dvb. If I really start to dig in, I'm afraid I'll find at least 
> tens of them. Some of those devices are really attractive.
> 
> That seems like a waste: we know how the device works, we actually have 
> working code.. But for one reason or another, it's not getting pulled. 
> Maybe the code needs a cleanup. Maybe somebody just forgot to file a 
> pull request. Maybe the code wasn't signed off. AFAIK we currently have 
> no overview of these patches.
> 
> The idea is to make a wiki page (suggestions for a page title?) that 
> lists the device, links to the available patch(es) or code and lists the 
> reason why the patch hasn't been pulled yet.

Well, if the patches exist and were not damaged by the emailer, they'll
be stored forever at patchwork:
	https://patchwork.linuxtv.org/project/linux-media/list/?state=*

If you're willing to dig into it, I suggest you to see if it was just
forgot to be applied and contact the corresponding sub-maintainer,
asking him to review it. If the patch is broken, then it makes sense
to ping the author for him to fix the patch and send a new version.

Ok, it may have there some things that are in so bad state that can't
be merged, but, on most cases, it is possible to merge them at
drivers/staging/media, if someone is willing to take some care on it
and fix the pending issues.

Regards,
Mauro


Cheers,
Mauro
