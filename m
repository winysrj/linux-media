Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:23192 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZEFSun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2009 14:50:43 -0400
Received: by yw-out-2324.google.com with SMTP id 5so161850ywb.1
        for <linux-media@vger.kernel.org>; Wed, 06 May 2009 11:50:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <247D2127-F564-4F55-A49D-3F0F8FA63112@gmail.com>
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
	 <247D2127-F564-4F55-A49D-3F0F8FA63112@gmail.com>
Date: Wed, 6 May 2009 14:50:43 -0400
Message-ID: <412bdbff0905061150g2e46f919i57823c8700252926@mail.gmail.com>
Subject: Re: XC5000 improvements: call for testers!
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Britney Fransen <britney.fransen@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 6, 2009 at 2:42 PM, Britney Fransen
<britney.fransen@gmail.com> wrote:
> Devin,
>
> I have an HVR-950q.
>
> Analog support is working much better for me.  I love the faster tuning.
>  Still no luck getting analog to work in MythTV.
>
> I am seeing some major regressions on the the digital side.  mplayer can't
> tune any digital channels and seems to be failing because it can't access
> the tuner.  In MythTV it does tune my QAM64 channel that previously would
> only tune with Frank's QAM64 patch. The other QAM256 channels either won't
> lock at all or if they do have bad pixelation and audio drops.  In
> mythtv-setup I can't do a channel scan because it says it can't open the
> card which seems similar to the problem mplayer had.  I had previously been
> using 11658 with the QAM64 patch.
>
> The 950q is definitely cooler to the touch.  Not a big deal but I did notice
> that the tune light that would light orange when tuned to a channel no
> longer lights up.
>
> Let me know if there is anything you would like me to try.
>
> Thanks,
> Britney

Ok, there is alot of information here.  Let me try to break it down.

First off, the QAM64 patches that Frank provided have not been merged
it.  It's on my todo list.

Has the MythTV situation gotten *worse* with this code compared to the
current v4l-dvb tip?  It would not surprise me if there are some
general MythTV issues with the 950q (I am in the process of building a
MythTV box so I can test/debug).  However, I would be surprised if
there were *new* issues.  I do know that mkrufky was mentioning there
was some sort of way to tell MythTV about hybrid devices, so that the
application doesn't try to use both the analog and digital at the same
time - and if you didn't do that then this could explain your issue.

Regarding the mplayer issue, please try this:

<unplug the 950q>
cd v4l-dvb
make unload
modprobe xc5000 no_poweroff=1
<plug in the 950q>

... and then see if mplayer still has issues.  This might be somehow
related to the firmware having to be reloaded taking too long for
mplayer (the firmware has to be reloaded when the chip is woken up
after being powered down).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
