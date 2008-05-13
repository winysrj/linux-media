Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from walker.ipnetwork.de ([83.246.120.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <admin@ipnetwork.de>) id 1JvvkO-0004uG-Fc
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 16:45:19 +0200
Received: from [10.0.1.199] (intra.tal.de [81.92.5.72]) (authenticated bits=0)
	by walker.ipnetwork.de (8.13.8/8.13.8/Debian-3) with ESMTP id
	m4DEf4l8013879
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Tue, 13 May 2008 16:41:16 +0200
Message-ID: <4829A87C.8080205@ipnetwork.de>
Date: Tue, 13 May 2008 16:41:00 +0200
From: Ingo Peukes <admin@ipnetwork.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <43276.192.168.9.10.1192357983.squirrel@ncircle.nullnet.fi>
	<20071018181040.GA6960@dose.home.local>
	<20071018182940.GA7317@dose.home.local>
	<20071018201418.GA16574@dose.home.local>
	<47075.192.168.9.10.1193248379.squirrel@ncircle.nullnet.fi>
	<472A0CC2.8040509@free.fr> <480F9062.6000700@free.fr>
	<16781.192.100.124.220.1209712634.squirrel@ncircle.nullnet.fi>
	<481B4A78.8090305@free.fr>
	<30354.192.100.124.220.1209969477.squirrel@ncircle.nullnet.fi>
	<481F66B0.4090302@free.fr> <482366CA.7050204@ipnetwork.de>
	<38941.192.168.9.10.1210617136.squirrel@ncircle.nullnet.fi>
In-Reply-To: <38941.192.168.9.10.1210617136.squirrel@ncircle.nullnet.fi>
Subject: Re: [linux-dvb] Testers wanted for alternative version of Terratec
 Cinergy T2 driver
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

Tomi Orava wrote:
> Hi,
> 
> 
>> Well, as I said it compiles and works with the above kernel and v4l-dvb
>> but w_scan finds no channels with this module most of the time. In 5
>> runs it found 4 channels on one multiplex.
>> I doubt it's the antenna although it's the stock one but if I use the
>> cinergyT2 on my desktop pc with the original module of kernel 2.6.25.1
>> w_scan finds all available channels all the time with the same antenna
>> in the same place. I will try a better antenna tomorrow to see if I can
>> use it somewhat productive in mythtv...
> 
> Does the "regular" scandvb work any better for you compared
> to the older driver ?
No, not realy. It find's and tunes only half of the channels available at my location.

> BTW. Where's the source for this w_scan so that I could try it as well ?
You find it here, at the bottom of the page: http://wirbel.htpc-forum.de/w_scan/index2.html
If I supply the parameter -t 3 to w_scan scan which sets the tuning timeout to 'slow' the card
finds almost all channels all the time...

> 
> Regards,
> Tomi Orava
Got a better Antenna today, will try it later.

Greetings,
Ingo Peukes

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
