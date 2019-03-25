Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB43FC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 03:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2E9020828
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 03:16:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jTcIPceX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbfCYDQY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 23:16:24 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35777 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729298AbfCYDQY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 23:16:24 -0400
Received: by mail-ot1-f67.google.com with SMTP id m10so6749126otp.2
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2019 20:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=94YwN85QnedJ3vwLt8fwFdHasxUqo8RcEpdMeNldCWE=;
        b=jTcIPceXGuqP5O8HijeoUIbOA2HjpoKQkM/Xp/pmeOtGlBq77D//fSpogEVAUH+VFD
         V1FmE5MyAZYnNtmE7x7zempAPhFXnyr63OAa1L9jE/XZLe16wC/AQgOTwDXZBmAQD30N
         hTzMNKNDC1d8J2mNvtsIKcCa2M1VzxEcABiY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=94YwN85QnedJ3vwLt8fwFdHasxUqo8RcEpdMeNldCWE=;
        b=cSTujFThNrgD0yzYuwB5oiGSulOU7TkDwwjC5+VkD7dkXt8jxYxdtVgxoMOGeHg2Z8
         I3FI7pm4dcxe7PIp4epiasAAb6GgAV2Wnrc4cwCdwKvSAjsawoJJ8oCXupZM3AkfBFSC
         4PRJOifOor90EXyamJ56+3jni4+odRhwlrjRWx0d0QRYtWRkzxYMXBhCQzxyPR5E5j9r
         i9wmUpllWnjCfGzXwYQQZPHqOlSwmlhBIFEB4sng30nBARKg3aTVwRk4/0krV2+z29a4
         e504dnxCe5pSPdgUPa27f6QOH26pvDPizagox5Oyz59zT5p24uRN7ozKcjVBr3dQuHmf
         D42w==
X-Gm-Message-State: APjAAAX6kxMQDVAaf5UbXnWmHKBEAiSFnajqkAv3dKLR0p+Gzf6VOSv7
        wCY77kRNCuIRez+PAgD7tPqM7ut+ZGs=
X-Google-Smtp-Source: APXvYqxlmp69i53VPgZ+XnCsTeQH0imIt0iMvRAuy/LL+H0pXTWdkfg6qmjFD8mibngHA2NctKkelA==
X-Received: by 2002:a9d:754a:: with SMTP id b10mr17024746otl.44.1553483782905;
        Sun, 24 Mar 2019 20:16:22 -0700 (PDT)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com. [209.85.167.179])
        by smtp.gmail.com with ESMTPSA id l5sm864654otr.53.2019.03.24.20.16.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Mar 2019 20:16:21 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id j132so5843771oib.2
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2019 20:16:21 -0700 (PDT)
X-Received: by 2002:aca:b7c4:: with SMTP id h187mr10453933oif.112.1553483780690;
 Sun, 24 Mar 2019 20:16:20 -0700 (PDT)
MIME-Version: 1.0
References: <1550221729-29240-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5BOJmE51nrbK+3KGeQWN88iOt--xervThtxrRx3AohFPw@mail.gmail.com>
 <bc3117f8-fd74-2b61-07c0-926fba898d5d@linux.intel.com> <CAAFQd5DQwBZFOzH6oztHhPR1MLQaAWS0MXDOWt8p5E3vibLFBg@mail.gmail.com>
 <2b90b4b3-a844-b3fb-5158-6818cf84f43d@linux.intel.com> <CAAFQd5AOrYukx=+5Hk9Qw8yWZ=PgjESYNcBv3iR_vUcQn74_zg@mail.gmail.com>
 <1b666a30-689e-d46c-f564-ae0848f92d54@linux.intel.com>
In-Reply-To: <1b666a30-689e-d46c-f564-ae0848f92d54@linux.intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Mon, 25 Mar 2019 12:16:10 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DgYmikHkxkGQhz=oV=h=CPuo03iJ80LZ5LXThiJFbR8A@mail.gmail.com>
Message-ID: <CAAFQd5DgYmikHkxkGQhz=oV=h=CPuo03iJ80LZ5LXThiJFbR8A@mail.gmail.com>
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

Hi Bingbu,

