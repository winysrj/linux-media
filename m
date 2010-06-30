Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <mo.ucina@gmail.com>) id 1OTw5i-000515-4a
	for linux-dvb@linuxtv.org; Wed, 30 Jun 2010 14:08:36 +0200
Received: from mail-pw0-f54.google.com ([209.85.160.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OTw5h-0000MT-3t; Wed, 30 Jun 2010 14:08:33 +0200
Received: by pwi3 with SMTP id 3so323316pwi.41
	for <linux-dvb@linuxtv.org>; Wed, 30 Jun 2010 05:08:27 -0700 (PDT)
Message-ID: <4C2B33B6.90408@gmail.com>
Date: Wed, 30 Jun 2010 22:08:22 +1000
From: O&M Ugarcina <mo.ucina@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TeVii S470 in mythtv  - diseqc problems
Reply-To: linux-media@vger.kernel.org, mo.ucina@gmail.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello Guys,

Just installed a S470 into my mythbox , fedora 12 kernel 
2.6.32.14-127.fc12.i686.PAE . Myth is .23 the most recent fedora package 
, the drivers for dvb card I have at the moment were pulled in 
2010-04-01 . I assume they are pretty current . The problem that I have 
is as follows :
Most of my viewing is done on a Satellite connected to diseqc port 2 , 
and myth tunes into that with no probs at all , but occasionally I try 
to watch a channel that is on a second satellite - port 1 and here 
things fail . Myth tries to tune into the channel - then times out with 
error , during this the dvb driver crashes , and when I try to retune 
again with myth there is no lock on either satellite  . So I need to 
restart pc , then everything comes back on port 2 and myth is able to 
tune again channels within that first satellite . Any one else 
experienced diseqc issues with this card and myth ?

Second question what is the tool of choice to use to scan dvbs2 
satellites ? I tried dvbscan but it only picked up dvbs transponders , 
on dvbs2 it failed to tune . I saw that there used to be this utillity 
scan-s2 , but looks like it was abandoned a couple of years ago and has 
not been maintained since . So how do you guys do a transponder scan for 
dvbs2 ?

Best Regards

Milorad



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
