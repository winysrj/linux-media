Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from core.devicen.de ([62.159.186.206])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <l.lacher@abian.de>) id 1KAUhD-0002FU-Rk
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 20:53:52 +0200
Received: from [10.71.67.13] ([10.71.67.13])
	by core.devicen.de (8.13.1/8.13.1/DEVICE/N GmbH 20070903) with ESMTP id
	m5MIr7ul032329
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 20:53:08 +0200
From: Lutz Lacher <l.lacher@abian.de>
To: linux-dvb@linuxtv.org
Date: Sun, 22 Jun 2008 20:53:00 +0200
References: <200806220300.51879.l.lacher@abian.de>
	<200806221035.50028.l.lacher@abian.de>
	<20080622140100.f841c5a2.SiestaGomez@web.de>
In-Reply-To: <20080622140100.f841c5a2.SiestaGomez@web.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806222053.00555.l.lacher@abian.de>
Subject: Re: [linux-dvb] dvb_usb_dib0700 and Remote Control DSR-0112
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

Hi Martin,

i just recompiled the drivers with your patch applied, changed the device in 
lircd to /dev/input/by-path/pci-2-1--event-ir as suggested and with your lirc 
conf it's working now. 

Thank you very much for your instant help, i appreciate it very much.
Again, thank you,
Lutz

-----Original Message-----
> Hi,
>
> its better to always use directly the
> /dev/input/by-path/pci-2-1--event-ir
> device because the event interface could change the next time you plug it
> in or when using another new input device.
>
> The get the remote work you need to apply the attached patch.
> Also attached you find a lirc config which works fine here.
>
> Best regards,
> Martin

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
