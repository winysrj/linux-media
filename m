Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39637 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934355AbZKXXor (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 18:44:47 -0500
Subject: Re: [linux-dvb] Hauppauge PVR-150 Vertical sync issue?
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <34373e030911241005r7f499297y1a84a93e0696f550@mail.gmail.com>
References: <34373e030911241005r7f499297y1a84a93e0696f550@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 18:43:50 -0500
Message-Id: <1259106230.3069.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-11-24 at 13:05 -0500, Robert Longfield wrote:
> I have a PVR-150 card running on mythbuntu 9 and it appears that my
> card is suffering a vertical (and possibly a horizontal) sync issue.
> 
> The video jumps around, shifts from side to side, up and down and when
> it shifts the video wraps. I'm including a link to a screen shot
> showing the vertical sync problem
> 
> http://imagebin.ca/view/6fS-14Yi.html

It looks like you have strong singal reflections in your cable due to
impedance mismatches, a bad splitter, a bad cable or connector, etc.

Please read:

http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality

and take steps to ensure you've got a good cabling plant in your home.

Regards,
Andy

> This is pretty tame to what happens sometimes. I haven't noticed this
> on all channels as we are mostly using this to record shows for my
> son.
> 
> Here is my setup. Pentium 4 2 Ghz with a gig of ram. 40 gig OS drive,
> 150 gig drive for recording, 250 gig drive for backup and storage, a
> dvd-burner.
> The 150 gig drive is on a Promise Ultra133 TX2 card but exhibits no
> issues on reads or writes.
> I have cable connected to the internal tuner of my PVR-150 card and
> S-video from an Nvidia card (running Nvidea drivers) out to the TV.
> 
> I don't know what else I can provide to help out but let me know and
> I'll get it.
> 
> Thanks,
> -Rob
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

