Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0CSNsD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 09:48:03 -0400
Message-ID: <4BA38088.1020006@redhat.com>
Date: Fri, 19 Mar 2010 10:47:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	v4l-dvb <linux-media@vger.kernel.org>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>    <201003190904.53867.laurent.pinchart@ideasonboard.com> <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
In-Reply-To: <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:

>> Do we still have V4L1-only drivers that use videobuf ?
> 
> No V4L1-only drivers use videobuf, but videobuf has support for the V4L1
> compat support in V4L2 drivers (the cgmbuf ioctl). So when we remove the
> compat support, then that videobuf code can be removed as well.

We shouldn't justify the removal of an userspace API due to an internal
code cleanup.

The original reason for the V4L1 API removal is that its design were never
extended to support all world video standards (yet, its non-RDS radio
support is just as fine as V4L2 API).

The fact is that V4L1 API stopped in the time, while V4L2 is live. So, 
V4L1 didn't followed 10 years of evolution that happened on media devices.

It would be probably simpler to just extend V4L1 API than to replace it to
a new one, but now we have to deal with both API's.

Due to the lack of features, the V4L1 drivers were gradually converted to V4L2.
This makes sense, since they can provide more features to userspace, like
the support for read/mmap/user mmap streaming, the fine-grained video format
support, the video format and fps enumeration and more userspace controls.

The V4L1 drivers that lasts are the ones without maintainers and probably without
a large users base. So, basically legacy hardware. So, their removals make sense.

After the driver removal, the last V4L1 vestige is the V4L1 compat layer removal.
So, what are the reasons to remove this layer?

I can think on a few technical reasons:
- V4L1 API emulation in kernel is not perfect. There are some known bugs, basically due to
the lack of a stateful layer emulation. So, it is possible, for example, that userspace
selects one video standard on a set and receive another on a get. For example, if userspace
tries to set VIDEO_PALETTE_YUV422, a subsequent get will return VIDEO_PALETTE_YUYV.
- V4L1 API lacks functionality. So, userspace applications using it would have a limited
control of the driver;
- Code cleanup;
- Lack of developers interested on maintaining V4L1 compat layer.

On the other hand, removing it may break applications that works fine with V4L1 emulation.
IMO, none of the above reasons are strong enough to justify prevent users to properly
use the hardware.

So, in order to remove this feature, we should be sure that the existing open-source 
V4L2 applications will cover all usage cases: teletext, radio, vbi, tv, webcam, stream
capture, text UI, graphical UI's (qt/gtk), .... If something is not covered, someone
has to port an existing application to V4L2 or to write/maintain a replacement application.

So, the main issue to remove V4L1 compat is: are all cases properly covered?

Comments?

-- 

Cheers,
Mauro
