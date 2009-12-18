Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:56406 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbZLRUYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 15:24:23 -0500
Received: by fxm21 with SMTP id 21so3186827fxm.21
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2009 12:24:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0912182107371.31371@ybpnyubfg.ybpnyqbznva>
References: <34373e030911241005r7f499297y1a84a93e0696f550@mail.gmail.com>
	 <1259106230.3069.16.camel@palomino.walls.org>
	 <34373e030912100856r2ba80741yca8f79c84ee730e3@mail.gmail.com>
	 <1260523942.3087.21.camel@palomino.walls.org>
	 <34373e030912181159k32d36a40yc989dfd777504aaa@mail.gmail.com>
	 <alpine.DEB.2.01.0912182107371.31371@ybpnyubfg.ybpnyqbznva>
Date: Fri, 18 Dec 2009 15:24:21 -0500
Message-ID: <34373e030912181224y7f8c6511w4cc1dd919e208e1@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge PVR-150 Vertical sync issue?
From: Robert Longfield <robert.longfield@gmail.com>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Cc: Andy Walls <awalls@radix.net>, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Barry,

Well that is certainly could be part of the problem, I was using
mplayer to play back the video recorded onto the computer monitor.
I wasn't too overly concerned with it as I thought it might be a playback issue.
I certainly have a lot more trouble shooting to do before I figure out
where the issue lies with this hardware.

-Rob

On Fri, Dec 18, 2009 at 3:17 PM, BOUWSMA Barry
<freebeer.bouwsma@gmail.com> wrote:
> On Fri, 18 Dec 2009, Robert Longfield wrote:
>
>> Ok so I ran a live CD on my windows box and there were no sync
>> problems. I installed the latest Ubuntu CD and dual booted my windows
>> machine and there was no sync problems but there was other issues,
>> many tiny black lines on edges during fast movement when I did a $ cat
>> /dev/video0 > foo.mpg.
>
> This sounds like an interlacing issue -- I suspect you are using
> some player that delivers 25 full frames per second to your
> display instead of somehow getting 50 partial fields from them
> or interpolating the fields into 50 frames per second.
>
> This is fairly normal when not dealing with progressive material
> (720p HD video, or 1080i HD or even SD video taken from source
> material such as film shot at 24 fps).  Most players have options
> to enable one of any number of deinterlacers, some of which work
> better than others for selected movement.  (There are many
> different commandline options for `mplayer', one of which will
> present the fields of a 576i video as 288-line images which helps
> decipher fast-scrolling text, for example.)
>
> If you are reproducing your video at your display's native
> resolution without zooming it to fullscreen, you can see each
> of the jagged lines matching one pixel vertical resolution.
>
>
> barrry bouwsma
>
