Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:11690 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbZIUW3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 18:29:05 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1027489fge.1
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 15:29:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090921221505.GA5187@zverina>
References: <20090913193118.GA12659@zverina> <20090921204418.GA19119@zverina>
	 <829197380909211349r68b92b3em577c02d0dee9e4fc@mail.gmail.com>
	 <20090921221505.GA5187@zverina>
Date: Mon, 21 Sep 2009 18:29:07 -0400
Message-ID: <829197380909211529r7ff7eab0nccc8d5fd55516ca2@mail.gmail.com>
Subject: Re: Questions about Terratec Hybrid XS (em2882) [0ccd:005e]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 21, 2009 at 6:15 PM, Uros Vampl <mobile.leecher@gmail.com> wrote:
> I tried arecord/aplay and sox with tvtime, and also mplayer (which
> has
> built-in audio support). I know about these tricks, I've used them
> successfully with Markus' em28xx-new driver. But with v4l-dvb it's as I
> said, audio is there but it's extremely quiet. If you have suggestions
> how I should try to diagnoze this, I'm all ears.
>
> Regards,
> Uroš

If the audio is present but very quiet, then it's probably some issue
you are having with your mixer.  I would check your ALSA and
PulseAudio configuration (in particular the mixer volume controls).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
