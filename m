Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:53212 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab3DBPrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 11:47:39 -0400
Date: Tue, 2 Apr 2013 17:47:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] V4L: Remove incorrect EXPORT_SYMBOL() usage at v4l2-of.c
In-Reply-To: <515AF82D.1010902@samsung.com>
Message-ID: <Pine.LNX.4.64.1304021747110.31999@axis700.grange>
References: <1364913818-7970-1-git-send-email-s.nawrocki@samsung.com>
 <Pine.LNX.4.64.1304021652021.31999@axis700.grange> <515AF82D.1010902@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2 Apr 2013, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 04/02/2013 04:54 PM, Guennadi Liakhovetski wrote:
> > On Tue, 2 Apr 2013, Sylwester Nawrocki wrote:
> > 
> >> > v4l2_of_parse_parallel_bus() function is now static and
> >> > EXPORT_SYMBOL() doesn't apply to it any more. Drop this
> >> > meaningless statement, which was supposed to be done in
> >> > the original merged patch.
> >> > 
> >> > While at it, edit the copyright notice so it is sorted in
> >> > both the v4l2-of.c and v4l2-of.h file in newest entries
> >> > on top order, and state clearly I'm just the author of
> >> > parts of the code, not the copyright owner.
> >> > 
> >> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >
> > This is not concerning the contents of this patch, but rather the form 
> > confuses me a bit - the two above Sob's: you are the author, and you're 
> > sending the patch to the list, but Kyungmin Park's Sob is the last in the 
> > list, which to me means that your patch went via his tree, but it's you 
> > who's sending it?... I think I saw this pattern in some other your patches 
> > too. What exactly does this mean?
> 
> This means just that Kyungmin approves the patch submission as our manager
> and the internal tree maintainer. He is not necessarily directly involved
> in the development of a patch. As you probably noticed his Signed-off is
> on patches from all our team members. I agree it is not immediately obvious
> what's going on here. This has been discussed in the past few times. For
> instance please refer to this thread:
> 
> http://www.spinics.net/lists/linux-usb/msg74981.html

Ok, thanks, I wasn't aware of this use of Sob.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
