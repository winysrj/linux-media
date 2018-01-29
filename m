Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43454 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751450AbeA2VA3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 16:00:29 -0500
Date: Mon, 29 Jan 2018 23:00:26 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 09/12] v4l2-compat-ioctl32.c: copy clip list in
 put_v4l2_window32
Message-ID: <20180129210026.o5c6fhbyt24lrosu@valkosipuli.retiisi.org.uk>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
 <20180126124327.16653-10-hverkuil@xs4all.nl>
 <20180129094742.x7rofwpgr4yke37h@valkosipuli.retiisi.org.uk>
 <20180129121302.68ec074a@vela.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180129121302.68ec074a@vela.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 29, 2018 at 12:13:14PM -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 29 Jan 2018 11:47:42 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> 
> > > +	compat_caddr_t p;
> > > +
> > >  	if (copy_to_user(&up->w, &kp->w, sizeof(kp->w)) ||
> > >  	    put_user(kp->field, &up->field) ||
> > >  	    put_user(kp->chromakey, &up->chromakey) ||
> > >  	    put_user(kp->clipcount, &up->clipcount) ||
> > >  	    put_user(kp->global_alpha, &up->global_alpha))
> > >  		return -EFAULT;  
> > 
> > One more newline here?
> 
> Why? A new line here would be weird.

There are two if clauses that are unrelated. I'd say it improves
readability to separate them. That said, this isn't an exact science, so I
leave this up to Hans to decide.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
