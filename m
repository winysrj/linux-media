Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 217-112-173-73.cust.avonet.cz ([217.112.173.73]
	helo=podzimek.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andrej@podzimek.org>) id 1KsQDH-0003wQ-Nc
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 01:00:32 +0200
Message-ID: <48FE5EED.8040609@podzimek.org>
Date: Wed, 22 Oct 2008 00:59:57 +0200
From: Andrej Podzimek <andrej@podzimek.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <48FE2872.3070105@podzimek.org> <48FE3553.5080009@iki.fi>
In-Reply-To: <48FE3553.5080009@iki.fi>
Cc: linux-dvb@linuxtv.org
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

> Looks like even firmware does not ran. Could you try debug, load driver 
> by modprobe dvb-usb-af9015 debug=3

OK, added this to /etc/modprobe.conf:

	options dvb-usb-af9015 debug=3

Now this is what I get when I plug in the receiver:

	Oct 22 00:55:02 xandrej usb 4-2: new high speed USB device using ehci_hcd and address 5
	Oct 22 00:55:03 xandrej usb 4-2: configuration #1 chosen from 1 choice
	Oct 22 00:55:03 xandrej Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 16 -> 8
	Oct 22 00:55:03 xandrej input: Afatech DVB-T 2 as /class/input/input11
	Oct 22 00:55:03 xandrej input: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:1d.7-2
	Oct 22 00:55:03 xandrej af9015_usb_probe: interface:0
	Oct 22 00:55:03 xandrej af9015_read_config: IR mode:1
	Oct 22 00:55:03 xandrej af9015_read_config: TS mode:0
	Oct 22 00:55:03 xandrej af9015_read_config: [0] xtal:2 set adc_clock:28000
	Oct 22 00:55:03 xandrej af9015_read_config: [0] IF1:43000
	Oct 22 00:55:03 xandrej af9015_read_config: [0] MT2060 IF1:0
	Oct 22 00:55:03 xandrej af9015_read_config: [0] tuner id:156
	Oct 22 00:55:03 xandrej af9015_identify_state: reply:01
	Oct 22 00:55:03 xandrej dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a firmware
	Oct 22 00:55:03 xandrej firmware: requesting dvb-usb-af9015.fw
	Oct 22 00:55:03 xandrej dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
	Oct 22 00:55:03 xandrej af9015_download_firmware:
	Oct 22 00:55:03 xandrej usbcore: registered new interface driver dvb_usb_af9015

> HW could be dead... If you can, test it with Windows.

I don't have admin access to such an exotic OS, sorry about that. Perhaps I could visit my grandfather who owns the same device and test it next week. AFAIK, it still works fine with his Linux.

Andrej


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
