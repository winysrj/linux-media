Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:59871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab1G1Ib1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 04:31:27 -0400
Date: Thu, 28 Jul 2011 10:31:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
In-Reply-To: <201107111732.52156.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1107280943470.20737@axis700.grange>
References: <4DDAE63A.3070203@gmx.de> <BANLkTi=RCx9Bifpw9BvqNAB0J+1ENkRK4A@mail.gmail.com>
 <4E04E975.2060003@gmx.de> <201107111732.52156.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 11 Jul 2011, Laurent Pinchart wrote:

> On Friday 24 June 2011 21:45:57 Florian Tobias Schandinat wrote:
> > On 06/24/2011 06:55 PM, Geert Uytterhoeven wrote:
> > > On Fri, Jun 24, 2011 at 08:19, Paul Mundt wrote:
> > >> On Thu, Jun 23, 2011 at 06:08:03PM +0200, Geert Uytterhoeven wrote:
> > >>> On Wed, Jun 22, 2011 at 07:45, Florian Tobias Schandinat wrote:
> > >>>> On 06/21/2011 10:31 PM, Laurent Pinchart wrote:
> > >>>>> On Tuesday 21 June 2011 22:49:14 Geert Uytterhoeven wrote:
> > >>>>>> As FOURCC values are always 4 ASCII characters (hence all 4 bytes
> > >>>>>> must be non-zero), I don't think there are any conflicts with
> > >>>>>> existing values of
> > >>>>>> nonstd. To make it even safer and easier to parse, you could set bit
> > >>>>>> 31 of
> > >>>>>> nonstd as a FOURCC indicator.
> > >>>>> 
> > >>>>> I would then create a union between nonstd and fourcc, and document
> > >>>>> nonstd as
> > >>>>> being used for the legacy API only. Most existing drivers use a
> > >>>>> couple of nonstd bits only. The driver that (ab)uses nonstd the most
> > >>>>> is pxafb and uses
> > >>>>> bits 22:0. Bits 31:24 are never used as far as I can tell, so nonstd&
> > >>>>> 0xff000000 != 0 could be used as a FOURCC mode test.
> > >>>>> 
> > >>>>> This assumes that FOURCCs will never have their last character set to
> > >>>>> '\0'. Is
> > >>>>> that a safe assumption for the future ?
> > >>>> 
> > >>>> Yes, I think. The information I found indicates that space should be
> > >>>> used for padding, so a \0 shouldn't exist.
> > >>>> I think using only the nonstd field and requiring applications to
> > >>>> check the capabilities would be possible, although not fool proof ;)
> > >>> 
> > >>> So we can declare the 8 msb bits of nonstd reserved, and assume FOURCC
> > >>> if any of them is set.
> > >>> 
> > >>> Nicely backwards compatible, as sane drivers should reject nonstd
> > >>> values they don't support (apps _will_ start filling in FOURCC values
> > >>> ignoring capabilities, won't they?).
> > >> 
> > >> That seems like a reasonable case, but if we're going to do that then
> > >> certainly the nonstd bit encoding needs to be documented and treated as
> > >> a hard ABI.
> > >> 
> > >> I'm not so sure about the if any bit in the upper byte is set assume
> > >> FOURCC case though, there will presumably be other users in the future
> > >> that will want bits for themselves, too. What exactly was the issue with
> > >> having a FOURCC capability bit in the upper byte?
> > > 
> > > That indeed gives less issues (as long as you don't stuff 8-bit ASCII
> > > in the MSB) and more bits for tradiditional nonstd users.
> > 
> > The only disadvantage I can see is that it requires adding this bit in the
> > application and stripping it when interpreting it. But I think the 24 lower
> > bits should be enough for driver specific behavior (as the current values
> > really can only be interpreted per driver).
> 
> I'm also not keen on adding/stripping the MSB. It would be easier for 
> applications to use FOURCCs directly.
> 
> > > BTW, after giving it some more thought: what does the FB_CAP_FOURCC buys
> > > us? It's not like all drivers will support whatever random FOURCC mode
> > > you give them, so you have to check whether it's supported by doing a
> > > set_var first.
> > 
> > Because any solution purely based on the nonstd field is insane. The abuse
> > of that field is just too widespread. Drivers that use nonstd usually only
> > check whether it is zero or nonzero and others will just interpret parts
> > of nonstd and ignore the rest. They will happily accept FOURCC values in
> > the nonstd and just doing the wrong thing. Even if we would fix those the
> > problems applications will run into with older kernels will remain.
> 
> I agree with Florian here. Many drivers currently check whether nonstd != 0. 
> Who knows what kind of values applications feed them ?

FWIW, I prefer the original Laurent's proposal, with a slight uncertainty 
about whether we need the .capability field, or whether the try-and-check 
approach is sufficient. As for struct fb_var_screeninfo fields to support 
switching to a FOURCC mode, I also prefer an explicit dedicated flag to 
specify switching to it. Even though using FOURCC doesn't fit under the 
notion of a videomode, using one of .vmode bits is too tempting, so, I 
would actually take the plunge and use FB_VMODE_FOURCC.

As for the actual location of the fourcc code, I would leave .nonstd 
alone: who knows, maybe drivers will need both, whereas using grayscale 
and fourcc certainly doesn't make any sense. And I personally don't see a 
problem with using a union: buggy applications are, well, buggy... 
Actually, since in FOURCC mode we don't need any of

	__u32 bits_per_pixel;		/* guess what			*/
	__u32 grayscale;		/* != 0 Graylevels instead of colors */

	struct fb_bitfield red;		/* bitfield in fb mem if true color, */
	struct fb_bitfield green;	/* else only length is significant */
	struct fb_bitfield blue;
	struct fb_bitfield transp;	/* transparency			*/	

so, we could put them all in the union for the case, if we need anything 
else for the fourcc configuration in the future.

> I'd like to reach an agreement on the API, and implement it. I'm fine with 
> either grayscale or nonstd to store the FOURCC (with a slight preference for 
> grayscale), and with either a vmode flag or using the most significant byte of 
> the grayscale/nonstd field to detect FOURCC mode. I believe FB_CAP_FOURCC (or 
> something similar) is needed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
