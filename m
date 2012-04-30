Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39794 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754088Ab2D3NER (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 09:04:17 -0400
Date: Mon, 30 Apr 2012 16:04:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
Message-ID: <20120430130413.GL7913@valkosipuli.localdomain>
References: <1335789624-15940-1-git-send-email-sakari.ailus@iki.fi>
 <2157218.XOp52YA11m@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2157218.XOp52YA11m@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Apr 30, 2012 at 02:48:23PM +0200, Laurent Pinchart wrote:
> On Monday 30 April 2012 15:40:24 Sakari Ailus wrote:
> > Remove input field in struct v4l2_buffer and flag V4L2_BUF_FLAG_INPUT which
> > tells the former is valid. The flag is used by no driver currently.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> > Hi all,
> > 
> > I thought this would be a good time to get rid of the input field in
> > v4l2_buffer to avoid writing more useless compat code for it --- the enum
> > compat code.
> > 
> > Comments are welcome. This patch is compile tested on videobuf and
> > videobuf2.
> 
> I'm all for this. As far as I know, the field was only useful for a single 
> out-of-tree driver which is long dead now.
> 
> >  drivers/media/video/v4l2-compat-ioctl32.c |    8 +++-----
> >  drivers/media/video/videobuf-core.c       |   16 ----------------
> >  drivers/media/video/videobuf2-core.c      |    4 +---
> >  include/linux/videodev2.h                 |    4 +---
> >  include/media/videobuf-core.h             |    2 --
> 
> A quick grep through the code shows that you've missed the cpia2 driver which 
> sets the input field to 0 in cpia2_dqbuf(). Please try to compile as many 
> drivers as possible with this patch. Using coccinelle 
> (http://coccinelle.lip6.fr/) could help finding other accesses to the input 
> field.

I grepped them but forgot to give -r option to grep... I found no further
uses of the input field by quick looking. I'll compile what I can and resend
the patch.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
