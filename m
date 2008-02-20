Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hyatt.suomi.net ([82.128.152.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JRoNq-0007hf-AP
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 13:49:10 +0100
Received: from tiku.suomi.net ([82.128.154.67])
	by hyatt.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0JWJ0094PFL0SX00@hyatt.suomi.net> for
	linux-dvb@linuxtv.org; Wed, 20 Feb 2008 14:48:36 +0200 (EET)
Received: from spam5.suomi.net (spam5.suomi.net [212.50.131.165])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0JWJ00J7BFL0APB0@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Wed, 20 Feb 2008 14:48:36 +0200 (EET)
Date: Wed, 20 Feb 2008 14:48:09 +0200
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <ea4209750802181530p7bd2ec78j562e7fdf281890b5@mail.gmail.com>
To: Albert Comerma <albert.comerma@gmail.com>
Message-id: <47BC2189.8070308@iki.fi>
MIME-version: 1.0
References: <ea4209750801161224p6b75d7fanbdcd29e7d367802d@mail.gmail.com>
	<47B9D533.7050504@iki.fi>
	<ea4209750802181306tcc8c98clff330d4289523d96@mail.gmail.com>
	<47BA011D.9060003@iki.fi>
	<ea4209750802181424q4ac90c7ag33ad8b8d79e258fd@mail.gmail.com>
	<47BA0C4D.4070102@iki.fi>
	<ea4209750802181530p7bd2ec78j562e7fdf281890b5@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Yuan EC372S (STK7700D based device)
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

Albert Comerma wrote:
> It seems ok. Could you test a scan with kaffeine instead of looking for 
> a specific location? And if you do so it reports signal strenght?

Kaffeine reports 100% signal strength. There must be some setting wrong 
in the driver. Tuner locks to the correct frequency but signal from 
uner to demodulator could be wrong and thats why PID-filter timeouts.

Even bad, I cannot snoop it in windows because I did not find all the 
required Windows XP drivers for my brand new laptop. Laptop is only 
computer I have ExpressCard slot...

> By the way, what does it mean moi and moikka? Hello in finish?
yes :)

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
