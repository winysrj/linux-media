Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41906 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1H2M5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 08:57:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 4/5] [media] v4l: fix copying ioctl results on failure
Date: Mon, 29 Aug 2011 14:58:04 +0200
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
References: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com> <201108291056.49049.laurent.pinchart@ideasonboard.com> <4E5B7E33.9020502@samsung.com>
In-Reply-To: <4E5B7E33.9020502@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291458.05372.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Monday 29 August 2011 13:55:31 Tomasz Stanislawski wrote:
> On 08/29/2011 10:56 AM, Laurent Pinchart wrote:
> > On Monday 29 August 2011 10:01:58 Tomasz Stanislawski wrote:
> >> On 08/26/2011 05:09 PM, Laurent Pinchart wrote:
> >>> On Friday 26 August 2011 15:06:06 Tomasz Stanislawski wrote:
> >>>> This patch fix the handling of data passed to V4L2 ioctls.  The
> >>>> content of the structures is not copied if the ioctl fails.  It
> >>>> blocks ability to obtain any information about occurred error other
> >>>> then errno code. This patch fix this issue.
> >>> 
> >>> Does the V4L2 spec say anything on this topic ? We might have
> >>> applications that rely on the ioctl argument structure not being
> >>> touched when a failure occurs.
> >> 
> >> Ups.. I missed something. It looks that modifying ioctl content is
> >> illegal if ioctl fails. The spec says:
> >> "When an ioctl that takes an output or read/write parameter fails, the
> >> parameter remains unmodified." (v4l2 ioctl section)
> >> However, there is probably a bug already present in V4L2 framework.
> >> There are some ioctls that takes a pointer to an array as a field in the
> >> argument struct.
> >> The examples are all VIDIOC_*_EXT_CTRLS and VIDIOC_{QUERY/DQ/Q}_BUF
> >> family. The content of such an auxiliary arays is copied even if ioctl
> >> fails. Please take a look to video_usercopy function in v4l2-ioctl.c.
> >> Therefore I think that the spec is already violated. What is your
> >> opinion about this problem?
> > 
> > I think it was a bad idea to state that a parameter remains unmodified
> > when the ioctl fails in the first place. I'm fine with not following
> > that for new ioctls, but applications might rely on it for existing
> > ioctls.
> > 
> >> Now back to selection case.
> >> This patch was added as proposition of fix to VIDIOC_S_SELECTION, to
> >> return the best-hit rectangle if constraints could not be satisfied. The
> >> ioctl return -ERANGE in this case. Using those return values the
> >> application gets some feedback on loosing constraints.
> > 
> > Shouldn't that always be the case ? :-) VIDIOC_S_SELECTION should adjust
> > the rectangle up or down depending on the constraints and always return
> > the best match without any error.
> 
> ok.. but what to do if constraints could not be satisfied?
> The configuration should not be applied to the hardware in such a case,
> because it is not what the application desired.
> Therefore the ioctl must fail ... somehow.
> If the ioctl always succeed then the constraint flags becomes actually
> the hints.

That's what currently happens with S_FMT. Is that behaviour too limited in 
your opinion ?

> We may need TRY_SELECTION to test rectangles without applying it.
> 
> I thought that returning the best-hit rectangle by S_SELECTION might be
> useful because it gives the application some feedback on what the driver
> would accept.

If we indeed need to fail with -ERANGE, I agree with you, the behaviour is 
useful. It would make sense in that case to only update the parameter for a 
specific set of ioctls. The V4L2 documentation will also need to be fixed.

-- 
Regards,

Laurent Pinchart
