Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58612 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759031Ab2EQXHX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 19:07:23 -0400
Received: by wgbdr13 with SMTP id dr13so2198153wgb.1
        for <linux-media@vger.kernel.org>; Thu, 17 May 2012 16:07:22 -0700 (PDT)
Message-ID: <4FB584A8.2000508@gmail.com>
Date: Fri, 18 May 2012 01:07:20 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/1] v4l: Remove "_ACTUAL" from subdev selection API target
 definition names
References: <1337015823-13603-1-git-send-email-s.nawrocki@samsung.com> <1337289325-19336-1-git-send-email-sakari.ailus@iki.fi> <4FB56FAB.7030308@gmail.com> <20120517223523.GO3373@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120517223523.GO3373@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 05/18/2012 12:35 AM, Sakari Ailus wrote:
...
>> On 05/17/2012 11:15 PM, Sakari Ailus wrote:
>>> The string "_ACTUAL" does not say anything more about the target names. Drop
>>> it. V4L2 selection API was changed by "V4L: Rename V4L2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
>>> V4L2_SEL_TGT_[CROP/COMPOSE]" by Sylwester Nawrocki. This patch does the same
>>> for the V4L2 subdev API.
>>>
>>> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
>>
>> Are these all changes, or do you think we could try to drop the _SUBDEV
>> part as well from the below selection target names, so they are same
>> across V4L2 and subdev API ? :-)
>>
>> I realize it might me quite a bit of documentation work and it's pretty
>> late for getting these patches in for v3.5.
>>
>> I still have a dependency on my previous pull request which is pending
>> for the patch you mentioned. Do you think we should leave "_SUBDEV"
>> in subdev selection target names for now (/ever) ?
> 
> I started working on removing the SUBDEV_ in between but I agree with you,
> there seems to be more than just a tiny bit of documentation work. It may be
> we'll go past 3.5 in doing that.
> 
> I think the most important change was to get rid or ACTUAL/ACTIVE anyway.
> What we could do is that we postpone this change after 3.5 (to 3.6) and
> perhaps keep the old subdev targets around awhile.
> 
> In my opinion the user space may (or perhaps even should) begin using the
> V4L2 targets already, but in kernel we'll use the existing subdev targets
> before the removal patch is eventually ready.

That sounds good to me. 

> This is primarily a documentation change after all.
> 
> Could you rebase your exposure metering target definition patch on top of
> the _ACTUAL/_ACTIVE removal patches?

It's not the focus targets patches that would cause conflicts, I have 
postponed them to 3.6. It's just the last patch from this series:

http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/v4l-fimc-exynos4x12

What I could do is just to apply the selection rename patch before it
and to resend whole pull request again. I'll try to do it tomorrow.

--

Best regards,
Sylwester
