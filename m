Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett2@onetel.com>) id 1JXniy-0000qn-UF
	for linux-dvb@linuxtv.org; Sat, 08 Mar 2008 02:19:45 +0100
Message-Id: <B410CC02-9890-415C-AF0E-C187AF72D05B@onetel.com>
From: Tim Hewett <tghewett2@onetel.com>
To: simeonov_2000@yahoo.com
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sat, 8 Mar 2008 01:18:43 +0000
Cc: Tim Hewett <tghewett2@onetel.com>, linux-dvb@linuxtv.org
Subject: [linux-dvb] VP 1041: Is anybody able to tune to DVBS2 or DSS?
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

Yes, I have the Skystar HD2 tuning to DVB-S2 transponders using the  
replacement szap.c mentioned on the wiki page, then listing the  
channels using 'scan -c -a <n>' to prove proper reception, all using  
the current mantis tree. No hacks were needed, it works out of the box  
every time now that the mantis tree has been updated to support the  
HD2 card (same one as the VP-1041).

If you are using a Diseqc switch then get rid of it for now, mine was  
causing lots of unreliability. I tried three different types of Diseqc  
switch, all were the same. Got rid of them then it all started working.

Tim.

> Hi, I am curious to find out if anybody is able to use Twinhan/ 
> Azurware VP-1041 with the mantis drivers to tune to standards other  
> than DVBS - DVBS2 and DSS? Thanks, Simeon

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