On Wed, Mar 13, 2019 at 1:25 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
>
>
>
> On 03/12/2019 04:54 PM, Tomasz Figa wrote:
> > On Tue, Mar 12, 2019 at 5:48 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
> >>
> >>
> >> On 03/12/2019 03:43 PM, Tomasz Figa wrote:
> >>> On Tue, Mar 12, 2019 at 3:48 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
> >>>>
> >>>> On 03/12/2019 01:33 PM, Tomasz Figa wrote:
> >>>>> Hi Bingbu,
> >>>>>
> >>>>> On Fri, Feb 15, 2019 at 6:02 PM <bingbu.cao@intel.com> wrote:
> >>>>>> From: Bingbu Cao <bingbu.cao@intel.com>
> >>>>>>
> >>>>>> Current ImgU driver processes and releases the parameter buffer
> >>>>>> immediately after queued from user. This does not align with other
> >>>>>> image buffers which are grouped in sets and used for the same frame.
> >>>>>> If user queues multiple parameter buffers continuously, only the last
> >>>>>> one will take effect.
> >>>>>> To make consistent buffers usage, this patch changes the parameter
> >>>>>> buffer handling and group parameter buffer with other image buffers
> >>>>>> for each frame.
> >>>>> Thanks for the patch. Please see my comments inline.
> >>>>>
> >>>>>> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> >>>>>> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> >>>>>> ---
> >>>>>>     drivers/staging/media/ipu3/ipu3-css.c  |  5 -----
> >>>>>>     drivers/staging/media/ipu3/ipu3-v4l2.c | 41 ++++++++--------------------------
> >>>>>>     drivers/staging/media/ipu3/ipu3.c      | 24 ++++++++++++++++++++
> >>>>>>     3 files changed, 33 insertions(+), 37 deletions(-)
> >>>>>>
> >>>>>> diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
> >>>>>> index b9354d2bb692..bcb1d436bc98 100644
> >>>>>> --- a/drivers/staging/media/ipu3/ipu3-css.c
> >>>>>> +++ b/drivers/staging/media/ipu3/ipu3-css.c
> >>>>>> @@ -2160,11 +2160,6 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
> >>>>>>            obgrid_size = ipu3_css_fw_obgrid_size(bi);
> >>>>>>            stripes = bi->info.isp.sp.iterator.num_stripes ? : 1;
> >>>>>>
> >>>>>> -       /*
> >>>>>> -        * TODO(b/118782861): If userspace queues more than 4 buffers, the
> >>>>>> -        * parameters from previous buffers will be overwritten. Fix the driver
> >>>>>> -        * not to allow this.
> >>>>>> -        */
> >>>>> Wouldn't this still happen even with current patch?
> >>>>> imgu_queue_buffers() supposedly queues "as many buffers to CSS as
> >>>>> possible". This means that if the userspace queues more than 4
> >>>>> complete frames, we still end up overwriting the parameter buffers in
> >>>>> the pool. Please correct me if I'm wrong.
> >>>> The parameter buffers are queued to CSS sequentially and queue one
> >>>> parameter along with one input buffer once ready, all the data and
> >>>> parameter buffers are tied together to queue to the CSS. If userspace
> >>>> queue more parameter buffers then input buffer, they are pending on the
> >>>> buffer list.
> >>> It doesn't seem to be what the code does. I'm talking about the
> >>> following example:
> >>>
> >>> Queue OUT buffer 1
> >>> Queue PARAM buffer 1
> >>> Queue IN buffer 1
> >>> Queue OUT buffer 2
> >>> Queue PARAM buffer 2
> >>> Queue IN buffer 2
> >>> Queue OUT buffer 3
> >>> Queue PARAM buffer 3
> >>> Queue IN buffer 3
> >>> Queue OUT buffer 4
> >>> Queue PARAM buffer 4
> >>> Queue IN buffer 4
> >>> Queue OUT buffer 5
> >>> Queue PARAM buffer 5
> >>> Queue IN buffer 5
> >>>
> >>> All the operations happening exactly one after each other. How would
> >>> the code prevent the 5th PARAM buffer to be queued to the IMGU, after
> >>> the 5th IN buffer is queued? As I said, imgu_queue_buffers() just
> >>> queues as many buffers of each type as there are IN buffers available.
> >> So the parameter pool now is only used as record last valid parameter not
> >> used as a list or cached, all the parameters will be queued to CSS as soon as
> >> possible(if queue for CSS is not full).
> >> As the size of pool now is a bit confusing, I think we can shrink the its value
> >> for each pipe to 2.
> > I don't follow. Don't we take one buffer from the pool, fill in the
> > parameters in hardware format there and then queue that buffer from
> > the pool to the ISP? The ISP wouldn't read those parameters from the
> > buffer until the previous frame is processed, would it?
> Hi, Tomasz,
>
> Currently, driver did not take the buffer from pool to queue to ISP,
> it just queue the parameter buffer along with input frame buffer depends
> on each user queue request.
>
> You are right, if user queue massive buffers one time, it will cause
> the firmware queue full. Driver should keep the buffer in its list
> instead of returning back to user irresponsibly.
>
> We are thinking about queue one group of buffers(input, output and params)
> to ISP one time and wait the pipeline finished and then queue next group
> of buffers. All the buffers are pending on the buffer list.
> What do you think about this behavior?

Sorry, I was sure I replied to your email, but apparently I didn't.

Yes, that would certainly work, but wouldn't it introduce pipeline
bubbles, potentially affecting the performance?

Best regards,
Tomasz
