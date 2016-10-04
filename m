Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48131 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752553AbcJDH7n (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2016 03:59:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Harman Kalra <harman4linux@gmail.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] : Removing warnings caught by checkpatch.pl
Date: Tue, 04 Oct 2016 10:59:37 +0300
Message-ID: <14918603.Xr1i9JU9lz@avalon>
In-Reply-To: <20161003215211.okrvsky5bgglm75p@acer>
References: <1475355646-6378-1-git-send-email-harman4linux@gmail.com> <20161003215211.okrvsky5bgglm75p@acer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

On Monday 03 Oct 2016 22:52:11 Andrey Utkin wrote:
> On Sun, Oct 02, 2016 at 02:30:45AM +0530, Harman Kalra wrote:
> >  static int iss_video_queue_setup(struct vb2_queue *vq,
> > 
> > -				 unsigned int *count, unsigned int 
*num_planes,
> > -				 unsigned int sizes[], struct device 
*alloc_devs[])
> > +			unsigned int *count, unsigned int *num_planes,
> > +			unsigned int sizes[], struct device *alloc_devs[])
> 
> 2 spaces + 3 tabs -> 2 spaces + 2 tabs? Am I seeing this correctly?
> Both ways are against CodingStyle.

It's 4 tabs + 1 space -> 3 tabs as far as I can see.

> > -	/* Try the get selection operation first and fallback to get format if
> > not -	 * implemented.
> > +	/* Try the get selection operation first and
> > +	 * fallback to get format if not implemented.
> > 
> >  	 */
> 
> This comment style is discouraged so this is at lease not perfect.
> Doesn't checkpatch complain with this change? If it doesn't, could you
> please also check with --strict, as long as you're working on style.

-- 
Regards,

Laurent Pinchart

