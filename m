Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47940 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbcEBKwq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2016 06:52:46 -0400
Date: Mon, 2 May 2016 07:52:35 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	<linux-media@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/2] media: exynos4-is: fix deadlock on driver probe
Message-ID: <20160502075235.6772fc3a@recife.lan>
In-Reply-To: <57267C5C.2000403@linux.intel.com>
References: <1461839104-29135-1-git-send-email-m.szyprowski@samsung.com>
 <57267C5C.2000403@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 2 May 2016 00:59:56 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Marek,
> 
> Marek Szyprowski wrote:
> > Commit 0c426c472b5585ed6e59160359c979506d45ae49 ("[media] media: Always
> > keep a graph walk large enough around") changed
> > media_device_register_entity() function to take mdev->graph_mutex. This
> > causes deadlock in driver probe, which calls (indirectly) this function
> > with ->graph_mutex taken. This patch removes taking ->graph_mutex in
> > driver probe to avoid deadlock. Other drivers don't take ->graph_mutex
> > for entity registration, so this change should be safe.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>  
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> You could also add:
> 
> Fixes: 0c426c472b55 ("[media] media: Always keep a graph walk large 
> enough around")
> 
> I guess these should go to fixes, the patches in question are already 
> heading for v4.6. Cc Mauro.

The patches from Sakari for v4.6 were merged already at -rc6. Just merged
them back at the master branch.

Regards,
Mauro
