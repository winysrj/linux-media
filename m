Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CA8C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 05:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3827D20651
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 05:38:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="F4gx781D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfAOFiQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 00:38:16 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42326 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbfAOFiQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 00:38:16 -0500
Received: by mail-ot1-f67.google.com with SMTP id v23so1420764otk.9
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 21:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HEJJ/FUBoVOlyWjiJWle5JFcO+QW0w8wllteFrlniQg=;
        b=F4gx781DvJCPp1yyrjtHzhtMlZEXIQ1/2Hicn4QvTRvR/ZscuqxC2sBGIgcmpNNaQS
         1kvwUyTSoU8j8nCkaDfOsMBw3jmxCSWQT44e9Sw0u2T4N+qVI0A6ZIeBVFQY5haBqf84
         CevWhZkWiyMn91zwR4t08/OiOA1mAVIz+kXsc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HEJJ/FUBoVOlyWjiJWle5JFcO+QW0w8wllteFrlniQg=;
        b=tBho831sBA3sWM3h2qYKjxzlEDLlnaG29XJDkgiBgKTJrlJDqh80tEulzlgbl3Epgw
         t4+lWj+dONbwcqGS5yNtGfHvceDvW/2A5mAmSW6VQuKM68/PLV6Zij//vn9seMyWxR8W
         /hqraTMtqhebtnkf0hrfOzXZJs0Kff+SOgS00Z5luNH5dtr2PGehlvTBTNeEMAcIvD4J
         xacXNIYlHRagul2UG/w6w38mN09gDce/Pa/njHMfmXeEiKrAS7lbPxE8L17dTY110tLy
         kBxYuSUKzKv3VBtVDOXumM9P29noBnAZATNCTv/AZweiawv8+OvzWML50GowpNJWfUXP
         wDJQ==
X-Gm-Message-State: AJcUukc6879cMIGx+KKupzpNN3v06kx0uYcBWFBmYy1Dci2cpJkK4Pka
        NKPioPkI0pu+jZch9U5arOWdSKcQKDc=
X-Google-Smtp-Source: ALg8bN5nkXgv44nykgc+ozvO0CDxfuZx0IS6CxJtPG07Cg1tgfVhK4UavYF6ldnJJshM6uqSV8O/SA==
X-Received: by 2002:a9d:5d2:: with SMTP id 76mr1305723otd.78.1547530694733;
        Mon, 14 Jan 2019 21:38:14 -0800 (PST)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com. [209.85.210.51])
        by smtp.gmail.com with ESMTPSA id i22sm1107500otl.20.2019.01.14.21.38.13
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 21:38:13 -0800 (PST)
Received: by mail-ot1-f51.google.com with SMTP id s13so1451711otq.4
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 21:38:13 -0800 (PST)
X-Received: by 2002:a05:6830:1193:: with SMTP id u19mr1353344otq.152.1547530693196;
 Mon, 14 Jan 2019 21:38:13 -0800 (PST)
MIME-Version: 1.0
References: <1547523465-27807-1-git-send-email-yong.zhi@intel.com> <1547523465-27807-2-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1547523465-27807-2-git-send-email-yong.zhi@intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 15 Jan 2019 14:38:01 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BZc33TkX_u5-vO_n13+73Ga5Pn+ERcFzTe4=HbPWRKXA@mail.gmail.com>
Message-ID: <CAAFQd5BZc33TkX_u5-vO_n13+73Ga5Pn+ERcFzTe4=HbPWRKXA@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: ipu3-imgu: Remove dead code for NULL check
To:     Yong Zhi <yong.zhi@intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Cao Bing Bu <bingbu.cao@intel.com>, dan.carpenter@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Yong,

On Tue, Jan 15, 2019 at 12:38 PM Yong Zhi <yong.zhi@intel.com> wrote:
>
> Since ipu3_css_buf_dequeue() never returns NULL, remove the
> dead code to fix static checker warning:
>
> drivers/staging/media/ipu3/ipu3.c:493 imgu_isr_threaded()
> warn: 'b' is an error pointer or valid
>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
> Link to Dan's bug report:
> https://www.spinics.net/lists/linux-media/msg145043.html

You can add Dan's Reported-by above your Signed-off-by to properly
credit him. I'd also add a comment below that Reported-by, e.g.

[Bug report: https://www.spinics.net/lists/linux-media/msg145043.html]

so that it doesn't get removed when applying the patch, as it would
get now, because any text right in this area is ignored by git.

With that fixes, feel free to add my Reviewed-by.

Best regards,
Tomasz

>
>  drivers/staging/media/ipu3/ipu3.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
> index d521b3afb8b1..839d9398f8e9 100644
> --- a/drivers/staging/media/ipu3/ipu3.c
> +++ b/drivers/staging/media/ipu3/ipu3.c
> @@ -489,12 +489,11 @@ static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
>                         mutex_unlock(&imgu->lock);
>                 } while (PTR_ERR(b) == -EAGAIN);
>
> -               if (IS_ERR_OR_NULL(b)) {
> -                       if (!b || PTR_ERR(b) == -EBUSY) /* All done */
> -                               break;
> -                       dev_err(&imgu->pci_dev->dev,
> -                               "failed to dequeue buffers (%ld)\n",
> -                               PTR_ERR(b));
> +               if (IS_ERR(b)) {
> +                       if (PTR_ERR(b) != -EBUSY)       /* All done */
> +                               dev_err(&imgu->pci_dev->dev,
> +                                       "failed to dequeue buffers (%ld)\n",
> +                                       PTR_ERR(b));
>                         break;
>                 }
>
> --
> 2.7.4
>
