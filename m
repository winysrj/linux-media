Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048AAC43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 02:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEE0C2177E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 02:39:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iS48nmZO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfCMCjV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 22:39:21 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37954 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfCMCjS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 22:39:18 -0400
Received: by mail-oi1-f195.google.com with SMTP id a15so228464oid.5
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 19:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mJPERLPxscd2e8dwN2KPz6Pa8XoKDLP50fZqGnE4Lak=;
        b=iS48nmZOcfUgcSjDRqssMNUsTk7+2hdnG6b3qyR4W4uo94ZrTBTMihDGuEMYHdp6N/
         Xa1JciHLX4q1W15wxmtlpchMJScV7fhUnloYkd+45Mnib/AV0SgL7LFx6YN/iDKTfMnf
         IMn9LUTsLOHNSzrnc4ZUnMiYZXlVhw+gb4wBU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mJPERLPxscd2e8dwN2KPz6Pa8XoKDLP50fZqGnE4Lak=;
        b=BMWXXCA38aMQRl1HINeqmUtv9Wls6AkN6ES8TDKf3oGZ/pvXvRhEf2UPNdl2xd7pqq
         KoeY6PD/hOehaASueroGHpddrGRyK263rsJ0szvX7SltHRN3pgaBrj4HCFLEsKG4isDe
         IwHvRrOZvgQ1GT5hoZ2NDrolLSByNJLJtzUO16y1W6/2/DYe22fttG81woO45kbn+RT0
         htH0TBW8JR9lPZoRSDmjUsQXWWFFNFNE5N+ooKB3/nkya0TeJpaanMf1AwwNs7YtrqUX
         bvcesdHlo5CBT5Y8ZoJzZfWiuVH8/6L/ulKC1T4kQCP0gRb/mYvaGL6SgJb8tIFkvZIs
         UrFw==
X-Gm-Message-State: APjAAAUSCfUL7pVrooji/vZ5R4XvazCCRC7WxyShRTIUfOaJqhEgKBUR
        /V+EqQ6qFOrovjGcIUggRp0S/yVS5zk=
X-Google-Smtp-Source: APXvYqynOkFcjIpQK+DWzKLJp+ITml5uqZra+VZIz8nQJK3Y3LX1PivUBoRNU+QI6LRI71mp9QKXbg==
X-Received: by 2002:aca:62c1:: with SMTP id w184mr69711oib.127.1552444756666;
        Tue, 12 Mar 2019 19:39:16 -0700 (PDT)
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com. [209.85.210.49])
        by smtp.gmail.com with ESMTPSA id b20sm3973516otl.55.2019.03.12.19.39.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 19:39:15 -0700 (PDT)
Received: by mail-ot1-f49.google.com with SMTP id x8so391999otg.7
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 19:39:14 -0700 (PDT)
X-Received: by 2002:a9d:760a:: with SMTP id k10mr1931732otl.367.1552444753700;
 Tue, 12 Mar 2019 19:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <20181017075242.21790-1-henryhsu@chromium.org> <CAAFQd5AL2CnnWLk+i133RRa36HTa0baFkezRhpTXf9YP0DSF1Q@mail.gmail.com>
 <CAHNYxRwbSSp02Zr4a1z5gh0q6cHUUDnZCqRQU7QtP8LMe3Jp2A@mail.gmail.com>
 <1610184.U7oo9Z4Yep@avalon> <CAAFQd5A7k2VgmawF-x=AcKhJiG-shrJiCP4Tu9054J0eE91+9w@mail.gmail.com>
 <d79e0857-c6ae-9e57-52e2-e596864a68f8@metafoo.de> <CAAFQd5C_QucJiZMUgCpztC52Mi3p6HDThHNkcNOm9C+SZUDDYQ@mail.gmail.com>
 <20190313012451.GR891@pendragon.ideasonboard.com>
In-Reply-To: <20190313012451.GR891@pendragon.ideasonboard.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 13 Mar 2019 11:38:56 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DtSD3TrXz8jaFnmBgpRQ6Gnq+LKxyY+LNZrqiM1pxNVA@mail.gmail.com>
Message-ID: <CAAFQd5DtSD3TrXz8jaFnmBgpRQ6Gnq+LKxyY+LNZrqiM1pxNVA@mail.gmail.com>
Subject: Re: [PATCH] media: uvcvideo: Add boottime clock support
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Alexandru Stan <amstan@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Gwendal Grignou <gwendal@chromium.org>,
        Heng-Ruey Hsu <henryhsu@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ricky Liang <jcliang@chromium.org>, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Mar 13, 2019 at 10:25 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Tomasz,
