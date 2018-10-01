Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35312 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729472AbeJAVq0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 17:46:26 -0400
Date: Mon, 1 Oct 2018 08:08:07 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] media: cx18: Don't check for address of video_dev
Message-ID: <20181001150807.GA16790@flashbox>
References: <20180921195736.7977-1-natechancellor@gmail.com>
 <440b7ec3-b0b6-c96b-93de-4b6a3be44eac@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <440b7ec3-b0b6-c96b-93de-4b6a3be44eac@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 01, 2018 at 10:30:54AM +0200, Hans Verkuil wrote:
> On 09/21/2018 09:57 PM, Nathan Chancellor wrote:
> > Clang warns that the address of a pointer will always evaluated as true
> > in a boolean context.
> > 
> > drivers/media/pci/cx18/cx18-driver.c:1255:23: warning: address of
> > 'cx->streams[i].video_dev' will always evaluate to 'true'
> > [-Wpointer-bool-conversion]
> >                 if (&cx->streams[i].video_dev)
> >                 ~~   ~~~~~~~~~~~~~~~^~~~~~~~~
> > 1 warning generated.
> > 
> > Presumably, the contents of video_dev should have been checked, not the
> > address. This check has been present since 2009, introduced by commit
> > 21a278b85d3c ("V4L/DVB (11619): cx18: Simplify the work handler for
> > outgoing mailbox commands")
> > 
> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> > 
> > Alternatively, this if statement could just be removed since it has
> > evaluated to true since 2009 and I assume some issue with this would
> > have been discovered by now.
> > 
> >  drivers/media/pci/cx18/cx18-driver.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
> > index 56763c4ea1a7..753a37c7100a 100644
> > --- a/drivers/media/pci/cx18/cx18-driver.c
> > +++ b/drivers/media/pci/cx18/cx18-driver.c
> > @@ -1252,7 +1252,7 @@ static void cx18_cancel_out_work_orders(struct cx18 *cx)
> >  {
> >  	int i;
> >  	for (i = 0; i < CX18_MAX_STREAMS; i++)
> > -		if (&cx->streams[i].video_dev)
> > +		if (cx->streams[i].video_dev)
> 
> This should read:
> 
> 		if (cx->streams[i].video_dev.v4l2_dev)
> 
> If cx->streams[i].video_dev.v4l2_dev == NULL, then the stream is not in use
> and there is no need to cancel any work.
> 
> Can you post a v2?
> 

Hi Hans,

Yes, sorry, I completely forgot to look into this further. I will sent a
v2 right now.

Thank you for the review,
Nathan

> >  			cancel_work_sync(&cx->streams[i].out_work_order);
> >  }
> >  
> > 
> 
> Regards,
> 
> 	Hans
