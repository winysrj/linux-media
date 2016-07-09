Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46262
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbcGIPAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 11:00:01 -0400
Date: Sat, 9 Jul 2016 11:59:56 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Wade Berrier <wberrier@gmail.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: Re: mceusb xhci issue?
Message-ID: <20160709115956.64187c4e@recife.lan>
In-Reply-To: <20160518145226.GA5553@htpc.lan>
References: <20160425040632.GD15140@berrier.lan>
	<20160425171506.GA25277@gofer.mess.org>
	<20160426031650.GA13700@berrier.lan>
	<20160427200730.GA6632@gofer.mess.org>
	<20160515022940.GB2865@miniwade.localdomain>
	<20160518145226.GA5553@htpc.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

C/C linux-usb Mailing list:


Em Wed, 18 May 2016 08:52:28 -0600
Wade Berrier <wberrier@gmail.com> escreveu:

> On May 14 20:29, Wade Berrier wrote:
> > On Wed Apr 27 21:07, Sean Young wrote:  
> > > On Mon, Apr 25, 2016 at 09:16:51PM -0600, Wade Berrier wrote:  
> > > > On Apr 25 18:15, Sean Young wrote:  
> > > > > On Sun, Apr 24, 2016 at 10:06:33PM -0600, Wade Berrier wrote:  
> > > > > > Hello,
> > > > > > 
> > > > > > I have a mceusb compatible transceiver that only seems to work with
> > > > > > certain computers.  I'm testing this on centos7 (3.10.0) and fedora23
> > > > > > (4.4.7).
> > > > > > 
> > > > > > The only difference I can see is that the working computer shows
> > > > > > "using uhci_hcd" and the non working shows "using xhci_hcd".
> > > > > > 
> > > > > > Here's the dmesg output of the non-working version:
> > > > > > 
> > > > > > ---------------------
> > > > > > 
> > > > > > [  217.951079] usb 1-5: new full-speed USB device number 10 using xhci_hcd
> > > > > > [  218.104087] usb 1-5: device descriptor read/64, error -71
> > > > > > [  218.371010] usb 1-5: config 1 interface 0 altsetting 0 endpoint 0x1 has an invalid bInterval 0, changing to 32
> > > > > > [  218.371019] usb 1-5: config 1 interface 0 altsetting 0 endpoint 0x81 has an invalid bInterval 0, changing to 32  
> > > > > 
> > > > > That's odd. Can you post a "lsusb -vvv" of the device please?
> > > > >   
> > > > 
> > > > Sure.
> > > > 
> > > > -------------------
> > > > 
> > > > Bus 002 Device 009: ID 1784:0006 TopSeed Technology Corp. eHome Infrared Transceiver
> > > > Device Descriptor:
> > > >   bLength                18
> > > >   bDescriptorType         1
> > > >   bcdUSB               2.00
> > > >   bDeviceClass            0 
> > > >   bDeviceSubClass         0 
> > > >   bDeviceProtocol         0 
> > > >   bMaxPacketSize0         8
> > > >   idVendor           0x1784 TopSeed Technology Corp.
> > > >   idProduct          0x0006 eHome Infrared Transceiver
> > > >   bcdDevice            1.02
> > > >   iManufacturer           1 TopSeed Technology Corp.
> > > >   iProduct                2 eHome Infrared Transceiver
> > > >   iSerial                 3 TS004RrP
> > > >   bNumConfigurations      1
> > > >   Configuration Descriptor:
> > > >     bLength                 9
> > > >     bDescriptorType         2
> > > >     wTotalLength           32
> > > >     bNumInterfaces          1
> > > >     bConfigurationValue     1
> > > >     iConfiguration          0 
> > > >     bmAttributes         0xa0
> > > >       (Bus Powered)
> > > >       Remote Wakeup
> > > >     MaxPower              100mA
> > > >     Interface Descriptor:
> > > >       bLength                 9
> > > >       bDescriptorType         4
> > > >       bInterfaceNumber        0
> > > >       bAlternateSetting       0
> > > >       bNumEndpoints           2
> > > >       bInterfaceClass       255 Vendor Specific Class
> > > >       bInterfaceSubClass    255 Vendor Specific Subclass
> > > >       bInterfaceProtocol    255 Vendor Specific Protocol
> > > >       iInterface              0 
> > > >       Endpoint Descriptor:
> > > >         bLength                 7
> > > >         bDescriptorType         5
> > > >         bEndpointAddress     0x01  EP 1 OUT
> > > >         bmAttributes            3
> > > >           Transfer Type            Interrupt
> > > >           Synch Type               None
> > > >           Usage Type               Data
> > > >         wMaxPacketSize     0x0020  1x 32 bytes
> > > >         bInterval               0  
> > > 
> > > That's wrong indeed. It might be interesting to see if there is anything
> > > in the xhci debug messages with (in Fedora 23):
> > > 
> > > echo "file xhci*.c +p" > /sys/kernel/debug/dynamic_debug/control
> > > echo "file mceusb.c +p" > /sys/kernel/debug/dynamic_debug/control
> > > 
> > > And then plug in the receiver, and try to send IR to it with a remote.
> > > You should have quite a few kernel messages in the journal.  
> > 
> > Here's the output after enabling the debug options, plugging in the
> > receiver, running lircd, and pressing some remote buttons:
> >  
> 
> [snip]
> 
> > 
> > I'm not sure what to look for... ?
> >   
> > >   
> > > >       Endpoint Descriptor:
> > > >         bLength                 7
> > > >         bDescriptorType         5
> > > >         bEndpointAddress     0x81  EP 1 IN
> > > >         bmAttributes            3
> > > >           Transfer Type            Interrupt
> > > >           Synch Type               None
> > > >           Usage Type               Data
> > > >         wMaxPacketSize     0x0020  1x 32 bytes
> > > >         bInterval               0
> > > > Device Status:     0x0001
> > > >   Self Powered
> > > > 
> > > > -------------------
> > > > 
> > > > Also, here's a link to a response on the lirc list:
> > > > 
> > > > https://sourceforge.net/p/lirc/mailman/message/35039126/  
> > > 
> > > That seems suggest that mode2 works but lirc does not. It would be nice
> > > if that could be narrowed down a bit.  
> > 
> > That message above links to some other threads describing the issue.
> > Here's a post with a patch that supposedly works:
> > 
> > http://www.gossamer-threads.com/lists/mythtv/users/587930
> > 
> > No idea if that's the "correct" way to fix this.
> > 
> > I'll be trying that out and then report back...  
> 
> Indeed, this patch does fix the issue:
> 
> ----------------------
> 
> diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
> index 31ccdcc..03321d4 100644
> --- a/drivers/usb/core/config.c
> +++ b/drivers/usb/core/config.c
> @@ -247,7 +247,7 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno, int inum,
>  			/* For low-speed, 10 ms is the official minimum.
>  			 * But some "overclocked" devices might want faster
>  			 * polling so we'll allow it. */
> -			n = 32;
> +			n = 10;
>  			break;
>  		}
>  	} else if (usb_endpoint_xfer_isoc(d)) {
> 
> 
> ----------------------
> 
> Is this change appropriate to be pushed upstream?  Where to go from
> here?

This issue is at the USB core. So, it should be reported to the
linux-usb mailing list. 

The people there should help about how to proceed to get this
fixed upstream.

Regards,
Mauro

Thanks,
Mauro
