Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:36622 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbZLRUR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 15:17:59 -0500
Received: by ey-out-2122.google.com with SMTP id d26so876543eyd.19
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2009 12:17:58 -0800 (PST)
Date: Fri, 18 Dec 2009 21:17:53 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Robert Longfield <robert.longfield@gmail.com>
cc: Andy Walls <awalls@radix.net>, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Hauppauge PVR-150 Vertical sync issue?
In-Reply-To: <34373e030912181159k32d36a40yc989dfd777504aaa@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.0912182107371.31371@ybpnyubfg.ybpnyqbznva>
References: <34373e030911241005r7f499297y1a84a93e0696f550@mail.gmail.com> <1259106230.3069.16.camel@palomino.walls.org> <34373e030912100856r2ba80741yca8f79c84ee730e3@mail.gmail.com> <1260523942.3087.21.camel@palomino.walls.org>
 <34373e030912181159k32d36a40yc989dfd777504aaa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 18 Dec 2009, Robert Longfield wrote:

> Ok so I ran a live CD on my windows box and there were no sync
> problems. I installed the latest Ubuntu CD and dual booted my windows
> machine and there was no sync problems but there was other issues,
> many tiny black lines on edges during fast movement when I did a $ cat
> /dev/video0 > foo.mpg.

This sounds like an interlacing issue -- I suspect you are using
some player that delivers 25 full frames per second to your 
display instead of somehow getting 50 partial fields from them
or interpolating the fields into 50 frames per second.

This is fairly normal when not dealing with progressive material 
(720p HD video, or 1080i HD or even SD video taken from source 
material such as film shot at 24 fps).  Most players have options 
to enable one of any number of deinterlacers, some of which work 
better than others for selected movement.  (There are many 
different commandline options for `mplayer', one of which will 
present the fields of a 576i video as 288-line images which helps 
decipher fast-scrolling text, for example.)

If you are reproducing your video at your display's native 
resolution without zooming it to fullscreen, you can see each
of the jagged lines matching one pixel vertical resolution.


barrry bouwsma
