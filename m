Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:40947 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751366Ab2FIVlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 17:41:20 -0400
Date: Sat, 9 Jun 2012 23:41:00 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Julia Lawall <julia.lawall@lip6.fr>, mchehab@infradead.org,
	linux-media@vger.kernel.org, joe@perches.com
Subject: Re: question about bt8xx/bttv-audio-hook.c, tvaudio.c
Message-ID: <20120609214100.GA1598@minime.bse>
References: <alpine.DEB.2.02.1206060852460.1777@hadrien>
 <201206091005.16782.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206091005.16782.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 09, 2012 at 10:05:16AM +0200, Hans Verkuil wrote:
> On Wed June 6 2012 09:06:23 Julia Lawall wrote:
> > The files drivers/media/video/bt8xx/bttv-audio-hook.c and 
> > drivers/media/video/tvaudio.c contain a number of occurrences of eg:
> > 
> > mode |= V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
> > 
> > and
> > 
> > if (mode & V4L2_TUNER_MODE_MONO)
> > 
> > (both from tvaudio.c)
> 
> I would have to analyse this more carefully, but the core issue here is that
> these drivers mixup the tuner audio reception bitmask flags (V4L2_TUNER_SUB_*)
> and the tuner audio modes (V4L2_TUNER_MODE_*, not a bitmask). This happened
> regularly in older drivers, and apparently these two are still not fixed.
> 
> More info is here:
> 
> http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-g-tuner
> 
> I can't just replace one define with another, I would need to look carefully
> at the code to see what was intended.

I have an old patch on one of my other machines that should fix this
in tvaudio.c. I'll try to clean it up.

  Daniel
