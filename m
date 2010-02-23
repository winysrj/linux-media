Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1234 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0BWHv5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 02:51:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Chroma gain configuration
Date: Tue, 23 Feb 2010 08:53:36 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@radix.net>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com> <201002222254.05573.hverkuil@xs4all.nl> <829197381002221400i6e4f4b17u42597d5138171e19@mail.gmail.com>
In-Reply-To: <829197381002221400i6e4f4b17u42597d5138171e19@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002230853.36928.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 February 2010 23:00:32 Devin Heitmueller wrote:
> On Mon, Feb 22, 2010 at 4:54 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Ah, that's another matter. The original approach for handling private
> > controls is seriously flawed. Drivers that want to use private controls
> > are strongly encouraged to use the extended control mechanism for them,
> > and to document those controls in the spec.
> 
> Yeah, it's just annoying that what should have been a change for
> something like six lines of code in the g_ctrl/s_ctrl functions in
> saa7115 is actually resulting in me having to extend saa7115 to add
> support for the extended control interface.  Yeah, I can do that, but
> it's still annoying that it should be necessary.
> 
> > Actually, it is not so much the extended control API that is relevant
> > here, but the use of V4L2_CTRL_FLAG_NEXT_CTRL in VIDIOC_QUERYCTRL to
> > enumerate the controls.
> 
> Control enumeration is actually working fine.  The queryctrl does
> properly return all of the controls, including my new private control.

OK. So the problem is that v4l2-ctl uses G/S_EXT_CTRLS for non-user controls,
right? Why not change v4l2-ctl: let it first try the EXT version but if that
fails with EINVAL then try the old control API.

> 
> > Unfortunately, the current support functions in v4l2-common.c to help
> > with this are pretty crappy, for which I apologize.
> 
> Of course, if you and Mauro wanted to sign off on the creation of a
> new non-private user control called V4L2_CID_CHROMA_GAIN, that would
> also resolve my problem.  :-)

Hmm, Mauro is right: the color controls we have now are a bit of a mess.
Perhaps this is a good moment to try and fix them. Suppose we had no color
controls at all: how would we design them in that case? When we know what we
really need, then we can compare that with what we have and figure out what
we need to do to make things right again.

Regards,

	Hans

> 
> Devin
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
