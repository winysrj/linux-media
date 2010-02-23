Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55544 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0BWPP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 10:15:59 -0500
Received: by bwz1 with SMTP id 1so1042220bwz.21
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 07:15:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002230853.36928.hverkuil@xs4all.nl>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
	 <201002222254.05573.hverkuil@xs4all.nl>
	 <829197381002221400i6e4f4b17u42597d5138171e19@mail.gmail.com>
	 <201002230853.36928.hverkuil@xs4all.nl>
Date: Tue, 23 Feb 2010 10:15:57 -0500
Message-ID: <829197381002230715w25973e7dq370f0651f538516a@mail.gmail.com>
Subject: Re: Chroma gain configuration
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@radix.net>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 23, 2010 at 2:53 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> OK. So the problem is that v4l2-ctl uses G/S_EXT_CTRLS for non-user controls,
> right? Why not change v4l2-ctl: let it first try the EXT version but if that
> fails with EINVAL then try the old control API.

Well, that's what I'm trying to figure out.  If this is a bug and I
just need to fix v4l2-ctl, then I can do that.  At this point, I was
just trying to figure out how everybody else does private controls,
since this appears to be broken out-of-the-box.

> Hmm, Mauro is right: the color controls we have now are a bit of a mess.
> Perhaps this is a good moment to try and fix them. Suppose we had no color
> controls at all: how would we design them in that case? When we know what we
> really need, then we can compare that with what we have and figure out what
> we need to do to make things right again.

Ok, this whole thread started because a client hit a specific quality
issue, and in order to address that issue I need to expose a single
slider to userland so that this advanced user can twiddle the knob
with v4l2-ctl.  I, perhaps naively, assumed this would be a trivial
change since we already have lots of infrastructure for this and the
driver in question is quite mature.  So we've gone from what I thought
was going to be a six line change in g_ctrl/s_ctrl to converting the
whole driver over to using the extended controls interface, to now the
suggestion that we redesign the way we do color controls across the
entire v4l2 subsystem?

I don't dispute that the way things have ended up is not ideal (and
presumably got that way because of the diversity of different decoders
we support and the differences in the underlying registers they
provide).  But at this point, I'm trying to solve what should be a
rather simple problem, and I haven't been contracted to redesign the
entire subsystem just to expose one advanced control.

So if people agree this is a bug in v4l2-ctl, then I'll dig into that
block of code and submit a patch.  If the real problem is that the
saa7115 driver needs to be converted to the extended control interface
to expose a single private control, well I can do that instead
(although I think that would be a pretty dumb limitation).  At this
point, I'm just trying to find the simplest change required to
accomplish something that should have taken me half an hour and been
done two days ago.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
