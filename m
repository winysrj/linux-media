Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n25.bullet.mail.ukl.yahoo.com ([87.248.110.142])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <crusader2901@yahoo.de>) id 1JZSfN-00077O-D5
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 16:14:54 +0100
Date: Wed, 12 Mar 2008 16:13:48 +0100
To: linux-dvb@linuxtv.org
From: crusader <crusader2901@yahoo.de>
MIME-Version: 1.0
Message-ID: <op.t7wshkpj4g343t@magnolia>
Subject: [linux-dvb] Problems with MSI Digi VOX mini II
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

Hi there,
I ran into problems using the MSI Digi VOX mini II (original Version, not  
V2.0 or V3.0) on Kubuntu 7.10.

Here is a tail -f /var/run/kern.log while inserting the stick and opening  
Kaffeine:

Mar 12 13:54:10 PBserver kernel: [  561.467245] usb 6-5: new high speed  
USB device using ehci_hcd and address 6
Mar 12 13:54:10 PBserver kernel: [  561.533991] usb 6-5: configuration #1  
chosen from 1 choice
Mar 12 13:54:10 PBserver kernel: [  561.534163] dvb-usb: found a 'MSI DIGI  
VOX mini II DVB-T USB2.0' in cold state, will try to load a firmware
Mar 12 13:54:10 PBserver kernel: [  561.541310] dvb-usb: downloading  
firmware from file 'dvb-usb-digivox-02.fw'
Mar 12 13:54:10 PBserver kernel: [  561.745442] usb 6-5: USB disconnect,  
address 6
Mar 12 13:54:11 PBserver kernel: [  561.861016] usb 6-5: new high speed  
USB device using ehci_hcd and address 7
Mar 12 13:54:11 PBserver kernel: [  561.928714] usb 6-5: configuration #1  
chosen from 1 choice
Mar 12 13:54:11 PBserver kernel: [  561.928876] dvb-usb: found a 'MSI DIGI  
VOX mini II DVB-T USB2.0' in warm state.
Mar 12 13:54:11 PBserver kernel: [  561.928903] dvb-usb: will pass the  
complete MPEG2 transport stream to the software demuxer.
Mar 12 13:54:11 PBserver kernel: [  561.929144] DVB: registering new  
adapter (MSI DIGI VOX mini II DVB-T USB2.0)
Mar 12 13:54:11 PBserver kernel: [  561.932178] DVB: registering frontend  
0 (Philips TDA10046H DVB-T)...
Mar 12 13:54:11 PBserver kernel: [  561.932271] dvb-usb: MSI DIGI VOX mini  
II DVB-T USB2.0 successfully initialized and connected.
Mar 12 13:54:27 PBserver kernel: [  569.553799] tda1004x: setting up plls  
for 48MHz sampling clock
Mar 12 13:54:29 PBserver kernel: [  570.599029] tda1004x: timeout waiting  
for DSP ready
Mar 12 13:54:29 PBserver kernel: [  570.611871] tda1004x: found firmware  
revision 0 -- invalid
Mar 12 13:54:29 PBserver kernel: [  570.611876] tda1004x: trying to boot  
 from eeprom
Mar 12 13:54:31 PBserver kernel: [  571.715696] tda1004x: timeout waiting  
for DSP ready
Mar 12 13:54:31 PBserver kernel: [  571.728537] tda1004x: found firmware  
revision 0 -- invalid
Mar 12 13:54:31 PBserver kernel: [  571.728541] tda1004x: no request  
function defined, can't upload from file
Mar 12 13:54:31 PBserver kernel: [  571.728543] tda1004x: firmware upload  
failed

It seems that the stick itself ist correctly initialized, but as soon as I  
start a TV application, the tda1004x module outputs these error messages  
(it is the same with VLC).

I personally think the important line is the line where the module states  
that no request function is defined.

The firmware files dvb-fe-tda10046.fw (and dvb-fe-tda10045.fw, just to be  
sure) are in the correct directory (/lib/firmware/2.6.22-14-generic). I  
also tried the alternate Lifeview firmware. The stick is running fine  
under Windows XP. By the way, the stick ran under Linux, but I think it  
was with Kubuntu 7.04. There must be a misconfiguration in my system, but  
I don't know where. I tried checking out and compiling  
http://linuxtv.org/hg/v4l-dvb, but this does not help.

Thanks in advance for your help!

Greets, Bert


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
