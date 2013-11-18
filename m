Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm15-vm4.access.bullet.mail.gq1.yahoo.com ([216.39.63.103]:39107
	"EHLO nm15-vm4.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab3KRDaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 22:30:22 -0500
From: "Tim E. Real" <termtech@rogers.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: SAA7134 driver reports zero frame rate
Date: Sun, 17 Nov 2013 22:23:21 -0500
Message-ID: <2745497.8HnslFDkl4@col-desktop>
In-Reply-To: <CAGoCfiy0nQdd1u4XHS-sem9QObbPgmaLC3cHhVQPqe0PoJeLVg@mail.gmail.com>
References: <1802041.4NDiOr0LmV@col-desktop> <CAGoCfiy0nQdd1u4XHS-sem9QObbPgmaLC3cHhVQPqe0PoJeLVg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On November 16, 2013 10:21:03 PM you wrote:
> On Sat, Nov 16, 2013 at 6:19 PM, Tim E. Real <termtech@rogers.com> wrote:
> > The SAA7134 driver causes libav to crash because the
> > 
> >  driver reports zero frame rate.
> > 
> > Thus it is virtually impossible to do any recording.
> 
> Step #1:  Open a bug against libav.  The app should return an error or
> not let you start streaming.  If it crashes (regardless of the
> underlying reason), they've got a bug in their library.
> 
> > About a year ago I debugged and found I had to do this,
> > 
> >  (but it was not enough, more fixes would be needed):
> > In libav/libavdevice/v4l2.c :
> > 
> > static int v4l2_set_parameters(AVFormatContext *s1, AVFormatParameters
> > *ap)
> > {
> > ...
> > 
> >     s1->streams[0]->codec->time_base.den = tpf->denominator;
> >     s1->streams[0]->codec->time_base.num = tpf->numerator;
> >     
> >     // By Tim. BUG: The saa7134 driver (at least) reports zero framerate,
> >     //  causing abort in rescale. So just force it.
> >     if(s1->streams[0]->codec->time_base.den == 0 ||
> >     
> >         s1->streams[0]->codec->time_base.num == 0)
> >     
> >     {
> >     
> >       s1->streams[0]->codec->time_base.num = 1;
> >       s1->streams[0]->codec->time_base.den = 30;
> >     
> >     }
> >     
> >     s->timeout = 100 +
> >     
> >         av_rescale_q(1, s1->streams[0]->codec->time_base,
> >         
> >                         (AVRational){1, 1000});
> >     
> >     return 0;
> > 
> > }
> > 
> > I looked at the SAA7134 module parameters but couldn't seem to
> > 
> >  find anything to help.
> > 
> > Does anyone know how to make the module work so it sets a proper
> > 
> >  frame rate, or if this problem been fixed recently?
> 
> Have you tried it with the latest kernel?  Many of the drivers have
> had fixes in the last year for V4L2 conformance, so it's possible this
> was already fixed.
> 
> I would recommend you try it with the latest kernel and see if it
> still happens.  If it does still occur, then somebody can dig into it
> (assuming they have time/energy/inclination).
> 
> I'm not arguing that you probably found a bug, but you'll have to do a
> bit more of the legwork to make sure it's still a real issue before
> somebody else gets involved.
> 
> Devin

Thanks, you're right I should test some more, it has been a year since.
Seem to have somewhat better luck with mencoder vs libav, at least 
 it doesn't crash. 
Possibly it's up to the app to tell the driver what frame rate to expect,
 so maybe I'm not supplying the right parameters in the first place...

Tim.
