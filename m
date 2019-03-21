Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C8AC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 12:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9EF9218D8
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 12:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553170817;
	bh=N/hzBnXxAanyWErCHWnXd60pOObo8QtPaEnNlqV/HBo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=JIRdecdACwZJ/YTcNZfCMzOL5Wkkc9phGxeoQP1t2JAnykCtTvWqFjQfeSuRcUeI/
	 SLqTo2DJyDRbIH/WP7UiIMfVuqf1BJZ6Ki5d2rn68B7eZpxLYuyqqUx2pV3Mo/TfpS
	 5TBB7DVHaYRsiBzN9fS35jkbcQVrYB6TfQq/ubcc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfCUMUR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 08:20:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:52536 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfCUMUR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 08:20:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eCalwW2e+xTYhTpK9evn/gNtvi7tobDLlOk5LhfSc6M=; b=S+/nhzgVLcicgTyRSkjvtfjrNs
        G7gfCx2IlKPSHtaY8XzOTVSNGzFna+/1GUz+cvJ0M/zrH9umrkrQi9KcM3VAUneqoebatHj+aqYKG
        uKd97q064GVy+OiBkOsOZxj7YXONhkXlM6V0dOM9JFNRnbwsxlkxGoYkt0/rOHpsV8ZmQjaMnipCD
        znXJuIQt9nSOCRoh/mlojOTQiyJ5gqud4B0jePxkK+4DyNfeh5jrlBo3zeVe/B5eNJvA6FRHKDFzM
        J01ggmx6zq3VGSwMOTmisorm1blE3nwv9PO5r+ePhLkOce2hEAdizPM09jyW3oVWkzPC69WtyVo8N
        RjbnKMqw==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6wg8-0002d6-9S; Thu, 21 Mar 2019 12:20:13 +0000
Date:   Thu, 21 Mar 2019 09:20:07 -0300
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/7] [media] doc-rst: switch to new names for Full
 Screen/Aspect keys
Message-ID: <20190321092007.3eb2fd2a@coco.lan>
In-Reply-To: <20190218072606.GG242714@dtor-ws>
References: <20190118233037.87318-1-dmitry.torokhov@gmail.com>
        <20190118233037.87318-2-dmitry.torokhov@gmail.com>
        <20190218072606.GG242714@dtor-ws>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Sun, 17 Feb 2019 23:26:06 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> escreveu:

> On Fri, Jan 18, 2019 at 03:30:32PM -0800, Dmitry Torokhov wrote:
> > We defined better names for keys to activate full screen mode or
> > change aspect ratio (while keeping the existing keycodes to avoid
> > breaking userspace), so let's use them in the document.
> > 
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> >  Documentation/media/uapi/rc/rc-tables.rst | 4 ++--  
> 
> Mauro, do you want to take this through your tree or I should pick it up
> with the patch that does renames in uapi header?

Feel free to apply it via your tree. It probably makes sense to keep it
with the series that add the new codes.

Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> 
> Thanks!
> 
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/rc/rc-tables.rst b/Documentation/media/uapi/rc/rc-tables.rst
> > index c8ae9479f842..57797e56f45e 100644
> > --- a/Documentation/media/uapi/rc/rc-tables.rst
> > +++ b/Documentation/media/uapi/rc/rc-tables.rst
> > @@ -616,7 +616,7 @@ the remote via /dev/input/event devices.
> >  
> >      -  .. row 78
> >  
> > -       -  ``KEY_SCREEN``
> > +       -  ``KEY_ASPECT_RATIO``
> >  
> >         -  Select screen aspect ratio
> >  
> > @@ -624,7 +624,7 @@ the remote via /dev/input/event devices.
> >  
> >      -  .. row 79
> >  
> > -       -  ``KEY_ZOOM``
> > +       -  ``KEY_FULL_SCREEN``
> >  
> >         -  Put device into zoom/full screen mode
> >  
> > -- 
> > 2.20.1.321.g9e740568ce-goog
> >   
> 



Thanks,
Mauro
