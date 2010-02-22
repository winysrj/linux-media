Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56828 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0BVWAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 17:00:34 -0500
Received: by bwz1 with SMTP id 1so484973bwz.21
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 14:00:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002222254.05573.hverkuil@xs4all.nl>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
	 <201002222241.22456.hverkuil@xs4all.nl>
	 <829197381002221343u7001cff2t59bfe3ef735db5fc@mail.gmail.com>
	 <201002222254.05573.hverkuil@xs4all.nl>
Date: Mon, 22 Feb 2010 17:00:32 -0500
Message-ID: <829197381002221400i6e4f4b17u42597d5138171e19@mail.gmail.com>
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

On Mon, Feb 22, 2010 at 4:54 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Ah, that's another matter. The original approach for handling private
> controls is seriously flawed. Drivers that want to use private controls
> are strongly encouraged to use the extended control mechanism for them,
> and to document those controls in the spec.

Yeah, it's just annoying that what should have been a change for
something like six lines of code in the g_ctrl/s_ctrl functions in
saa7115 is actually resulting in me having to extend saa7115 to add
support for the extended control interface.  Yeah, I can do that, but
it's still annoying that it should be necessary.

> Actually, it is not so much the extended control API that is relevant
> here, but the use of V4L2_CTRL_FLAG_NEXT_CTRL in VIDIOC_QUERYCTRL to
> enumerate the controls.

Control enumeration is actually working fine.  The queryctrl does
properly return all of the controls, including my new private control.

> Unfortunately, the current support functions in v4l2-common.c to help
> with this are pretty crappy, for which I apologize.

Of course, if you and Mauro wanted to sign off on the creation of a
new non-private user control called V4L2_CID_CHROMA_GAIN, that would
also resolve my problem.  :-)

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
