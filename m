Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F6EC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71461214AE
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:54:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="f5EjqzJz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfCLIyw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:54:52 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38824 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCLIyw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 04:54:52 -0400
Received: by mail-ot1-f66.google.com with SMTP id m1so1776923otf.5
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 01:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SV1BA8fVO901ls3aPgscEsYlZvxLWGXKbv1ZBpkuZVo=;
        b=f5EjqzJzrZEfPRPoz1gTiSnz837ZXVOAkOX5ZeCCm7DQj2y43K86p/yocF5LpU69dR
         nE8cVuK5bu0mwQ4Gsw4ad4E5Z7pALU872FuRCZkUwUorBcmmRzQ2WuWF7jFR+cce/K/M
         cMld7+PLYu+HA25wgF8Cbx9A0vCt1egOb4Sps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SV1BA8fVO901ls3aPgscEsYlZvxLWGXKbv1ZBpkuZVo=;
        b=IVqzI+GCS92FNQnSwn761r2eVA+2jtPt9tdB2dfc9WXe24GUsAIsTWNZwRlKZNXHZG
         7mrDZAD9Pk1swtmJ7tS7r8vXZ9HX2H7aFu5zdqhIp2HKLWvC8lMOydvK7U19NAPrEZiO
         5V30WX6l4jvBtKQzAZ6V3BxF68TbuD5jbyYzNU6arY7DL45jLrH8cukPR/QQrqGYrkW4
         ylw+a3x8Qhg2KnbJ4n+aX1pDnpuyijmHk/cDg3CiMNj73Xpw/gkcQk3r8VJ7R67dEAzG
         Sis+WrTmcROCFLAi/e+f2CvW0pWdilL5ll18V2knrmRL4PnMr61zHRmK1JP8/buGu0Fu
         HTxQ==
X-Gm-Message-State: APjAAAVEFCdzVyyAewoMdaXgfY/bKJOBnTxTOqHnnwZdFu2xpC8S7Vi4
        TVoFBxALRm2po7XLw3awzCveXTWYumE=
X-Google-Smtp-Source: APXvYqwDiWsF4OpE2nfYkAhfPxeCoVWBWJQq78HtDqvrNenSACdRJ9Uzp/pLkrfD9JERF/FUmxKZoQ==
X-Received: by 2002:a05:6830:125a:: with SMTP id s26mr25064840otp.74.1552380890584;
        Tue, 12 Mar 2019 01:54:50 -0700 (PDT)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id e13sm3276423otq.61.2019.03.12.01.54.49
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 01:54:49 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id k11so887956oic.7
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 01:54:49 -0700 (PDT)
X-Received: by 2002:aca:b7c4:: with SMTP id h187mr1055185oif.112.1552380889201;
 Tue, 12 Mar 2019 01:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <1550221729-29240-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5BOJmE51nrbK+3KGeQWN88iOt--xervThtxrRx3AohFPw@mail.gmail.com>
 <bc3117f8-fd74-2b61-07c0-926fba898d5d@linux.intel.com> <CAAFQd5DQwBZFOzH6oztHhPR1MLQaAWS0MXDOWt8p5E3vibLFBg@mail.gmail.com>
 <2b90b4b3-a844-b3fb-5158-6818cf84f43d@linux.intel.com>
