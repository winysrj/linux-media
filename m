Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JV1Wg-0005dK-88
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 10:27:34 +0100
Received: from berkeloid.vlook.shikadi.net ([192.168.4.11])
	by vitalin.sorra.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JV1Wa-0002mK-13
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 19:27:28 +1000
Received: from korath.teln.shikadi.net ([192.168.0.14])
	by berkeloid.teln.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JV1WX-0006Zv-3G
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 19:27:25 +1000
Message-ID: <47C7CFFD.1020600@shikadi.net>
Date: Fri, 29 Feb 2008 19:27:25 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <1204233917.22520.12.camel@youkaida>
In-Reply-To: <1204233917.22520.12.camel@youkaida>
Subject: Re: [linux-dvb] [OT] UHF masthead amp power supply location
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

> This this OT, but I don't really know where to ask. And after all, the
> odds are that I will find a person with that sort of knowledge here.

Perhaps a satellite TV forum, if you don't get any good replies here.

> Option A - This is the easiest for me to achieve, but the position of
> the power supply worries me.
> 
> Option B - I'm confident that this is technically sound, except that the
> necessary physical location of the power supply in this case has no
> power plug nearby...
> 
> My question is: can Option A fly?

I'm no expert, but I think with Option A you'd have problems trying to
send 12V and 13/18V over the same line.  I don't know how the power
distributed, but is it possible to run the masthead amp from the 13V
supplied by the sat tuner?  As long as it doesn't choke on 18V (and the
sat combiner doesn't block the voltage) that might be an option.

Of course if each power supply increases the voltage (so putting in 12V
and 13V means you actually have 25V on the cable for a while) then it
might work, but I don't think that's how it's done (or if it is, I don't
think the sat combiner would strip out the 13/18V and leave 12V on the
line for the masthead amp to use.)

I don't know whether the power is sent as DC or AC, but if your masthead
amp runs on roughly the same power as the sat tuner puts out, you might
be able to do away with the masthead amp altogether, assuming the sat
tuner still puts out power when you're not watching a sat channel.

Again - I'm no expert!

Cheers,
Adam.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
