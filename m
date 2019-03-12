Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA6EC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 07:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595AE21734
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 07:43:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fZuGUmvH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfCLHnr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 03:43:47 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46794 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfCLHnr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 03:43:47 -0400
Received: by mail-ot1-f66.google.com with SMTP id c18so1580441otl.13
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 00:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wQpU1E2SWdf3niR1q1ZUyUeIYfyTkD5Scl6cjsLrc9A=;
        b=fZuGUmvHEwJOvXbOnyhIMfan9NcltlthsxD6jkIKU6f6noEGZCBF4nqjgaRquS8Iff
         Axq5rJL91C95CcX4v1J82hpdZhbONjlwfL2pmTM6PLH/usMgsqI/tuKR6xjpx9o5AadE
         RqIvxuuyuzJNzmq9bBlcKGdgrB4uSrRPDVmQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wQpU1E2SWdf3niR1q1ZUyUeIYfyTkD5Scl6cjsLrc9A=;
        b=sGjnrMTOdZfuUwYS7NZ6cy8jvuwm6Nga0t2SLLUZZ/4oJAvG5gtQfQnwxyd3Z+Q/Bq
         J3kkadkYpzBiRPcvGkzq8UPmwifTzsP3OSqec0P+Zi7eBGSXFO0iJcIIdlleh3pRK0Pj
         4oHENitGJMogfRLHsE9KSudk4gUdPIoTNsdiTFX/VdNOkEBfNeVMwPf9VicrQ5/3GdRV
         bWBDFryCW8Zc/wGY+nMS6TNU7EXuOy8rTK8D+4qRxZeyr1lmwul+46z5FlQ685zWYN1g
         +5IJMFeGTb/y9bgvE1kKTf7IhBnQrkQzAar8NYg29U/PnNIIi2LatmLshy0myiYhzWdt
         JD0Q==
X-Gm-Message-State: APjAAAVU9UjNR3iOYR2F9z5dMyX+hRHGxPypRe2lukG48fzM1KKLmJKU
        XgKyBwHilrDdbLwhTlcuEj1g3bO4mVk=
X-Google-Smtp-Source: APXvYqyr76iobR2DyJU39l+a8Pfw0kDk6vWbGxo8d6oGq61IiqJJvIBBo5HZVw4svui/dUE+BMgMkg==
X-Received: by 2002:a9d:5f9e:: with SMTP id g30mr13002674oti.62.1552376625683;
        Tue, 12 Mar 2019 00:43:45 -0700 (PDT)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id 9sm3201666oid.22.2019.03.12.00.43.44
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 00:43:44 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id b4so1291661oif.6
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 00:43:44 -0700 (PDT)
X-Received: by 2002:aca:dec4:: with SMTP id v187mr908837oig.92.1552376623824;
 Tue, 12 Mar 2019 00:43:43 -0700 (PDT)
MIME-Version: 1.0
References: <1550221729-29240-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5BOJmE51nrbK+3KGeQWN88iOt--xervThtxrRx3AohFPw@mail.gmail.com> <bc3117f8-fd74-2b61-07c0-926fba898d5d@linux.intel.com>
In-Reply-To: <bc3117f8-fd74-2b61-07c0-926fba898d5d@linux.intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 12 Mar 2019 16:43:32 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DQwBZFOzH6oztHhPR1MLQaAWS0MXDOWt8p5E3vibLFBg@mail.gmail.com>
Message-ID: <CAAFQd5DQwBZFOzH6oztHhPR1MLQaAWS0MXDOWt8p5E3vibLFBg@mail.gmail.com>
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

On Tue, Mar 12, 2019 at 3:48 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
>
>
>
> On 03/12/2019 01:33 PM, Tomasz Figa wrote:
> > Hi Bingbu,
> >
> > On Fri, Feb 15, 2019 at 6:02 PM <bingbu.cao@intel.com> wrote:
> >> From: Bingbu Cao <bingbu.cao@intel.com>
> >>
> >> Current ImgU driver processes and releases the parameter buffer
> >> immediately after queued from user. This does not align with other
> >> image buffers which are grouped in sets and used for the same frame.
> >> If user queues multiple parameter buffers continuously, only the last
> >> one will take effect.
> >> To make consistent buffers usage, this patch changes the parameter
> >> buffer handling and group parameter buffer with other image buffers
> >> for each frame.
> > Thanks for the patch. Please see my comments inline.
> >
> >> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> >> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> >> ---
> >>   drivers/staging/media/ipu3/ipu3-css.c  |  5 -----
> >>   drivers/staging/media/ipu3/ipu3-v4l2.c | 41 ++++++++--------------------------
> >>   drivers/staging/media/ipu3/ipu3.c      | 24 ++++++++++++++++++++
> >>   3 files changed, 33 insertions(+), 37 deletions(-)
> >>
> >> diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
> >> index b9354d2bb692..bcb1d436bc98 100644
> >> --- a/drivers/staging/media/ipu3/ipu3-css.c
> >> +++ b/drivers/staging/media/ipu3/ipu3-css.c
> >> @@ -2160,11 +2160,6 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
> >>          obgrid_size = ipu3_css_fw_obgrid_size(bi);
> >>          stripes = bi->info.isp.sp.iterator.num_stripes ? : 1;
> >>
> >> -       /*
> >> -        * TODO(b/118782861): If userspace queues more than 4 buffers, the
> >> -        * parameters from previous buffers will be overwritten. Fix the driver
> >> -        * not to allow this.
> >> -        */
> > Wouldn't this still happen even with current patch?
> > imgu_queue_buffers() supposedly queues "as many buffers to CSS as
> > possible". This means that if the userspace queues more than 4
> > complete frames, we still end up overwriting the parameter buffers in
> > the pool. Please correct me if I'm wrong.
> The parameter buffers are queued to CSS sequentially and queue one
> parameter along with one input buffer once ready, all the data and
> parameter buffers are tied together to queue to the CSS. If userspace
> queue more parameter buffers then input buffer, they are pending on the
> buffer list.

It doesn't seem to be what the code does. I'm talking about the
following example:

Queue OUT buffer 1
Queue PARAM buffer 1
Queue IN buffer 1
Queue OUT buffer 2
Queue PARAM buffer 2
Queue IN buffer 2
Queue OUT buffer 3
Queue PARAM buffer 3
Queue IN buffer 3
Queue OUT buffer 4
Queue PARAM buffer 4
Queue IN buffer 4
Queue OUT buffer 5
Queue PARAM buffer 5
Queue IN buffer 5

All the operations happening exactly one after each other. How would
the code prevent the 5th PARAM buffer to be queued to the IMGU, after
the 5th IN buffer is queued? As I said, imgu_queue_buffers() just
queues as many buffers of each type as there are IN buffers available.

Best regards,
Tomasz
