Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n62.bullet.mail.sp1.yahoo.com ([98.136.44.35])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KdGpN-000647-F5
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 05:57:15 +0200
Date: Tue, 9 Sep 2008 20:56:38 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Patrick Boisvenue <patrbois@magma.ca>, Steven Toth <stoth@linuxtv.org>
In-Reply-To: <48C732DE.2030902@linuxtv.org>
MIME-Version: 1.0
Message-ID: <87793.24376.qm@web46108.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1500Q eeprom not being parsed correctly
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

--- On Wed, 9/10/08, Steven Toth <stoth@linuxtv.org> wrote:

>  > kobject_add_internal failed for i2c-2 with -EEXIST, don't try to
>  > register things with the same name in the same directory.
> 
> Ooh, that's nasty problem, this is new - and looks like
> it's i2c related.
> 
> Why does this sound familiar? Anyone?

It's probably completely unrelated, but I see this (apparently
harmless) similar message when I boot from my stock 2.6.18-ish
snapshot kernel.

Actual dmesg there being
Jun 29 01:22:19 localhost kernel: [   75.960000] kobject_add failed for usbdev4.3_ep81 with -EEXIST, don't try to register things with the same name in the same directory.


Maybe that's why it's familiar; maybe I'm just wasting valuable
e-mail.  I dunno.  It sure freaked me out then (in spite of
not adversely affecting anything).

Anyway, ignore this message.
thanks.
barry.  bouwsma.


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
