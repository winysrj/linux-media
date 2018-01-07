Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:43850 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752956AbeAGLDw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 Jan 2018 06:03:52 -0500
Date: Sun, 7 Jan 2018 09:03:36 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
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
        <torvalds@linux-foundation.org>
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180107090336.03826df2@vento.lan>
In-Reply-To: <Pine.LNX.4.44L0.1801061638220.12069-100000@netrider.rowland.org>
References: <20180106175420.275e24e7@recife.lan>
        <Pine.LNX.4.44L0.1801061638220.12069-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 6 Jan 2018 16:44:20 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> escreveu:

> On Sat, 6 Jan 2018, Mauro Carvalho Chehab wrote:
> 
> > Hi Josef,
> > 
> > Em Sat, 6 Jan 2018 16:04:16 +0100
> > "Josef Griebichler" <griebichler.josef@gmx.at> escreveu:
> >   
> > > Hi,
> > > 
> > > the causing commit has been identified.
> > > After reverting commit https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4cd13c21b207e80ddb1144c576500098f2d5f882
> > > its working again.  
> > 
> > Just replying to me won't magically fix this. The ones that were involved on
> > this patch should also be c/c, plus USB people. Just added them.
> >   
> > > Please have a look into the thread https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?pageNo=13
> > > here are several users aknowledging the revert solves their issues with usb dvb cards.  
> > 
> > I read the entire (long) thread there. In order to make easier for the
> > others, from what I understand, the problem happens on both x86 and arm,
> > although almost all comments there are mentioning tests with raspbian
> > Kernel (with uses a different USB host driver than the upstream one).
> > 
> > It happens when watching digital TV DVB-C channels, with usually means
> > a sustained bit rate of 11 MBps to 54 MBps.
> > 
> > The reports mention the dvbsky, with uses USB URB bulk transfers.
> > On every several minutes (5 to 10 mins), the stream suffer "glitches"
> > caused by frame losses.
> > 
> > The part of the thread that contains the bisect is at:
> > 	https://forum.libreelec.tv/thread/4235-dvb-issue-since-le-switched-to-kernel-4-9-x/?postID=75965#post75965
> > 
> > It indirectly mentions another comment on the thread with points
> > to:
> > 	https://github.com/raspberrypi/linux/issues/2134
> > 
> > There, it says that this fix part of the issues:
> > 	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=34f41c0316ed52b0b44542491d89278efdaa70e4
> > 
> > but it affects URB packet losses on a lesser extend.
> > 
> > The main issue is really the logic changes a the core softirq logic.
> > 
> > Using Kernel 4.14.10 on a Raspberry Pi 3 with 4cd13c2 commit reverted
> > fixed the issue. 
> > 
> > Joseph, is the above right? Anything else to mention? Does the
> > same issue affect also on x86 with vanilla Kernel 4.14.10?
> > 
> > -
> > 
> > It seems that the original patch were designed to solve some IRQ issues
> > with network cards with causes data losses on high traffic. However,
> > it is also causing bad effects on sustained high bandwidth demands
> > required by DVB cards, at least on some USB host drivers.
> > 
> > Alan/Greg/Eric/David:
> > 
> > Any ideas about how to fix it without causing regressions to
> > network?  
> 
> It would be good to know what hardware was involved on the x86 system
> and to have some timing data.  Can we see the output from lsusb and
> usbmon, running on a vanilla kernel that gets plenty of video glitches?

>From Josef's report, and from the BZ, the affected hardware seems
to be based on Montage Technology M88DS3103/M88TS2022 chipset.
The driver it uses is at drivers/media/usb/dvb-usb-v2/dvbsky.c,
with shares a USB implementation that is used by a lot more drivers.
The URB handling code is at:

	drivers/media/usb/dvb-usb-v2/usb_urb.c

This particular driver allocates 8 buffers with 4096 bytes each
for bulk transfers, using transfer_flags = URB_NO_TRANSFER_DMA_MAP.

This become a popular USB hardware nowadays. I have one S960c
myself, so I can send you the lsusb from it. You should notice, however,
that a DVB-C/DVB-S2 channel can easily provide very high sustained bit
rates. Here, on my DVB-S2 provider, a typical transponder produces 58 Mpps
of payload after removing URB headers. A 10 minutes record with the
entire data (with typically contains 5-10 channels) can easily go
above 4 GB, just to reproduce 1-2 glitches. So, I'm not sure if
a usbmon dump would be useful.

I'm enclosing the lsusb from a S960C device, with is based on those
Montage chipsets:

Bus 002 Device 007: ID 0572:960c Conexant Systems (Rockwell), Inc. DVBSky S960C DVB-S2 tuner
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0572 Conexant Systems (Rockwell), Inc.
  idProduct          0x960c DVBSky S960C DVB-S2 tuner
  bcdDevice            0.00
  iManufacturer           1 
  iProduct                2 
  iSerial                 3 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          219
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x13f2  3x 1010 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       2
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x12d6  3x 726 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       3
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x12ae  3x 686 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       4
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x03ca  1x 970 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       5
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x02ac  1x 684 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       6
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x03ac  1x 940 bytes
        bInterval               1

> Overall, this may be a very difficult problem to solve.  The
> 4cd13c21b207 commit was intended to improve throughput at the cost of
> increased latency.  But then what do you do when the latency becomes
> too high for the video subsystem to handle?

Latency can't be too high, otherwise frames will be dropped.
Even if the Kernel itself doesn't drop, if the delay goes higher
than a certain threshold, userspace will need to drop, as it
should be presenting audio and video on real time. Yet, typically,
userspace will delay it by one or two seconds, with would mean
1500-3500 buffers, with I suspect it is a lot more than the hardware
limits. So I suspect that the hardware starves free buffers a way 
before userspace, as media hardware don't have unlimited buffers
inside them, as they assume that the Kernel/userspace will be fast
enough to sustain bit rates up to 66 Mbps of payload.

Perhaps media drivers could pass some quirk similar to URB_ISO_ASAP,
in order to revert the kernel logic to prioritize latency instead of
throughput.

Thanks,
Mauro
