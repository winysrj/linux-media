Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.j.buxton@gmail.com>) id 1KfNVb-0002mQ-93
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 01:29:32 +0200
Received: by ey-out-2122.google.com with SMTP id 25so1050214eya.17
	for <linux-dvb@linuxtv.org>; Mon, 15 Sep 2008 16:29:26 -0700 (PDT)
Message-ID: <3d374d00809151629u3d55dfacqf802ea4a20422af7@mail.gmail.com>
Date: Tue, 16 Sep 2008 00:29:25 +0100
From: "Alistair Buxton" <a.j.buxton@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <35680.33061.qm@web28404.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <48CD2193.2000106@linuxtv.org>
	<35680.33061.qm@web28404.mail.ukl.yahoo.com>
Subject: Re: [linux-dvb] Kernel integration of rtl2831u driver
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

2008/9/15 Peter Mayer <horuljo@yahoo.de>:
> --- Steven Toth <stoth@linuxtv.org> schrieb am So, 14.9.2008:
>
>> > So, I wonder now what the next steps are to make
>> this driver available in the linux kernel, and when it will
>> probably happen.
>> >
>>
>> I gather the tree has some significant merge issues,
>> that's probably why it hasn't been merged. Generally if the drivers are
>> legally clean, code clean they get merged in a couple of weeks.
>
> Sorry if I need to ask again, but what does this actually mean with respect to that specific driver rtl2821u? I just wonder.

It seems that the rtl2831 driver duplicates a lot of code that is
already in mainline. This is a no-no and the code must be modularized
before it can go in.

> My problem is that in Ubuntu Hardy I managed to make this stick work, but in Debian SID I have no idea how to get it work. When I do
>
> hg clone http://linuxtv.org/hg/v4l-dvb
> make
> make install

The code for rtl2831 is at: http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2
But I'll assume you know that since you already got it working in Ubuntu.

> the stick is not recognized. The entries in /var/log/syslog are:
>
> Sep 15 23:35:55  kernel: usb 3-3: New USB device found, idVendor=14aa, idProduct=0160
> Sep 15 23:35:55  kernel: usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Sep 15 23:35:55  kernel: usb 3-3: Product: DTV Receiver
> Sep 15 23:35:55  kernel: usb 3-3: Manufacturer: DTV Receiver
> Sep 15 23:35:55  kernel: usb 3-3: SerialNumber: 0000000000010205
>
> When I unpack and make & make install rtl2831u_dvb-usb_v0.0.2mod, syslog says:
>
> Sep 15 23:40:17  kernel: usb 3-3: new high speed USB device using ehci_hcd and address 3
> Sep 15 23:40:17  kernel: usb 3-3: configuration #1 chosen from 1 choice
> Sep 15 23:40:17  kernel: usb 3-3: New USB device found, idVendor=14aa, idProduct=0160
> Sep 15 23:40:17  kernel: usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Sep 15 23:40:17  kernel: usb 3-3: Product: DTV Receiver
> Sep 15 23:40:17  kernel: usb 3-3: Manufacturer: DTV Receiver
> Sep 15 23:40:17  kernel: usb 3-3: SerialNumber: 0000000000010205
> Sep 15 23:40:17  NetworkManager: <debug> [1221514817.598859] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_14aa_160_0000000000010205').
> Sep 15 23:40:17  NetworkManager: <debug> [1221514817.602281] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_14aa_160_0000000000010205_usbraw').
> Sep 15 23:40:17  kernel: dvb-usb: found a 'Freecom USB 2.0 DVB-T Device' in warm state.
> Sep 15 23:40:17  kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> Sep 15 23:40:17  udevd-event[3309]: run_program: '/sbin/modprobe' abnormal exit
> Sep 15 23:40:17  NetworkManager: <debug> [1221514817.795519] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_14aa_160_0000000000010205_if0').
>
> So, what can I try to make this stick work in Debian SID?
>

Your log seems to indicate that the driver has loaded OK and detected
the device. If you dont have any device nodes for the card, then you
are probably missing udev/hal rules for their creation.

-- 
Alistair Buxton
a.j.buxton@gmail.com

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
