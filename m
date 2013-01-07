Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45833 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab3AGMSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 07:18:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: William Swanson <william.swanson@fuel7.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Ken Petit <ken@fuel7.com>
Subject: Re: [PATCH] omap3isp: Add support for interlaced input data
Date: Mon, 07 Jan 2013 13:20:23 +0100
Message-ID: <1489481.HbZGQ48duQ@avalon>
In-Reply-To: <50E732FC.10203@fuel7.com>
References: <1355796739-2580-1-git-send-email-william.swanson@fuel7.com> <20121227182709.5e89a61a@redhat.com> <50E732FC.10203@fuel7.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

On Friday 04 January 2013 11:52:28 William Swanson wrote:
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> >> On Monday 17 December 2012 18:12:19 William Swanson wrote:
> >>> If the remote video sensor reports an interlaced video mode, the CCDC
> >>> block should configure itself appropriately.
> >> 
> >> What will the CCDC do in that case ? Will it capture fields or frames to
> >> memory ? If frames, what's the field layout ? You will most likely need
> >> to modify ispvideo.c as well, to support interlacing in the V4L2 API, and
> >> possibly add interlaced formats support to the media bus API.
> 
> Sorry for the delay in responding; today is my first day back at the
> office. I do not know the answers to these questions, and the
> documentation doesn't discuss interlacing much. Our application has the
> following pipeline:
> 
>      composite video -> TVP5146 decoder
>      -> CCDC parallel interface -> memory -> application
> 
> One of the wires in the parallel interface, cam_fld, indicates the
> current field, and this patch simply enables that wire. Without the
> patch, every other line in our memory buffer is garbage; with the patch,
> the image comes out correctly.

What do you get in the memory buffers ? Are fields captured in separate 
buffers or combined in a single buffer ? If they're combined, are they 
interleaved or sequential in memory ?

> As a matter of fact, an earlier version of the ISP driver actually
> contained code for dealing with this flag; it was removed in
> cf7a3d91ade6c56bfd860b377f84bd58132f7a81 along with a bunch of other
> cleanup work. This patch simply adds the code back, but in a way that is
> compatible with the new media pipeline stuff.
> 
> I believe that the CCDC simply captures image data a line at a time and
> writes it directly to memory, at least in our use case. The CCDC_SDOFST
> register controls the layout, and the default value (which is what the
> driver uses now) is basically correct. I am not familiar enough with the
> V4L2 architecture to tell you how the driver decides that it now has a
> complete frame, or what that even means in an interlaced case.
> 
> On 12/27/2012 12:27 PM, Mauro Carvalho Chehab wrote:
>  > Btw, you missed to add a Signed-off-by: line on it.
> 
> Oops, this was a problem with my git setup. Both email addresses are
> mine; I can re-send the patch with them both set to the same address if
> you would prefer that.

-- 
Regards,

Laurent Pinchart

