Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1CQNTO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2011 09:19:14 -0400
Date: Thu, 17 Mar 2011 09:19:09 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/6] lirc_zilog: error out if buffer read bytes != chunk
 size
Message-ID: <20110317131909.GA5941@redhat.com>
References: <1300307071-19665-1-git-send-email-jarod@redhat.com>
 <1300307071-19665-6-git-send-email-jarod@redhat.com>
 <1300320442.2296.25.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300320442.2296.25.camel@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Mar 16, 2011 at 08:07:22PM -0400, Andy Walls wrote:
> On Wed, 2011-03-16 at 16:24 -0400, Jarod Wilson wrote:
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > ---
> >  drivers/staging/lirc/lirc_zilog.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
> > index 407d4b4..5ada643 100644
> > --- a/drivers/staging/lirc/lirc_zilog.c
> > +++ b/drivers/staging/lirc/lirc_zilog.c
> > @@ -950,6 +950,10 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
> >  				ret = copy_to_user((void *)outbuf+written, buf,
> >  						   rbuf->chunk_size);
> >  				written += rbuf->chunk_size;
> > +			} else {
> > +				zilog_error("Buffer read failed!\n");
> > +				ret = -EIO;
> > +				break;
> 
> No need to break, just let the non-0 ret value drop you out of the while
> loop.

Ah, indeed. I think I mindlessly copied what the tests just a few lines
above were doing without looking at the actual reason for them. I'll
remove that break from the patch here locally.

-- 
Jarod Wilson
jarod@redhat.com

