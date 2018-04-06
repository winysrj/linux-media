Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39747 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751412AbeDFQW5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 12:22:57 -0400
Date: Fri, 6 Apr 2018 13:22:51 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 18/21] media: isppreview: fix __user annotations
Message-ID: <20180406132251.72b5f5c3@vento.lan>
In-Reply-To: <9078125.KNKj9j4yVL@avalon>
References: <cover.1523024380.git.mchehab@s-opensource.com>
        <de3b0b55d826e597f2be27f79e6e8177c0022e6a.1523024380.git.mchehab@s-opensource.com>
        <9078125.KNKj9j4yVL@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 06 Apr 2018 18:54:50 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Friday, 6 April 2018 17:23:19 EEST Mauro Carvalho Chehab wrote:
> > That prevent those warnings:
> >    drivers/media/platform/omap3isp/isppreview.c:893:45: warning: incorrect
> > type in initializer (different address spaces)
> > drivers/media/platform/omap3isp/isppreview.c:893:45:    expected void
> > [noderef] <asn:1>*from drivers/media/platform/omap3isp/isppreview.c:893:45:
> >    got void *[noderef] <asn:1><noident>
> > drivers/media/platform/omap3isp/isppreview.c:893:47: warning: dereference
> > of noderef expression  
> 
> That's nice, but it would be even nicer to explain what the problem is and how 
> you fix it, otherwise one might be left wondering if the fix is correct, or if 
> it could be a false positive.

Ok. Please see the enclosed patch.

> With the commit message updated,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>


Thanks,
Mauro

[PATCH] media: isppreview: fix __user annotations

The 'from' variable at preview_config() expects an __user * type.

However, the logic there does:

    from = *(void * __user *) ((void *)cfg + attr->config_offset);

With actually means a void pointer, pointing to a void __ user
pointer. When the first pointer is de-referenced with *(foo),
the type it returns is "void *" instead of "void __user *".

Change it to:
    from = *(void __user **) ((void *)cfg + attr->config_offset);

in order to obtain, when de-referenced, a void __user pointer,
as desired.

That prevent those warnings:
   drivers/media/platform/omap3isp/isppreview.c:893:45: warning: incorrect type in initializer (different address spaces)
   drivers/media/platform/omap3isp/isppreview.c:893:45:    expected void [noderef] <asn:1>*from
   drivers/media/platform/omap3isp/isppreview.c:893:45:    got void *[noderef] <asn:1><noident>
   drivers/media/platform/omap3isp/isppreview.c:893:47: warning: dereference of noderef expression

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index ac30a0f83780..c2ef5870b231 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -890,7 +890,7 @@ static int preview_config(struct isp_prev_device *prev,
 		params = &prev->params.params[!!(active & bit)];
 
 		if (cfg->flag & bit) {
-			void __user *from = *(void * __user *)
+			void __user *from = *(void __user **)
 				((void *)cfg + attr->config_offset);
 			void *to = (void *)params + attr->param_offset;
 			size_t size = attr->param_size;
