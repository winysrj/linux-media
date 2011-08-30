Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52229 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1H3BJH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 21:09:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH/RFC v2 1/3] fbdev: Add FOURCC-based format configuration API
Date: Tue, 30 Aug 2011 03:09:33 +0200
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com> <201108291632.06717.laurent.pinchart@ideasonboard.com> <4E5BC11F.7000704@gmx.de>
In-Reply-To: <4E5BC11F.7000704@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108300309.33509.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Monday 29 August 2011 18:41:03 Florian Tobias Schandinat wrote:
> On 08/29/2011 02:32 PM, Laurent Pinchart wrote:
> > On Monday 29 August 2011 16:26:02 Geert Uytterhoeven wrote:
> >> On Mon, Aug 29, 2011 at 16:17, Laurent Pinchart wrote:
> >>> On Monday 29 August 2011 16:14:38 Geert Uytterhoeven wrote:
> >>>> On Mon, Aug 29, 2011 at 15:34, Laurent Pinchart wrote:
> >>>>> On Monday 29 August 2011 15:09:04 Geert Uytterhoeven wrote:
> >>>>>> On Mon, Aug 29, 2011 at 14:55, Laurent Pinchart wrote:
> >>>>>>>> When will the driver report FB_{TYPE,VISUAL}_FOURCC?
> >>>>>>>> 
> >>>>>>>>   - When using a mode that cannot be represented in the legacy
> >>>>>>>> 
> >>>>>>>> way,
> >>>>>>> 
> >>>>>>> Definitely.
> >>>>>>> 
> >>>>>>>>   - But what with modes that can be represented? Legacy software
> >>>>>>>> 
> >>>>>>>> cannot handle FB_{TYPE,VISUAL}_FOURCC.
> >>>>>>> 
> >>>>>>> My idea was to use FB_{TYPE,VISUAL}_FOURCC only when the mode is
> >>>>>>> configured using the FOURCC API. If FBIOPUT_VSCREENINFO is called
> >>>>>>> with a non-FOURCC format, the driver will report non-FOURCC types
> >>>>>>> and visuals.
> >>>>>> 
> >>>>>> Hmm, two use cases:
> >>>>>>   - The video mode is configured using a FOURCC-aware tool ("fbset
> >>>>>>   on
> >>>>>> 
> >>>>>> steroids").
> >>>>> 
> >>>>> Such as http://git.ideasonboard.org/?p=fbdev-test.git;a=summary :-)
> >>>> 
> >>>> Yep.
> >>>> 
> >>>>>>     Later the user runs a legacy application.
> >>>>>>     
> >>>>>>       => Do not retain FOURCC across opening of /dev/fb*.
> >>>>> 
> >>>>> I know about that problem, but it's not that easy to work around. We
> >>>>> have no per-open fixed and variable screen info, and FB devices can
> >>>>> be opened by multiple applications at the same time.
> >>>>> 
> >>>>>>   - Is there an easy way to force FOURCC reporting, so new apps
> >>>>>>   don't
> >>>>>> 
> >>>>>> have to support parsing the legacy formats? This is useful for new
> >>>>>> apps that want to support (a subset of) FOURCC modes only.
> >>>>> 
> >>>>> Not at the moment.
> >>>> 
> >>>> So perhaps we do need new ioctls instead...
> >>>> That would also ease an in-kernel translation layer.
> >>> 
> >>> Do you mean new ioctls to replace the FOURCC API proposal, or new
> >>> ioctls for the above two operations ?
> >> 
> >> New ioctls to replace the FOURCC proposal.
> > 
> > *sigh*...
> > 
> > I'd like other people's opinion on this before throwing everything away.
> > Florian, Magnus, Guennadi, others, what do you think ?
> 
> So, your issue is that some formats can be represented in the new and the
> old way? There are 2 simpler solutions I can think of:
> 
> (1) ignore it, just do it the way Laurent proposed. I understand that
> someone might feel uneasy about applications that are trapped because they
> don't know the new format but could work with the old one. But I think
> this is not a big issue as many applications will just try to set their
> own mode. For those that doesn't and rely on the previous mode that is set
> by fbset or similar, we could change fbset to prefer the old format if
> available. But even if we don't do this, I don't have a problem with a
> program failing because it sees an unsuitable mode even if it supports the
> legacy mode. It's not a regression and can be easily fixed in userspace.

I agree with you here. Issues should be fixed in userspace. I don't expect 
many issues in practice, as fbdev is often used on systems where userspace 
components are developed to work with each other (such as embedded systems). 
If such a system is upgraded to use YUV support, all components will likely be 
tested and upgraded.

> (2) forbid it, just allow drivers to implement FOURCC for formats that
> cannot be represented in the old scheme. This is my preferred solution if
> anyone has problems with (1).

I'm tempted by that solution. Not that I have an issue with (1), but I'm 
wondering if we should try to use the FOURCC API for all formats, or just for 
formats that can't be represented by the current API. We currently have no 
bitplane FOURCCs, and I'm not sure if it would be worth adding them.

BTW, do recent hardware still support planar (in the bitplane sense) frame 
buffers ? If so, is that used in practice on recent devices ? If the answer is 
no, (1) might be the best solution, with bit-planar formats supported by the 
current API only, and all other formats supported by the FOURCC API.

> I don't see how IOCTLs would help here. The pixel format just belongs into
> var and fix so it has to be represented there anyway and thus set through
> it. We could do an IOCTL that always returns the FOURCC active at the
> moment, if such a FOURCC exists, and always use the legacy API for
> representing it in var/fix, if it exists. But as I see this is not what
> you thought about so please explain what your IOCTLS would look like and
> how they would solve the problem.
> 
> And I don't think a in-kernel translation layer is a good idea. Yes, it
> sounds interesting, but it's tricky and the result will be that the driver
> and userspace will permanently see different var and fix structures.
> Seriously I think changing every framebuffer driver out there would be
> easier and much saner than trying to implement such a thing.

I agree.

-- 
Regards,

Laurent Pinchart
