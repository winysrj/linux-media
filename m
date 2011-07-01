Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40967 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab1GAIUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 04:20:23 -0400
Date: Fri, 1 Jul 2011 11:20:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [GIT PULL FOR 3.1] Bitmask controls, flash API and adp1653
 driver
Message-ID: <20110701082017.GM12671@valkosipuli.localdomain>
References: <20110610092703.GH7830@valkosipuli.localdomain>
 <4E0D226E.5010809@redhat.com>
 <201107010957.39930.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107010957.39930.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans and Mauro,

On Fri, Jul 01, 2011 at 09:57:39AM +0200, Hans Verkuil wrote:
> On Friday, July 01, 2011 03:27:10 Mauro Carvalho Chehab wrote:
> > Em 10-06-2011 06:27, Sakari Ailus escreveu:
> > > Hi Mauro,
> > > 
> > > This pull request adds the bitmask controls, flash API and the adp1653
> > > driver. What has changed since the patches is:
> > > 
> > > - Adp1653 flash faults control is volatile. Fix this.
> > > - Flash interface marked as experimental.
> > > - Moved the DocBook documentation to a new location.
> > > - The target version is 3.1, not 2.6.41.
> > > 
> > > The following changes since commit 75125b9d44456e0cf2d1fbb72ae33c13415299d1:
> > > 
> > >   [media] DocBook: Don't be noisy at make cleanmediadocs (2011-06-09 16:40:58 -0300)
> > > 
> > > are available in the git repository at:
> > >   ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.1
> > > 
> > > Hans Verkuil (3):
> > >       v4l2-ctrls: add new bitmask control type.
> > >       vivi: add bitmask test control.
> > >       DocBook: document V4L2_CTRL_TYPE_BITMASK.
> > 
> > I'm sure I've already mentioned, but I think it was at the Hans pull request:
> > the specs don't mention what endiannes is needed for the bitmask controls: 
> > machine endianess, little endian or big endian.  IMO, we should stick with either
> > LE or BE.
> 
> Sorry Sakari, I should have fixed that. But since the patch was going through
> your repository I forgot about it. Anyway, it should be machine endianess. You
> have to be able to do (value & bit_define). The bit_defines for each bitmask
> control should be part of the control's definition in videodev2.h.

No problem, Hans.

The bit defines would change from endianness to another if the endianness
were to be either big or little. I agree to using machine endianness ---
that was also my assumption previously.

> It makes no sense to require LE or BE. We don't do that for other control types,
> so why should bitmask be any different?
> 
> Can you add this clarification to DocBook?

Sure I can. Mauro: are you ok with this?

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
