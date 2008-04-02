Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.voila.fr ([193.252.22.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abdouniang@voila.fr>) id 1Jh9V9-0004Gm-RC
	for linux-dvb@linuxtv.org; Wed, 02 Apr 2008 22:24:08 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf4019.voila.fr (SMTP Server) with ESMTP id 1B50E7000105
	for <linux-dvb@linuxtv.org>; Wed,  2 Apr 2008 22:23:31 +0200 (CEST)
Received: from wwinf4612 (wwinf4612 [10.232.13.55])
	by mwinf4019.voila.fr (SMTP Server) with ESMTP id 183C27000095
	for <linux-dvb@linuxtv.org>; Wed,  2 Apr 2008 22:23:31 +0200 (CEST)
From: Abdou NIANG <abdouniang@voila.fr>
To: linux-dvb@linuxtv.org
Message-ID: <25709347.2350411207167811091.JavaMail.www@wwinf4612>
MIME-Version: 1.0
Date: Wed,  2 Apr 2008 22:23:31 +0200 (CEST)
Subject: [linux-dvb] Can't record transport stream - Error:
 cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)
Reply-To: abdouniang@voila.fr
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

Hi everybody,

I want to realise a DVB-T recorder using dvbstream package. I work with KUbuntu 7.10 (64 bits because i've an AMD64 bit processor) with a 2.6.22.14 kernel, DVB-T card: Hauppauge Win TV Nova T (PCI), . 
I've already realised a similar system with Mandriva 2006 and 2007 everything worked well.

After having installed KUbuntu i've downloaded dvb-utils, dvbsnoop and dvbstream packages and Kaffeine.
I can scan frequencies using "scan" of dvb-utils package.
I've added modules cx88_dvb and cx8802 correctly in /etc/modules. I've rode that since kernel 2.6.20 cx88-dvb and cx88-blackbird are now sub modules of cx8802 module.

I can watch DVB-T channels with kaffeine.

But when i try to record an entire Transport Stream with dvbstream like this: 

$ dvbstream 8192 -o > test.ts

My output file "test.ts" is always empty. When i try to see kernel's messages i've:

$dmesg | grep dvb
[   27.474327] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   27.474796] cx88[0]: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=18,autodetected]
[   27.474799] cx88[0]: TV tuner type 4, Radio tuner type -1
[   27.543907] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   27.627854] cx88[0]: hauppauge eeprom: model=90003
[   27.629167] input: cx88 IR (Hauppauge Nova-T DVB-T as /class/input/input7
[   27.629198] cx88[0]/0: found at 0000:01:0a.0, rev: 5, irq: 18, latency: 20, mmio: 0xf9000000
[   27.629242] cx88[0]/0: registered device video0 [v4l2]
[   27.629263] cx88[0]/0: registered device vbi0
[   27.629446] cx88[0]/2: cx2388x 8802 Driver Manager
[   27.629477] cx88[0]/2: found at 0000:01:0a.2, rev: 5, irq: 18, latency: 64, mmio: 0xf8000000
[   27.715372] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   27.715377] cx88/2: registering cx8802 driver, type: dvb access: shared
[   27.715381] cx88[0]/2: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=18]
[   27.715384] cx88[0]/2: cx2388x based DVB/ATSC card
[   27.775995] DVB: registering new adapter (cx88[0])
[  124.600992] cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)
[  124.826959] cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)
[  125.054027] cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)
[  125.281095] cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)
[  125.508166] cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)
[  125.735235] cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)
[  125.962303] cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)
[  126.189372] cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)
[  126.416438] cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)

So the problem is in "cx8802_start_dma()" function i don't know what can i do ??

Thanks. 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
