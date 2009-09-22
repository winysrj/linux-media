Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:42590 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbZIVJMg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 05:12:36 -0400
Received: by yxe37 with SMTP id 37so4035083yxe.33
        for <linux-media@vger.kernel.org>; Tue, 22 Sep 2009 02:12:40 -0700 (PDT)
Date: Tue, 22 Sep 2009 11:12:35 +0200
From: Uros Vampl <mobile.leecher@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: Questions about Terratec Hybrid XS (em2882) [0ccd:005e]
Message-ID: <20090922091235.GA10335@zverina>
References: <20090913193118.GA12659@zverina>
 <20090921204418.GA19119@zverina>
 <829197380909211349r68b92b3em577c02d0dee9e4fc@mail.gmail.com>
 <20090921221505.GA5187@zverina>
 <829197380909211529r7ff7eab0nccc8d5fd55516ca2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <829197380909211529r7ff7eab0nccc8d5fd55516ca2@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21.09.09 18:29, Devin Heitmueller wrote:
> On Mon, Sep 21, 2009 at 6:15 PM, Uros Vampl <mobile.leecher@gmail.com> wrote:
> > I tried arecord/aplay and sox with tvtime, and also mplayer (which
> > has
> > built-in audio support). I know about these tricks, I've used them
> > successfully with Markus' em28xx-new driver. But with v4l-dvb it's as I
> > said, audio is there but it's extremely quiet. If you have suggestions
> > how I should try to diagnoze this, I'm all ears.
> >
> > Regards,
> > Uroš
> 
> If the audio is present but very quiet, then it's probably some issue
> you are having with your mixer.  I would check your ALSA and
> PulseAudio configuration (in particular the mixer volume controls).
> 
> Devin

No PulseAudio here. And I've played plenty with the ALSA mixer, all the 
sliders that are there.

Using em28xx-new instead of v4l-dvb, all else being equal, tv volume is 
fine. So there's gotta be a difference somewhere in the way em28xx-new 
sets up audio compared to how v4l-dvb does it.

Regards,
Uroš
