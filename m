Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0JWAbZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 20:31:25 -0400
Message-ID: <4CC22CD0.1090800@redhat.com>
Date: Fri, 22 Oct 2010 22:31:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: David Ellingsworth <david@identd.dyndns.org>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] radio-mr800: locking fixes
References: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl> <AANLkTikdgWXsmGE1KPC3KbLc37T_=G3Aa8RaVhL1PsAN@mail.gmail.com> <AANLkTi=S4o+V0YSbkySEpVOCMFx5JJC-TB5QzYN0B=Qx@mail.gmail.com> <201010181751.39859.hverkuil@xs4all.nl>
In-Reply-To: <201010181751.39859.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 18-10-2010 13:51, Hans Verkuil escreveu:
> On Monday, October 18, 2010 16:55:40 David Ellingsworth wrote:
>> OK, I see how this fixes it now.. You added the video_is_registered
>> check inside v4l2_open after acquiring the device lock. So while it
>> fixes that race it's rather ugly and very difficult to follow. In this
>> case, the original code provided an easier to follow sequence. If
>> possible it would be nice if v4l2_open and v4l2_unlocked_ioctl relied
>> on the device being connected rather than registered. Then this would
>> have been a non-issue and it would be much easier to follow.
> 
> I agree that it isn't the prettiest code. My goal is to improve the v4l
> core to make such cases easier to handle. But I'm waiting for the next
> kernel cycle before I continue with this.
> 
> Working on this driver definitely helped give me a better understanding of
> what is involved.
> 
> Regards,
>
Any conclusion about the locking fixes patch?

Cheers,
Mauro
