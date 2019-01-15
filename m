Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43766C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 16:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 150C320675
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 16:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="rXiPkoGN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbfAOQiL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 11:38:11 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:43968 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732021AbfAOQiL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 11:38:11 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id CDED34F8;
        Tue, 15 Jan 2019 17:38:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547570288;
        bh=XfEjJ0bnKddRXNU+I+8HBH2vLsab+TCixJ/UGxXGch0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXiPkoGNikaV2YDEahGbFLoNxTCiKr3Tkj2ATD1o0Tkd4ho1EMBfdxkRk+t6xEP3K
         oTuZoWOpLkJIvEqB1e8VU9gkDEcA/kCHMoxjeutSVabamtrP3j7JV/hWsFkKiv1Mx4
         kEwtfxjKF1KZkNVw64c76fF+Hnom2mkKmFkSZ0FE=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Cao Bing Bu <bingbu.cao@intel.com>, dan.carpenter@oracle.com
Subject: Re: [PATCH 2/2] media: ipu3-imgu: Remove dead code for NULL check
Date:   Tue, 15 Jan 2019 18:39:24 +0200
Message-ID: <1939737.6q52cZT16g@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <CAAFQd5BZc33TkX_u5-vO_n13+73Ga5Pn+ERcFzTe4=HbPWRKXA@mail.gmail.com>
References: <1547523465-27807-1-git-send-email-yong.zhi@intel.com> <1547523465-27807-2-git-send-email-yong.zhi@intel.com> <CAAFQd5BZc33TkX_u5-vO_n13+73Ga5Pn+ERcFzTe4=HbPWRKXA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tomasz,

On Tuesday, 15 January 2019 07:38:01 EET Tomasz Figa wrote:
> On Tue, Jan 15, 2019 at 12:38 PM Yong Zhi <yong.zhi@intel.com> wrote:
> > Since ipu3_css_buf_dequeue() never returns NULL, remove the
> > dead code to fix static checker warning:
> > 
> > drivers/staging/media/ipu3/ipu3.c:493 imgu_isr_threaded()
> > warn: 'b' is an error pointer or valid
> > 
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> > Link to Dan's bug report:
> > https://www.spinics.net/lists/linux-media/msg145043.html
> 
> You can add Dan's Reported-by above your Signed-off-by to properly
> credit him. I'd also add a comment below that Reported-by, e.g.
> 
> [Bug report: https://www.spinics.net/lists/linux-media/msg145043.html]

How about pointing to https://lore.kernel.org/linux-media/
20190104122856.GA1169@kadam/ instead, now that we have a shiny new archive 
that should be stable until the end of times ? :-)

> so that it doesn't get removed when applying the patch, as it would
> get now, because any text right in this area is ignored by git.
> 
> With that fixes, feel free to add my Reviewed-by.
> 
> Best regards,
> Tomasz
> 
> >  drivers/staging/media/ipu3/ipu3.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/staging/media/ipu3/ipu3.c
> > b/drivers/staging/media/ipu3/ipu3.c index d521b3afb8b1..839d9398f8e9
> > 100644
> > --- a/drivers/staging/media/ipu3/ipu3.c
> > +++ b/drivers/staging/media/ipu3/ipu3.c
> > @@ -489,12 +489,11 @@ static irqreturn_t imgu_isr_threaded(int irq, void
> > *imgu_ptr)> 
> >                         mutex_unlock(&imgu->lock);
> >                 
> >                 } while (PTR_ERR(b) == -EAGAIN);
> > 
> > -               if (IS_ERR_OR_NULL(b)) {
> > -                       if (!b || PTR_ERR(b) == -EBUSY) /* All done */
> > -                               break;
> > -                       dev_err(&imgu->pci_dev->dev,
> > -                               "failed to dequeue buffers (%ld)\n",
> > -                               PTR_ERR(b));
> > +               if (IS_ERR(b)) {
> > +                       if (PTR_ERR(b) != -EBUSY)       /* All done */
> > +                               dev_err(&imgu->pci_dev->dev,
> > +                                       "failed to dequeue buffers
> > (%ld)\n", +                                       PTR_ERR(b));
> > 
> >                         break;
> >                 
> >                 }
> > 
> > --
> > 2.7.4


-- 
Regards,

Laurent Pinchart



