Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xdsl-83-150-88-111.nebulazone.fi ([83.150.88.111]
	helo=ncircle.nullnet.fi) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tomimo@ncircle.nullnet.fi>) id 1Jvrji-0002BZ-Ko
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 12:27:59 +0200
Message-ID: <35894.192.100.124.218.1210674472.squirrel@ncircle.nullnet.fi>
In-Reply-To: <48222B54.3030601@iki.fi>
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
	<48222B54.3030601@iki.fi>
Date: Tue, 13 May 2008 13:27:52 +0300 (EEST)
From: "Tomi Orava" <tomimo@ncircle.nullnet.fi>
To: "Antti Palosaari" <crope@iki.fi>
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


Hi,

> I looked through your driver and here is some comments raised up.
>
> - why cinergyt2_cmd, why not dvb_usb_generic_rw ?
> - USB IDs are usually defined in own file dvb-usb-ids.h
> - remote control code seems quite complex and long, maybe there is
> easier way?

Ok, as you may have noticed, the latest version of the patch
has been cleaned so that it now uses the dvb_usb_generic_rw instead
of its own version and Thierry Merle sent a patch that removed the
private version of remote control code and converted Cinergy T2
driver to use the generic one. I'll still need to remember to insert
the USB ID of the card into the dvb-usb-ids.h instead as requested.

Now what is needed is some good testing to make sure that the
driver still works properly, especially if no structural changes
are required.

The current patch has been posted to the mailing list on monday 12.05.08
under the subject: "Re: [linux-dvb] Testers wanted for alternative version
of Terratec Cinergy T2 driver"

Regards,
Tomi Orava

-- 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
