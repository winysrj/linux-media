Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from static.123.246.46.78.clients.your-server.de ([78.46.246.123]
	helo=rohieb.name) by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <rohieb@rohieb.name>) id 1Ms0t3-0006PB-KY
	for linux-dvb@linuxtv.org; Sun, 27 Sep 2009 23:02:30 +0200
Received: from [134.169.174.188] (c188.apm.etc.tu-bs.de [134.169.174.188])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: rohieb)
	by rohieb.name (Postfix) with ESMTPSA id 2AAAF5D2DF
	for <linux-dvb@linuxtv.org>; Sun, 27 Sep 2009 23:02:25 +0200 (CEST)
Message-ID: <4ABFD2E0.7000103@rohieb.name>
Date: Sun, 27 Sep 2009 23:02:24 +0200
From: Roland Hieber <rohieb@rohieb.name>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problems with af9013/5: I2C read failed reg:d417,
	bulk message failed:-22
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

Hello,

I am having problems with my DIGITTRADE DVB-T USB Stick with af9015 chipset
since a few weeks. It works for a while (sometimes about 3 minutes, sometimes
half an hour) but suddenly the video stream freezes and dmesg says:

> [  155.924040] usb 1-6: new high speed USB device using ehci_hcd and address 4
> [  156.091151] usb 1-6: configuration #1 chosen from 1 choice
> [  156.096560] Afatech DVB-T: Fixing fullspeed to highspeed interval: 16 -> 8
> [  156.096985] input: Afatech DVB-T as /devices/pci0000:00/0000:00:10.3/usb1/1-6/1-6:1.1/input/input7
> [  156.138858] generic-usb 0003:15A4:9016.0002: input,hidraw1: USB HID v1.01 Keyboard [Afatech DVB-T] on usb-0000:00:10.3-6/input1
> [  156.262580] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a firmware
> [  156.262591] usb 1-6: firmware: requesting dvb-usb-af9015.fw
> [  156.313938] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> [  156.382340] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
> [  156.382441] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> [  156.382984] DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
> [  156.906560] af9013: firmware version:4.95.0
> [  156.911056] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
> [  156.995283] MT2060: successfully identified (IF1 = 1220)
> [  157.471840] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized and connected.
> [  157.551768] usbcore: registered new interface driver dvb_usb_af9015
> [  239.765547] usb 1-6: USB disconnect, address 4
> [  239.769954] af9015: bulk message failed:-22 (8/-224805168)
> [  239.769961] af9013: I2C read failed reg:d417
> [  239.769965] af9015: bulk message failed:-22 (8/-1067461161)
> [  239.769968] af9013: I2C read failed reg:d417
> [  239.769971] af9015: bulk message failed:-22 (9/54295)
> [  239.769973] mt2060 I2C write failed
> [  239.769975] af9015: bulk message failed:-22 (8/134)
> [  239.769977] af9013: I2C read failed reg:d417
> [  239.769980] af9015: bulk message failed:-22 (8/15)
> [  239.769982] af9013: I2C read failed reg:d417
> [  239.769986] af9015: bulk message failed:-22 (8/-1065361500)
> [  239.769988] af9013: I2C read failed reg:d730

I am not even able to rmmod the dvb_usb_af9015 driver, the process hangs.

I already tried a more recent firmware and driver, so I am now working with
firmware v4.95.0 and changeset 71dec186cdae of the v4l-dvb repository. My
system is running on a 2.6.28-15-generic #49-Ubuntu SMP kernel.

What do these error messages mean? What meaning do the numbers have? Could it
be that my hardware is broken? It has now been working for over a year now
without major problems (and even better than on Windows, thanks to v4l-dvb ;-))

Thanks in advantage,
Roland Hieber








_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
