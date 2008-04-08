Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dc2rpt@gmx.de>) id 1JjIqg-00015X-1I
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 20:47:14 +0200
From: Thomas Pinz <dc2rpt@gmx.de>
To: linux-dvb@linuxtv.org
Date: Tue, 8 Apr 2008 20:46:38 +0200
References: <79f9d6350804081125h5a480222gd33c5b44a6630204@mail.gmail.com>
In-Reply-To: <79f9d6350804081125h5a480222gd33c5b44a6630204@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804082046.38363.dc2rpt@gmx.de>
Cc: Paolo Pettinato <p.pettinato@gmail.com>
Subject: Re: [linux-dvb] Help with unsupported DVB-T usb stick (CE6230)
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

Hi Paolo, 

On Tuesday 08 April 2008, Paolo Pettinato wrote:
> The vendorid:productid codes are 8086:9500. On "Device Manager" it is
> listed as "CE6230 Standalone Driver (BDA)". On its properties, it says
> that it's manufactured by Realfine Ltd and is on Location 0
> (CE9500B1).

CE6230 is a demodulator of Intel 
(http://www.intel.com/design/celect/demodulators/ce6230.htm) . Its seems to 
be a successor of the Zarlink MT352/MT353 (Intel bought Zarlink some time 
ago). 

So you should have a look on the 352/353 drivers, maybe there are some 
parallels. 

What tuner is inside ? 

Kind regards, 

Thomas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
