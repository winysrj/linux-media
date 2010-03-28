Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab0C1Pii (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 11:38:38 -0400
Message-ID: <4BAF77F7.3070205@redhat.com>
Date: Sun, 28 Mar 2010 12:38:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: What would be a good time to move subdev drivers to a subdev
 directory?
References: <201003281224.17678.hverkuil@xs4all.nl>
In-Reply-To: <201003281224.17678.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi Mauro,
> 
> Currently drivers/media/video is a mix of subdev drivers and bridge/platform
> drivers. I think it would be good to create a drivers/media/subdev directory
> where subdev drivers can go.
> 
> We discussed in the past whether we should have categories for audio subdevs,
> video subdevs, etc. but I think that will cause problems, especially with
> future multifunction devices.

Due to the discussions we had on the last time, I'm not so sure that such move
would be good: There are some cases where the division of a subdev is more a
matter of a logical organization than a physical device division. for example,
cx231xx is just one chip, but, as it has internally the same functionalities as
a cx2584x, the cx2584x is a subdev used by the driver. There are other similar
examples on other IC's and SoC.

I remember that Oliver argued on that time that the better would be to reduce the
number of subdirs, instead of increasing. On that discussions, I got convinced 
that he was right, but maybe we have some new reasons to create a subdev dir.

So, let's get some feedback from developers about this again. Whatever decided,
we should clearly document the used criteria, to avoid having drivers misplaced.

Ah, as we're talking about drivers directory, I'm intending to move the Remote
Controller common code to another place, likely drivers/input/rc or drivers/rc.
The idea is to use this subsystem for pure input devices as well. By keeping it
at drivers/media, it will be missplaced.

> What is your opinion on this, and what would be a good time to start moving
> drivers?

If we're doing this change, I prefer to generate the patch by the end of a
merge window, after merging from everybody else and being sure that trivial patches
also got merged.

Comments?

-- 

Cheers,
Mauro
