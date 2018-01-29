Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47552 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751256AbeA2ON0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 09:13:26 -0500
Date: Mon, 29 Jan 2018 12:13:14 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 09/12] v4l2-compat-ioctl32.c: copy clip list in
 put_v4l2_window32
Message-ID: <20180129121302.68ec074a@vela.lan>
In-Reply-To: <20180129094742.x7rofwpgr4yke37h@valkosipuli.retiisi.org.uk>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
        <20180126124327.16653-10-hverkuil@xs4all.nl>
        <20180129094742.x7rofwpgr4yke37h@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Jan 2018 11:47:42 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:


> > +	compat_caddr_t p;
> > +
> >  	if (copy_to_user(&up->w, &kp->w, sizeof(kp->w)) ||
> >  	    put_user(kp->field, &up->field) ||
> >  	    put_user(kp->chromakey, &up->chromakey) ||
> >  	    put_user(kp->clipcount, &up->clipcount) ||
> >  	    put_user(kp->global_alpha, &up->global_alpha))
> >  		return -EFAULT;  
> 
> One more newline here?

Why? A new line here would be weird.





Cheers,
Mauro
