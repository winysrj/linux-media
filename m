Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [124.189.64.44] (helo=mail.randall.id.au)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@luke.bpa.nu>) id 1KwcY0-0007Lf-Vj
	for linux-dvb@linuxtv.org; Sun, 02 Nov 2008 13:59:19 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.randall.id.au (Postfix) with ESMTP id E1ADC1A3D86
	for <linux-dvb@linuxtv.org>; Sun,  2 Nov 2008 23:58:31 +1100 (EST)
Received: from mail.randall.id.au ([127.0.0.1])
	by localhost (gw1.lan [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z5VBgDViBNUB for <linux-dvb@linuxtv.org>;
	Sun,  2 Nov 2008 23:58:30 +1100 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.randall.id.au (Postfix) with ESMTP id 9CC4A1A3D9D
	for <linux-dvb@linuxtv.org>; Sun,  2 Nov 2008 23:58:30 +1100 (EST)
Received: from ld1.localnet (luke.lan [192.168.1.2])
	by mail.randall.id.au (Postfix) with ESMTP id 6FE5B1A3D86
	for <linux-dvb@linuxtv.org>; Sun,  2 Nov 2008 23:58:30 +1100 (EST)
From: Luke <linuxtv@luke.bpa.nu>
To: linux-dvb@linuxtv.org
Date: Sun, 2 Nov 2008 23:57:53 +1100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811022357.54138.linuxtv@luke.bpa.nu>
Subject: [linux-dvb] Issue with Dvico Nano USB DVB-T
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

I'm having an issue getting the Dvico Nano2 DVB-T USB stick to work under 
Mythbuntu 7.10 and hoping someone can give me some pointers.

In the dmesg output, I keep getting this:

[  576.541492] dvb-usb: found a 'DViCO FusionHDTV DVB-T NANO2 w/o firmware' in 
warm state.
[  576.725695] dvb-usb: will pass the complete MPEG2 transport streamto the 
software demuxer.
[  576.732111] DVB: registering new adapter (DViCO FusionHDTV DVB-T NANO2 w/o 
firmware)
[  576.827488] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[  576.827918] xc2028 0-0061: creating new instance
[  576.827926] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[  576.831676] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:11.0/0000:02:02.0/usb1/1-1/input/input8
[  576.856412] dvb-usb: schedule remote query interval to 100 msecs.
[  577.072740] dvb-usb: DViCO FusionHDTV DVB-T NANO2 w/o firmware successfully 
initialized and connected.

I'm a bit concerned about the "w/o firmware" bit above.

I have the following firmware files in /lib/firmware...
xc3028-dvico-au-01.fw
xc3028-v27.fw
dvb-usb-bluebird-01.fw
dvb-usb-bluebird-02.fw
...which I've downloaded based on various posts I've found.

When trying to run a scan I constantly get "tuning failed!!!"...

# scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-sydney_north_shore
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-sydney_north_shore
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 2 9 3 1 2 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 571500000 1 2 9 3 1 2 0
initial transponder 578500000 1 2 9 3 1 2 0
>>> tune to: 
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!

Any ideas? I'm using kernel version 2.6.27-7-generic. 

One thing to note is that I am running this on a Guest OS under VMware Server 
2 (with the USB passed through) - so that might be the reason its coming up in 
a warm state.

Any help would be much appreciated.

Thanks,

Luke





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
