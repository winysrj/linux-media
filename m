Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A9DC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 02:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B41F20651
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 02:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CZkuwVcb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfAPCP1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 21:15:27 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34775 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbfAPCP1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 21:15:27 -0500
Received: by mail-ot1-f68.google.com with SMTP id t5so4753660otk.1
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 18:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NTwjOsQLtwkL0HrGwUEZPbv7SZJ6y40yh4O9uBduU8M=;
        b=CZkuwVcbNq+FmrQr1+TM4SGYF2XOfzbiBaP9E3ETgVEC5G1MjE7PzEtf3gURHJDbJs
         NBrsPQ7gvvA8eSxp/a/6sPvUoZ7g8yNOiTKUfj3H7tHiNWhuDAReOfTLE4JZNJesszJa
         oINwpYabzWkxM9eMuOc0DZDXOioy/zZXmE5vg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NTwjOsQLtwkL0HrGwUEZPbv7SZJ6y40yh4O9uBduU8M=;
        b=M3PpreGWsDCChDZCopu+X9UEppQbT8fNjjalOv6iOc6xDWbOU4oLBVan7yizAEd0ba
         3gskwJEMKlLHr0EPA2tjfcv2BLsHRJ8iqXVtHVstyIgbur8Y9bwjKabSVtz9Y7lcZ03j
         w3PPb3qwZAmOVPVJusa1tF1eWrruJ0OSfQuj2Mlw3j95HMgDo7JQJp6TXPrf45VYSJod
         0gmvEav1hssWgNtDY+4Y5s6Gzb5OLvja6BRQqcGA7pANFSlF+jDIhqW0OUfE9g9sZISW
         v4lb0mLf3EQTOgZQdQW3utNrYxvrLYYyUsWEoInaeVxNorquKrQpupk+yXqPuJKKQmKA
         tmNw==
X-Gm-Message-State: AJcUukfIs5BVWdJI3D/uP0TMHfhVxw6TwM5g9OUmyJZJX1E0KXO7zgyY
        GRiWROn5kPNdoEzHqmVM3IcdUscRSw0=
X-Google-Smtp-Source: ALg8bN6WKESS4ASfdCfI30W369ptT4iQ9fHc2GFv94g0+/tq1FIwt3569FyERpsQAxFxRcZ5heu6bA==
X-Received: by 2002:aca:5b43:: with SMTP id p64mr3409024oib.41.1547604926050;
        Tue, 15 Jan 2019 18:15:26 -0800 (PST)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com. [209.85.210.47])
        by smtp.gmail.com with ESMTPSA id h2sm2053627oti.76.2019.01.15.18.15.24
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 18:15:24 -0800 (PST)
Received: by mail-ot1-f47.google.com with SMTP id e12so4720886otl.5
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 18:15:24 -0800 (PST)
X-Received: by 2002:a9d:1d65:: with SMTP id m92mr4187235otm.65.1547604923923;
 Tue, 15 Jan 2019 18:15:23 -0800 (PST)
MIME-Version: 1.0
References: <1547523465-27807-1-git-send-email-yong.zhi@intel.com>
 <1547523465-27807-2-git-send-email-yong.zhi@intel.com> <CAAFQd5BZc33TkX_u5-vO_n13+73Ga5Pn+ERcFzTe4=HbPWRKXA@mail.gmail.com>
 <1939737.6q52cZT16g@avalon>
In-Reply-To: <1939737.6q52cZT16g@avalon>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 16 Jan 2019 11:15:12 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CZ9bNe7h15T2CYVUfRws1LgdAGRqveiwv0C8rxVJc3sg@mail.gmail.com>
Message-ID: <CAAFQd5CZ9bNe7h15T2CYVUfRws1LgdAGRqveiwv0C8rxVJc3sg@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: ipu3-imgu: Remove dead code for NULL check
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Cao Bing Bu <bingbu.cao@intel.com>, dan.carpenter@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 1:38 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Tomasz,
>
> On Tuesday, 15 January 2019 07:38:01 EET Tomasz Figa wrote:
> > On Tue, Jan 15, 2019 at 12:38 PM Yong Zhi <yong.zhi@intel.com> wrote:
> > > Since ipu3_css_buf_dequeue() never returns NULL, remove the
> > > dead code to fix static checker warning:
> > >
> > > drivers/staging/media/ipu3/ipu3.c:493 imgu_isr_threaded()
> > > warn: 'b' is an error pointer or valid
> > >
> > > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > > ---
> > > Link to Dan's bug report:
> > > https://www.spinics.net/lists/linux-media/msg145043.html
> >
> > You can add Dan's Reported-by above your Signed-off-by to properly
> > credit him. I'd also add a comment below that Reported-by, e.g.
> >
> > [Bug report: https://www.spinics.net/lists/linux-media/msg145043.html]
>
> How about pointing to https://lore.kernel.org/linux-media/
> 20190104122856.GA1169@kadam/ instead, now that we have a shiny new archive
> that should be stable until the end of times ? :-)
>

Even better, thanks! (I often use the lore patchwork, but somehow I
wasn't able to look that patch up there. :))

> > so that it doesn't get removed when applying the patch, as it would
> > get now, because any text right in this area is ignored by git.
> >
> > With that fixes, feel free to add my Reviewed-by.
> >
> > Best regards,
> > Tomasz
> >
> > >  drivers/staging/media/ipu3/ipu3.c | 11 +++++------
> > >  1 file changed, 5 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/staging/media/ipu3/ipu3.c
> > > b/drivers/staging/media/ipu3/ipu3.c index d521b3afb8b1..839d9398f8e9
> > > 100644
> > > --- a/drivers/staging/media/ipu3/ipu3.c
> > > +++ b/drivers/staging/media/ipu3/ipu3.c
> > > @@ -489,12 +489,11 @@ static irqreturn_t imgu_isr_threaded(int irq, void
> > > *imgu_ptr)>
> > >                         mutex_unlock(&imgu->lock);
> > >
> > >                 } while (PTR_ERR(b) == -EAGAIN);
> > >
> > > -               if (IS_ERR_OR_NULL(b)) {
> > > -                       if (!b || PTR_ERR(b) == -EBUSY) /* All done */
> > > -                               break;
> > > -                       dev_err(&imgu->pci_dev->dev,
> > > -                               "failed to dequeue buffers (%ld)\n",
> > > -                               PTR_ERR(b));
> > > +               if (IS_ERR(b)) {
> > > +                       if (PTR_ERR(b) != -EBUSY)       /* All done */
> > > +                               dev_err(&imgu->pci_dev->dev,
> > > +                                       "failed to dequeue buffers
> > > (%ld)\n", +                                       PTR_ERR(b));
> > >
> > >                         break;
> > >
> > >                 }
> > >
> > > --
> > > 2.7.4
>
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>
