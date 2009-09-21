Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:53621 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbZIUNgk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 09:36:40 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KQB000YKPT6U1H0@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 21 Sep 2009 09:36:43 -0400 (EDT)
Date: Mon, 21 Sep 2009 09:36:41 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Preliminary working HVR-1850 IR hardware and grey Hauppauge RC-5
 remote
In-reply-to: <1253413236.13400.24.camel@morgan.walls.org>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org
Message-id: <4AB78169.5030800@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <1252297247.18025.8.camel@morgan.walls.org>
 <1252369138.2571.17.camel@morgan.walls.org>
 <1253413236.13400.24.camel@morgan.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/19/09 10:20 PM, Andy Walls wrote:
> Steve,
>
> I've finally have a working implementation of the the HVR-1850 IR
> receiver and the grey Hauppauge RC-5 remote with in kernel (non-LIRC) IR
> input to key press events.
>
> If you feel adventurous, give it a try for testing the IR receiver:
>
> http://www.linuxtv.org/hg/~awalls/cx23888-ir

Very nice, excellent work. Sorry, my weekend was crazy so I never managed to 
test your tree, even though I saw your email. Today and tomorrow won't be much 
better as I'll be preparing to head out to LPC.

A couple of things on my mind currently:

1. I'd like to test this asap and give you some feedback. This is a very welcome 
addition to the cx23885/25840 driver codebase. In reality this could be a week 
or so.

2. Once you have your patch-sets in order I'd like to pull those patches and do 
some HVR1850 analog encoder work. I have some small patches pending that should 
immediately allow me to start testing various aspects of analog. (Unrelated to 
your IR work but highly related to the fact you're fixed up the clocks inside 
the 25840 nicely).

3. Getting RC5 IR support on the existing HVR1800/HVR1250 would be _really_ nice 
and from the sound of it an incremental step built on the current work. I think 
from memory you only have HVR1600 and HVR1850 Hauppauge boards. Is this correct? 
I want to bring a couple of 'samples' to LPC for you.... Assuming you're 
interested. Let me know as my luggage space will be tight.

4. I'm hoping we'll sample a beer or two in Portland ;)

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
