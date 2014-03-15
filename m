Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32970 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbaCOOHH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 10:07:07 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2H0016TDVTFR90@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 15 Mar 2014 10:07:05 -0400 (EDT)
Date: Sat, 15 Mar 2014 11:06:59 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC PATCH 1/3] dvbdev: add a dvb_dettach() macro
Message-id: <20140315110659.5f435b40@samsung.com>
In-reply-to: <532459E8.9060903@xs4all.nl>
References: <1394890994-29185-1-git-send-email-m.chehab@samsung.com>
 <1394890994-29185-2-git-send-email-m.chehab@samsung.com>
 <532459E8.9060903@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Mar 2014 14:47:20 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> On 03/15/2014 02:43 PM, Mauro Carvalho Chehab wrote:
> > The dvb_attach() was unbalanced, as there was no dvb_dettach. Ok,
> > on current cases, the dettach is done by dvbdev, but that are some
> > future corner cases where we may need to do this before registering
> > the frontend.
> > 
> > So, add a dvb_dettach() and use it at dvb_frontend.c.
> 
> Typo: it's spelled 'detach', one 't'.

Fixed, thanks! 

The new patches are at:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/dvb_detach

I always assumed that this would be symmetrical, but English is not
always logic ;)

PS.: I won't send a v2 of this RFC patch series just due to that,
as this is just a "cosmetic" correction. So, I'll wait for more
changes before sending a v2.

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/dvb-core/dvb_frontend.c | 8 ++++----
> >  drivers/media/dvb-core/dvbdev.h       | 4 ++++
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> > index 6ce435ac866f..24cf4fbf92a8 100644
> > --- a/drivers/media/dvb-core/dvb_frontend.c
> > +++ b/drivers/media/dvb-core/dvb_frontend.c
> > @@ -2666,20 +2666,20 @@ void dvb_frontend_detach(struct dvb_frontend* fe)
> >  
> >  	if (fe->ops.release_sec) {
> >  		fe->ops.release_sec(fe);
> > -		symbol_put_addr(fe->ops.release_sec);
> > +		dvb_dettach(fe->ops.release_sec);
> >  	}
> >  	if (fe->ops.tuner_ops.release) {
> >  		fe->ops.tuner_ops.release(fe);
> > -		symbol_put_addr(fe->ops.tuner_ops.release);
> > +		dvb_dettach(fe->ops.tuner_ops.release);
> >  	}
> >  	if (fe->ops.analog_ops.release) {
> >  		fe->ops.analog_ops.release(fe);
> > -		symbol_put_addr(fe->ops.analog_ops.release);
> > +		dvb_dettach(fe->ops.analog_ops.release);
> >  	}
> >  	ptr = (void*)fe->ops.release;
> >  	if (ptr) {
> >  		fe->ops.release(fe);
> > -		symbol_put_addr(ptr);
> > +		dvb_dettach(ptr);
> >  	}
> >  }
> >  #else
> > diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
> > index 93a9470d3f0c..49904efc476c 100644
> > --- a/drivers/media/dvb-core/dvbdev.h
> > +++ b/drivers/media/dvb-core/dvbdev.h
> > @@ -136,11 +136,15 @@ extern int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
> >  	__r; \
> >  })
> >  
> > +#define dvb_dettach(FUNC)	symbol_put_addr(FUNC)
> > +
> >  #else
> >  #define dvb_attach(FUNCTION, ARGS...) ({ \
> >  	FUNCTION(ARGS); \
> >  })
> >  
> > +#define dvb_dettach(FUNC)	{}
> > +
> >  #endif
> >  
> >  #endif /* #ifndef _DVBDEV_H_ */
> > 
> 


-- 

Regards,
Mauro
