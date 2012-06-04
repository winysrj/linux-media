Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49465 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2FDQkq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 12:40:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: balbi@ti.com
Cc: Bhupesh SHARMA <bhupesh.sharma@st.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use videobuf2 framework
Date: Mon, 04 Jun 2012 18:40:46 +0200
Message-ID: <12753426.T5yg9NUgS1@avalon>
In-Reply-To: <20120604152831.GB20313@arwen.pp.htv.fi>
References: <cover.1338543124.git.bhupesh.sharma@st.com> <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF1@EAPEX1MAIL1.st.com> <20120604152831.GB20313@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

On Monday 04 June 2012 18:28:33 Felipe Balbi wrote:
> On Mon, Jun 04, 2012 at 11:21:13PM +0800, Bhupesh SHARMA wrote:
> > On Monday, June 04, 2012 8:44 PM Felipe Balbi wrote:
> > > On Fri, Jun 01, 2012 at 03:08:57PM +0530, Bhupesh Sharma wrote:
> > > > This patch reworks the videobuffer management logic present in the
> > > > UVC webcam gadget and ports it to use the "more apt" videobuf2
> > > > framework for video buffer management.
> > > > 
> > > > To support routing video data captured from a real V4L2 video capture
> > > > device with a "zero copy" operation on videobuffers (as they pass from
> > > > the V4L2 domain to UVC domain via a user-space application), we need
> > > > to support USER_PTR IO method at the UVC gadget side.
> > > > 
> > > > So the V4L2 capture device driver can still continue to use MMAO IO
> > > > method and now the user-space application can just pass a pointer to
> > > > the video buffers being DeQueued from the V4L2 device side while
> > > > Queueing them at the UVC gadget end. This ensures that we have a
> > > > "zero-copy" design as the videobuffers pass from the V4L2 capture
> > > > device to the UVC gadget.
> > > >
> > > > Note that there will still be a need to apply UVC specific payload
> > > > headers on top of each UVC payload data, which will still require a
> > > > copy operation to be performed in the 'encode' routines of the UVC
> > > > gadget.
> > > >
> > > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > > 
> > > this patch doesn't apply. Please refresh on top of v3.5-rc1 or my gadget
> > > branch which I will update in a while.
> > 
> > I rebased and submitted my changes on your "gadget-for-v3.5" tag.
> > Should I now refresh my patches on top of your "v3.5-rc1" branch ?
> > 
> > I am a bit confused on what is the latest gadget branch to be used now.
> > Thanks for helping out.
> 
> The gadget branch is the branch called gadget on my kernel.org tree. For
> some reason this didn't apply. Probably some patches on
> drivers/usb/gadget/*uvc* went into v3.5 without my knowledge. Possibly
> because I was out for quite a while and asked Greg to help me out during
> the merge window.
> 
> Anyway, I just pushed gadget with a bunch of new patches and part of
> your series.

I would have appreciated an occasion to review them first (especially 3/5 
which should *really* have been split into several patches) :-( Have they been 
pushed to mainline yet ?

I'm currently traveling to Japan for LinuxCon so I won't have time to look 
into this before next week. I'll send incremental patches to fix issues with 
the already applied patches, *please* don't apply 4/5 and 5/5 before I can 
review them.

-- 
Regards,

Laurent Pinchart

