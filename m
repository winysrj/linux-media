Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:26424 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696Ab1AUXf1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 18:35:27 -0500
Subject: Re: v4l2-compliance utility
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201101212337.54213.hverkuil@xs4all.nl>
References: <201101212337.54213.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 18:35:19 -0500
Message-ID: <1295652919.2474.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 2011-01-21 at 23:37 +0100, Hans Verkuil wrote:
> Hi all,
> 
> As you may have seen I have been adding a lot of tests to the v4l2-compliance
> utility in v4l-utils lately. It is now getting to the state that is becomes
> quite useful even though there is no full coverage yet.
> 
> Currently the following ioctls are being tested:

Hans,

This is a great thing to have.  Thanks!


> Also tested is whether you can open device nodes multiple times.
> 
> These tests are pretty exhaustive and more strict than the spec itself.

OK, so multiple open is not strictly required by the spec, IIRC.  If you
check the ivtv /dev/radio node, it does not allow multiple open, IIRC,
so it should not get OK for that test.

I also think during the subdev conversion, some of the less popular ivtv
cards with GPIO controlled radio audio may have been broken (and still
not fixed yet :(  ), but working for the PVR-150, PVR-500, etc..

The DEBUG ioctl()s can be compiled out too.

So for someone making decisions based on the output of this tool:

1. if something comes back as "Not supported", that still means the
driver is API specification compliant, right?

2. could it be the case that this compliance tool will be sensitive to
the driver/hardware combination and not the driver alone?

Regards,
Andy

