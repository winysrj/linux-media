Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53144 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750726AbdAaKmz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 05:42:55 -0500
Date: Tue, 31 Jan 2017 12:42:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Avraham Shukron <avraham.shukron@gmail.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: omap4iss: fix coding style issues
Message-ID: <20170131104251.GU7139@valkosipuli.retiisi.org.uk>
References: <1485626408-9768-1-git-send-email-avraham.shukron@gmail.com>
 <4008193.dpuA6Cf6Yl@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4008193.dpuA6Cf6Yl@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 30, 2017 at 07:47:40PM +0200, Laurent Pinchart wrote:
> > @@ -678,8 +679,8 @@ iss_video_get_selection(struct file *file, void *fh,
> > struct v4l2_selection *sel) if (subdev == NULL)
> >  		return -EINVAL;
> > 
> > -	/* Try the get selection operation first and fallback to get format if 
> not
> > -	 * implemented.
> > +	/* Try the get selection operation first and fallback to get format if
> > +	 * not implemented.
> >  	 */

/*
 * Multi line
 * comment.
 */

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
