Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34624 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391089AbeIVCaq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 22:30:46 -0400
Date: Fri, 21 Sep 2018 13:40:08 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: awalls@md.metrocast.net,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: cx18: Don't check for address of video_dev
Message-ID: <20180921204008.GA13928@flashbox>
References: <20180921195736.7977-1-natechancellor@gmail.com>
 <CAKwvOdk-w04qavrzeOg_yCH6gYRE4UEX49TJBEb8wMjRssPDdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdk-w04qavrzeOg_yCH6gYRE4UEX49TJBEb8wMjRssPDdQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 21, 2018 at 01:31:37PM -0700, Nick Desaulniers wrote:
> On Fri, Sep 21, 2018 at 1:03 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
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
> >         int i;
> >         for (i = 0; i < CX18_MAX_STREAMS; i++)
> > -               if (&cx->streams[i].video_dev)
> > +               if (cx->streams[i].video_dev)
> 
> cx->streams[i].video_dev has the type `struct video_device video_dev`.
> So wouldn't this change always be true as well, since the struct is
> embedded?
> 

Guess I forgot to compile this with Clang before sending because I now
get a build error (sigh...)

drivers/media/pci/cx18/cx18-driver.c:1255:3: error: statement requires
expression of scalar type ('struct video_device' invalid)                                                                              
                if (cx->streams[i].video_dev)
                                ^   ~~~~~~~~~~~~~~~~~~~~~~~~
                                1 error generated.

I guess the whole if statement should go unless I'm missing something
else.

Thanks for the review!
Nathan

> >                         cancel_work_sync(&cx->streams[i].out_work_order);
> >  }
> >
> > --
> > 2.19.0
> >
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers
