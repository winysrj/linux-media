Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:54520 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3KQDVF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Nov 2013 22:21:05 -0500
Received: by mail-we0-f176.google.com with SMTP id w62so4910985wes.21
        for <linux-media@vger.kernel.org>; Sat, 16 Nov 2013 19:21:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1802041.4NDiOr0LmV@col-desktop>
References: <1802041.4NDiOr0LmV@col-desktop>
Date: Sat, 16 Nov 2013 22:21:03 -0500
Message-ID: <CAGoCfiy0nQdd1u4XHS-sem9QObbPgmaLC3cHhVQPqe0PoJeLVg@mail.gmail.com>
Subject: Re: SAA7134 driver reports zero frame rate
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Tim E. Real" <termtech@rogers.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 16, 2013 at 6:19 PM, Tim E. Real <termtech@rogers.com> wrote:
> The SAA7134 driver causes libav to crash because the
>  driver reports zero frame rate.
> Thus it is virtually impossible to do any recording.

Step #1:  Open a bug against libav.  The app should return an error or
not let you start streaming.  If it crashes (regardless of the
underlying reason), they've got a bug in their library.

> About a year ago I debugged and found I had to do this,
>  (but it was not enough, more fixes would be needed):
>
> In libav/libavdevice/v4l2.c :
>
> static int v4l2_set_parameters(AVFormatContext *s1, AVFormatParameters *ap)
> {
> ...
>     s1->streams[0]->codec->time_base.den = tpf->denominator;
>     s1->streams[0]->codec->time_base.num = tpf->numerator;
>
>     // By Tim. BUG: The saa7134 driver (at least) reports zero framerate,
>     //  causing abort in rescale. So just force it.
>     if(s1->streams[0]->codec->time_base.den == 0 ||
>         s1->streams[0]->codec->time_base.num == 0)
>     {
>       s1->streams[0]->codec->time_base.num = 1;
>       s1->streams[0]->codec->time_base.den = 30;
>     }
>
>     s->timeout = 100 +
>         av_rescale_q(1, s1->streams[0]->codec->time_base,
>                         (AVRational){1, 1000});
>
>     return 0;
> }
>
> I looked at the SAA7134 module parameters but couldn't seem to
>  find anything to help.
>
> Does anyone know how to make the module work so it sets a proper
>  frame rate, or if this problem been fixed recently?

Have you tried it with the latest kernel?  Many of the drivers have
had fixes in the last year for V4L2 conformance, so it's possible this
was already fixed.

I would recommend you try it with the latest kernel and see if it
still happens.  If it does still occur, then somebody can dig into it
(assuming they have time/energy/inclination).

I'm not arguing that you probably found a bug, but you'll have to do a
bit more of the legwork to make sure it's still a real issue before
somebody else gets involved.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
