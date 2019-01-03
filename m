Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988C4C43444
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 00:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 670752073F
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 00:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PCpJ6LR7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfACA6Y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 19:58:24 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39651 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfACA6Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2019 19:58:24 -0500
Received: by mail-lf1-f65.google.com with SMTP id n18so22154910lfh.6;
        Wed, 02 Jan 2019 16:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ir0xtxBMinC20KRVclhQ3HDwMpxPmmJGYz4e/QZPpLU=;
        b=PCpJ6LR7urhOo1C8m/0u9Xjo17ENB/xS668+huflw3vFBrJ1D7U+HPsg4CsG1Xh0dU
         zK7DgssDyoThRfAnFkOEvDfNTRTZz2xmCcxhxq8RBjVOStASxP6S7ZinjShkkYiQVZ+x
         53ZAtFbBvU22MMpvtQ7DMR+ezWgEC+vYwEiiArA0H+kOz0BNnmpGRm6CPhrsBWFbn7mx
         5WdzHJaweH1aJVVDsbc/5X6uI6HIkqg4/1IyEeUVIEXZsOJn/tMamTjuxHoziZz7gsFl
         gTB3bPbfBjOdQWuAINEKyY0tQL2HjMvaBs4eMwj7GgAPb+6nwSQg0A3cE6QYAx0QdvYF
         N9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ir0xtxBMinC20KRVclhQ3HDwMpxPmmJGYz4e/QZPpLU=;
        b=Q5je5wE27Z3BAfndqXayCaMG3tL6PwdYhz4pKRHTV0DFKFxe7bS7J17eQmncbh6rSi
         3/W1bRmR1rbAo6kKu03Kh9dfvDmgV5wZB6olerXtbMO8qqlI3tvffWWPSWYMMnT4pumw
         +GecHTJby93tOwQdQ5C2YKLo6moecARoAb4bkK8fTh+TAiIfL77B/pyphB16gYlI7a2m
         CZdz5+7k3ab+uiDOQoLDBRFQaqzQN8xWQfeEPXPtblplSjF6VIZa7WXuwkaCASpo5oW/
         v6D0+MtW4wftcnxXOut22MILYqUSOhGm3buL4HBTVfojmwMIZYUPovgSug0I2IgmwloG
         ZfcA==
X-Gm-Message-State: AA+aEWYl8Q2XViJCTI9oi72KkrYcLBn7EQx0XjXtqOcUBGTfQV+SGFJo
        dN88tuur5XJk0PjDDBs8suGs8o+ayqb21hv+TQ==
X-Google-Smtp-Source: AFSGD/V1oiKaQsqeo9iZ3aq1006+NPDYuFpQR3354hXFlobbFPtEVtbVDvaM8zG1k5a5+SfR6NDER+Spd8iRNonr+2s=
X-Received: by 2002:a19:7352:: with SMTP id o79mr24411222lfc.104.1546477101812;
 Wed, 02 Jan 2019 16:58:21 -0800 (PST)
MIME-Version: 1.0
References: <20181108120350.17266-1-sakari.ailus@linux.intel.com>
 <20181108120350.17266-3-sakari.ailus@linux.intel.com> <ae0bc57fad9bf7db15b9b3943dd5bb093a9d386d.camel@decadent.org.uk>
In-Reply-To: <ae0bc57fad9bf7db15b9b3943dd5bb093a9d386d.camel@decadent.org.uk>
From:   Yi Qingliang <niqingliang2003@gmail.com>
Date:   Thu, 3 Jan 2019 08:58:10 +0800
Message-ID: <CADwFkYeFDgKvC5r6X4x-A73R1KwmPr6SLmiaavti_kdJ3UHiZw@mail.gmail.com>
Subject: Re: [PATCH v3.16 2/2] v4l: event: Add subscription to list before
 calling "add" operation
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        "for 4.14 and up" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

hello, I sent a email about 'can't wake problem' 4 days ago.

Is this problem related with mine?

> epoll and vb2_poll: can't wake_up

> Sun, Dec 30, 2018, 6:17 PM (4 days ago)
> to linux-kernel
> Hello, I encountered a "can't wake_up" problem when use camera on imx6.
>
> if delay some time after 'streamon' the /dev/video0, then add fd
> through epoll_ctl, then the process can't be waken_up after some time.
>
> I checked both the epoll / vb2_poll(videobuf2_core.c) code.
>
> epoll will pass 'poll_table' structure to vb2_poll, but it only
> contain valid function pointer when inserting fd.
>
> in vb2_poll, if found new data in done list, it will not call 'poll_wait'.
> after that, every call to vb2_poll will not contain valid poll_table,
> which will result in all calling to poll_wait will not work.
>
> so if app can process frames quickly, and found frame data when
> inserting fd (i.e. poll_wait will not be called or not contain valid
> function pointer), it will not found valid frame in 'vb2_poll' finally
> at some time, then call 'poll_wait' to expect be waken up at following
> vb2_buffer_done, but no good luck.
>
> I also checked the 'videobuf-core.c', there is no this problem.
>
> of course, both epoll and vb2_poll are right by itself side, but the
> result is we can't get new frames.
>
> I think by epoll's implementation, the user should always call poll_wait.
>
> and it's better to split the two actions: 'wait' and 'poll' both for
> epoll framework and all epoll users, for example, v4l2.
>
> am I right?

On Thu, Jan 3, 2019 at 4:17 AM Ben Hutchings <ben@decadent.org.uk> wrote:
>
> On Thu, 2018-11-08 at 14:03 +0200, Sakari Ailus wrote:
> > [ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]
> >
> > Patch ad608fbcf166 changed how events were subscribed to address an issue
> > elsewhere. As a side effect of that change, the "add" callback was called
> > before the event subscription was added to the list of subscribed events,
> > causing the first event queued by the add callback (and possibly other
> > events arriving soon afterwards) to be lost.
> >
> > Fix this by adding the subscription to the list before calling the "add"
> > callback, and clean up afterwards if that fails.
> [...]
>
> I've queued this up for the next update, thanks.
>
> Ben.
>
> --
> Ben Hutchings
> Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer
>
>
