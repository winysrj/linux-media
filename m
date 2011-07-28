Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39335 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab1G1Kvf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 06:51:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
Date: Thu, 28 Jul 2011 12:51:34 +0200
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <4DDAE63A.3070203@gmx.de> <201107111732.52156.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1107280943470.20737@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1107280943470.20737@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107281251.35018.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the review.

On Thursday 28 July 2011 10:31:24 Guennadi Liakhovetski wrote:
> On Mon, 11 Jul 2011, Laurent Pinchart wrote:
> > On Friday 24 June 2011 21:45:57 Florian Tobias Schandinat wrote:
> > > On 06/24/2011 06:55 PM, Geert Uytterhoeven wrote:
> > > > On Fri, Jun 24, 2011 at 08:19, Paul Mundt wrote:
> > > >> On Thu, Jun 23, 2011 at 06:08:03PM +0200, Geert Uytterhoeven wrote:
> > > >>> On Wed, Jun 22, 2011 at 07:45, Florian Tobias Schandinat wrote:
> > > >>>> On 06/21/2011 10:31 PM, Laurent Pinchart wrote:
> > > >>>>> On Tuesday 21 June 2011 22:49:14 Geert Uytterhoeven wrote:
> > > >>>>>> As FOURCC values are always 4 ASCII characters (hence all 4
> > > >>>>>> bytes must be non-zero), I don't think there are any conflicts
> > > >>>>>> with existing values of
> > > >>>>>> nonstd. To make it even safer and easier to parse, you could set
> > > >>>>>> bit 31 of
> > > >>>>>> nonstd as a FOURCC indicator.
> > > >>>>> 
> > > >>>>> I would then create a union between nonstd and fourcc, and
> > > >>>>> document nonstd as
> > > >>>>> being used for the legacy API only. Most existing drivers use a
> > > >>>>> couple of nonstd bits only. The driver that (ab)uses nonstd the
> > > >>>>> most is pxafb and uses
> > > >>>>> bits 22:0. Bits 31:24 are never used as far as I can tell, so
> > > >>>>> nonstd& 0xff000000 != 0 could be used as a FOURCC mode test.
> > > >>>>> 
> > > >>>>> This assumes that FOURCCs will never have their last character
> > > >>>>> set to '\0'. Is
> > > >>>>> that a safe assumption for the future ?
> > > >>>> 
> > > >>>> Yes, I think. The information I found indicates that space should
> > > >>>> be used for padding, so a \0 shouldn't exist.
> > > >>>> I think using only the nonstd field and requiring applications to
> > > >>>> check the capabilities would be possible, although not fool proof
> > > >>>> ;)
> > > >>> 
> > > >>> So we can declare the 8 msb bits of nonstd reserved, and assume
> > > >>> FOURCC if any of them is set.
> > > >>> 
> > > >>> Nicely backwards compatible, as sane drivers should reject nonstd
> > > >>> values they don't support (apps _will_ start filling in FOURCC
> > > >>> values ignoring capabilities, won't they?).
> > > >> 
> > > >> That seems like a reasonable case, but if we're going to do that
> > > >> then certainly the nonstd bit encoding needs to be documented and
> > > >> treated as a hard ABI.
> > > >> 
> > > >> I'm not so sure about the if any bit in the upper byte is set assume
> > > >> FOURCC case though, there will presumably be other users in the
> > > >> future that will want bits for themselves, too. What exactly was
> > > >> the issue with having a FOURCC capability bit in the upper byte?
> > > > 
> > > > That indeed gives less issues (as long as you don't stuff 8-bit ASCII
> > > > in the MSB) and more bits for tradiditional nonstd users.
> > > 
> > > The only disadvantage I can see is that it requires adding this bit in
> > > the application and stripping it when interpreting it. But I think the
> > > 24 lower bits should be enough for driver specific behavior (as the
> > > current values really can only be interpreted per driver).
> > 
> > I'm also not keen on adding/stripping the MSB. It would be easier for
> > applications to use FOURCCs directly.
> > 
> > > > BTW, after giving it some more thought: what does the FB_CAP_FOURCC
> > > > buys us? It's not like all drivers will support whatever random
> > > > FOURCC mode you give them, so you have to check whether it's
> > > > supported by doing a set_var first.
> > > 
> > > Because any solution purely based on the nonstd field is insane. The
> > > abuse of that field is just too widespread. Drivers that use nonstd
> > > usually only check whether it is zero or nonzero and others will just
> > > interpret parts of nonstd and ignore the rest. They will happily
> > > accept FOURCC values in the nonstd and just doing the wrong thing.
> > > Even if we would fix those the problems applications will run into
> > > with older kernels will remain.
> > 
> > I agree with Florian here. Many drivers currently check whether nonstd !=
> > 0. Who knows what kind of values applications feed them ?
> 
> FWIW, I prefer the original Laurent's proposal, with a slight uncertainty
> about whether we need the .capability field, or whether the try-and-check
> approach is sufficient.

Try-and-check would be better, but unfortunately I don't think it would work. 
Existing drivers will either ignore the new FB_VMODE_FOURCC flag or fail. I 
expect many drivers that ignore it to still accept it blindly, and not clear 
it, so applications won't be able to find out whether the flag is supported.

> As for struct fb_var_screeninfo fields to support switching to a FOURCC
> mode, I also prefer an explicit dedicated flag to specify switching to it.
> Even though using FOURCC doesn't fit under the notion of a videomode, using
> one of .vmode bits is too tempting, so, I would actually take the plunge and
> use FB_VMODE_FOURCC.

Another option would be to consider any grayscale > 1 value as a FOURCC. I've 
briefly checked the in-tree drivers: they only assign grayscale with 0 or 1, 
and check whether grayscale is 0 or different than 0. If a userspace 
application only sets grayscale > 1 when talking to a driver that supports the 
FOURCC-based API, we could get rid of the flag.

What can't be easily found out is whether existing applications set grayscale 
to a > 1 value. They would break when used with FOURCC-aware drivers if we 
consider any grayscale > 1 value as a FOURCC. Is that a risk we can take ?

> As for the actual location of the fourcc code, I would leave .nonstd
> alone: who knows, maybe drivers will need both, whereas using grayscale
> and fourcc certainly doesn't make any sense. And I personally don't see a
> problem with using a union: buggy applications are, well, buggy...

I agree with this.

> Actually, since in FOURCC mode we don't need any of
> 
> 	__u32 bits_per_pixel;		/* guess what			*/
> 	__u32 grayscale;		/* != 0 Graylevels instead of colors */
> 
> 	struct fb_bitfield red;		/* bitfield in fb mem if true color, */
> 	struct fb_bitfield green;	/* else only length is significant */
> 	struct fb_bitfield blue;
> 	struct fb_bitfield transp;	/* transparency			*/
> 
> so, we could put them all in the union for the case, if we need anything
> else for the fourcc configuration in the future.

Good point. It might make sense to exclude bits_per_pixel from the union 
though, as that's interesting information for applications. The red, green, 
blue and transp fields are less useful.

> > I'd like to reach an agreement on the API, and implement it. I'm fine
> > with either grayscale or nonstd to store the FOURCC (with a slight
> > preference for grayscale), and with either a vmode flag or using the
> > most significant byte of the grayscale/nonstd field to detect FOURCC
> > mode. I believe FB_CAP_FOURCC (or something similar) is needed.

-- 
Regards,

Laurent Pinchart
