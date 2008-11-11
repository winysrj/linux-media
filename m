Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n75.bullet.mail.sp1.yahoo.com ([98.136.44.51])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KzoxW-0002Mh-S2
	for linux-dvb@linuxtv.org; Tue, 11 Nov 2008 09:50:54 +0100
Date: Tue, 11 Nov 2008 00:50:14 -0800 (PST)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <212220.52318.qm@web46107.mail.sp1.yahoo.com>
Subject: [linux-dvb] Fw: Re:  dvb-t receiver sturm ns-06
Reply-To: free_beer_for_all@yahoo.com
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

Cleaning out an old mail account, I discovered this, which
I don't recall seeing appearing on the mailing list...

As I'm not a developer, you need to post to the list, not
to me, to get the attention of people who are developers.

But in any case, the vendor ID 0x15A4 happens to be listed
as `Afatech', and product ID 0x9016 is listed in the af9015.c
source file, so you may well have a rebrand of a device
which is already supported, and you merely need to enable
the correct kernel configuration to support your device.


Sodding webmail, I try to `forward' this message to the
list but it's formatted as a quoted reply.  That's it.
I'm off webmail.  Grrr.  Raw SMTP for me...  Darned
newfangled Web 2.0 horseless carriage technology on
these here ARPAtubes...


barry bouwsma


--- On Tue, 11/4/08, alberto sarcletti <alberto@sarcletti.it> wrote:

> From: alberto sarcletti <alberto@sarcletti.it>
> Subject: Re: [linux-dvb] dvb-t receiver sturm ns-06
> To: free_beer_for_all@yahoo.com
> Date: Tuesday, November 4, 2008, 10:51 PM
> hi, sorry for the delay to replay
> lsusb give me  15a4:9016
> 
> following some instruction I obtained that but no idea how
> to use it
> 
> less@kless-desktop:~$ lsusb -vd 15a4:9016
> 
> Bus 006 Device 008: ID 15a4:9016
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x15a4
>   idProduct          0x9016
>   bcdDevice            2.00
>   iManufacturer           1
>   iProduct                2
>   iSerial                 3
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           71
>     bNumInterfaces          2
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         3 Human Interface Device
>       bInterfaceSubClass      0 No Subclass
>       bInterfaceProtocol      1 Keyboard
>       iInterface              0
>         HID Device Descriptor:
>           bLength                 9
>           bDescriptorType        33
>           bcdHID               1.01
>           bCountryCode            0 Not supported
>           bNumDescriptors         1
>           bDescriptorType        34 Report
>           wDescriptorLength      65
>          Report Descriptors:
>            ** UNAVAILABLE **
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval              16
> can't get device qualifier: Operation not permitted
> can't get debug descriptor: Operation not permitted
> cannot read device status, Operation not permitted (1)
> 
> 
> 2008/9/19 barry bouwsma <free_beer_for_all@yahoo.com>
> 
> > --- On Thu, 9/18/08, kless
> <wunderkless@gmail.com> wrote:
> >
> > > I would like to use my dvb-t usb on linux, is a
> dvb-t
> > > receiver sturm ns-06 .
> > > I can find nothing about it, no producer website
> nothing. I
> >
> > For starters, what do you see when you plug it in?
> >
> > Also, vendor and product ID will be helpful (if not
> shown
> > as above, then `lsusb' will show this...
> >
> >
> > barry bouwsma
> >
> >
> >
> >
> >


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
