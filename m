Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61729 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751324AbeAZORt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 09:17:49 -0500
Date: Fri, 26 Jan 2018 12:17:37 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        John Youn <johnyoun@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Grigor Tovmasyan <Grigor.Tovmasyan@synopsys.com>
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180126121737.70710f02@vela.lan>
In-Reply-To: <Pine.LNX.4.44L0.1801081354450.1908-100000@iolanthe.rowland.org>
References: <CA+55aFx90oOU-3R8pCeM0ESTDYhmugD5znA9LrGj1zhazWBtcg@mail.gmail.com>
        <Pine.LNX.4.44L0.1801081354450.1908-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

Em Mon, 8 Jan 2018 14:15:35 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> escreveu:

> On Mon, 8 Jan 2018, Linus Torvalds wrote:
> 
> > Can somebody tell which softirq it is that dvb/usb cares about?  
> 
> I don't know about the DVB part.  The USB part is a little difficult to
> analyze, mostly because the bug reports I've seen are mostly from
> people running non-vanilla kernels. 

I suspect that the main reason for people not using non-vanilla Kernels
is that, among other bugs, the dwc2 upstream driver has serious troubles
handling ISOCH traffic.

Using Kernel 4.15-rc7 from this git tree:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=softirq_fixup

(e. g. with the softirq bug partially reverted with Linux patch, and
 the DWC2 deferred probe fixed)

With a PCTV 461e device, with uses em28xx driver + Montage frontend
(with is the same used on dvbsky hardware - except for em28xx).

This device doesn't support bulk for DVB, just ISOCH. The drivers work 
fine on x86.

Using a test signal at the bit rate of 56698,4 Kbits/s, that's what
happens, when capturing less than one second of data:

$ dvbv5-zap -c ~/dvb_channel.conf "tv brasil" -l universal -X 100 -m -t2dvbv5-zap -c ~/dvb_channel.conf "tv brasil" -l universal -X 100 -m -t2
Using LNBf UNIVERSAL
	Universal, Europe
	Freqs     : 10800 to 11800 MHz, LO: 9750 MHz
	Freqs     : 11600 to 12700 MHz, LO: 10600 MHz
using demux 'dvb0.demux0'
reading channels from file '/home/mchehab/dvb_channel.conf'
tuning to 11468000 Hz
       (0x00) Signal= -33.90dBm
Lock   (0x1f) Signal= -33.90dBm C/N= 30.28dB postBER= 2.33x10^-6
dvb_dev_set_bufsize: buffer set to 6160384
  dvb_set_pesfilter to 0x2000
354.08s: Starting capture
354.73s: only read 59220 bytes
354.73s: Stopping capture

[  354.000827] dwc2 3f980000.usb: DWC OTG HCD EP DISABLE: bEndpointAddress=0x84, ep->hcpriv=116f41b2
[  354.000859] dwc2 3f980000.usb: DWC OTG HCD EP RESET: bEndpointAddress=0x84
[  354.010744] dwc2 3f980000.usb: --Host Channel 5 Interrupt: Frame Overrun--
... (hundreds of thousands of Frame Overrun messages)
[  354.660857] dwc2 3f980000.usb: --Host Channel 5 Interrupt: Frame Overrun--
[  354.660935] dwc2 3f980000.usb: DWC OTG HCD URB Dequeue
[  354.660959] dwc2 3f980000.usb: Called usb_hcd_giveback_urb()
[  354.660966] dwc2 3f980000.usb:   urb->status = 0
[  354.660992] dwc2 3f980000.usb: DWC OTG HCD URB Dequeue
[  354.661001] dwc2 3f980000.usb: Called usb_hcd_giveback_urb()
[  354.661008] dwc2 3f980000.usb:   urb->status = 0
[  354.661054] dwc2 3f980000.usb: DWC OTG HCD URB Dequeue
[  354.661065] dwc2 3f980000.usb: Called usb_hcd_giveback_urb()
[  354.661072] dwc2 3f980000.usb:   urb->status = 0
[  354.661107] dwc2 3f980000.usb: DWC OTG HCD URB Dequeue
[  354.661120] dwc2 3f980000.usb: Called usb_hcd_giveback_urb()
[  354.661127] dwc2 3f980000.usb:   urb->status = 0
[  354.661146] dwc2 3f980000.usb: DWC OTG HCD URB Dequeue
[  354.661158] dwc2 3f980000.usb: Called usb_hcd_giveback_urb()
[  354.661165] dwc2 3f980000.usb:   urb->status = 0

Kernel was compiled with:

CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_HOST=y
# CONFIG_USB_DWC2_PERIPHERAL is not set
# CONFIG_USB_DWC2_DUAL_ROLE is not set
# CONFIG_USB_DWC2_PCI is not set
CONFIG_USB_DWC2_DEBUG=y
# CONFIG_USB_DWC2_VERBOSE is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_DWC2_DEBUG_PERIODIC=y

As reference, that's the output of lsusb for the PCTV usb hardware:

$ lsusb -v -d 2013:0258

Bus 001 Device 005: ID 2013:0258 PCTV Systems 
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x2013 PCTV Systems
  idProduct          0x0258 
  bcdDevice            1.00
  iManufacturer           3 
  iProduct                1 
  iSerial                 2 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           41
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x03ac  1x 940 bytes
        bInterval               1

Cheers,
Mauro
