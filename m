Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60228 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S967208Ab2EQWf2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 18:35:28 -0400
Date: Fri, 18 May 2012 01:35:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/1] v4l: Remove "_ACTUAL" from subdev selection API
 target definition names
Message-ID: <20120517223523.GO3373@valkosipuli.retiisi.org.uk>
References: <1337015823-13603-1-git-send-email-s.nawrocki@samsung.com>
 <1337289325-19336-1-git-send-email-sakari.ailus@iki.fi>
 <4FB56FAB.7030308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB56FAB.7030308@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, May 17, 2012 at 11:37:47PM +0200, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> thanks for the patch.
> 
> On 05/17/2012 11:15 PM, Sakari Ailus wrote:
> > The string "_ACTUAL" does not say anything more about the target names. Drop
> > it. V4L2 selection API was changed by "V4L: Rename V4L2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
> > V4L2_SEL_TGT_[CROP/COMPOSE]" by Sylwester Nawrocki. This patch does the same
> > for the V4L2 subdev API.
> > 
> > Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
> 
> Are these all changes, or do you think we could try to drop the _SUBDEV
> part as well from the below selection target names, so they are same
> across V4L2 and subdev API ? :-)
> 
> I realize it might me quite a bit of documentation work and it's pretty 
> late for getting these patches in for v3.5.
> 
> I still have a dependency on my previous pull request which is pending
> for the patch you mentioned. Do you think we should leave "_SUBDEV"
> in subdev selection target names for now (/ever) ? 

I started working on removing the SUBDEV_ in between but I agree with you,
there seems to be more than just a tiny bit of documentation work. It may be
we'll go past 3.5 in doing that.

I think the most important change was to get rid or ACTUAL/ACTIVE anyway.
What we could do is that we postpone this change after 3.5 (to 3.6) and
perhaps keep the old subdev targets around awhile.

In my opinion the user space may (or perhaps even should) begin using the
V4L2 targets already, but in kernel we'll use the existing subdev targets
before the removal patch is eventually ready.

This is primarily a documentation change after all.

Could you rebase your exposure metering target definition patch on top of
the _ACTUAL/_ACTIVE removal patches?

Kind regars,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
