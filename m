Return-path: <mchehab@pedra>
Received: from uucp.cirr.com ([192.67.63.5]:65136 "EHLO killer.cirr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab0JMMLp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 08:11:45 -0400
Received: from afc by tashi.lonestar.org with local (Exim 4.69)
	(envelope-from <afc@shibaya.lonestar.org>)
	id 1P5sKU-0002Ko-Qw
	for linux-media@vger.kernel.org; Tue, 12 Oct 2010 23:48:38 -0400
Date: Tue, 12 Oct 2010 23:48:38 -0400
From: "A. F. Cano" <afc@shibaya.lonestar.org>
To: linux-media@vger.kernel.org
Subject: Re: s-video input from terratec cinergy 200 gives black frame or
	out of sync video
Message-ID: <20101013034838.GA5502@shibaya.lonestar.org>
References: <AANLkTik-PXRnbzhF_4hPW2y=2h6Vnht9VsCtsBHcpFHG@mail.gmail.com> <AANLkTinqQy-iWrWxwqUZTPc_5qWonFLG9NKphZthutic@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinqQy-iWrWxwqUZTPc_5qWonFLG9NKphZthutic@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Oct 12, 2010 at 06:31:53PM +0200, Antonio-Blasco Bonito wrote:
> I got no answer. Why? I thought it was correct to ask my question on
> this list... Did I ask it in a wrong way?

I don't think so.  It's likely that no one has a good answer/solution.

I don't use the same usb device you're using so I can't be of much help,
unfortunately.  However, with my own usb device (OnAir Creator) I also
encounter the black screen when trying to display from the composite
input.  I have been in contact with one of the developers but I now
need to test under Windows and I don't have access to windows machines,
so that's the holdup until I manage to find one where I could install
the manufacturer's driver and software.  You might try your setup under
windows, if you have access to such a machine.

When I asked about my black screen issue here, I was pointed to

http://www.isely.net/pvrusb2/usage.html#V4L

I have tried mplayer in pvr mode

$ mplayer -tv input=1:normid=16 pvr://

For my device, input=1 is the composite input, 2 is the S-video, but
the camera I'm connecting has only composite, no S-video, so I can't
test the S-video input.  Normid=16 is the first NTSC video standard,
NTSC-M if I remember correctly, but I tried all of them: no difference.

You might want to test with mplayer, it gives pretty verbose output and
it describes all the video standards supported and inputs of the device.
I see that you use PAL-DK.  Interesting that we have the same black
screen problem with different norms and different devices.  Does your
device supply an mpeg stream?  Mplayer in pvr mode detects the mpeg
stream.

It would be interesting to compare notes as we both try to figure this
out...

A.

> 
> 2010/10/10 Antonio-Blasco Bonito <blasco.bonito@gmail.com>
> >
> > I'm trying to use a Terratec Cinergy 200 usb board to grab analog video.
> > I'm using Ubuntu 10.04 and the included em28xx driver
> >
> > ...
> > $ v4lctl -c /dev/video1 setinput s-video
> > $ v4lctl -c /dev/video1 show
> > norm: PAL-DK
> > input: S-Video
> > audio mode: mono
> >
> > $ xawtv -c /dev/video1
> > I get nothing... a black frame :-(
> >

