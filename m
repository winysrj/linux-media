Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kristoffer.ericson@gmail.com>) id 1KkmFX-0001Ja-JO
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 22:55:17 +0200
Received: by nf-out-0910.google.com with SMTP id g13so120889nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 30 Sep 2008 13:55:12 -0700 (PDT)
Date: Tue, 30 Sep 2008 22:54:32 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Message-Id: <20080930225432.ab9845bf.kristoffer.ericson@gmail.com>
In-Reply-To: <20080930223328.675aa43c.kristoffer.ericson@gmail.com>
References: <20080930223328.675aa43c.kristoffer.ericson@gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Zap 3420D/SV Non-working
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

Hi,

I did a google check for the IdVendor code and came up with an
device that identifies with exactly same IdVendor and IdProduct.

Chipset: E3C EC168
Tuner: Microtune MXL5003s

Website here :
http://plone.lucidsolutions.co.nz/dvb/t/usb/sinovideo-3420a-2

You can see Hi-Res pictures of the chips here :
http://plone.lucidsolutions.co.nz/dvb/t/usb/images/SV-3420A%20-PCB%20top.JPG

When following his USB adapter back to the manufacturer I 
also find mine there, so its really the same in new
packaging.

http://sinovideo.manufacturer.globalsources.com/si/6008824852613/Homepage.htm
http://www.sinovideo.com.cn/ (official homepage)

Best wishes
Kristoffer

On Tue, 30 Sep 2008 22:33:28 +0200
Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:

> Greetings,
> 
> The Zap 3420D (swedish edition) is an USB dvb stick with remote
> IR controller. Currently it gets detected as an keyboard.
> 
> Im familiar with the kernel code, but totally new
> in linux-dvb coding. So any information would be helpful.
> 
> I searched google and your mailinglist without finding
> any previous reporting so I included dmesg+lsusb output.
> 
> Best wishes
> Kristoffer Ericson
> 
> dmesg :
> usb 1-4: new high speed USB device using ehci_hcd and address 4
> usb 1-4: configuration #1 chosen from 1 choice
> input: HID 18b4:1689 as /class/input/input5
> input: USB HID v1.11 Keyboard [HID 18b4:1689] on usb-0000:00:1d.7-4
> usb 1-4: New USB device found, idVendor=18b4, idProduct=1689
> usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> 
> lsusb :
> Bus 001 Device 004: ID 18b4:1689
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x18b4
>   idProduct          0x1689
>   bcdDevice            0.00
>   iManufacturer           0
>   iProduct                0
>   iSerial                 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           50
>     bNumInterfaces          2
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              100mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         3 Human Interface Device
>       bInterfaceSubClass      1 Boot Interface Subclass
>       bInterfaceProtocol      1 Keyboard
>       iInterface              0
>         HID Device Descriptor:
>           bLength                 9
>           bDescriptorType        33
> 	  bcdHID               1.11
>           bCountryCode            0 Not supported
>           bNumDescriptors         1
>           bDescriptorType        34 Report
>           wDescriptorLength      63
>          Report Descriptors:
>            ** UNAVAILABLE **
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               7
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0001
>   Self Powered
> 
> 
> -- 
> Kristoffer Ericson <kristoffer.ericson@gmail.com>


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
