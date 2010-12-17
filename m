Return-path: <mchehab@gaivota>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3188 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0LQT5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 14:57:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Reading/writing controls from different classes in a single VIDIOC_[GS]_EXT_CTRLS call
Date: Fri, 17 Dec 2010 20:57:32 +0100
Cc: linux-media@vger.kernel.org
References: <201012171717.06765.laurent.pinchart@ideasonboard.com> <201012172052.25704.hverkuil@xs4all.nl>
In-Reply-To: <201012172052.25704.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012172057.32872.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Friday, December 17, 2010 20:52:25 Hans Verkuil wrote:
> On Friday, December 17, 2010 17:17:05 Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > I've recently run into an issue when porting a sensor driver to the control 
> > framework.
> > 
> > A userspace application using that driver using VIDIOC_G_EXT_CTRLS to retrieve 
> > the value of a bunch of controls in a single call. Those controls don't belong 
> > to the same class, and the application started failing.
> > 
> > What's the rationale behind forbidding that ?
> 
> Which driver? The control framework doesn't have that limitation anymore.
> Originally the API had that limitation, mostly to reduce driver complexity,
> but that limitation is lifted in the control framework.

A follow-up: if the ctrl_class field of v4l2_ext_controls is set to a specific
control class by the application, then all controls in the list must belong to
that control class. This is checked by the control framework. This matches the
behavior as defined in the spec. If ctrl_class is 0, then the control framework
allows controls from any class.

This doesn't seem to be documented yet. I thought I did :-(

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
