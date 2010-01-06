Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.youplala.net ([88.191.51.216]:41434 "EHLO mail.youplala.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716Ab0AFVXm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2010 16:23:42 -0500
Subject: Re: Call for Testers - dib0700 IR improvements
From: Nicolas Will <nico@youplala.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Harald Gustafsson <hgu1972@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <829197381001060636x311a7bddw73d5e5cb30320dea@mail.gmail.com>
References: <829197381001040936w3bc9b4e0w22eecded4687d9d3@mail.gmail.com>
	 <63a62e0a1001060200r11e440abt84daf0822fcb3e8d@mail.gmail.com>
	 <829197381001060636x311a7bddw73d5e5cb30320dea@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 21:14:43 +0000
Message-ID: <1262812483.17200.41.camel@youkaida>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wed, 2010-01-06 at 09:36 -0500, Devin Heitmueller wrote:
> Just to be clear, this patch does *not* address the warm reboot
> problem.  I am continuing to work that issue, but there should be no
> expectation that this patch allows the device to survive a warm
> reboot.
> 

That one would be cool.


> It should address concerns people were seeing where the system load
> would be between 0.50 and 1.0 just by having the device connected, and
> *may* help in cases where you start to see mt2060 errors after several
> hours of operation. 

hmmm... 

32 days uptime, no mt2060 error from my NovaT500, outside of a failed
read at startup.

regarding the load, I'm not sure I am experiencing it, or it is shadowed
by MythTV's frontend "idling" at 15% cpu...


I'll stop the frontend during the night and look at the load in the
morning. I may be able to provide a graph from munin, as I have multiple
recordings, some concurrent, of the kids shows in the morning.

If I have the load thing, I'll test the patch, otherwise I'll keep the
WAF, and KAF, as I would not be a proper guinea pig anyway.

Nico

