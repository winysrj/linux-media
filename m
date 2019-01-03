Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BE2C43612
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 12:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74F77217F5
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 12:00:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OjSGaCzg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbfACMA6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 07:00:58 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36967 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729692AbfACMA6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2019 07:00:58 -0500
Received: by mail-lf1-f68.google.com with SMTP id y11so22987999lfj.4;
        Thu, 03 Jan 2019 04:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=05cy47ubAZihLKhRl8e3jk+gL7cFoKRAu9A9H8slA2w=;
        b=OjSGaCzgsD64+2XPq4lcIeXn631OBvRBG/j1TxgOddWDYeq6T7RCkkUH7h1u+7+fbj
         E+zSApkpVWydX2mpRWTcWkYKCGqy2Nc752qY2746sPY86uszNSOO/hZV+2+oR5JGJTLR
         FaeKFv5wIek193VYPL73ukoS00KB4jg0t6FcdQA/D4EkkzK4R5nWqFXszsr3rW2mTth7
         YTtUoC4/tXh0XygXd52r192oOOxJhdpM+veSvk/OIH3Gokj8B9RfXqySVD8BmqmNLuw1
         dyieBtr2kU0x7RhJo648f8tCFmA4zPkzXW0v41xfXZBZog4qzG09AF+IO1V42rXO44yn
         Kg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=05cy47ubAZihLKhRl8e3jk+gL7cFoKRAu9A9H8slA2w=;
        b=JxkA5PRK+bchLlr/YZDr2EkagvLO3jqZawOW8Dt0idOTUM1vVHXKYJHT/bopM32kv/
         5Il48QaKqpEe+PF3No4VaI5O8pFrf0uhUWDxjk2xoIj0sQjl13wBsSY+XTLYBqY11gg8
         5onDkglPm6GQ/cl+MiM8bK5UEVz4OkQfITcruQlQ6jDKGzlMHFvZofxZ8aWpEHbgQnFv
         dqp0ZL2vlcfwmisfMhVRoD3wDOrgWUqRYMStFY+nSKny8mTHNcwe0VCZo7u3xOogG/48
         mWQYc03Bg+EB+Ys3rXIaqqdzRBhDD7WaaXmx6bvEzwfkhVyByUgfQLTiZTpe0Ip/HatF
         rMZQ==
X-Gm-Message-State: AA+aEWaQKoOON3jrrZ77+ldVBoPIK7i2o68sRDtepzHZnO0/d+Kngs76
        UOlDXw7DQtILNsE4Annx+lzSCIPOj/nv0AW49g==
X-Google-Smtp-Source: AFSGD/XQDK1+pTuddtQHwvD+vnAcAKKvhMV8+9WAmTUwRk+S7JHV9VIGGEABhzEb+wT0YHRCIsVGftTkzjwK2TA/MAA=
X-Received: by 2002:a19:7352:: with SMTP id o79mr25347282lfc.104.1546516856015;
 Thu, 03 Jan 2019 04:00:56 -0800 (PST)
MIME-Version: 1.0
References: <20181108120350.17266-1-sakari.ailus@linux.intel.com>
 <20181108120350.17266-3-sakari.ailus@linux.intel.com> <ae0bc57fad9bf7db15b9b3943dd5bb093a9d386d.camel@decadent.org.uk>
 <CADwFkYeFDgKvC5r6X4x-A73R1KwmPr6SLmiaavti_kdJ3UHiZw@mail.gmail.com> <326afce1-5b40-cff6-be63-8c64be3f8dbd@xs4all.nl>
In-Reply-To: <326afce1-5b40-cff6-be63-8c64be3f8dbd@xs4all.nl>
From:   Yi Qingliang <niqingliang2003@gmail.com>
Date:   Thu, 3 Jan 2019 20:00:44 +0800
Message-ID: <CADwFkYfUHpr6wcwCN7ihwPnzx4td0SQT98mnQgDmtLLu=JqFxQ@mail.gmail.com>
Subject: Re: [PATCH v3.16 2/2] v4l: event: Add subscription to list before
 calling "add" operation
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        "for 4.14 and up" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Ok, thanks a lot.

On Thu, Jan 3, 2019 at 6:15 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 01/03/2019 01:58 AM, Yi Qingliang wrote:
> > hello, I sent a email about 'can't wake problem' 4 days ago.
> >
> > Is this problem related with mine?
>
> No, it's unrelated.
>
> I'll take a look at vb2_poll next week.
>
> Regards,
>
>         Hans
>
> >
> >> epoll and vb2_poll: can't wake_up
> >
> >> Sun, Dec 30, 2018, 6:17 PM (4 days ago)
> >> to linux-kernel
> >> Hello, I encountered a "can't wake_up" problem when use camera on imx6.
> >>
> >> if delay some time after 'streamon' the /dev/video0, then add fd
> >> through epoll_ctl, then the process can't be waken_up after some time.
> >>
> >> I checked both the epoll / vb2_poll(videobuf2_core.c) code.
> >>
> >> epoll will pass 'poll_table' structure to vb2_poll, but it only
> >> contain valid function pointer when inserting fd.
> >>
> >> in vb2_poll, if found new data in done list, it will not call 'poll_wait'.
> >> after that, every call to vb2_poll will not contain valid poll_table,
> >> which will result in all calling to poll_wait will not work.
> >>
> >> so if app can process frames quickly, and found frame data when
> >> inserting fd (i.e. poll_wait will not be called or not contain valid
> >> function pointer), it will not found valid frame in 'vb2_poll' finally
> >> at some time, then call 'poll_wait' to expect be waken up at following
> >> vb2_buffer_done, but no good luck.
> >>
> >> I also checked the 'videobuf-core.c', there is no this problem.
> >>
> >> of course, both epoll and vb2_poll are right by itself side, but the
> >> result is we can't get new frames.
> >>
> >> I think by epoll's implementation, the user should always call poll_wait.
> >>
> >> and it's better to split the two actions: 'wait' and 'poll' both for
> >> epoll framework and all epoll users, for example, v4l2.
> >>
> >> am I right?
> >
> > On Thu, Jan 3, 2019 at 4:17 AM Ben Hutchings <ben@decadent.org.uk> wrote:
> >>
> >> On Thu, 2018-11-08 at 14:03 +0200, Sakari Ailus wrote:
> >>> [ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]
> >>>
> >>> Patch ad608fbcf166 changed how events were subscribed to address an issue
> >>> elsewhere. As a side effect of that change, the "add" callback was called
> >>> before the event subscription was added to the list of subscribed events,
> >>> causing the first event queued by the add callback (and possibly other
> >>> events arriving soon afterwards) to be lost.
> >>>
> >>> Fix this by adding the subscription to the list before calling the "add"
> >>> callback, and clean up afterwards if that fails.
> >> [...]
> >>
> >> I've queued this up for the next update, thanks.
> >>
> >> Ben.
> >>
> >> --
> >> Ben Hutchings
> >> Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer
> >>
> >>
>
