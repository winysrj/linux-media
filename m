Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38423 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0JMRUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 13:20:33 -0400
Received: by ywi6 with SMTP id 6so1622843ywi.19
        for <linux-media@vger.kernel.org>; Wed, 13 Oct 2010 10:20:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101013034838.GA5502@shibaya.lonestar.org>
References: <AANLkTik-PXRnbzhF_4hPW2y=2h6Vnht9VsCtsBHcpFHG@mail.gmail.com>
	<AANLkTinqQy-iWrWxwqUZTPc_5qWonFLG9NKphZthutic@mail.gmail.com>
	<20101013034838.GA5502@shibaya.lonestar.org>
Date: Wed, 13 Oct 2010 19:20:09 +0200
Message-ID: <AANLkTinG5T_Dw6RNRVm-TPLU4vf5E4CvFp2ThF1_YMU_@mail.gmail.com>
Subject: Re: s-video input from terratec cinergy 200 gives black frame or out
 of sync video
From: Antonio-Blasco Bonito <blasco.bonito@gmail.com>
To: "A. F. Cano" <afc@shibaya.lonestar.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

AF Cano, many thanks for your answer!

I would also like someone to answer why the em28xx driver recognizes
my board differently whether connected when booting or after that.
And... what does it mean "em28xx #0: preparing read at i2c address
0x60 failed (error=-19)"?

2010/10/13 A. F. Cano <afc@shibaya.lonestar.org>:
> I don't use the same usb device you're using so I can't be of much help,
> unfortunately.  However, with my own usb device (OnAir Creator) I also
> encounter the black screen when trying to display from the composite
> input.  I have been in contact with one of the developers but I now
> need to test under Windows and I don't have access to windows machines,
> so that's the holdup until I manage to find one where I could install
> the manufacturer's driver and software.  You might try your setup under
> windows, if you have access to such a machine.

My device was supported under windows xp which I don't have at hands :-(
I tried using windows7 which recognizes the device and installs a
default driver. I downloded and run the Terratec Home Cinema
application: what I get is an out-of-sync video :-((


>
> When I asked about my black screen issue here, I was pointed to
>
> http://www.isely.net/pvrusb2/usage.html#V4L

I'm not able to get mplayer working with the "second method" i.e.
simply playing the video input from the board :-(
I can with xawtv and also vlc but what the best I get is an out-of-sync video

>
> I have tried mplayer in pvr mode
>
> $ mplayer -tv input=1:normid=16 pvr://
>
> For my device, input=1 is the composite input, 2 is the S-video, but
> the camera I'm connecting has only composite, no S-video, so I can't
> test the S-video input.  Normid=16 is the first NTSC video standard,
> NTSC-M if I remember correctly, but I tried all of them: no difference.
>
> You might want to test with mplayer, it gives pretty verbose output and
> it describes all the video standards supported and inputs of the device.
> I see that you use PAL-DK.  Interesting that we have the same black
> screen problem with different norms and different devices.  Does your
> device supply an mpeg stream?  Mplayer in pvr mode detects the mpeg
> stream.

Sorry, my device cannot supply an mpeg stream... in fact mplayer says:

Playing pvr://.
[v4l2] select channel list europe-east, entries 133
[pvr] Using device /dev/video1
[pvr] Detected Terratec Cinergy 200 USB
[encoder] device do not support MPEG input.
Failed to open pvr://.


-- 
Antonio-Blasco Bonito
Via Vico Fiaschi 35
54033 Carrara Avenza MS

tel. 0585-026169
cell. 340-6199450
