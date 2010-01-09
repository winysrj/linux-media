Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <valent.turkovic@gmail.com>) id 1NTjbE-0008UE-71
	for linux-dvb@linuxtv.org; Sat, 09 Jan 2010 23:16:02 +0100
Received: from mail-bw0-f227.google.com ([209.85.218.227])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NTjbD-0003vf-Ke; Sat, 09 Jan 2010 23:15:59 +0100
Received: by bwz27 with SMTP id 27so12484875bwz.1
	for <linux-dvb@linuxtv.org>; Sat, 09 Jan 2010 14:15:59 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 9 Jan 2010 23:15:58 +0100
Message-ID: <64b14b301001091415l1ce004a4s2770166d8678e623@mail.gmail.com>
From: Valent Turkovic <valent.turkovic@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Genius TVGo DVB-T02Q MCE firmware and module issues
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,
I have Genius DVB-T02Q MCE USB DVB-T tuner. I tried using it on Ubuntu
and Fedora without success.

Here is the info that I get via dmesg and lsusb:

# dmesg
usb 1-6: new high speed USB device using ehci_hcd and address 8
usb 1-6: New USB device found, idVendor=0458, idProduct=400f
usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-6: Product: DVB-T02Q MCE
usb 1-6: Manufacturer: Genius
usb 1-6: configuration #1 chosen from 1 choice
input: Genius DVB-T02Q MCE as
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6:1.0/input/input14
generic-usb 0003:0458:400F.0007: input,hidraw3: USB HID v1.11 Keyboard
[Genius DVB-T02Q MCE] on usb-0000:00:1d.7-6/input0

Is the correct driver for this device dvb-usb-m920x ?

On Fedora 12 with 2.6.31.9-174.fc12.i686 kernel I don't see that this
module is getting loaded, why?

I manually loaded dvb-usb-m920x module:
# modprobe dvb-usb-m920x
# dmesg
usbcore: registered new interface driver dvb_usb_m920x

I don't see /dev/dvb or /dev/video0 devices present, so I guess that
something still is not ok, maybe firmware?

Which is the correct firmware for this device? I downloaded all
firmware from: http://linuxtv.org/downloads/firmware/ and copied them
to /lib/firmware and tried reloading the module, still nothing :(

Then I saw post on this mailing list saying that correct firware is
dvb-usb-megasky-02.fw so I downloaded it also, but still nothing.

Do you have any idea why this device is not working?

Can I give you some more info in order to fix this issue?

Cheers!


-- 
pratite me na twitteru - www.twitter.com/valentt
http://kernelreloaded.blog385.com/
linux, blog, anime, spirituality, windsurf, wireless
registered as user #367004 with the Linux Counter, http://counter.li.org.
ICQ: 2125241, Skype: valent.turkovic


-- 
pratite me na twitteru - www.twitter.com/valentt
http://kernelreloaded.blog385.com/
linux, blog, anime, spirituality, windsurf, wireless
registered as user #367004 with the Linux Counter, http://counter.li.org.
ICQ: 2125241, Skype: valent.turkovic, msn: valent.turkovic@hotmail.com

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
