Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36486 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbcGOPxT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 11:53:19 -0400
Date: Fri, 15 Jul 2016 12:53:12 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] [media] Documentation: Add HSV format
Message-ID: <20160715125312.481aa36b@recife.lan>
In-Reply-To: <CAPybu_077ZkW3_SnPLqkMMgUUrrBDYH+8WzSEnSHAkyTkE525w@mail.gmail.com>
References: <1468595816-31272-1-git-send-email-ricardo.ribalda@gmail.com>
	<1468595816-31272-3-git-send-email-ricardo.ribalda@gmail.com>
	<20160715122845.7f357277@recife.lan>
	<CAPybu_077ZkW3_SnPLqkMMgUUrrBDYH+8WzSEnSHAkyTkE525w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 15 Jul 2016 17:36:15 +0200
Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> escreveu:

> Hi Mauro
> 
> On Fri, Jul 15, 2016 at 5:28 PM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> > Hi Ricardo,
> >
> > I'm not seeing patch 1.  
> 
> That is because you blacklisted me :P
> https://lkml.org/lkml/2016/7/15/45
> 
> I resend it to you right away.

Thanks.

> >
> > Anyway, please send documentation patches against the rst files. They're
> > at the "docs-next" branch and will be merged upstream on this merge window.
> >  
> 
> you are absolutely right, I read about it in lwn. Sorry about that.
> 
> 
> How do you prefer it:
> - 2 patchset : One on top of media/master with the code changes, and
> one on top of docs-next with the doc changes.
> or
> -1 patchset on top of doc-next and we will figure out later if there
> is a merge conflict with media

IMHO, the best would be to wait for it to be merged. I'm finishing
handling patches for 4.7 in a few, and applying only on more trivial
patches and bug fixes.

Yet, I suspect that there won't be conflicts if you base your
patches against docs-next, as most of the media stuff is merged
there.

Thanks,
Mauro
