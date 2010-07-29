Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-us.gmx.com ([74.208.5.67]:58798 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755787Ab0G2JV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 05:21:26 -0400
Message-ID: <4C517241.9050502@gmx.com>
Date: Thu, 29 Jul 2010 12:21:21 +0000
From: Hasan SAHIN <hasan.sahin@gmx.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: gspca_zc3xx module
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hello Jean-Francois,

I am using Gentoo linux stable x86 with kernel 2.6.34-r1.
before the kernel update to 2.6.34-r1, I was using 2.6.32-r7 and there 
was no problem with webcam.
The webcam was working as good with kernel 2.6.32-r7(old gentoo stable 
kernel)
but right now it does not work with the kernel 2.6.34-r1 (new gentoo 
stable kernel)

And also I have tried with ubuntu 10.04 (kernel 2.6.32-25) and working 
good. I could not understood what is the problem. (Problem is : there is 
no output, no stream)

All test has been done with wxcam,cheese and your svv.c program.

Could you please help me?

Thanks and regards,
Hasan.

lsusb :
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 005: ID 0ac8:303b Z-Star Microelectronics Corp. ZC0303 Webcam
Bus 001 Device 002: ID 04b3:310c IBM Corp. Wheel Mouse
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

lsmod
gspca_zc3xx            34720  0
gspca_main             17677  1 gspca_zc3xx
videodev               27331  1 gspca_main
usbcore                92279  7 
gspca_zc3xx,gspca_main,usbhid,usbmouse,ehci_hcd,ohci_hcd


this is the kernel message when I remove and re-plug the webcam :

dmesg | tail -30
gspca: isoc irq
gspca: found int in endpoint: 0x82, buffer_len=8, interval=10
gspca: stream off OK
gspca: [svv] close
gspca: frame free
gspca: close done
usb 1-8: USB disconnect, address 5
gspca: video0 disconnect
gspca: video0 released
usb 1-8: new full speed USB device using ohci_hcd and address 6
usb 1-8: New USB device found, idVendor=0ac8, idProduct=303b
usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-8: Product: PC Camera
usb 1-8: Manufacturer: Vimicro Corp.
gspca: probing 0ac8:303b
zc3xx: probe 2wr ov vga 0x0000
zc3xx: probe 3wr vga 1 0xc001
zc3xx: probe sensor -> 0013
zc3xx: Find Sensor MI0360SOC. Chip revision c001
input: zc3xx as /devices/pci0000:00/0000:00:02.0/usb1/1-8/input/input7
gspca: video0 created
gspca: found int in endpoint: 0x82, buffer_len=8, interval=10
gspca: [v4l_id] open
gspca: open done
gspca: [v4l_id] close
gspca: close done
gspca: [hald-probe-vide] open
gspca: open done
gspca: [hald-probe-vide] close
gspca: close done





