Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 217-112-173-73.cust.avonet.cz ([217.112.173.73]
	helo=podzimek.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andrej@podzimek.org>) id 1KsQ39-0002yz-6q
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 00:50:05 +0200
Message-ID: <48FE5C78.2030301@podzimek.org>
Date: Wed, 22 Oct 2008 00:49:28 +0200
From: Andrej Podzimek <andrej@podzimek.org>
MIME-Version: 1.0
To: Sebastian Marskamp <SebastianMarskamp@web.de>
References: <1550114954@web.de>
In-Reply-To: <1550114954@web.de>
Cc: Antti Palosaari <crope@iki.fi>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MSI DigiVox mini II V3.0 stopped working
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

Sebastian Marskamp wrote:
> Same here  ..Problem occures with Kernel  	2.6.27   . Firmware is installed correct , hardware is working under windows . No error Message at all. 
> 
> [ 2696.610565] af9015_usb_probe: interface:0
> [ 2696.611970] af9015_read_config: IR mode:1
> [ 2696.614463] af9015_read_config: TS mode:0
> [ 2696.615839] af9015_read_config: [0] xtal:2 set adc_clock:28000
> [ 2696.618595] af9015_read_config: [0] IF1:43000
> [ 2696.621344] af9015_read_config: [0] MT2060 IF1:0
> [ 2696.622718] af9015_read_config: [0] tuner id:156
> [ 2696.623093] af9015_identify_state: reply:01
> [ 2696.623097] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a firmware
> [ 2696.623100] firmware: requesting dvb-usb-af9015.fw
> [ 2696.634547] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> [ 2696.634552] af9015_download_firmware:
> [ 2696.701890] usbcore: registered new interface driver dvb_usb_af9015
> 
> Its just not working anymore 

Well, in my case, it *did* work just normally. I watched TV for about three hours yesterday evening, using exactly the same SW and machine as now. Will try to set debug=3 for that module in modprobe.conf.

Andrej


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
