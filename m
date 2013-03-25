Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:57240 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab3CYRra (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 13:47:30 -0400
Received: by mail-ee0-f53.google.com with SMTP id c13so634781eek.40
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 10:47:29 -0700 (PDT)
Date: Mon, 25 Mar 2013 19:48:20 +0200
From: Timo Teras <timo.teras@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130325194820.7c122834@vostro>
In-Reply-To: <20130325143647.3da1360f@redhat.com>
References: <20130325190846.3250fe98@vostro>
	<20130325143647.3da1360f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 25 Mar 2013 14:36:47 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em Mon, 25 Mar 2013 19:08:46 +0200
> Timo Teras <timo.teras@iki.fi> escreveu:
> 
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
> > [ 1250.076845] em2860 #0: AC97 vendor ID = 0x60f160f1
> > [ 1250.086814] em2860 #0: AC97 features = 0x60f1
> 
> That looks weird on my eyes: 3 AC97 reads returned 0x60f1. I suspect
> that the GPIOs for this device are different than on version 1.

Yes, I just noticed this now too. It seems something went wrong when
loading em28xx with a bunch of debug logging enabled. On normal load it
returns instead:

[   12.453631] em2860 #0: AC97 vendor ID = 0x83847650
[   12.463650] em2860 #0: AC97 features = 0x6a90
[   12.463658] em2860 #0: Empia 202 AC97 audio processor detected

> > Any suggestions how to debug/fix this?
> 
> The better is to run the original driver at a recent version of KVM
> with USB port forward enabled, and capture the USB logs. There are
> some pages at LinuxTV wiki explaining how to do it.

Oh, ok. Seems Wireshark/USBPcap might be better option for me as I
don't have KVMed Windows install handy. Will try to get traces from it.

- Timo
