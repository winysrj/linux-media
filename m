Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <korgull@home.nl>) id 1KKyCr-0001yn-8d
	for linux-dvb@linuxtv.org; Mon, 21 Jul 2008 18:25:52 +0200
Received: from [213.51.146.190] (port=41652 helo=smtp1.tilbu1.nb.home.nl)
	by smtpq2.tilbu1.nb.home.nl with esmtp (Exim 4.60)
	(envelope-from <korgull@home.nl>) id 1KKyCn-0003ON-Ly
	for linux-dvb@linuxtv.org; Mon, 21 Jul 2008 18:25:45 +0200
Received: from cp31197-b.landg1.lb.home.nl ([84.25.119.9]:62984
	helo=[192.168.0.4]) by smtp1.tilbu1.nb.home.nl with esmtp (Exim 4.60)
	(envelope-from <korgull@home.nl>) id 1KKyCn-0004RN-EF
	for linux-dvb@linuxtv.org; Mon, 21 Jul 2008 18:25:45 +0200
From: Marcel Janssen <korgull@home.nl>
To: linux-dvb@linuxtv.org
Date: Mon, 21 Jul 2008 18:25:34 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807211825.34660.korgull@home.nl>
Subject: [linux-dvb] KNC DVB-C card using kernel 2.6.25
Reply-To: korgull@home.nl
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

Yesterday I've updated my Fedora8 mythtv box to the 2.6.25 kernel and since, 
my DVB-C card doesn't work any more. When switching back to kernel 2.6.24 it 
works well, so I expect something wrong with the drivers in kernel 2.6.25.

The drivers get inserted and I do see this in dmesg :
saa7146: register extension 'budget dvb'.
saa7146: register extension 'budget_av'.

But, that's about all I see. There are no devices created in /dev/dvb and I do 
see no other messages either in dmesg or /var/log/messages.

Any idea how to get my card working with this kernel ?

regards,
Marcel Janssen

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
