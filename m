Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:46483
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZHRAi7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 20:38:59 -0400
Cc: linux-media@vger.kernel.org
Message-Id: <41D273E7-E1A0-4086-A03E-9BFD32DF23C6@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: tfjellstrom@shaw.ca
In-Reply-To: <200908171328.08301.tfjellstrom@shaw.ca>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: KWorld UB435-Q support?
Date: Mon, 17 Aug 2009 20:42:29 -0400
References: <200908122253.12021.tfjellstrom@shaw.ca> <200908140903.29582.tfjellstrom@shaw.ca> <84CB1AA0-2C5D-4326-9240-11A38FC582DC@wilsonet.com> <200908171328.08301.tfjellstrom@shaw.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Aug 17, 2009, at 3:28 PM, Thomas Fjellstrom wrote:

> Yeah, I've had absolutely no luck with it so far, and have returned  
> it :(
> given your experience, and mine combined, I don't think its worth  
> the time to
> fix it. Especially since I can't even tune a channel on the darn  
> thing in any
> OS I have access to.

Now, did you try it with some other OS before trying it under Linux,  
and it failed to work, or did you only try other OS after trying under  
Linux w/that tree? There's some concern that perhaps the stick might  
be getting neutered on the Linux side by an incorrect gpio setting or  
something... But my stick worked (flaky usb connection aside) for  
quite some time before it stopped working, even with lots of  
unplugging and replugging over several days while working on the  
driver...

> It did indeed have trouble keeping a connection, but when ever it lost
> connection, I got that message. And the driver is pretty much stuck.  
> can't
> rmmod it, and it won't redetect the stick, so every single time it  
> looses
> connection, I have to reboot. Hardly a good way to work.

Indeed. I wonder if there are bad solder joints in these, or what?...  
Mine's dead, yours is dead, Mike Krufky had to RMA his first one and  
his second one seems it might be dead too... :\

-- 
Jarod Wilson
jarod@wilsonet.com




