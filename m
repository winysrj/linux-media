Return-path: <linux-media-owner@vger.kernel.org>
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:33744 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612Ab0AEEid (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 23:38:33 -0500
Received: from [192.168.1.100] (unverified [118.209.229.72])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id 10977689-1927428
	for <linux-media@vger.kernel.org>; Tue, 05 Jan 2010 14:53:24 +1030 (CDT)
Subject: Re: [linux-dvb] siano firmware and behaviour after resuming power
From: Rodd Clarkson <rodd@clarkson.id.au>
To: linux-media@vger.kernel.org
In-Reply-To: <4B17BF5B.7010400@ventoso.org>
References: <4B14CC1E.7030102@ventoso.org>
	 <alpine.DEB.2.01.0912030540570.4548@ybpnyubfg.ybpnyqbznva>
	 <4B177C81.5030900@ventoso.org>
	 <alpine.DEB.2.01.0912031303050.4548@ybpnyubfg.ybpnyqbznva>
	 <4B17BF5B.7010400@ventoso.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jan 2010 10:10:12 +1100
Message-ID: <1262387412.2574.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-12-03 at 14:38 +0100, Luca Olivetti wrote:
> En/na BOUWSMA Barry ha escrit:
> 
> >> I found a something here
> >>
> >> http://marc.info/?l=linux-usb-users&m=116827193506484&w=2
> >>
> >> that purportedly resets an usb device.
> >> What I tried was, before powering off:
> >>
> >> 1) unload the drivers
> >> 2) use the above to reset the stick
> >> 3) power off
> >>
> >> and, before loading the drivers, issue a reset again.
> >> Sometimes it works, sometimes it doesn't, the end result is that I cannot
> >> leave the device plugged-in if I want to use it.

I've also got a siano card, but in my case it's embedded in my Dell
laptop, so yanking it out and plugging it back in isn't even an option.

The card is however a USB device and I've included the lsusb -v output
at the end in case it's useful.

I've tried the firmware you're referring too, but there's also a request
for sms1xxx-nova-b-dvbt-01.fw in the dmesg and this is asked for first
(in my case), with a siano supplied one sought if it can't find this
first one.

I'm not having problems with cold restarts, but suspend/hibernate sees
the things go bad on resume.

I've added some stuff to /etc/pm/sleep.d which unloads the modules and
then reloads then on resume.  It's a simple script:

#!/bin/bash
case $1 in
 hibernate)
  echo "Suspending to disk"
  modprobe -r smsdvb
  modprobe -r smsusb
 ;;
 suspend)
  echo "Suspending to RAM"
  modprobe -r smsdvb
  modprobe -r smsusb
 ;;
 thaw)
  echo "Suspend to disk is over, Resuming..."
  modprobe smsdvb
  modprobe smsusb
 ;;
 resume)
  echo "Suspend to RAM is over, Resuming..."
  modprobe smsdvb
  modprobe smsusb
 ;;     
 *)     
  echo "somebody is calling me totally wrong."
 ;;     
esac

This addresses these problems for me.  You might be able to add
something similar to /etc/pm/power.d to unload modules to address the
problem.


Rodd



Bus 001 Device 003: ID 2040:1801 Hauppauge 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x2040 Hauppauge
  idProduct          0x1801 
  bcdDevice            0.01
  iManufacturer           1 Hauppauge Computer Works
  iProduct                2 WinTV-NOVA
  iSerial                 3 f05eb5ec
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
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
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
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
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)


