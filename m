Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from eazy.amigager.de ([213.239.192.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tino@tikei.de>) id 1K8GZQ-0003Sd-BQ
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 17:24:36 +0200
Date: Mon, 16 Jun 2008 17:24:30 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Message-ID: <20080616152430.GA9995@dose.home.local>
References: <472A0CC2.8040509@free.fr> <480F9062.6000700@free.fr>
	<16781.192.100.124.220.1209712634.squirrel@ncircle.nullnet.fi>
	<481B4A78.8090305@free.fr>
	<30354.192.100.124.220.1209969477.squirrel@ncircle.nullnet.fi>
	<481F66B0.4090302@free.fr> <4821F9A9.6030304@ncircle.nullnet.fi>
	<48236E1F.5080300@free.fr>
	<60450.192.168.9.10.1210618180.squirrel@ncircle.nullnet.fi>
	<Pine.LNX.4.64.0805122100590.7907@pub3.ifh.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805122100590.7907@pub3.ifh.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Testers wanted for alternative version of
	Terratec	Cinergy T2 driver
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

On Mon, May 12, 2008 at 21:05:40 +0200, Patrick Boettcher wrote:

[...]

> Trent Piepo was suggesting a solution, but no one ever had time to solve 
> this problem. In fast this is only a propblem for developers, not so much 
> for the average users as he is not unloading the module usually.

I unload the module at each suspend and reload it at resume. I did this
with the old driver, because it was not suspend-proof, and I think I
continued to do so because I had suspend/resume problems with the new
driver.

I'll re-check if the current driver still causes problems with suspend.

Regards,
Tino

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
