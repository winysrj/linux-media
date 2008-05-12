Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JvdLn-0002rD-CU
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 21:06:20 +0200
Date: Mon, 12 May 2008 21:05:40 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Tomi Orava <tomimo@ncircle.nullnet.fi>
In-Reply-To: <60450.192.168.9.10.1210618180.squirrel@ncircle.nullnet.fi>
Message-ID: <Pine.LNX.4.64.0805122100590.7907@pub3.ifh.de>
References: <43276.192.168.9.10.1192357983.squirrel@ncircle.nullnet.fi>    
	<20071018181040.GA6960@dose.home.local>
	<20071018182940.GA7317@dose.home.local>
	<20071018201418.GA16574@dose.home.local>    
	<47075.192.168.9.10.1193248379.squirrel@ncircle.nullnet.fi>    
	<472A0CC2.8040509@free.fr> <480F9062.6000700@free.fr>    
	<16781.192.100.124.220.1209712634.squirrel@ncircle.nullnet.fi>    
	<481B4A78.8090305@free.fr>
	<30354.192.100.124.220.1209969477.squirrel@ncircle.nullnet.fi>
	<481F66B0.4090302@free.fr> <4821F9A9.6030304@ncircle.nullnet.fi>    
	<48236E1F.5080300@free.fr>
	<60450.192.168.9.10.1210618180.squirrel@ncircle.nullnet.fi>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

Hi all,

On Mon, 12 May 2008, Tomi Orava wrote:
> In my understanding this is a bug in the dvb-usb-framework that cannot
> be fixed in Cinergy T2 driver. I checked that if you DON'T define the
> menuconfig option:
>
> "Load and attach frontend and tuner driver modules as needed" ie.
> the CONFIG_MEDIA_ATTACH
>
> The framework will use a different version of the function called
> "dvb_frontend_detach" and thefore it will not call the symbol_put_addr
> on linux/drivers/media/dvb/dvb-core/dvb_frontend.c line 1220.
> With this option deselected the module reference count seems to stay
> in sane values.

In fact any dvb-driver driver has this problem when it is not using a 
separate frontend-module, but using the module from "inside". (vp702x, 
gp8psk, vp7045, dtt200u)

dvb_frontend is decrementing the use_count when releasing the driver. 
dvb_attach is incrementing it, but you can only use dvb_attach on 
EXPORT_SYMBOL-functions.

Trent Piepo was suggesting a solution, but no one ever had time to solve 
this problem. In fast this is only a propblem for developers, not so much 
for the average users as he is not unloading the module usually.

thanks for your great work,
Patrick.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
