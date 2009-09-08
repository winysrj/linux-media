Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:40559 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZIHQYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Sep 2009 12:24:39 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KPN00F5YUX4NMT0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 08 Sep 2009 12:24:41 -0400 (EDT)
Date: Tue, 08 Sep 2009 12:24:40 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] cx25840: fix determining the
 firmware name
In-reply-to: <1252377042.321.57.camel@morgan.walls.org>
To: Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Hans Verkuil via Mercurial <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-id: <4AA68548.2000508@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <E1MiTfS-0001LQ-SU@mail.linuxtv.org>
 <37219a840909041105u7fe714aala56893566d93cdc3@mail.gmail.com>
 <20090907021002.2f4d3a57@caramujo.chehab.org>
 <37219a840909062220p3ae71dc0t4df96fd140c5c7b4@mail.gmail.com>
 <20090907030652.04e2d2a3@caramujo.chehab.org>
 <1252340384.3146.52.camel@palomino.walls.org>
 <37219a840909070925k25ed146bn9c3725596c9490b9@mail.gmail.com>
 <20090907183632.195dc3e5@caramujo.chehab.org>
 <37219a840909071521j67e9c3d6h1e9b2e1a8ded45cd@mail.gmail.com>
 <20090907194007.37c222cc@caramujo.chehab.org>
 <303a8ee30909071822jfa6c932i41f3dc3a97684b2c@mail.gmail.com>
 <1252377042.321.57.camel@morgan.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> What is the exact benefit we're after here by making things common
> between all these cores?  Code reuse is not a benefit, if it leads to
> more expensive maintenance.

We'll, it diverged for the 23885 because the register addressed change for some 
registers, it's not the same part. Certainly for the video decoder, not 
necessarily for the audio encoder.

I know Andy knows this, I'm just pointing it out for the record.

This, coupled with the 'don't screw up other boards' approach leads to a unified 
driver, not so much internally.

The 25840 driver does 'just enough' to get by, Andy has taken it to the next 
level and done the stuff that I should have done for the cx23885 merge (although 
I did 'just enough' to get by).

The notion of flexible clocks pays big dividends thanks to Andy, but is largely 
a positive change that falls outside of this discussion topic (firmware filename).

>
> I had considered moving the cx18-av code from the cx18 module into the
> cx25840 module, but could never find a reason to undertake all the work.
> Memory footprint isn't a good reason: desktop PC memory is cheap and
> embedded systems would likely only use one type of card anyway.  The
> return on investment seems like it would be less than 0.

Hmm. You should check out the cx23102 driver, whole crap, massive cx25840 
overlap, massive superset in terms of functionality.

>
> OK.  I'm done ranting...

A great pity, you were getting me fired up along the same train of thought :)

Andy, you have the support and full access to the resources of KernelLabs if you 
need help (directly or indirectly) with regression testing. Your work is very 
positive and a much needed overhaul.

Mauro, my pitch: Let's leave the firmwares unique for the time being, which 
indeed they are. So, leave the firmware detection code as is, it's working for 
everyone. Let's rethink this discussion after Andy's massive patch series. It 
sounds like the cx25840 driver is 'getting a new owner' and we'll look at the 
driver differently once the overhaul is complete.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
