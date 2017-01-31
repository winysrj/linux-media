Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:43273 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751159AbdAaStj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 13:49:39 -0500
Message-ID: <1485888573.20550.35.camel@perches.com>
Subject: Re: [PATCH 6/6] staging: bcm2835-v4l2: Apply spelling fixes from
 checkpatch.
From: Joe Perches <joe@perches.com>
To: Eric Anholt <eric@anholt.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Jan 2017 10:49:33 -0800
In-Reply-To: <87k29b84ln.fsf@eliezer.anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
         <20170127215503.13208-7-eric@anholt.net>
         <1485556233.12563.142.camel@perches.com>
         <87inowfh55.fsf@eliezer.anholt.net> <1485826718.20550.14.camel@perches.com>
         <87k29b84ln.fsf@eliezer.anholt.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-01-31 at 10:30 -0800, Eric Anholt wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > On Mon, 2017-01-30 at 12:05 -0800, Eric Anholt wrote:
> > > Joe Perches <joe@perches.com> writes:
> > > 
> > > > On Fri, 2017-01-27 at 13:55 -0800, Eric Anholt wrote:
> > > > > Generated with checkpatch.pl --fix-inplace and git add -p out of the
> > > > > results.
> > > > 
> > > > Maybe another.
> > > > 
> > > > > diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
> > > > 
> > > > []
> > > > > @@ -239,7 +239,7 @@ static int bulk_receive(struct vchiq_mmal_instance *instance,
> > > > >  		pr_err("buffer list empty trying to submit bulk receive\n");
> > > > >  
> > > > >  		/* todo: this is a serious error, we should never have
> > > > > -		 * commited a buffer_to_host operation to the mmal
> > > > > +		 * committed a buffer_to_host operation to the mmal
> > > > >  		 * port without the buffer to back it up (underflow
> > > > >  		 * handling) and there is no obvious way to deal with
> > > > >  		 * this - how is the mmal servie going to react when
> > > > 
> > > > Perhaps s/servie/service/ ?
> > > 
> > > I was trying to restrict this patch to just the fixes from checkpatch.
> > 
> > That's the wrong thing to do if you're fixing
> > spelling defects.  checkpatch is just one mechanism
> > to identify some, and definitely not all, typos and
> > spelling defects.
> > 
> > If you fixing, fix.  Don't just rely on the brainless
> > tools, use your decidedly non-mechanical brain.
> 
> "if you touch anything, you must fix everything."  If that's how things
> work, I would just retract the patch.

I didn't say that,and I don't mean that.

If you notice a similar defect when you are fixing
any arbitrary defect, please try to fix all of similar
defects.

As is, a patch that fixes just servie would cause a
patch conflict with your patch.

