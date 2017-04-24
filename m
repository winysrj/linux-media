Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48052 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1174402AbdDXU3N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 16:29:13 -0400
Date: Mon, 24 Apr 2017 23:29:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] vb2: Fix an off by one error in
 'vb2_plane_vaddr'
Message-ID: <20170424202906.GW7456@valkosipuli.retiisi.org.uk>
References: <20170423213257.14773-1-christophe.jaillet@wanadoo.fr>
 <20170424141655.GQ7456@valkosipuli.retiisi.org.uk>
 <9aab41eb-5543-58d2-211f-95fb00f5176c@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9aab41eb-5543-58d2-211f-95fb00f5176c@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christophe,

On Mon, Apr 24, 2017 at 10:00:24PM +0200, Christophe JAILLET wrote:
> Le 24/04/2017 à 16:16, Sakari Ailus a écrit :
> >On Sun, Apr 23, 2017 at 11:32:57PM +0200, Christophe JAILLET wrote:
> >>We should ensure that 'plane_no' is '< vb->num_planes' as done in
> >>'vb2_plane_cookie' just a few lines below.
> >>
> >>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> >>---
> >>  drivers/media/v4l2-core/videobuf2-core.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >>diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> >>index 94afbbf92807..c0175ea7e7ad 100644
> >>--- a/drivers/media/v4l2-core/videobuf2-core.c
> >>+++ b/drivers/media/v4l2-core/videobuf2-core.c
> >>@@ -868,7 +868,7 @@ EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
> >>  void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
> >>  {
> >>-	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
> >>+	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
> >>  		return NULL;
> >>  	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
> >Oh my. How could this happen?
> >
> >This should go to stable as well.
> Should I resubmit with "Cc: stable@vger.kernel.org" or will you add it
> yourself?

Please resend. And preferrably figure out which version is the first one
requiring the fix.

Mauro can then pick it up, and it ends up to stable through his tree. I.e.
Cc: stable ... tag is enough, no need to send an actual  e-mail there.

Thanks!

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
