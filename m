Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56808 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S964862AbcKXO2U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 09:28:20 -0500
Date: Thu, 24 Nov 2016 16:26:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4l-utils v7 3/7] mediactl: Add
 media_entity_get_backlinks()
Message-ID: <20161124142652.GQ16630@valkosipuli.retiisi.org.uk>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-4-git-send-email-j.anaszewski@samsung.com>
 <CGME20161124124125epcas4p17ad5ee584d92f73a8762fa72ade9101c@epcas4p1.samsung.com>
 <20161124124046.GH16630@valkosipuli.retiisi.org.uk>
 <b96fdac8-6e9d-b758-22f9-592aaa624bc0@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b96fdac8-6e9d-b758-22f9-592aaa624bc0@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Thu, Nov 24, 2016 at 03:00:46PM +0100, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> Thanks for the review.

It's taken way too long. :-( My apologies for that.

> On 11/24/2016 01:40 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >On Wed, Oct 12, 2016 at 04:35:18PM +0200, Jacek Anaszewski wrote:
> >>Add a new graph helper useful for discovering video pipeline.
> >>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>---
> >> utils/media-ctl/libmediactl.c | 21 +++++++++++++++++++++
> >> utils/media-ctl/mediactl.h    | 15 +++++++++++++++
> >> 2 files changed, 36 insertions(+)
> >>
> >>diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
> >>index 91ed003..155b65f 100644
> >>--- a/utils/media-ctl/libmediactl.c
> >>+++ b/utils/media-ctl/libmediactl.c
> >>@@ -36,6 +36,7 @@
> >> #include <unistd.h>
> >>
> >> #include <linux/media.h>
> >>+#include <linux/kdev_t.h>
> >
> >Is there something that needs this one in the patch?
> 
> MAJOR and MINOR macros.

Ok.

> 
> >
> >> #include <linux/videodev2.h>
> >>
> >> #include "mediactl.h"
> >>@@ -172,6 +173,26 @@ const struct media_entity_desc *media_entity_get_info(struct media_entity *entit
> >> 	return &entity->info;
> >> }
> >>
> >>+int media_entity_get_backlinks(struct media_entity *entity,
> >>+				struct media_link **backlinks,
> >>+				unsigned int *num_backlinks)
> >>+{
> >>+	unsigned int num_bklinks = 0;
> >>+	int i;
> >>+
> >>+	if (entity == NULL || backlinks == NULL || num_backlinks == NULL)
> >>+		return -EINVAL;
> >>+
> >
> >If you have an interface that accesses a memory buffer of unknown size, you
> >need to verify that the user has provided a buffer large enough.
> >
> >How about using the num_backlinks argument to provide the maximum size to
> >the function, and passing the actual number to the user, the latter of which
> >you already do?
> 
> Sounds reasonable.
> 
> >Alternatively, an iterator style API could be nice as well. Up to you.
> 
> It would probably need an addition of some generic infrastructure.
> I suppose that there is no such a feature in v4l-utils?

You basically need to store a value for the framework to tell which entity
is being worked on. So nothing too fancy.

I guess Laurent would prefer the current interface but I let him answer
that.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
