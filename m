Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zdenek.kabelac@gmail.com>) id 1JnNMC-0000XS-9D
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 02:24:39 +0200
Received: by rv-out-0506.google.com with SMTP id b25so825423rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 19 Apr 2008 17:24:29 -0700 (PDT)
Message-ID: <c4e36d110804191724j47b6e39byda88f2ed8707bd28@mail.gmail.com>
Date: Sun, 20 Apr 2008 02:24:29 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <c4e36d110804090905t3574e09ao8cadadacc9c12080@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <7dd90a210804070554t6d8b972xa85eb6a75b0663cd@mail.gmail.com>
	<47FA3A7A.3010002@iki.fi> <47FAFDDA.4050109@iki.fi>
	<c4e36d110804081627s21cc5683l886e2a4a8782cd59@mail.gmail.com>
	<47FC373F.5060006@iki.fi>
	<c4e36d110804090130s5b66a357s3ec754a1d617b30@mail.gmail.com>
	<47FCE5FB.9080003@iki.fi>
	<c4e36d110804090905t3574e09ao8cadadacc9c12080@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USB 1.1 support for AF9015 DVB-T tuner
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

2008/4/9, Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2008/4/9, Antti Palosaari <crope@iki.fi>:
>  > Zdenek Kabelac wrote:
>  >
>  >  AF9013 is DVB-T demodulator and AF9015 is integrated USB-bridge + AF9013
>  > demodulator. Your device does not have AF9015 at all. DVB-T USB-device needs
>  > logically three "chips". USB-bridge, demodulator and tuner. As I can
>  > understand there is CY7C68013 USB-bridge, AF9013 demodulator and TDA18271
>  > tuner. First you should try to find driver for demodulator. After thats is
>  > OK we can try to connect AF9013 demodulator to USB-bridge and TDA18271 tuner
>  > to AF9013 demodulator.
>
>
> Yep - that's what I needed to know - I have no idea how these things
>  are connected so I'll try to find something for CY7C USB-bridge first.

Hi

I've tried to replace .usb_ctrl wth CYPRESS_FX2
But didn't get much futher:

[63013.534810] usb 2-2: new high speed USB device using ehci_hcd and address 5
[63014.232871] usb 2-2: configuration #1 chosen from 1 choice
[63014.234708] usb 2-2: New USB device found, idVendor=07ca, idProduct=a827
[63014.234796] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[63014.234802] usb 2-2: Product: AVerTV
[63014.234807] usb 2-2: Manufacturer: AVerMedia
[63014.234812] usb 2-2: SerialNumber: 300426401445
[63014.334662] af9015_usb_probe: interface:0
[63014.334669] >>> 10 00 38 00 00 00 00 01
[63014.334677] af9015: af9015_rw_udev: sending failed: -22 (8/-32512)
[63015.333846] af9015: af9015_rw_udev: receiving failed: -110
[63015.333859] dvb-usb: found a 'AverMedia AVerTV Hybrid Volar HX' in
cold state, will try to load a firmware
[63015.354959] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[62539.045310] dvb-usb: firmware download failed at 15904 with -22
[62539.045384] dvb_usb_af9015: probe of 2-2:1.0 failed with error -22
[62539.045468] usbcore: registered new interface driver dvb_usb_af9015


Will I need to do any additional modification - any different firmware
for download ?

Is there any guide how to trace the driver in Windows - does anyone
have any experience to use qemu-kvm for this - will this even work ?

Technilly it looks similar to Leadtek Winfast Gold from this discussion:
http://www.mail-archive.com/linux-dvb@linuxtv.org/msg30055.html

But I'm so far lost how the thing should be initialized.

Zdenek

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
