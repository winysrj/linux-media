Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50371 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZIWT2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2009 15:28:10 -0400
Received: by fxm18 with SMTP id 18so882894fxm.17
        for <linux-media@vger.kernel.org>; Wed, 23 Sep 2009 12:28:13 -0700 (PDT)
Date: Wed, 23 Sep 2009 22:28:10 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: xc2028 sound carrier detection
Message-ID: <20090923192810.GA4653@moon>
References: <20090921223751.GA1303@moon> <20090921215238.2e189d60@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921215238.2e189d60@pedra.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 21, 2009 at 09:52:38PM -0300, Mauro Carvalho Chehab wrote:
> Em Tue, 22 Sep 2009 01:37:51 +0300
> "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com> escreveu:
> 
> > Is xc2028 tuner able to autodetect/handle different sound carrier standards
> > without being spoon-fed precise input system information using module param
> > or ioctl?
> > 
> > Got an ivtv board here (AverTV MCE 116) with xc2028 and cx25843.
> > 
> > When I specify a generic standard using 'v4l2-ctl -s pal', xc2028 loads
> > firmware specific to PAL-BG, so if there is an PAL-DK or PAL-I signal on RF
> > input... nice picture but no sound. Setting a more precise standard like
> > 'v4l2-ctl -s pal-dk' fixes the issue, but other PAL-BG or PAL-I channels
> > loose sound.
> > 
> > Bttv board with a tin-can tuner sitting on the same RF source autodetects
> > PAL-BG, PAL-DK and PAL-I without any manual intervention.
> > 
> > So any voodoo tricks to get the autodetection running?
> 
> No, sorry. It requires specific and different firmwares based on your video
> standard. I suspect that it is due to some firmware limiting size, since newer
> products from Xceive, like xc5000 don't have such troubles, but this is just my
> guess.

Mmm, tested that tuner under windows, it autodetects all 3 sound carrier sub-
standards instantly: PAL-BG, PAL-DK, PAL-I.

In order to test, I connected ancient Panasonic VCR that has a built-in tuner
and can output video to RF-OUT on fixed frequency using PAL standard. Sound
carrier frequency can be choosen using hardware switch BG, DK or I.

So under windows: tuner produces clear audio in BG, DK and I, hardware switch
can be toggled on fly, audio never stops, only a few miliseconds of static on
switch.

Under linux: audio only works if driver is set to use specific audio carrier
sub-standard AND same is selected on PVR. (not to mention extremely unreliable
PAL-DK detection by cx25843, only works 50% of times, but thats another issue)

Either a more generic firmware exists can be uploaded on xc2028.. or several
can be uploaded at once. Any xc2028 gurus out there?
