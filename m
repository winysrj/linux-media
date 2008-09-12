Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Ke9PE-0008Sj-I2
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 16:13:53 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7300I6A665H9A0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 12 Sep 2008 10:13:18 -0400 (EDT)
Date: Fri, 12 Sep 2008 10:13:17 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <130284.93148.qm@web46107.mail.sp1.yahoo.com>
To: free_beer_for_all@yahoo.com
Message-id: <48CA78FD.1020600@linuxtv.org>
MIME-version: 1.0
References: <130284.93148.qm@web46107.mail.sp1.yahoo.com>
Cc: Steven Toth <stoth@hauppauge.com>, linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Siano ISDB [was: Re: S2API - Status - Thu Sep 11th]
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

barry bouwsma wrote:
> --- On Fri, 9/12/08, Steven Toth <stoth@hauppauge.com> wrote:
> 
>>> module parameter `default_mode=5' or =6,
>>>   
>> Correct, that tree expects a module option to load the firmware, you 
>> might want to check this code snippet in the other tree.  The other 
>> detects the delivery system and reloads the firmware on the fly.
> 
> Hey, no fair, I think you're answering questions I'm about
> to ask before I can send them!

:)

> 
> Oh heck, here's what I wrote a short while ago, just in case...
> 
>  =-=#=-=#=-=
> 
> In looking at the S2API code for the Siano chipsets, I had
> a question which I couldn't answer by reading the code.
> 
> At present, my card supports DVB-T by default, and I can
> load a different firmware to get it to (potentially) support
> alternatives, say, DVB-H.
> 
> The answer might be blindingly obvious, but I don't see if
> this card has the capability of saying, okay, I can give
> you DVB-T, or DVB-H, or DAB, or T-DMB...  Right now, I spit
> DVB-T.  Then an application wanting DVB-H would then be able
> to initiate a reload of the firmware, and the device would
> reappear as a DVB-H device.
> 
> The ability to do this firmware switch seems to be present
> within the driver, but I'm wondering if the S2API, or indeed
> the present APIs, can handle a case like this.

The delivery system is present in the tuning cache. Demod drivers who 
need these advanced features can check the required delivery type 
(c->delivery_system) and decide to load the appropriate firmware to 
satisfy the users needs.

That _should_ work today, but the firmware reload in the siano demod was 
added late in the evening (thanks mkrufky) so any bugs need to be shaken 
out of the demod driver. Prior to this we were only testing the isdb-t 
portion.

What's missing now in tune.c is the GET_PROPERTY example code to show 
what delivery systems and modulations types these new drivers can support.

> 
> I know that `mplayer' will grab the first available device
> of the appropriate standard, while my other applications
> pick a fixed adapter number (or more correctly, device by
> product).  But I can see myself wanting to make both DVB-T
> and DAB (eventually) use of this one device, without the
> bother of reloading the kernel module to switch.
> 
> I did spend the night looking at the old API, and remember
> virtually none of it, and the discussion of multifrontend
> devices and what they mean has made me wonder about this...


Regards,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
