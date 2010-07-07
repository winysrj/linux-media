Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40453 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab0GGOGC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 10:06:02 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Wed, 7 Jul 2010 09:05:54 -0500
Subject: RE: [RFC/PATCH 1/6] v4l: subdev: Don't require core operations
Message-ID: <A69FA2915331DC488A831521EAE36FE4016B5EDCC8@dlee06.ent.ti.com>
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1278503608-9126-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278503608-9126-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

This is a good fix. For example, soc based sub devices may not
have core ops implemented. 

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Laurent Pinchart
>Sent: Wednesday, July 07, 2010 7:53 AM
>To: linux-media@vger.kernel.org
>Cc: sakari.ailus@maxwell.research.nokia.com
>Subject: [RFC/PATCH 1/6] v4l: subdev: Don't require core operations
>
>There's no reason to require subdevices to implement the core
>operations. Remove the check for non-NULL core operations when
>initializing the subdev.
>
>Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>---
> include/media/v4l2-subdev.h |    3 +--
> 1 files changed, 1 insertions(+), 2 deletions(-)
>
>diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>index 02c6f4d..6088316 100644
>--- a/include/media/v4l2-subdev.h
>+++ b/include/media/v4l2-subdev.h
>@@ -437,8 +437,7 @@ static inline void v4l2_subdev_init(struct v4l2_subdev
>*sd,
> 					const struct v4l2_subdev_ops *ops)
> {
> 	INIT_LIST_HEAD(&sd->list);
>-	/* ops->core MUST be set */
>-	BUG_ON(!ops || !ops->core);
>+	BUG_ON(!ops);
> 	sd->ops = ops;
> 	sd->v4l2_dev = NULL;
> 	sd->flags = 0;
>--
>1.7.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
