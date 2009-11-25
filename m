Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2155 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758770AbZKYQpu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 11:45:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH/RFC v2] V4L core cleanups HG tree
Date: Wed, 25 Nov 2009 17:45:52 +0100
Cc: linux-media@vger.kernel.org, stoth@linuxtv.org,
	mchehab@infradead.org, srinivasa.deevi@conexant.com,
	dean@sensoray.com, palash.bandyopadhyay@conexant.com,
	awalls@radix.net, dheitmueller@kernellabs.com
References: <200911181354.06529.laurent.pinchart@ideasonboard.com> <200911251721.26506.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200911251721.26506.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251745.52902.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 25 November 2009 17:21:26 Laurent Pinchart wrote:
> Hopefully CC'ing the au0828, cx231xx, cx23885, s2255 and cx25821 maintainers.
> 
> Could you please ack patch http://linuxtv.org/hg/~pinchartl/v4l-dvb-
> cleanup/rev/7a762df57149 ? The patch should be committed to v4l-dvb in time 
> for 2.6.33.

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

> 
> On Wednesday 18 November 2009 13:54:06 Laurent Pinchart wrote:
> > Hi everybody,
> > 
> > the V4L cleanup patches are now available from
> > 
> > http://linuxtv.org/hg/~pinchartl/v4l-dvb-cleanup
> > 
> > The tree will be rebased if needed (or rather dropped and recreated as hg
> > doesn't provide a rebase operation), so please don't pull from it yet if
> >  you don't want to have to throw the patches away manually later.
> > 
> > I've incorporated the comments received so far and went through all the
> > patches to spot bugs that could have sneaked in.
> > 
> > Please test the code against the driver(s) you maintain. The changes are
> > small, *should* not create any issue, but the usual bug can still sneak in.
> > 
> > I can't wait for an explicit ack from all maintainers (mostly because I
> >  don't know you all), so I'll send a pull request in a week if there's no
> >  blocking issue. I'd like this to get in 2.6.33 if possible.
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
