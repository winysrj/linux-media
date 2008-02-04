Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp102.rog.mail.re2.yahoo.com ([206.190.36.80])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <CityK@rogers.com>) id 1JM3qX-0000ad-P0
	for linux-dvb@linuxtv.org; Mon, 04 Feb 2008 17:07:02 +0100
Message-ID: <47A73800.8000909@rogers.com>
Date: Mon, 04 Feb 2008 11:06:24 -0500
From: CityK <CityK@rogers.com>
MIME-Version: 1.0
To: ashim saikia <ar.saikia@yahoo.com>
References: <638226.79716.qm@web57814.mail.re3.yahoo.com>
In-Reply-To: <638226.79716.qm@web57814.mail.re3.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hi
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

ashim saikia wrote:
> Hi,
> I just wanna know if in linux 2.6 kernel, DVB driver
> will support more than 4 cards or not. Can any one
> help me.

Its not a question of cards/devices, its a question of the number of 
adapters...which is currently set at 8 (see dvbdev.c for the 
max_adapters define). Example, a usb device with dual receivers means 
only 4 such devices would be supported ... if you desire more, change 
the define and recompile the drivers.

Note that "support for x number of adapters" is also somewhat dependant 
on the software you use -- though I'd expect that most would be 
respective of the above, you still should check the application to see 
if it has any further restrictions.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