In-Reply-To: <2b90b4b3-a844-b3fb-5158-6818cf84f43d@linux.intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 12 Mar 2019 17:54:38 +0900
X-Gmail-Original-Message-ID: <CAAFQd5AOrYukx=+5Hk9Qw8yWZ=PgjESYNcBv3iR_vUcQn74_zg@mail.gmail.com>
Message-ID: <CAAFQd5AOrYukx=+5Hk9Qw8yWZ=PgjESYNcBv3iR_vUcQn74_zg@mail.gmail.com>
Subject: Re: [PATCH] media:staging/intel-ipu3: parameter buffer refactoring
To:     Bingbu Cao <bingbu.cao@linux.intel.com>
Cc:     Cao Bing Bu <bingbu.cao@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 12, 2019 at 5:48 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
>
>
>
> On 03/12/2019 03:43 PM, Tomasz Figa wrote:
> > On Tue, Mar 12, 2019 at 3:48 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
> >>
> >>
> >> On 03/12/2019 01:33 PM, Tomasz Figa wrote:
> >>> Hi Bingbu,
> >>>
> >>> On Fri, Feb 15, 2019 at 6:02 PM <bingbu.cao@intel.com> wrote:
> >>>> From: Bingbu Cao <bingbu.cao@intel.com>
> >>>>
> >>>> Current ImgU driver processes and releases the parameter buffer
> >>>> immediately after queued from user. This does not align with other
> >>>> image buffers which are grouped in sets and used for the same frame.
> >>>> If user queues multiple parameter buffers continuously, only the last
> >>>> one will take effect.
> >>>> To make consistent buffers usage, this patch changes the parameter
> >>>> buffer handling and group parameter buffer with other image buffers
> >>>> for each frame.
> >>> Thanks for the patch. Please see my comments inline.
> >>>
> >>>> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> >>>> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> >>>> ---
> >>>>    drivers/staging/media/ipu3/ipu3-css.c  |  5 -----
> >>>>    drivers/staging/media/ipu3/ipu3-v4l2.c | 41 ++++++++--------------------------
> >>>>    drivers/staging/media/ipu3/ipu3.c      | 24 ++++++++++++++++++++
> >>>>    3 files changed, 33 insertions(+), 37 deletions(-)
> >>>>
> >>>> diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
> >>>> index b9354d2bb692..bcb1d436bc98 100644
> >>>> --- a/drivers/staging/media/ipu3/ipu3-css.c
> >>>> +++ b/drivers/staging/media/ipu3/ipu3-css.c
> >>>> @@ -2160,11 +2160,6 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
> >>>>           obgrid_size = ipu3_css_fw_obgrid_size(bi);
> >>>>           stripes = bi->info.isp.sp.iterator.num_stripes ? : 1;
> >>>>
> >>>> -       /*
> >>>> -        * TODO(b/118782861): If userspace queues more than 4 buffers, the
> >>>> -        * parameters from previous buffers will be overwritten. Fix the driver
> >>>> -        * not to allow this.
> >>>> -        */
> >>> Wouldn't this still happen even with current patch?
> >>> imgu_queue_buffers() supposedly queues "as many buffers to CSS as
> >>> possible". This means that if the userspace queues more than 4
> >>> complete frames, we still end up overwriting the parameter buffers in
> >>> the pool. Please correct me if I'm wrong.
> >> The parameter buffers are queued to CSS sequentially and queue one
> >> parameter along with one input buffer once ready, all the data and
> >> parameter buffers are tied together to queue to the CSS. If userspace
> >> queue more parameter buffers then input buffer, they are pending on the
> >> buffer list.
> > It doesn't seem to be what the code does. I'm talking about the
> > following example:
> >
> > Queue OUT buffer 1
> > Queue PARAM buffer 1
> > Queue IN buffer 1
> > Queue OUT buffer 2
> > Queue PARAM buffer 2
> > Queue IN buffer 2
> > Queue OUT buffer 3
> > Queue PARAM buffer 3
> > Queue IN buffer 3
> > Queue OUT buffer 4
> > Queue PARAM buffer 4
> > Queue IN buffer 4
> > Queue OUT buffer 5
> > Queue PARAM buffer 5
> > Queue IN buffer 5
> >
> > All the operations happening exactly one after each other. How would
> > the code prevent the 5th PARAM buffer to be queued to the IMGU, after
> > the 5th IN buffer is queued? As I said, imgu_queue_buffers() just
> > queues as many buffers of each type as there are IN buffers available.
> So the parameter pool now is only used as record last valid parameter not
> used as a list or cached, all the parameters will be queued to CSS as soon as
> possible(if queue for CSS is not full).
> As the size of pool now is a bit confusing, I think we can shrink the its value
> for each pipe to 2.

I don't follow. Don't we take one buffer from the pool, fill in the
parameters in hardware format there and then queue that buffer from
the pool to the ISP? The ISP wouldn't read those parameters from the
buffer until the previous frame is processed, would it?

>
> The buffer queue size is limited for CSS, if massive buffers from
> user pass down and the css queue is full, driver will get -EBUSY
> and return the buffers to user with error.
>

That's not a correct behavior. If the VB2 queue has N buffers, the
userspace needs to be able to queue all the N buffers. The driver
should account the queued buffers internally and queue them to the
hardware/firmware only as much as the hardware/firmware allows.

Best regards,
Tomasz
