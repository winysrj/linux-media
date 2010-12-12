Return-path: <mchehab@gaivota>
Received: from mx.treblig.org ([80.68.94.177]:34274 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab0LLR5n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:57:43 -0500
Date: Sun, 12 Dec 2010 17:57:37 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org
Subject: Re: user accesses in ivtv-fileops.c:ivtv_v4l2_write ?
Message-ID: <20101212175737.GA30695@gallifrey>
References: <20101128174022.GA4401@gallifrey> <1292118578.21588.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292118578.21588.13.camel@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

* Andy Walls (awalls@md.metrocast.net) wrote:
> On Sun, 2010-11-28 at 17:40 +0000, Dr. David Alan Gilbert wrote:
> > Hi,
> >   Sparse pointed me at the following line in ivtv-fileops.c's ivtv_v4l2_write:
> > 
> >                 ivtv_write_vbi(itv, (const struct v4l2_sliced_vbi_data *)user_buf, elems);
> > 
> 
> Hi David,
> 
> Let me know if this patch works for your sparse build and adequately
> addresses the problem.

Hi Andy,
  Yes that seems to fix it.
The only other comment I have is that it would probably be better if
ivtv_write_vbi_from_user() were to return an error if the copy_from_user
were to fail and then pass that all the way back up so that if an app passed
a bad pointer in it would get an EFAULT or the like.

Thanks,

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
