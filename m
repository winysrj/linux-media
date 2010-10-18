Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3580 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab0JRPvt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 11:51:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Ellingsworth <david@identd.dyndns.org>
Subject: Re: [RFC PATCH] radio-mr800: locking fixes
Date: Mon, 18 Oct 2010 17:51:39 +0200
Cc: linux-media@vger.kernel.org
References: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl> <AANLkTikdgWXsmGE1KPC3KbLc37T_=G3Aa8RaVhL1PsAN@mail.gmail.com> <AANLkTi=S4o+V0YSbkySEpVOCMFx5JJC-TB5QzYN0B=Qx@mail.gmail.com>
In-Reply-To: <AANLkTi=S4o+V0YSbkySEpVOCMFx5JJC-TB5QzYN0B=Qx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010181751.39859.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, October 18, 2010 16:55:40 David Ellingsworth wrote:
> OK, I see how this fixes it now.. You added the video_is_registered
> check inside v4l2_open after acquiring the device lock. So while it
> fixes that race it's rather ugly and very difficult to follow. In this
> case, the original code provided an easier to follow sequence. If
> possible it would be nice if v4l2_open and v4l2_unlocked_ioctl relied
> on the device being connected rather than registered. Then this would
> have been a non-issue and it would be much easier to follow.

I agree that it isn't the prettiest code. My goal is to improve the v4l
core to make such cases easier to handle. But I'm waiting for the next
kernel cycle before I continue with this.

Working on this driver definitely helped give me a better understanding of
what is involved.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
