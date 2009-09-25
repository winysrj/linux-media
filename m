Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52708 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZIYRWR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2009 13:22:17 -0400
Received: by fxm18 with SMTP id 18so2373267fxm.17
        for <linux-media@vger.kernel.org>; Fri, 25 Sep 2009 10:22:20 -0700 (PDT)
Date: Fri, 25 Sep 2009 19:22:09 +0200
From: Uros Vampl <mobile.leecher@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: Questions about Terratec Hybrid XS (em2882) [0ccd:005e]
Message-ID: <20090925172209.GA10054@zverina>
References: <20090913193118.GA12659@zverina>
 <20090921204418.GA19119@zverina>
 <829197380909211349r68b92b3em577c02d0dee9e4fc@mail.gmail.com>
 <20090921221505.GA5187@zverina>
 <829197380909211529r7ff7eab0nccc8d5fd55516ca2@mail.gmail.com>
 <20090922091235.GA10335@zverina>
 <829197380909221647p33236306ked2137a35707646d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <829197380909221647p33236306ked2137a35707646d@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.09.09 19:47, Devin Heitmueller wrote:
> >> If the audio is present but very quiet, then it's probably some issue
> >> you are having with your mixer.  I would check your ALSA and
> >> PulseAudio configuration (in particular the mixer volume controls).
> >>
> >> Devin
> >
> > No PulseAudio here. And I've played plenty with the ALSA mixer, all the
> > sliders that are there.
> >
> > Using em28xx-new instead of v4l-dvb, all else being equal, tv volume is
> > fine. So there's gotta be a difference somewhere in the way em28xx-new
> > sets up audio compared to how v4l-dvb does it.
> 
> Interesting.  Have you tried the A/V inputs (as opposed to the tuner)?
>  That might help us identify whether it's an issue with the xc3028
> tuner chip extracting the audio carrier or whether it's something
> about the way we are programming the emp202.


Hello,

That was a great idea. Tested with a Playstation2 and audio is ok. It's 
just TV input that has a problem. So I guess that means the issue is 
with the tuner chip. That's progress. Where do I go from here?

Regards,
Uroš
