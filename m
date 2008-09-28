Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1Kk0Z0-000635-9R
	for linux-dvb@linuxtv.org; Sun, 28 Sep 2008 20:00:11 +0200
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Kk0Ys-0007lB-II
	for linux-dvb@linuxtv.org; Sun, 28 Sep 2008 18:00:02 +0000
Received: from pd9533915.dip0.t-ipconnect.de ([217.83.57.21])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 28 Sep 2008 18:00:02 +0000
Received: from malte.forkel by pd9533915.dip0.t-ipconnect.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 28 Sep 2008 18:00:02 +0000
To: linux-dvb@linuxtv.org
From: Malte Forkel <malte.forkel@berlin.de>
Date: Sun, 28 Sep 2008 19:47:09 +0200
Message-ID: <gbofuu$gds$1@ger.gmane.org>
Mime-Version: 1.0
Subject: [linux-dvb] Still problems with ttusb_dec / DEC3000-s
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

I'm trying to get my Hauppauge DEC3000-s working. And I don't seem to be the only one. For an earlier, more accurate account see e.g. http://www.linuxtv.org/pipermail/linux-dvb/2006-April/009259.html. 

With the patch to ttusbdecfe.c referenced in http://www.linuxtv.org/pipermail/linux-dvb/2008-August/027782.html I got past the

ttusbdecfe_read_status: returned unknown value: 0

errors. But I still can't scan:

# scan -x0 -t1 /usr/share/dvb/dvb-s/Astra-19.2E | tee channels.conf
scanning /usr/share/dvb/dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12551500 V 22000000 5
>>> tune to: 12551:v:0:22000
DVB-S IF freq is 1951500
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
dumping lists (0 services)
Done.

Is anybody successfully using a DEC3000-s or can give some advice?

Thanks for your help,
Malte



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
