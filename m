Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E60C4360F
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 04:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF97820828
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 04:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gQYP0VaG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfCZEDm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 00:03:42 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35202 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbfCZEDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 00:03:42 -0400
Received: by mail-ot1-f67.google.com with SMTP id m10so2617711otp.2
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 21:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b8PjCbkM5BHgpqbyB1H0YI31x+Vn19UDfw9SzWsMjHo=;
        b=gQYP0VaG+p4Gdp5XgkJIu/dbZCGn2n35ubry2+B8qECiI3g9KZVRfqB/R8a0G1jGMb
         jGo0ddBLZsCj56l0A/L+6QNF1VqbUaLtV+CnmidZqY7fDJJ8KimNKXBCldMc2c1fdERb
         aTLo2MAVP1hOtx0WC2r+iHyl1CRA1zRPBB9TY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b8PjCbkM5BHgpqbyB1H0YI31x+Vn19UDfw9SzWsMjHo=;
        b=ET0z9MjNshATBqksJWlmIIJOG85wP0SanHRPj2cMPfR4/U7DFAYfV6GCViTVS6RaX3
         LvCofl31IhOIo7ehABP+YKGcAJy8RnjGFRfeleTwFcK1nT4O9p1WauZFhd81sOjIvgQR
         N3dsujs9fxGEIOG1qfAxokMA/k87zuvEvI3KKqU+sS5S9jQtjDRp5Ozljapq8RJMhjoc
         W0NSnLcOIqStEJcvn7eLV4XFkQ7BNBSRUHsDnnOyhPMpZxMGeO3ZHeq5SeEJKtr7ZWam
         kynSZFZLS2L7yOSvrqw4gnivM2n/T9FCPY/3X4JbbWtNP3s3YL/3wllyj1XX6ziKk1xb
         WwGw==
X-Gm-Message-State: APjAAAXzg9bCrkB2HWYqJ2IgmGy7OAGsi9uhiz67/9FllKiPFQvirFQ9
        Tdzedqe2wvBzHIVuRF+xxBf6akCM0mI=
X-Google-Smtp-Source: APXvYqydVPmIoVsHDZPcyAb5Uq4vdOBkqru6orVVX0ozHd1uP7novrcQfOpQnm935eE8iIrlQkOdKQ==
X-Received: by 2002:a9d:19cd:: with SMTP id k71mr3895446otk.267.1553573020914;
        Mon, 25 Mar 2019 21:03:40 -0700 (PDT)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id 42sm3498361otg.10.2019.03.25.21.03.39
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Mar 2019 21:03:39 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id v10so4504450oib.1
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 21:03:39 -0700 (PDT)
X-Received: by 2002:aca:62c1:: with SMTP id w184mr13966119oib.127.1553573018573;
 Mon, 25 Mar 2019 21:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <1550221729-29240-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5BOJmE51nrbK+3KGeQWN88iOt--xervThtxrRx3AohFPw@mail.gmail.com>
 <bc3117f8-fd74-2b61-07c0-926fba898d5d@linux.intel.com> <CAAFQd5DQwBZFOzH6oztHhPR1MLQaAWS0MXDOWt8p5E3vibLFBg@mail.gmail.com>
 <2b90b4b3-a844-b3fb-5158-6818cf84f43d@linux.intel.com> <CAAFQd5AOrYukx=+5Hk9Qw8yWZ=PgjESYNcBv3iR_vUcQn74_zg@mail.gmail.com>
 <1b666a30-689e-d46c-f564-ae0848f92d54@linux.intel.com> <CAAFQd5DgYmikHkxkGQhz=oV=h=CPuo03iJ80LZ5LXThiJFbR8A@mail.gmail.com>
 <2f342699-f7e3-ef94-e458-1f7634b7a69b@linux.intel.com> <CAAFQd5D9Twv7yyQX=kO=+kJNW7TvgRx=WrwO9-_QBpZHuwuHJA@mail.gmail.com>
 <6da9c6c3-5e69-744a-242a-58c866abac96@linux.intel.com>