>
> On Fri, Nov 23, 2018 at 11:46:43PM +0900, Tomasz Figa wrote:
> > On Fri, Nov 2, 2018 at 12:03 AM Lars-Peter Clausen wrote:
> > > On 11/01/2018 03:30 PM, Tomasz Figa wrote:
> > >> On Thu, Nov 1, 2018 at 11:03 PM Laurent Pinchart wrote:
> > >>> On Thursday, 18 October 2018 20:28:06 EET Alexandru M Stan wrote:
> > >>>> On Wed, Oct 17, 2018 at 9:31 PM, Tomasz Figa wrote:
> > >>>>> On Thu, Oct 18, 2018 at 5:50 AM Laurent Pinchart wrote:
> > >>>>>> On Wednesday, 17 October 2018 11:28:52 EEST Tomasz Figa wrote:
> > >>>>>>> On Wed, Oct 17, 2018 at 5:02 PM Laurent Pinchart wrote:
> > >>>>>>>> On Wednesday, 17 October 2018 10:52:42 EEST Heng-Ruey Hsu wrote:
> > >>>>>>>>> Android requires camera timestamps to be reported with
> > >>>>>>>>> CLOCK_BOOTTIME to sync timestamp with other sensor sources.
> > >>>>>>>>
> > >>>>>>>> What's the rationale behind this, why can't CLOCK_MONOTONIC work ? If
> > >>>>>>>> the monotonic clock has shortcomings that make its use impossible for
> > >>>>>>>> proper synchronization, then we should consider switching to
> > >>>>>>>> CLOCK_BOOTTIME globally in V4L2, not in selected drivers only.
> > >>>>>>>
> > >>>>>>> CLOCK_BOOTTIME includes the time spent in suspend, while
> > >>>>>>> CLOCK_MONOTONIC doesn't. I can imagine the former being much more
> > >>>>>>> useful for anything that cares about the actual, long term, time
> > >>>>>>> tracking. Especially important since suspend is a very common event on
> > >>>>>>> Android and doesn't stop the time flow there, i.e. applications might
> > >>>>>>> wake up the device to perform various tasks at necessary times.
> > >>>>>>
> > >>>>>> Sure, but this patch mentions timestamp synchronization with other
> > >>>>>> sensors, and from that point of view, I'd like to know what is wrong with
> > >>>>>> the monotonic clock if all devices use it.
> > >>>>>
> > >>>>> AFAIK the sensors mentioned there are not camera sensors, but rather
> > >>>>> things we normally put under IIO, e.g. accelerometers, gyroscopes and
> > >>>>> so on. I'm not sure how IIO deals with timestamps, but Android seems
> > >>>>> to operate in the CLOCK_BOTTIME domain. Let me add some IIO folks.
> > >>>>>
> > >>>>> Gwendal, Alexandru, do you think you could shed some light on how we
> > >>>>> handle IIO sensors timestamps across the kernel, Chrome OS and
> > >>>>> Android?
> > >>>>
> > >>>> On our devices of interest have a specialized "sensor" that comes via
> > >>>> IIO (from the EC, cros-ec-ring driver) that can be used to more
> > >>>> accurately timestamp each frame (since it's recorded with very low
> > >>>> jitter by a realtime-ish OS). In some high level userspace thing
> > >>>> (specifically the Android Camera HAL) we try to pick the best
> > >>>> timestamp from the IIO, whatever's closest to what the V4L stuff gives
> > >>>> us.
> > >>>>
> > >>>> I guess the Android convention is for sensor timestamps to be in
> > >>>> CLOCK_BOOTTIME (maybe because it likes sleeping so much). There's
> > >>>> probably no advantage to using one over the other, but the important
> > >>>> thing is that they have to be the same, otherwise the closest match
> > >>>> logic would fail.
> > >>>
> > >>> That's my understanding too, I don't think CLOCK_BOOTTIME really brings much
> > >>> benefit in this case,
> > >>
> > >> I think it does have a significant benefit. CLOCK_MONOTONIC stops when
> > >> the device is sleeping, but the sensors can still capture various
> > >> actions. We would lose the time keeping of those actions if we use
> > >> CLOCK_MONOTONIC.
> > >>
> > >>> but it's important than all timestamps use the same
> > >>> clock. The question is thus which clock we should select. Mainline mostly uses
> > >>> CLOCK_MONOTONIC, and Android CLOCK_BOOTTIME. Would you like to submit patches
> > >>> to switch Android to CLOCK_MONOTONIC ? :-)
> > >>
> > >> Is it Android using CLOCK_BOOTTIME or the sensors (IIO?). I have
> > >> almost zero familiarity with the IIO subsystem and was hoping someone
> > >> from there could comment on what time domain is used for those
> > >> sensors.
> > >
> > > IIO has the option to choose between BOOTTIME or MONOTONIC (and a few
> > > others) for the timestamp on a per device basis.
> > >
> > > There was a bit of a discussion about this a while back. See
> > > https://lkml.org/lkml/2018/7/10/432 and the following thread.
> >
> > Given that IIO supports BOOTTIME in upstream already and also the
> > important advantage of using it over MONOTONIC for systems which keep
> > capturing events during sleep, do you think we could move on with some
> > way to support it in uvcvideo or preferably V4L2 in general?
>
> I'm not opposed to that, but I don't think we should approach that from
> a UVC point of view. The issue should be addressed in V4L2, and then
> driver-specific support could be added, if needed.

Yes, fully agreed. The purpose of sending this patch was just to start
the discussion on how to support this.

Do you think something like a buffer flag called
V4L2_BUF_FLAG_TIMESTAMP_BOOTTIME that could be set by the userspace at
QBUF could work here? (That would change the timestamp flags
semantics, because it used to be just the information from the driver,
but shouldn't have any compatibility implications.) I suppose we would
also need some capability flag for querying purposes, possibly added
to the capability flags returned by REQBUFS/CREATE_BUFS?

Best regards,
Tomasz
