Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smeagol.cambrium.nl ([217.19.16.145] ident=qmailr)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1JV6aw-0005QE-7q
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 15:52:18 +0100
Received: from [192.168.1.70] (ashley.powercraft.nl [84.245.7.46])
	by ashley.powercraft.nl (Postfix) with ESMTP id 4AB8E1CC6F
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 15:52:14 +0100 (CET)
Message-ID: <47C81C1E.5080400@powercraft.nl>
Date: Fri, 29 Feb 2008 15:52:14 +0100
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] how can I create a czap config file without an sample
 config file for my environment
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

Hello all,

I wanted to create the channel config files for my environment, but 
there is no scan example configuration that works for my environment, I 
do have the websites with tabels of the frequencys. How do i create my 
channel.conf ....

sudo apt-get install dvb-utils

# dvb-c channels:
firefox http://www.upc.nl/frequencies_gm.php?GM=0493 &

# dvb-t channels:
firefox http://www.digitenne.nl/pagina_49.html &

# make directorys to store channel configurations
mkdir --verbose ~/.{t,c}zap

scan --help
sudo scan -A 1/usr/share/doc/dvb-utils/examples/scan/dvb-t/..... > 
~/.tzap/channels.conf
sudo scan -A 2 /usr/share/doc/dvb-utils/examples/scan/dvb-c/.... > 
~/.czap/channels.conf

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
