Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt2.poste.it ([62.241.5.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1KoHNt-0008WV-GS
	for linux-dvb@linuxtv.org; Fri, 10 Oct 2008 14:46:23 +0200
Received: from geppetto.reilabs.com (212.123.91.176) by relay-pt2.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 48EE8D3E00006B86 for linux-dvb@linuxtv.org;
	Fri, 10 Oct 2008 14:46:16 +0200
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1KoHMw-0007yU-TP
	for linux-dvb@linuxtv.org; Fri, 10 Oct 2008 14:45:22 +0200
Date: Fri, 10 Oct 2008 14:45:22 +0200
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: linux-dvb Mailing List <linux-dvb@linuxtv.org>
Message-ID: <20081010124522.GA30145@geppetto>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Module modprobing problem
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

Hi all,

I'm trying the latest v4l-dvb mercurial and this is the output I get:

stefano@geppetto ~> sudo modprobe dib7000m -v
insmod /lib/modules/2.6.22-3-486/kernel/drivers/media/dvb/frontends/dibx000_common.ko 
WARNING: Error inserting dibx000_common (/lib/modules/2.6.22-3-486/kernel/drivers/media/dvb/frontends/dibx000_common.ko): Invalid module format
insmod /lib/modules/2.6.22-3-486/kernel/drivers/media/dvb/frontends/dib7000m.ko 
FATAL: Error inserting dib7000m (/lib/modules/2.6.22-3-486/kernel/drivers/media/dvb/frontends/dib7000m.ko): Invalid module format

stefano@geppetto ~> uname -a
Linux geppetto 2.6.22-3-486 #1 Mon Nov 12 07:53:08 UTC 2007 i686 GNU/Linux

I get in dmesg:
dibx000_common: disagrees about version of symbol struct_module
dib7000m: disagrees about version of symbol struct_module

Any hint will be highly appreciated.

Regards.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
