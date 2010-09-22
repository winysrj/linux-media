Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <post@dietmar-nowack.de>) id 1OySvQ-000551-Tc
	for linux-dvb@linuxtv.org; Wed, 22 Sep 2010 19:16:09 +0200
Received: from dd6814.kasserver.com ([85.13.131.124])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OySvQ-000644-7x; Wed, 22 Sep 2010 19:16:08 +0200
Received: from [192.168.1.201]
	(HSI-KBW-078-042-213-043.hsi3.kabel-badenwuerttemberg.de
	[78.42.213.43])
	by dd6814.kasserver.com (Postfix) with ESMTP id C5D5F180C9135
	for <linux-dvb@linuxtv.org>; Wed, 22 Sep 2010 19:16:07 +0200 (CEST)
From: Dietmar Nowack <post@dietmar-nowack.de>
To: linux-dvb@linuxtv.org
Date: Wed, 22 Sep 2010 19:16:07 +0200
Message-ID: <1285175767.1817.13.camel@dicomputer>
Mime-Version: 1.0
Subject: [linux-dvb] SAA7146-based card- tunes, but no multiplex
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hi all,
I have an (old) SAA7146-based DVB device- a Technotrend/Hauppauge WinTV
DVB-S rev1.3 SE, if the autodetection is to be trusted. It is recognized
without error (apparently), the firmware file resides in the appropriate
folder and is loaded correctly, and nothing in the logs points to an
error. However, while the device tunes and acquires a lock, no video
data can be captured. 

Here's what I think are the relevant messages from the kernel:


[   19.620310] DVB: registering new adapter (Technotrend/Hauppauge WinTV
DVB-S rev1.3 SE)
[   19.661939] adapter has MAC addr = 00:d0:5c:00:00:b3
[   19.670459] dvb 0000:05:00.0: firmware: requesting
av7110/bootcode.bin
[   19.906050] dvb-ttpci: gpioirq unknown type=0 len=0
[   19.920105] dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018,
vid 00000000, app 80002622
[   19.920107] dvb-ttpci: firmware @ card 0 supports CI link layer
interface
[   20.096224] dvb-ttpci: adac type set to 0 @ card 0
[   20.101859] saa7146_vv: saa7146 (0): registered device video0 [v4l2]
[   20.101882] saa7146_vv: saa7146 (0): registered device vbi0 [v4l2]
[   20.289732] ves1x93: Detected ves1893a rev2
[   20.289737] DVB: registering adapter 0 frontend 0 (VLSI VES1x93
DVB-S)...
[   20.289865] input: DVB on-card IR receiver
as /devices/pci0000:00/0000:00:1e.0/0000:05:00.0/input/input6
[   20.289900] dvb-ttpci: found av7110-0.



A tuning attempt using dvbtune yields:

>dvbtune -f 12551000 -p v -s 22000
Using DVB card "VLSI VES1x93 DVB-S"
tuning DVB-S to L-Band:134513994, Pol:V Srate=22000000, 22kHz=off
polling....
Getting frontend event
FE_STATUS:
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
FE_HAS_SYNC
Event:  Frequency: 12551859
        SymbolRate: 22000000
        FEC_inner:  5

Bit error rate: 0
Signal strength: 43433
SNR: 57054
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
FE_HAS_SYNC



This is the output I get from 'scan' (dvbscan)

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



Using a different card, I can tune, scan using the same command and
receive a TS, so reception problems can be ruled out. 

Any suggestions how to proceed to resolve the issue or what further data
to provide to that end would be highly appreciated.

Best regards
Dietmar


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
