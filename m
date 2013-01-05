Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <jajcus@jajcus.net>) id 1TrUH4-0000Op-IH
	for linux-dvb@linuxtv.org; Sat, 05 Jan 2013 14:59:23 +0100
Received: from tropek.jajcus.net ([84.205.176.49])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1TrUH4-00079p-GL; Sat, 05 Jan 2013 14:58:58 +0100
Received: from lolek.nigdzie (lolek.nigdzie [10.253.0.124])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by tropek.jajcus.net (Postfix) with ESMTPSA id 6FA185002
	for <linux-dvb@linuxtv.org>; Sat,  5 Jan 2013 14:58:55 +0100 (CET)
Date: Sat, 5 Jan 2013 14:58:55 +0100
From: Jacek Konieczny <jajcus@jajcus.net>
To: linux-dvb@linuxtv.org
Message-ID: <20130105145855.75998a29@lolek.nigdzie>
Mime-Version: 1.0
Subject: [linux-dvb] Problem with 'NOT Only TV DVB-T USB Deluxe"
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
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I have a 'NOT Only TV DVB-T USB Deluxe' tuner device:

Model name: LV5TDLX DVB-T USB
P/N: STLV5TDLXT702
S/N: LV5TDLX120700116
USB ID: 1f4d:c803

This is based on the RTL2838UHIDIR chip with e4000 tuner (at least, that
is detected by various drivers).

I had some minor success with it with some old 3.x kernel and the
drivers from:

https://github.com/tmair/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0

This stopped working with kernel 3.5 and would not even build with newer
kernels.

Then I tried drivers from linuxtv.org, with little success. The RTL2838u
driver has been recently included in the upstream kernel (3.7), so I
have tried that. The hardware is detected, but I am not able to tune in.

The signal is good - tested with my TV set. The USB tuner device is also
OK, I have tried it with Windows and the software provided with the
device and the same channels are available as on the TV.

So the driver must be broken. Any ideas how can I debug or fix that?

dmesg:
> [ 3336.916384] usb 2-4: new high-speed USB device number 7 using ehci_hcd
> [ 3337.051822] usb 2-4: New USB device found, idVendor=1f4d, idProduct=c803
> [ 3337.051829] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [ 3337.051835] usb 2-4: Product: RTL2838UHIDIR
> [ 3337.051839] usb 2-4: Manufacturer: Realtek
> [ 3337.051843] usb 2-4: SerialNumber: 00000001
> [ 3337.072145] usb 2-4: dvb_usb_v2: found a 'Trekstor DVB-T Stick Terres 2.0' in warm state
> [ 3337.072194] usbcore: registered new interface driver dvb_usb_rtl28xxu
> [ 3337.136867] usb 2-4: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
> [ 3337.136886] DVB: registering new adapter (Trekstor DVB-T Stick Terres 2.0)
> [ 3337.147449] usb 2-4: DVB: registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
> [ 3337.163939] i2c i2c-7: e4000: Elonics E4000 successfully identified
> [ 3337.174823] Registered IR keymap rc-empty
> [ 3337.174928] input: Trekstor DVB-T Stick Terres 2.0 as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc0/input15
> [ 3337.174989] rc0: Trekstor DVB-T Stick Terres 2.0 as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc0
> [ 3337.174994] usb 2-4: dvb_usb_v2: schedule remote query interval to 400 msecs
> [ 3337.187693] usb 2-4: dvb_usb_v2: 'Trekstor DVB-T Stick Terres 2.0' successfully initialized and connected

Scanning on one of the available channels:
> # tzap -r "TVP2" 
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/root/.tzap/channels.conf'
> tuning to 746000000 Hz
> video pid 0x00ca, audio pid 0x00cb
> status 00 | signal bfe1 | snr 0000 | ber 0000ffff | unc bfe14648 | 
> status 00 | signal bfe1 | snr 0000 | ber 0000ffff | unc bfe14648 | 
> status 00 | signal bfe1 | snr 0000 | ber 0000ffff | unc bfe14648 | 
> status 00 | signal bfe1 | snr 0000 | ber 0000ffff | unc bfe14648 | 
> status 00 | signal bfe1 | snr 0000 | ber 0000ffff | unc bfe14648 | 
> status 00 | signal bfe1 | snr 0000 | ber 0000ffff | unc bfe14648 | 
> status 00 | signal bfe1 | snr 008c | ber 00004ca0 | unc bfe14648 | 
> status 00 | signal bfe1 | snr 0000 | ber 0000ffff | unc bfe14648 | 
> status 00 | signal bfe1 | snr 008d | ber 00004ca0 | unc bfe14648 | 
> status 00 | signal bfe1 | snr 0000 | ber 0000ffff | unc bfe14648 | 
> status 00 | signal bfe1 | snr 0072 | ber 00004ca0 | unc bfe14648 | 
> status 00 | signal bfe1 | snr 0000 | ber 0000ffff | unc bfe14648 | 
> status 00 | signal bfe1 | snr 008b | ber 00004ca0 | unc bfe14648 | 
> status 00 | signal bfe1 | snr 0000 | ber 0000ffff | unc bfe14648 | 

And on the other one:
> # tzap -r "Polsat"
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/root/.tzap/channels.conf'
> tuning to 698000000 Hz
> video pid 0x0066, audio pid 0x0067
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 
> status 00 | signal bfb5 | snr 0000 | ber 0000ffff | unc bfb5f4d8 | 

Greets,
	Jacek

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
