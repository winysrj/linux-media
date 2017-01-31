Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35669 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbdAaKqd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 05:46:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Avraham Shukron <avraham.shukron@gmail.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: omap4iss: fix coding style issues
Date: Tue, 31 Jan 2017 12:46:51 +0200
Message-ID: <99077677.ouMsYN1JNl@avalon>
In-Reply-To: <20170131104251.GU7139@valkosipuli.retiisi.org.uk>
References: <1485626408-9768-1-git-send-email-avraham.shukron@gmail.com> <4008193.dpuA6Cf6Yl@avalon> <20170131104251.GU7139@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 31 Jan 2017 12:42:51 Sakari Ailus wrote:
> On Mon, Jan 30, 2017 at 07:47:40PM +0200, Laurent Pinchart wrote:
> > > @@ -678,8 +679,8 @@ iss_video_get_selection(struct file *file, void *fh,
> > > struct v4l2_selection *sel) if (subdev == NULL)
> > > 
> > >  		return -EINVAL;
> > > 
> > > -	/* Try the get selection operation first and fallback to get format if
> > 
> > not
> > 
> > > -	 * implemented.
> > > +	/* Try the get selection operation first and fallback to get format if
> > > +	 * not implemented.
> > > 
> > >  	 */
> 
> /*
>  * Multi line
>  * comment.
>  */

Then let's patch the whole driver in one go :-)

-- 
Regards,

Laurent Pinchart