In-Reply-To: <6da9c6c3-5e69-744a-242a-58c866abac96@linux.intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 26 Mar 2019 13:03:27 +0900
X-Gmail-Original-Message-ID: <CAAFQd5AbgP_-POHz88YQfmWCrS8NNV3oEDALSVM18XvMB-6HSA@mail.gmail.com>
Message-ID: <CAAFQd5AbgP_-POHz88YQfmWCrS8NNV3oEDALSVM18XvMB-6HSA@mail.gmail.com>
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

On Mon, Mar 25, 2019 at 6:52 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
>
>
>
> On 3/25/19 12:20 PM, Tomasz Figa wrote:
> > On Mon, Mar 25, 2019 at 1:12 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
> >>
> >>
> >>
> >> On 3/25/19 11:16 AM, Tomasz Figa wrote:
> >>> Hi Bingbu,
> >>>
> >>> On Wed, Mar 13, 2019 at 1:25 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 03/12/2019 04:54 PM, Tomasz Figa wrote:
> >>>>> On Tue, Mar 12, 2019 at 5:48 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 03/12/2019 03:43 PM, Tomasz Figa wrote:
> >>>>>>> On Tue, Mar 12, 2019 at 3:48 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
> >>>>>>>>
> >>>>>>>> On 03/12/2019 01:33 PM, Tomasz Figa wrote:
> >>>>>>>>> Hi Bingbu,
> >>>>>>>>>
> >>>>>>>>> On Fri, Feb 15, 2019 at 6:02 PM <bingbu.cao@intel.com> wrote:
> >>>>>>>>>> From: Bingbu Cao <bingbu.cao@intel.com>
> >>>>>>>>>>
> >>>>>>>>>> Current ImgU driver processes and releases the parameter buffer
> >>>>>>>>>> immediately after queued from user. This does not align with other
> >>>>>>>>>> image buffers which are grouped in sets and used for the same frame.
> >>>>>>>>>> If user queues multiple parameter buffers continuously, only the last
> >>>>>>>>>> one will take effect.
> >>>>>>>>>> To make consistent buffers usage, this patch changes the parameter
> >>>>>>>>>> buffer handling and group parameter buffer with other image buffers
> >>>>>>>>>> for each frame.
> >>>>>>>>> Thanks for the patch. Please see my comments inline.
> >>>>>>>>>
> >>>>>>>>>> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> >>>>>>>>>> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> >>>>>>>>>> ---
> >>>>>>>>>>     drivers/staging/media/ipu3/ipu3-css.c  |  5 -----
> >>>>>>>>>>     drivers/staging/media/ipu3/ipu3-v4l2.c | 41 ++++++++--------------------------
> >>>>>>>>>>     drivers/staging/media/ipu3/ipu3.c      | 24 ++++++++++++++++++++
> >>>>>>>>>>     3 files changed, 33 insertions(+), 37 deletions(-)
> >>>>>>>>>>
> >>>>>>>>>> diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
> >>>>>>>>>> index b9354d2bb692..bcb1d436bc98 100644
> >>>>>>>>>> --- a/drivers/staging/media/ipu3/ipu3-css.c
> >>>>>>>>>> +++ b/drivers/staging/media/ipu3/ipu3-css.c
> >>>>>>>>>> @@ -2160,11 +2160,6 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
> >>>>>>>>>>            obgrid_size = ipu3_css_fw_obgrid_size(bi);
> >>>>>>>>>>            stripes = bi->info.isp.sp.iterator.num_stripes ? : 1;
> >>>>>>>>>>
> >>>>>>>>>> -       /*
> >>>>>>>>>> -        * TODO(b/118782861): If userspace queues more than 4 buffers, the
> >>>>>>>>>> -        * parameters from previous buffers will be overwritten. Fix the driver
> >>>>>>>>>> -        * not to allow this.
> >>>>>>>>>> -        */
> >>>>>>>>> Wouldn't this still happen even with current patch?
> >>>>>>>>> imgu_queue_buffers() supposedly queues "as many buffers to CSS as
> >>>>>>>>> possible". This means that if the userspace queues more than 4
> >>>>>>>>> complete frames, we still end up overwriting the parameter buffers in
> >>>>>>>>> the pool. Please correct me if I'm wrong.
> >>>>>>>> The parameter buffers are queued to CSS sequentially and queue one
> >>>>>>>> parameter along with one input buffer once ready, all the data and
> >>>>>>>> parameter buffers are tied together to queue to the CSS. If userspace
> >>>>>>>> queue more parameter buffers then input buffer, they are pending on the
> >>>>>>>> buffer list.
> >>>>>>> It doesn't seem to be what the code does. I'm talking about the
> >>>>>>> following example:
> >>>>>>>
> >>>>>>> Queue OUT buffer 1
> >>>>>>> Queue PARAM buffer 1
> >>>>>>> Queue IN buffer 1
> >>>>>>> Queue OUT buffer 2
> >>>>>>> Queue PARAM buffer 2
> >>>>>>> Queue IN buffer 2
> >>>>>>> Queue OUT buffer 3
> >>>>>>> Queue PARAM buffer 3
> >>>>>>> Queue IN buffer 3
> >>>>>>> Queue OUT buffer 4
> >>>>>>> Queue PARAM buffer 4
> >>>>>>> Queue IN buffer 4
> >>>>>>> Queue OUT buffer 5
> >>>>>>> Queue PARAM buffer 5
> >>>>>>> Queue IN buffer 5
> >>>>>>>
> >>>>>>> All the operations happening exactly one after each other. How would
> >>>>>>> the code prevent the 5th PARAM buffer to be queued to the IMGU, after
> >>>>>>> the 5th IN buffer is queued? As I said, imgu_queue_buffers() just
> >>>>>>> queues as many buffers of each type as there are IN buffers available.
> >>>>>> So the parameter pool now is only used as record last valid parameter not
> >>>>>> used as a list or cached, all the parameters will be queued to CSS as soon as
> >>>>>> possible(if queue for CSS is not full).
> >>>>>> As the size of pool now is a bit confusing, I think we can shrink the its value
> >>>>>> for each pipe to 2.
> >>>>> I don't follow. Don't we take one buffer from the pool, fill in the
> >>>>> parameters in hardware format there and then queue that buffer from
> >>>>> the pool to the ISP? The ISP wouldn't read those parameters from the
> >>>>> buffer until the previous frame is processed, would it?
> >>>> Hi, Tomasz,
> >>>>
> >>>> Currently, driver did not take the buffer from pool to queue to ISP,
> >>>> it just queue the parameter buffer along with input frame buffer depends
> >>>> on each user queue request.
> >>>>
> >>>> You are right, if user queue massive buffers one time, it will cause
> >>>> the firmware queue full. Driver should keep the buffer in its list
> >>>> instead of returning back to user irresponsibly.
> >>>>
> >>>> We are thinking about queue one group of buffers(input, output and params)
> >>>> to ISP one time and wait the pipeline finished and then queue next group
> >>>> of buffers. All the buffers are pending on the buffer list.
> >>>> What do you think about this behavior?
> >>>
> >>> Sorry, I was sure I replied to your email, but apparently I didn't.
> >>>
> >>> Yes, that would certainly work, but wouldn't it introduce pipeline
> >>> bubbles, potentially affecting the performance?
> >> Hi, Tomasz,
> >>
> >> Thanks for your reply.
> >>
> >> The driver will queue the buffers to CSS immediately after previous
> >> pipeline finished which is invoked in imgu_isr_threaded.
> >>
> >> The bubbles compared from before should be very small since current
> >> camera HAL implementation in production will queue new buffers IFF all
> >> the buffers dequeued from driver, as I know.
> >
> > If the firmware has a queue depth of 4, I think it would still be much
> > better to use it. Would it really make the code much more complicated?
> > I think you could just maintain a counter of queued buffers and keep
> > refilling the queue whenever it's less than 4 and there are any
> > buffers to queue.
> Actually, firmware will use latest parameter queued and apply to frame,
> they are not consumed frame by frame.
> The parameter buffers are not used same way as frame buffers, so the
> pool in driver is just used for storing previous parameter and refilling
> fields within new coming parameter from user and combine with previous
> ones into a whole parameter.

Hmm, that's a rather strange design.

Well, in that case we can't queue more than 1 frame indeed, as
otherwise we wouldn't be able to synchronize the parameters with the
right frames.

Best regards,
Tomasz
