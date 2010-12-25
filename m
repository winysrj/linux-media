Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:30633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0LYJH4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 04:07:56 -0500
Message-ID: <4D15B467.90004@redhat.com>
Date: Sat, 25 Dec 2010 07:07:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: Re: Removal of V4L1 drivers
References: <201012241442.39702.hverkuil@xs4all.nl>
In-Reply-To: <201012241442.39702.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 24-12-2010 11:42, Hans Verkuil escreveu:
> Hi Hans, Mauro,
> 
> The se401, vicam, ibmcam and konicawc drivers are the only V4L1 drivers left in
> 2.6.37. The others are either converted or moved to staging (stradis and cpia),
> ready to be removed.
> 
> Hans, what is the status of those four drivers? How likely is it that they will be
> converted to V4L2?
> 
> If we can't convert them to V4L2 for 2.6.38, then we can at least remove the
> V4L1_COMPAT code throughout the v4l drivers and move those four drivers to staging.
> 
> For 2.6.39 we either remove them or when they are converted to V4L2 they are moved
> out of staging again (probably to gspca).
> 
> As an illustration I have removed the V4L1_COMPAT mode in this branch:
> 
> http://git.linuxtv.org/hverkuil/media_tree.git?a=shortlog;h=refs/heads/v4l1

Seems ok for me.

> 
> There are two drivers that need more work: stk-webcam has some controls under sysfs
> that are enabled when CONFIG_VIDEO_V4L1_COMPAT is set. These controls should be
> rewritten as V4L2 controls. Hans, didn't you have hardware to test this driver?
> I should be able to make a patch that you can test.

The conversion seems trivial. Even knowing that none of us have that hardware, I think
we should just convert it and apply the patch. We'll have the entire .38 kernel cycle for
people to test.

> The other driver is the zoran driver which has a bunch of zoran-specific ioctls
> under CONFIG_VIDEO_V4L1_COMPAT. I think I can just delete the lot since they are
> all replaced by V4L2 counterparts AFAIK. But it would be good if someone else can
> also take a look at that.

They seem to mimic v4l2. Also, they implement their own private API, and this is a bad
thing. I doubt that most applications would use that API. So, if the driver works fine
with just V4L2, I think it is ok to just remove that old code. So let's go ahead and 
remove, asking people to test it. I'll do some tests also in Jan.

Cheers,
Mauro
