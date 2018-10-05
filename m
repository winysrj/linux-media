Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbeJERcI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:32:08 -0400
Date: Fri, 5 Oct 2018 07:33:52 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH 2/3] media: v4l2-fwnode: cleanup functions that parse
 endpoints
Message-ID: <20181005073352.7cdefbc9@coco.lan>
In-Reply-To: <20181005100824.ibqcgva2iteoq3rt@paasikivi.fi.intel.com>
References: <cover.1538690587.git.mchehab+samsung@kernel.org>
        <19c5acc2b8c64b37005a6934f6f54b32cf93c0dc.1538690587.git.mchehab+samsung@kernel.org>
        <20181005080118.dvw5m7z2xgruu476@paasikivi.fi.intel.com>
        <20181005065220.360198b9@coco.lan>
        <20181005100824.ibqcgva2iteoq3rt@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 5 Oct 2018 13:08:25 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> > > This is still over 80 here. I think we could think of abbreviating what's
> > > in the function name, not limiting to the endpoint. I think I'd prefer to
> > > leave that for 4.21 as there's not much time anymore.  
> > 
> > Yes, I know. Renaming the function is the only way to get rid of
> > those remaining warnings. If you're ok with renaming, IMHO it is best
> > do do it right now, as we are already churning a lot of fwnode-related
> > code, avoiding the need of touching it again for 4.21.  
> 
> This will presumably continue in v4.21 (or later). As noted in the cover
> page of the fwnode patchset:
> 
> 	This patchset does not address remaining issues such as supporting
> 	setting defaults for e.g. bridge drivers with multiple ports, but
> 	with Steve Longerbeam's patchset we're much closer to that goal.

OK! Feel free to rename them when you feel ready. My suggestion is
to do it at the end of a media merging cycle, as makes easier to
avoid conflicts.

I don't care that much about 80 cols. Yet, here it makes a point: we
should be more spartan when naming functions :-)


Thanks,
Mauro
