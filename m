Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:41013 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZEEAxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2009 20:53:34 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2431704ywb.1
        for <linux-media@vger.kernel.org>; Mon, 04 May 2009 17:53:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49FF85F1.5080600@wowway.com>
References: <49FF85F1.5080600@wowway.com>
Date: Mon, 4 May 2009 20:53:33 -0400
Message-ID: <412bdbff0905041753p744bf0b4n409989f9997703a9@mail.gmail.com>
Subject: Re: Hauppauge 950Q Analog (Composite Input) Problem
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: "John R." <johnr@wowway.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 4, 2009 at 8:18 PM, John R. <johnr@wowway.com> wrote:
> Hello,
>
> Actually, I am trying to use the analog composite input (not cable
> television) working.  Is this part of analog support?  Or is that for analog
> cable only?
>
> When I hook a video source up to the composite RCA jack and "mplayer
> /dev/video" it presents the following:
>
> MPlayer dev-SVN-r26753-4.1.2 (C) 2000-2008 MPlayer Team
> CPU: Intel(R) Pentium(R) M processor 1.20GHz (Family: 6, Model: 13,
> Stepping: 8)
> CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
> Compiled for x86 CPU with extensions: MMX MMX2 SSE SSE2
>
> Playing /dev/video.
>
> It just sits there.  Typing "cat /dev/video" does not produce any output.
>
> Linux aqui 2.6.29.2.  I am running hvr950q-analog-1bbabf78f9ef (downloaded a
> couple days ago).
>
> From log output everything seems good:
>
> May  4 18:52:19 aqui usb 1-1: new high speed USB device using ehci_hcd and
> address 5
> May  4 18:52:19 aqui usb 1-1: configuration #1 chosen from 1 choice
> May  4 18:52:20 aqui Linux video capture interface: v2.00
> May  4 18:52:20 aqui au0828 driver loaded
> May  4 18:52:20 aqui au0828: i2c bus registered
> May  4 18:52:20 aqui tveeprom 1-0050: Hauppauge model 72001, rev B3F0,
> serial# 6134581
> May  4 18:52:20 aqui tveeprom 1-0050: MAC address is 00-0D-FE-5D-9B-35
> May  4 18:52:20 aqui tveeprom 1-0050: tuner model is Xceive XC5000 (idx 150,
> type 76)
> May  4 18:52:20 aqui tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital
> (eeprom 0x88)
> May  4 18:52:20 aqui tveeprom 1-0050: audio processor is AU8522 (idx 44)
> May  4 18:52:20 aqui tveeprom 1-0050: decoder processor is AU8522 (idx 42)
> May  4 18:52:20 aqui tveeprom 1-0050: has no radio, has IR receiver, has no
> IR transmitter
> May  4 18:52:20 aqui hauppauge_eeprom: hauppauge eeprom: model=72001
> May  4 18:52:20 aqui au8522 1-0047: creating new instance
> May  4 18:52:20 aqui au8522_decoder creating new instance...
> May  4 18:52:20 aqui tuner 1-0061: chip found @ 0xc2 (au0828)
> May  4 18:52:20 aqui xc5000 1-0061: creating new instance
> May  4 18:52:20 aqui xc5000: Successfully identified at address 0x61
> May  4 18:52:20 aqui xc5000: Firmware has not been loaded previously
> May  4 18:52:20 aqui xc5000: waiting for firmware upload
> (dvb-fe-xc5000-1.1.fw)...
> May  4 18:52:20 aqui i2c-adapter i2c-1: firmware: requesting
> dvb-fe-xc5000-1.1.fw
> May  4 18:52:20 aqui xc5000: firmware read 12332 bytes.
> May  4 18:52:20 aqui xc5000: firmware upload
> May  4 18:52:31 aqui au8522 1-0047: attaching existing instance
> May  4 18:52:31 aqui xc5000 1-0061: attaching existing instance
> May  4 18:52:31 aqui xc5000: Successfully identified at address 0x61
> May  4 18:52:31 aqui xc5000: Firmware has been loaded previously
> May  4 18:52:31 aqui DVB: registering new adapter (au0828)
> May  4 18:52:31 aqui DVB: registering adapter 0 frontend 0 (Auvitek AU8522
> QAM/8VSB Frontend)...
> May  4 18:52:31 aqui Registered device AU0828 [Hauppauge HVR950Q]
> May  4 18:52:31 aqui usbcore: registered new interface driver au0828
>
> Thanks,
>
> John
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hello John,

That's not really how v4l2 capture works, in particular with devices
that do not provide an mpeg stream (you cannot just run "mplayer
/dev/video0").  You're not actually doing any sort of input selection,
so how are you expecting the driver to know to capture on the
composite input?

I would suggest you give the man page for mplayer a read, in
particular the options related to driver=v4l2.  If you still have
questions, email the ML.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
