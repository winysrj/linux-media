Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett2@onetel.com>) id 1JkIln-0006lh-Km
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 14:54:20 +0200
Message-Id: <665E5397-D516-4E6B-B989-4A631FB9C25E@onetel.com>
From: Tim Hewett <tghewett2@onetel.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Fri, 11 Apr 2008 13:52:31 +0100
Cc: Tim Hewett <tghewett2@onetel.com>
Subject: [linux-dvb] Updated copy of dvbstream to support DVB-S2
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

I have updated my (enhanced) source of dvbstream to allow it to work  
with DVB-S2 transponders for Mantis DVB-S/DVB-S2 cards, you can get it  
from here:

http://www.coolatoola.com/dvbstream.multiproto.tgz

It may also work with other DVB-S2 cards.

There is a new command line option '-ds' ("Delivery System") which  
takes 'DVBS' or 'DVBS2' as options. All other tuning parameters  
operate as before. The changes have been tested using a Technisat  
SkyStar HD2 PCI card with the current mantis tree ('hg clone http://jusst.de/hg/mantis') 
.

The source includes many other features I have added for my own use  
over the years, e.g. using the device name as shown by dmesg rather  
than card number to specify the DVB device (useful when device numbers  
change with each reboot), so you can replace the card number with -c  
'STB0899 Multistandard'. If you have several devices of the same type,  
you can specify one by appending :0, :1, :2 etc. at the end of the  
device name.

You can also specify the channel to record using the channel name (as  
shown by scan -c) rather than pids, which helps to cope with  
broadcasters changing their pids, add the parameter -C 'channel name'  
and the associated pids will be found. You can still specify the pids  
and these will be used instead if the channel name cannot be found.  
This uses source taken from the scan utility in linux-dvb-apps.

It can also set the system clock from a tuned transponder, use -d.  
This uses source taken from the dvbdate utility in linux-dvb-apps.

It will take exclusive control of the device, to avoid two processes  
competing for the same device.

So far it only is known to work reliably with the Technisat SkyStar  
HD2 PCI card but should also work with the Twinhan VP-1041/Azurewave  
AD SP400.

Note that I am sharing this software which I have developed and tested  
only for my own purposes, and since I don't use all features of  
dvbstream I can't say whether or not any features have been damaged by  
my work.

Tim.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
