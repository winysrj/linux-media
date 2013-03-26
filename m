Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47577 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256Ab3CZIUF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 04:20:05 -0400
Received: by mail-ee0-f45.google.com with SMTP id b57so3720009eek.32
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2013 01:20:04 -0700 (PDT)
Date: Tue, 26 Mar 2013 10:20:56 +0200
From: Timo Teras <timo.teras@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130326102056.63b55916@vostro>
In-Reply-To: <20130325211238.7c325d5e@vostro>
References: <20130325190846.3250fe98@vostro>
	<20130325143647.3da1360f@redhat.com>
	<20130325194820.7c122834@vostro>
	<20130325153220.3e6dbfe5@redhat.com>
	<20130325211238.7c325d5e@vostro>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 25 Mar 2013 21:12:38 +0200
Timo Teras <timo.teras@iki.fi> wrote:

> On Mon, 25 Mar 2013 15:32:20 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> > Em Mon, 25 Mar 2013 19:48:20 +0200
> > Timo Teras <timo.teras@iki.fi> escreveu:
> > 
> > > On Mon, 25 Mar 2013 14:36:47 -0300
> > > Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > > 
> > > > Em Mon, 25 Mar 2013 19:08:46 +0200
> > > > Timo Teras <timo.teras@iki.fi> escreveu:
> > > > 
> > > > > I just bought a Terratec Grabby hardware revision 2 in hopes
> > > > > that it would work on my linux box.
> > > > > 
> > > > > But alas, I got only sound working. It seems that analog video
> > > > > picture grabbing does not work.
> > > > > 
> > > > > I tried kernels 3.4.34-grsec, 3.7.1 (vanilla), 3.8.2-grsec and
> > > > > 3.9.0-rc4 (vanilla). And all fail the same way - no video data
> > > > > received.
> > > > > 
> > > > > The USB ID is same as on the revision 1 board:
> > > > > Bus 005 Device 002: ID 0ccd:0096 TerraTec Electronic GmbH
> > > > > 
> > > > > And it is properly detected as Grabby.
> > > > > 
> > > > > It seems that the videobuf2 changes for 3.9.0-rc4 resulted in
> > > > > better debug logging, and it implies that the application
> > > > > (ffmpeg 1.1.4) is behaving well: all buffers are allocated,
> > > > > mmapped, queued, streamon called. But no data is received from
> > > > > the dongle. I also tested mencoder and it fails in similar
> > > > > manner.
> > > > > 
> > > > > Dmesg (on 3.9.0-rc4) tells after module load the following:
> > > > >  
> > > > > [ 1250.076845] em2860 #0: AC97 vendor ID = 0x60f160f1
> > > > > [ 1250.086814] em2860 #0: AC97 features = 0x60f1
> > > > 
> > > > That looks weird on my eyes: 3 AC97 reads returned 0x60f1. I
> > > > suspect that the GPIOs for this device are different than on
> > > > version 1.
> > > 
> > > Yes, I just noticed this now too. It seems something went wrong
> > > when loading em28xx with a bunch of debug logging enabled. On
> > > normal load it returns instead:
> > > 
> > > [   12.453631] em2860 #0: AC97 vendor ID = 0x83847650
> > > [   12.463650] em2860 #0: AC97 features = 0x6a90
> > > [   12.463658] em2860 #0: Empia 202 AC97 audio processor detected
> > 
> > Weird. Except for an additional delay, those debug stuff shouldn't
> > be changing the driver's behavior.
> > 
> > Are those results consistent? There are some known problems with a
> > few em28xx devices that, from time to time, aren't able to read
> > data from the eeprom. On such devices, it is a hardware issue.
> 
> Actually it seems consistent that:
> 1. load em28xx -> attach USB -> fail
> 2. attach USB -> load em28xx -> success
> 
> Sounds like if the driver is loaded, it tries to access eeprom while
> it's still initializing or something like that.
> 
> > > > > Any suggestions how to debug/fix this?
> > > > 
> > > > The better is to run the original driver at a recent version of
> > > > KVM with USB port forward enabled, and capture the USB logs.
> > > > There are some pages at LinuxTV wiki explaining how to do it.
> > > 
> > > Oh, ok. Seems Wireshark/USBPcap might be better option for me as I
> > > don't have KVMed Windows install handy. Will try to get traces
> > > from it.
> > 
> > Ok, thanks!
> 
> Seems that USBPcap needs compiling and TESTSIGNING enabled - so I'd
> rather avoid it.
> 
> I did get etl format windows captures via "logman start usbtrace".
> Can you read those, or know anyway to convert them to text / something
> wireshark reads?

Seems not easily. And all the nice looking USB tracers cost money to
get anything out.

I did manage to get decent traces with USBlyzer evaluation version.

The output is at:
http://dev.alpinelinux.org/~tteras/grabby-rev2-init.html

I had to add by hand the 'R xx' notes (Setup Packet wIndex) in Request
Details for VendorDevice requests. Thus they are present only in the
ones close to when the Isoch transfer starts. If you need more of them,
let me know and I can paste them. Alternatively, I can dump the
USBlyzer format capture somewhere if you have a windows with the
program installed.

The sequence to create capture was:
 1. Attach USB device
 2. Start capture
 3. Start program that uses initiates video capture
 4. Stop program
 5. Stop capture

So it should contain everything done at "stream on" time.

- Timo
