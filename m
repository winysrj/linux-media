Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp6-g19.free.fr ([212.27.42.36])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.merle@free.fr>) id 1K9mUw-0005Db-7c
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 21:42:15 +0200
Message-ID: <485C0886.5070606@free.fr>
Date: Fri, 20 Jun 2008 21:44:06 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>,
	Tomi Orava <tomimo@ncircle.nullnet.fi>,
	linux-dvb@linuxtv.org, Tino Keitel <tino.keitel@tikei.de>,
	Ingo Peukes <admin@ipnetwork.de>
References: <472A0CC2.8040509@free.fr>
	<480F9062.6000700@free.fr>	<16781.192.100.124.220.1209712634.squirrel@ncircle.nullnet.fi>	<481B4A78.8090305@free.fr>	<30354.192.100.124.220.1209969477.squirrel@ncircle.nullnet.fi>	<481F66B0.4090302@free.fr>
	<4821F9A9.6030304@ncircle.nullnet.fi>	<48236E1F.5080300@free.fr>	<60450.192.168.9.10.1210618180.squirrel@ncircle.nullnet.fi>	<Pine.LNX.4.64.0805122100590.7907@pub3.ifh.de>
	<20080616152430.GA9995@dose.home.local>
In-Reply-To: <20080616152430.GA9995@dose.home.local>
Subject: Re: [linux-dvb] Testers wanted for alternative version of	Terratec
 Cinergy T2 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi all,
Tino Keitel a =E9crit :
> On Mon, May 12, 2008 at 21:05:40 +0200, Patrick Boettcher wrote:
>
> [...]
>
>   =

>> Trent Piepo was suggesting a solution, but no one ever had time to solve =

>> this problem. In fast this is only a propblem for developers, not so muc=
h =

>> for the average users as he is not unloading the module usually.
>>     =

>
> I unload the module at each suspend and reload it at resume. I did this
> with the old driver, because it was not suspend-proof, and I think I
> continued to do so because I had suspend/resume problems with the new
> driver.
>
> I'll re-check if the current driver still causes problems with suspend.
>
> Regards,
> Tino
>   =

To follow easily the state of this patch and keep track on it, I put it
in a hg repo:
http://linuxtv.org/hg/~tmerle/cinergyT2
And to sum-up, 3 issues:
- possible lirc issue
    http://article.gmane.org/gmane.linux.drivers.dvb/37865
   But I am not sure this is a problem, just a lack in lirc conf.
- possible dvb-t tuning issue
    http://article.gmane.org/gmane.linux.drivers.dvb/41632
   To be confirmed
- rmmod: driver count is not well managed, dvb-usb framework issue
   This prevents the ability to remove drivers that do not support
suspend before passing in suspend mode.

Cheers,
Thierry

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
