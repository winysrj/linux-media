Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36045 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbeJBFxF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 01:53:05 -0400
Date: Mon, 1 Oct 2018 16:12:51 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: awalls@md.metrocast.net,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] media: cx18: Don't check for address of video_dev
Message-ID: <20181001231251.GA1593@flashbox>
References: <20180921195736.7977-1-natechancellor@gmail.com>
 <20181001152110.20780-1-natechancellor@gmail.com>
 <CAKwvOdk6Z2und-7U6SVHqKxiEk6Ahpuc8_=O7Os5axx43itp5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdk6Z2und-7U6SVHqKxiEk6Ahpuc8_=O7Os5axx43itp5Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 01, 2018 at 04:05:57PM -0700, Nick Desaulniers wrote:
> On Mon, Oct 1, 2018 at 8:22 AM Nathan Chancellor
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
> > Check whether v4l2_dev is null, not the address, so that the statement
> > doesn't fire all the time. This check has been present since 2009,
> > introduced by commit 21a278b85d3c ("V4L/DVB (11619): cx18: Simplify the
> > work handler for outgoing mailbox commands")
> >
> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >
> > v1 -> v2:
> >
> > * Fix build error and logic per review from Hans
> >
> >  drivers/media/pci/cx18/cx18-driver.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
> > index 56763c4ea1a7..a6ba4ca5aa91 100644
> > --- a/drivers/media/pci/cx18/cx18-driver.c
> > +++ b/drivers/media/pci/cx18/cx18-driver.c
> > @@ -1252,7 +1252,7 @@ static void cx18_cancel_out_work_orders(struct cx18 *cx)
> >  {
> >         int i;
> >         for (i = 0; i < CX18_MAX_STREAMS; i++)
> > -               if (&cx->streams[i].video_dev)
> > +               if (cx->streams[i].video_dev.v4l2_dev)
> 
> There we go, that looks better!  Thanks for respinning this patch.  I
> would've given Hans credit in a Suggested-by tag, but there's not
> necessarily strict rules on that (and doesn't necessitate a v3).
> Maybe the maintainer could apply that to the commit message when
> applying?  Either way:
> 
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> 

Very fair point, I should have done that. Will be better about that in
the future.

Thank you for the review,
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
