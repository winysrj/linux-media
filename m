Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42640 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab2LXM3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 07:29:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [RFC/PATCH] v4l2-compliance: Reject invalid ioctl error codes
Date: Mon, 24 Dec 2012 13:30:30 +0100
Message-ID: <1951365.pbMKjqvrx2@avalon>
In-Reply-To: <201212241024.48384.hverkuil@xs4all.nl>
References: <1356301444-10191-1-git-send-email-laurent.pinchart@ideasonboard.com> <201212241024.48384.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 24 December 2012 10:24:48 Hans Verkuil wrote:
> On Sun December 23 2012 23:24:04 Laurent Pinchart wrote:
> > The recent uvcvideo regression that broke pulseaudio/KDE (see commit
> > 9c016d61097cc39427a2f5025bdd97ac633d26a6 in the mainline kernel) was
> > caused by the uvcvideo driver returning a -ENOENT error code to
> > userspace by mistake.
> > 
> > To make sure such regressions will be caught before reaching users, test
> > ioctl error codes to make sure they're valid.
> 
> I don't like this change. Error codes should be checked in the test for
> the actual ioctl.
> 
> Apparently it is QUERYCTRL that is returning the wrong error code in uvc,
> but looking at the code in v4l2-test-controls.cpp it is already checking
> for ENOTTY or EINVAL and returning a failure if it is a different error
> code. So why is that not triggered in this case?

I've just checked that, the missing control class issue made the control tests 
stop early before hitting the wrong return value. I guess that's a good reason 
to fix *all* compliance errors...

We can drop this patch.

-- 
Regards,

Laurent Pinchart

