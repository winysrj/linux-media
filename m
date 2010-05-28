Return-path: <linux-media-owner@vger.kernel.org>
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:56051 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab0E1UOf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 16:14:35 -0400
Date: Fri, 28 May 2010 23:06:04 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jaya Kumar <jayakumar.lkml@gmail.com>,
	linux-fbdev@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Idea of a v4l -> fb interface driver
Message-ID: <20100528200604.GA10135@sci.fi>
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
 <AANLkTilnb20a4KO1NmK_y148HE_4b6ka14hUJY5o93QT@mail.gmail.com>
 <Pine.LNX.4.64.1005270809110.2293@axis700.grange>
 <AANLkTin_ia3Ym3z7FOu40voZkjCeMqSDZjuE_1aBjwOW@mail.gmail.com>
 <Pine.LNX.4.64.1005272216380.1703@axis700.grange>
 <AANLkTikTBFPxbl5p9kI65bHt2UJZ5j0DAxFwJ6rzD77L@mail.gmail.com>
 <4C001643.2070802@gmx.de>
 <AANLkTimHM66vREdBf60D1jrgvFLDOjf3f3KcHjy6cYSR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimHM66vREdBf60D1jrgvFLDOjf3f3KcHjy6cYSR@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 28, 2010 at 03:41:46PM -0400, Alex Deucher wrote:
> On Fri, May 28, 2010 at 3:15 PM, Florian Tobias Schandinat
> > If he wants different (independent) content on each output, just provide
> > multiple /dev/fbX devices. I admit that we could use a controlling interface
> > here that decides which user (application) might draw at a time to the
> > interface which they currently only do if they are the active VT.
> > If you want 2 or more outputs to be merged as one just configure this in the
> > driver.
> > The only thing that is impossible to do in fbdev is controlling 2 or more
> > independent display outputs that access the same buffer. But that's not an
> > issue I think.
> > The things above only could use a unification of how to set them up on
> > module load time (as only limited runtime changes are permited given that we
> > must always be able to support a mode that we once entered during runtime).
> >
> 
> What about changing outputs on the fly (turn off VGA, turn on DVI,
> switch between multi-head and single-head, etc) or encoders shared
> between multiple connectors (think a single dac shared between a VGA
> and a TV port); how do you expose them easily as separate fbdevs?
> Lots of stuff is doable with fbdev, but it's nicer with kms.

But actually getting your data onto the screen is a lot easier with
fbdev. There's no standard API in drm to actually allocate the
framebuffer and manipulate it. You always need a user space driver
to go along with the kernel bits.

I'm not saying fbdev is better than drm/kms but at least it can be
used to write simple applications that work across different
hardware. Perhaps that's something that should be addressed in the
drm API.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
