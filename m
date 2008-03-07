Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay7.mail.ox.ac.uk ([129.67.1.167])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <John.Veness.myth@pelago.org.uk>) id 1JXkdb-0001M8-9z
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 23:01:59 +0100
Received: from smtp0.mail.ox.ac.uk ([129.67.1.205])
	by relay7.mail.ox.ac.uk with esmtp (Exim 4.68)
	(envelope-from <John.Veness.myth@pelago.org.uk>) id 1JXkdX-0005e6-O5
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 22:01:55 +0000
Received: from i-83-67-98-35.freedom2surf.net ([83.67.98.35]
	helo=[192.168.1.128])
	by smtp0.mail.ox.ac.uk with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <John.Veness.myth@pelago.org.uk>)
	id 1JXkdW-0001SN-2H
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 22:01:55 +0000
Message-ID: <47D1BB51.9060903@pelago.org.uk>
Date: Fri, 07 Mar 2008 22:01:53 +0000
From: John Veness <John.Veness.myth@pelago.org.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <e57cc13a0803070621w5063a126o2e13f571660468b5@mail.gmail.com>
In-Reply-To: <e57cc13a0803070621w5063a126o2e13f571660468b5@mail.gmail.com>
Subject: Re: [linux-dvb] Nova T-500 firmware download
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

pankaj patel wrote:
> Hello,
> 
>     I wonder if anyone can help me - I have had a working NOVA T-500 setup
> on Ubuntu Gutsy for some time now. However,
> ever since updating the v4l-dvb drivers yesterday, the cards have stopped
> working with "did not find the firmware file
> (dvb-usb-dib0700-1.10.fw)". Now this file exists in /lib/firmware and I have
> not been able to figure out why the dvb driver
> cannot find the file. I have set the debug option and here is the output :-
> 
> [ 5245.800255] check for cold 10b8 1e14
> [ 5245.800257] check for cold 10b8 1e78
> [ 5245.800258] check for cold 2040 7050
> [ 5245.800259] check for cold 2040 7060
> [ 5245.800261] check for cold 7ca a807
> [ 5245.800262] check for cold 7ca b808
> [ 5245.800263] check for cold 185b 1e78
> [ 5245.800264] check for cold 185b 1e80
> [ 5245.800265] check for cold 1584 6003
> [ 5245.800266] check for cold 413 6f00
> [ 5245.800268] check for cold 7ca b568
> [ 5245.800269] check for cold 1044 7001
> [ 5245.800270] something went very wrong, device was not found in current
> device list - let's see what comes next.
> [ 5245.800272] check for cold 2040 9941
> [ 5245.800273] check for cold 2040 9950
> [ 5245.800794] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold
> state, will try to load a firmware
> [ 5265.793345] dvb-usb: did not find the firmware file. (
> dvb-usb-dib0700-1.10.fw) Please see linux/Documentation/dvb/ for more
> details on firmware-problems. (-2)
> 
>   I have reverted to previous version of v4l-dvb and I still get the above
> error. Anyone have any tips on what else I should do ?

On my Ubuntu 7.10 system with WinTV Nova-TD stick, I've put the firmware 
in /lib/firmware/`uname -r`, i.e. 
/lib/firmware/2.6.22-14-generic/dvb-usb-dib0700-1.10.fw currently.

Cheers,

John

-- 
John Veness, MythTV user, UK, DVB-T

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
