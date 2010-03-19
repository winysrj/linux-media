Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42586 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab0CSIsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 04:48:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
Date: Fri, 19 Mar 2010 09:50:52 +0100
Cc: "v4l-dvb" <linux-media@vger.kernel.org>
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl> <201003190904.53867.laurent.pinchart@ideasonboard.com> <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
In-Reply-To: <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003190950.52964.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 19 March 2010 09:46:02 Hans Verkuil wrote:
> > On Friday 19 March 2010 08:59:08 Hans Verkuil wrote:
> >> Hi all,
> >> 
> >> V4L1 support has been marked as scheduled for removal for a long time.
> >> The deadline for that in the feature-removal-schedule.txt file was July
> >> 2009.
> >> 
> >> I think it is time that we remove the V4L1 compatibility support from
> >> V4L2 drivers for 2.6.35.
> > 
> > Do you mean just removing V4L1-specific code from V4L2 drivers, or
> > removing the V4L1 compatibility layer completely ?
> 
> The compat layer as well. So the only V4L1 code left is that for V4L1-only
> drivers.
> 
> This means that V4L2 drivers can only be used by V4L2-aware applications
> and can no longer be accessed by V4L1-only applications.
> 
> >> It would help with the videobuf cleanup as well, but that's just a bonus.
> > 
> > Do we still have V4L1-only drivers that use videobuf ?
> 
> No V4L1-only drivers use videobuf, but videobuf has support for the V4L1
> compat support in V4L2 drivers (the cgmbuf ioctl). So when we remove the
> compat support, then that videobuf code can be removed as well.

In that case, please go for it :-)

-- 
Regards,

Laurent Pinchart
