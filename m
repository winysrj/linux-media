Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3417 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab0BVVp5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 16:45:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Chroma gain configuration
Date: Mon, 22 Feb 2010 22:47:58 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@radix.net>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com> <4B82F7F4.3090802@redhat.com> <829197381002221338q6af601bfs8d99632f82b75c8e@mail.gmail.com>
In-Reply-To: <829197381002221338q6af601bfs8d99632f82b75c8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002222247.58100.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 February 2010 22:38:56 Devin Heitmueller wrote:
> On Mon, Feb 22, 2010 at 4:32 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Devin Heitmueller wrote:
> >> In fact, I would be in favor of taking the basic logic found in
> >> cx18_g_ext_ctrls(), and making that generic to the videodev interface,
> >> such that any driver which provides a user control interface but
> >> doesn't provide an extended control function will work if the calling
> >> application makes an extended control call.  This will allow userland
> >> applications to always use the extended controls API, even if the
> >> driver didn't explicitly add support for it.
> >
> > That's exactly the idea: convert all driverst o use ext_ctrl's and let the
> > V4L2 core to handle the calls to the non-extended interface.
> 
> I think you actually missed the point of what I'm trying to say:  You
> can only do the opposite of what you proposed:  You can have the v4l2
> core receive extended interface calls and pass those calls through to
> the older interface in drivers (since the older interface is a
> *subset* of the newer interface).  However, you cannot provide a way
> for callers of the older interface have those requests passed through
> to the new interface (since the old interface does not support
> multiple controls in one call and there are multiple classes of
> controls in the newer interface).
> 
> In other words, a caller using the extended interface can
> automatically call the old interface, but a caller using the old
> interface cannot automatically call into the extended interface.

Sure you can. See v4l2-ioctl.c, VIDIOC_G/S_CTRL. That's exactly what is
being done there.

It's the other way around that is not in general possible.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
