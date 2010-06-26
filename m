Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52269 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab0FZShy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 14:37:54 -0400
Received: by ewy7 with SMTP id 7so39523ewy.19
        for <linux-media@vger.kernel.org>; Sat, 26 Jun 2010 11:37:51 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 26 Jun 2010 14:37:51 -0400
Message-ID: <AANLkTim9TfITmvy7nEuSVJnCxRwCkpbmgRc2FIIIWHGF@mail.gmail.com>
Subject: Correct way to do s_ctrl ioctl taking into account subdev framework?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

First, a bit of background:

A bug in the em28xx implementation of s_ctrl() was present where it
would always return 1, even in success cases, regardless of what the
subdev servicing the request said (in this case the video decoder).
It was using v4l2_device_call_all(), and disregarding the return value
from any of the subdevs.

This prompted me to change the code so that it started using
v4l2_device_call_until_err(), figuring that subdevs that did not
support it would simply return -ENOIOCTLCMD.  However, as Mauro
correctly pointed out, subdevs that do implement s_ctrl, but not the
desired control will return -EINVAL, which would cause the bridge to
stop sending the command to other subdevs and return an error.

I looked at various other bridges, and don't see any consistent
approach for this case.  Some of the bridges always return zero
(regardless of what happened during the call).  Some of them look at
the content of the resulting struct for some value that suggests it
was changed.  Others feed the call to different classes of subdevice
depending on what the actual control being set was.

So what's the "right" approach?  I'm willing to conform to whatever
the recommendation is here, since it will obviously be an improvement
over always returning 1 (even always returning zero would be better
since at least applications wouldn't treat it as a failure).

Hans?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
