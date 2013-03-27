Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:51357 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3C0R46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 13:56:58 -0400
Received: by mail-ee0-f44.google.com with SMTP id l10so4577934eei.31
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 10:56:57 -0700 (PDT)
Date: Wed, 27 Mar 2013 19:57:49 +0200
From: Timo Teras <timo.teras@iki.fi>
To: Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130327195749.4fbd4ae1@vostro>
In-Reply-To: <51532E56.9070108@googlemail.com>
References: <20130325190846.3250fe98@vostro>
	<51532E56.9070108@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 Mar 2013 18:37:26 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> wrote:

> Am 25.03.2013 18:08, schrieb Timo Teras:
> > I just bought a Terratec Grabby hardware revision 2 in hopes that it
> > would work on my linux box.
> >
> > But alas, I got only sound working. It seems that analog video
> > picture grabbing does not work.
> >
> > I tried kernels 3.4.34-grsec, 3.7.1 (vanilla), 3.8.2-grsec and
> > 3.9.0-rc4 (vanilla). And all fail the same way - no video data
> > received.
> >
> > The USB ID is same as on the revision 1 board:
> > Bus 005 Device 002: ID 0ccd:0096 TerraTec Electronic GmbH
> >
> > And it is properly detected as Grabby.
> >
> > It seems that the videobuf2 changes for 3.9.0-rc4 resulted in better
> > debug logging, and it implies that the application (ffmpeg 1.1.4) is
> > behaving well: all buffers are allocated, mmapped, queued, streamon
> > called. But no data is received from the dongle. I also tested
> > mencoder and it fails in similar manner.
> >
> > Dmesg (on 3.9.0-rc4) tells after module load the following:
> >  
> > [ 1249.600246] em28xx: New device TerraTec Electronic GmbH TerraTec
> > Grabby @ 480 Mbps (0ccd:0096, inte rface 0, class 0)
> > [ 1249.600258] em28xx: Video interface 0 found: isoc
> > [ 1249.600264] em28xx: DVB interface 0 found: isoc
> 
> Hmm... yet another device where we detect a DVB endpoint (which is
> obviously wrong)...
> Could you please post the output of lsusb -v -d 0ccd:0096 ?

# lsusb -vvv -d 0ccd:0096

Bus 005 Device 028: ID 0ccd:0096 TerraTec Electronic GmbH 
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0ccd TerraTec Electronic GmbH
  idProduct          0x0096 
  bcdDevice            1.00
  iManufacturer           2 
  iProduct                1 
  iSerial                 0 
  bNumConfigurations      1
Couldn't get configuration descriptor 0, some information will be missing
Couldn't get configuration descriptor 0, some information will be missing

The errors are weird. strace gives:
open("/dev/bus/usb/005/028", O_RDONLY)  = -1 ENOENT (No such file or directory)
open("/dev/bus/usb/005/028", O_RDONLY)  = -1 ENOENT (No such file or directory)

# ls  /dev/bus/usb/005/
001  003  013
