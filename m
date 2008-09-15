Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.j.buxton@gmail.com>) id 1KfNmO-0004ON-KZ
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 01:46:55 +0200
Received: by gv-out-0910.google.com with SMTP id n29so2013056gve.16
	for <linux-dvb@linuxtv.org>; Mon, 15 Sep 2008 16:46:49 -0700 (PDT)
Message-ID: <3d374d00809151646tcd57e24p4e6481a771aaef48@mail.gmail.com>
Date: Tue, 16 Sep 2008 00:46:48 +0100
From: "Alistair Buxton" <a.j.buxton@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <3d374d00809151629u3d55dfacqf802ea4a20422af7@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <48CD2193.2000106@linuxtv.org>
	<35680.33061.qm@web28404.mail.ukl.yahoo.com>
	<3d374d00809151629u3d55dfacqf802ea4a20422af7@mail.gmail.com>
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

2008/9/16 Alistair Buxton <a.j.buxton@gmail.com>:

>> When I unpack and make & make install rtl2831u_dvb-usb_v0.0.2mod, syslog says:
>>
>> Sep 15 23:40:17  kernel: usb 3-3: new high speed USB device using ehci_hcd and address 3
>> Sep 15 23:40:17  kernel: usb 3-3: configuration #1 chosen from 1 choice
>> Sep 15 23:40:17  kernel: usb 3-3: New USB device found, idVendor=14aa, idProduct=0160
>> Sep 15 23:40:17  kernel: usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> Sep 15 23:40:17  kernel: usb 3-3: Product: DTV Receiver
>> Sep 15 23:40:17  kernel: usb 3-3: Manufacturer: DTV Receiver
>> Sep 15 23:40:17  kernel: usb 3-3: SerialNumber: 0000000000010205
>> Sep 15 23:40:17  NetworkManager: <debug> [1221514817.598859] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_14aa_160_0000000000010205').
>> Sep 15 23:40:17  NetworkManager: <debug> [1221514817.602281] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_14aa_160_0000000000010205_usbraw').
>> Sep 15 23:40:17  kernel: dvb-usb: found a 'Freecom USB 2.0 DVB-T Device' in warm state.
>> Sep 15 23:40:17  kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
>> Sep 15 23:40:17  udevd-event[3309]: run_program: '/sbin/modprobe' abnormal exit
>> Sep 15 23:40:17  NetworkManager: <debug> [1221514817.795519] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_14aa_160_0000000000010205_if0').
>>
>> So, what can I try to make this stick work in Debian SID?
>>
>
> Your log seems to indicate that the driver has loaded OK and detected
> the device. If you dont have any device nodes for the card, then you
> are probably missing udev/hal rules for their creation.
>

Hmm... scratch what I just said, it's clearly not working at all. Try
the repository at http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2
The original source release (rtl2831u_dvb-usb_v0.0.2mod) is not
compatible with the newer dvb modules.

-- 
Alistair Buxton
a.j.buxton@gmail.com

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
