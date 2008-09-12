Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n71.bullet.mail.sp1.yahoo.com ([98.136.44.36])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1Ke9nX-0001h1-7S
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 16:39:00 +0200
Date: Fri, 12 Sep 2008 07:38:23 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Steven Toth <stoth@linuxtv.org>
In-Reply-To: <48CA78FD.1020600@linuxtv.org>
MIME-Version: 1.0
Message-ID: <436186.89856.qm@web46114.mail.sp1.yahoo.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Siano ISDB [was: Re: S2API - Status - Thu Sep 11th]
Reply-To: free_beer_for_all@yahoo.com
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

--- On Fri, 9/12/08, Steven Toth <stoth@linuxtv.org> wrote:

> The delivery system is present in the tuning cache. Demod drivers who 
> need these advanced features can check the required delivery type 
> (c->delivery_system) and decide to load the appropriate firmware to 
> satisfy the users needs.

Sweet.  Neat to see how code can be used in practice,
when I haven't the faintest idea how it should be used
when reading it.


> That _should_ work today, but the firmware reload in the siano demod was 
> added late in the evening (thanks mkrufky) so any bugs need to be shaken 

My only concern, and I hope it's not, 'cuz I can't read
code worth beans, is the time when the device gets the
new firmware, disconnects, and reconnects, that nothing
untoward should happen in this time.  But then, I'm only
eyeballing what happens during asynchronous `insmod'
with non-S2API.  Gosh -- what if mode=3 for which my
device has no firmware is selected, and the device
reappears as a generic USB device?

Probably I need not worry.

Carry On Coding.


thanks,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
