Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45641 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZGVQS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 12:18:26 -0400
Date: Wed, 22 Jul 2009 13:18:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Steve Castellotti <sc@eyemagnet.com>, linux-media@vger.kernel.org,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: offering bounty for GPL'd dual em28xx support
Message-ID: <20090722131817.725cf309@pedra.chehab.org>
In-Reply-To: <829197380907220902p5044e931jf54edcec48b4c26f@mail.gmail.com>
References: <4A6666CC.7020008@eyemagnet.com>
	<829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>
	<4A667735.40002@eyemagnet.com>
	<829197380907211932v6048d099h2ebb50da05959d89@mail.gmail.com>
	<4A668BB9.1020700@eyemagnet.com>
	<20090722024320.2f1d9990@pedra.chehab.org>
	<829197380907220902p5044e931jf54edcec48b4c26f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 22 Jul 2009 12:02:48 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> Hello Mauro,
> 
> As far as I know, the em28xx has no capability to adjust the frame
> rate.  It will forward the frames at whatever rate the ITU656 stream
> is delivered from the decoder.

Ok. So, the fps changing will be limited to the decoder and/or sensor that
supports it.

>  I also don't think the tvp5150 will
> deliver frames at any rather other than the NTSC/PAL standard in
> question (but I would have to double-check the tvp5150 datasheet to be
> sure).

On a very quick check on saa7114/saa7115 and tvp5150, I couldn't find any way
do do spatial decimation to reduce fps. So, it seems that we'll have this
feature only with webcams where such type of control is common.

> I would like to spend some time looking closer at the formula used to
> calculate the set_alternate() call.  I just haven't had the time to
> invest in such an investigation given all the other stuff I am working
> on right now (in particular the three or four em28xx devices I am
> adding support for, the xc4000 driver work, and hvr-950q analog
> fixes).

Maybe that magic calculus took from experimentation are due to vbi and/or audio
streams. It would be nice to adjust it to be less conservative.

> I didn't know about the 80% utilization cap for isoc, so thanks for
> providing the reference to that previous thread, which has some pretty
> interesting information.

Anytime.



Cheers,
Mauro
