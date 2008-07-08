Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KGIMG-0006m4-VD
	for linux-dvb@linuxtv.org; Tue, 08 Jul 2008 20:56:14 +0200
Received: by gv-out-0910.google.com with SMTP id n29so527109gve.16
	for <linux-dvb@linuxtv.org>; Tue, 08 Jul 2008 11:55:48 -0700 (PDT)
Message-ID: <412bdbff0807081155u6c06e3c0hb3d02b3c55c6f8b0@mail.gmail.com>
Date: Tue, 8 Jul 2008 14:55:47 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Ronnie Bailey" <purevw@wtxs.net>
In-Reply-To: <1215541957.4797.21.camel@Opto.Bailey>
MIME-Version: 1.0
Content-Disposition: inline
References: <1215541957.4797.21.camel@Opto.Bailey>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with ATI USB Hybrid
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

Hello,

2008/7/8 Ronnie Bailey <purevw@wtxs.net>:
> Hi All,
>     I am trying to install an ATI TV Wonder HD 600 USB card and not having
> any luck. No matter what I try, there is no /dev/video  and also no
> /dev/dvb.  The module seems to load OK, but the card is not found. Yast sees
> the card, but only identifies it as a USB device and not a TV card. I'll
> include what info I have. I would appreciate any help offered. I am trying
> my best to eliminate Microsoft from my systems. This driver problem is one
> of the last major headaches. I'm not sure if this matters, but I need to set
> it up as NTSC-M with us cable. Channel 3 will be the only channel used.
>
> Yast Hardware information states:
>
>   102: udi = '/org/freedesktop/Hal/devices/usb_device_438_b002_660729005035'
>   info.subsystem = 'usb_device'
>   usb_device.vendor = 'Advanced Micro Devices, Inc.'
>   usb_device.bus_number = 2 (0x2)
>   linux.subsystem = 'usb'
>   info.linux.driver = 'usb'
>   usb_device.product = 'ATI TV Wonder 600 USB 2.0'
>   info.product = 'ATI TV Wonder 600 USB 2.0'
>   linux.device_file = '/dev/bus/usb/002/008'
>   usb_device.linux.sysfs_path =
> '/sys/devices/pci0000:00/0000:00:02.1/usb2/2-1/2-1.7'
>   usb_device.device_revision_bcd = 272 (0x110)
>   info.udi = '/org/freedesktop/Hal/devices/usb_device_438_b002_660729005035'
>   usb_device.configuration_value = 1 (0x1)
>   usb_device.max_power = 500 (0x1f4)
>   usb_device.num_configurations = 1 (0x1)
>   usb_device.num_ports = 0 (0x0)
>   usb_device.num_interfaces = 1 (0x1)
>   usb_device.linux.device_number = 8 (0x8)
>   usb_device.device_class = 0 (0x0)
>   usb_device.serial = '660729005035'
>   linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:02.1/usb2/2-1/2-1.7'
>   usb_device.device_subclass = 0 (0x0)
>   info.vendor = 'Advanced Micro Devices, Inc.'
>   usb_device.speed = 480.000
>   info.parent = '/org/freedesktop/Hal/devices/usb_device_50d_237_noserial'
>   usb_device.device_protocol = 0 (0x0)
>   usb_device.version = 2.00000
>   usb_device.vendor_id = 1080 (0x438)
>   usb_device.is_self_powered = false
>   usb_device.product_id = 45058 (0xb002)
>   usb_device.can_wake_up = false
>   linux.hotplug_type = 2 (0x2)
>
> Pertinent lsmod info:
>
> Module                Size            Used By
> em28xx_dvb           26884          0
> dvb_core              109348          1 em28xx_dvb
> em28xx                   81836          1 em28xx_dvb
> compat_ioctl32        25856          1 em28xx
> videodev                  55040          2 em28xx,compat_ioctl32
> v4l1_compat            31620          1 videodev
> videobuf_vmalloc       25476          1 em28xx
> videobuf_core          38788          2 em28xx,videobuf_vmalloc
> ir_common              60932          2 ir_kbd_i2c,em28xx
> v4l2_common            29824          1 em28xx
> tveeprom               30724              1 em28xx
>
> lsusb gives me this:
>
> Bus 002 Device 008: ID 0438:b002 Advanced Micro Devices, Inc.
>
> dmesg shows:
>
> fuse init (API version 7.9)
> Linux video capture interface: v2.00
> em28xx v4l2 driver version 0.1.0 loaded
> usbcore: registered new interface driver em28xx
> Em28xx: Initialized (Em28xx dvb Extension) extension
>
> Xine posted a couple of warning messages:
>
> Jul 8 12:26:44 Opto xinetd[3495]: No such internal service: chargen/raw -
> DISABLING
>
> Jul 8 12:26:45 Opto xinetd[3495]: Port not specified and can't find service:
> netstat with getservbyname
>
> Jul 8 12:26:45 Opto xinetd[3495]: No such internal service: servers/stream -
> DISABLING
>
> Jul 8 12:26:45 Opto xinetd[3495]: No such internal service: services/stream
> - DISABLING
>
> When I open Xine and try to connect to DVB. it simply states:
>
> Input plugin failed to open mrl 'Sorry, No DVB input device found
>
> Thanks in advance,
> Ronnie Bailey
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

I'm wondering why it tried to load the em28xx driver.  Do you have
some other device in the system that is em28xx based?

Could you please provide the output of "lsusb -v" for the device in question.

Thanks,

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
