Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:43441 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932517AbeCMKY2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 06:24:28 -0400
Received: by mail-io0-f196.google.com with SMTP id l12so15076332ioc.10
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 03:24:28 -0700 (PDT)
Received: from mail-io0-f173.google.com (mail-io0-f173.google.com. [209.85.223.173])
        by smtp.gmail.com with ESMTPSA id r23sm68532iod.8.2018.03.13.03.24.26
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Mar 2018 03:24:26 -0700 (PDT)
Received: by mail-io0-f173.google.com with SMTP id e7so15120246ioj.1
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 03:24:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1520606128.15946.22.camel@bootlin.com>
References: <20180220044425.169493-20-acourbot@chromium.org>
 <1520440654.1092.15.camel@bootlin.com> <CAPBb6MUeUaHZj9y1N7wJk9yS8QL+zTqWCGvujcKCY0YpdeiyWg@mail.gmail.com>
 <1520606128.15946.22.camel@bootlin.com>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 13 Mar 2018 19:24:05 +0900
Message-ID: <CAPBb6MWAXjCWJB6x-osFKZ-wGzMiucL6oa1ZHEzTgscpJTs35Q@mail.gmail.com>
Subject: Re: [RFCv4,19/21] media: vim2m: add request support
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 9, 2018 at 11:35 PM, Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
> Hi,
>
> On Thu, 2018-03-08 at 22:48 +0900, Alexandre Courbot wrote:
>> Hi Paul!
>>
>> Thanks a lot for taking the time to try this! I am also working on
>> getting it to work with an actual driver, but you apparently found
>> rough edges that I missed.
>>
>> On Thu, Mar 8, 2018 at 1:37 AM, Paul Kocialkowski
>> <paul.kocialkowski@bootlin.com> wrote:
>> > Hi,
>> >
>> > First off, I'd like to take the occasion to say thank-you for your
>> > work.
>> > This is a major piece of plumbing that is required for me to add
>> > support
>> > for the Allwinner CedarX VPU hardware in upstream Linux. Other
>> > drivers,
>> > such as tegra-vde (that was recently merged in staging) are also
>> > badly
>> > in need of this API.
>> >
>> > I have a few comments based on my experience integrating this
>> > request
>> > API with the Cedrus VPU driver (and the associated libva backend),
>> > that
>> > also concern the vim2m driver.
>> >
>> > On Tue, 2018-02-20 at 13:44 +0900, Alexandre Courbot wrote:
>> > > Set the necessary ops for supporting requests in vim2m.
>> > >
>> > > Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> > > ---
>> > >  drivers/media/platform/Kconfig |  1 +
>> > >  drivers/media/platform/vim2m.c | 75
>> > > ++++++++++++++++++++++++++++++++++
>> > >  2 files changed, 76 insertions(+)
>> > >
>> > > diff --git a/drivers/media/platform/Kconfig
>> > > b/drivers/media/platform/Kconfig
>> > > index 614fbef08ddc..09be0b5f9afe 100644
>> > > --- a/drivers/media/platform/Kconfig
>> > > +++ b/drivers/media/platform/Kconfig
>> >
>> > [...]
>> >
>> > > +static int vim2m_request_submit(struct media_request *req,
>> > > +                             struct media_request_entity_data
>> > > *_data)
>> > > +{
>> > > +     struct v4l2_request_entity_data *data;
>> > > +
>> > > +     data = to_v4l2_entity_data(_data);
>> >
>> > We need to call v4l2_m2m_try_schedule here so that m2m scheduling
>> > can
>> > happen when only 2 buffers were queued and no other action was taken
>> > from usespace. In that scenario, m2m scheduling currently doesn't
>> > happen.
>>
>> I don't think I understand the sequence of events that results in
>> v4l2_m2m_try_schedule() not being called. Do you mean something like:
>>
>> *
>> * QBUF on output queue with request set
>> * QBUF on capture queue
>> * SUBMIT_REQUEST
>>
>> ?
>>
>> The call to vb2_request_submit() right after should trigger
>> v4l2_m2m_try_schedule(), since the buffers associated to the request
>> will enter the vb2 queue and be passed to the m2m framework, which
>> will then call v4l2_m2m_try_schedule(). Or maybe you are thinking
>> about a different sequence of events?
>
> This is indeed the sequence of events that I'm seeing, but the
> scheduling call simply did not happen on vb2_request_submit. I suppose I will need to investigate some more to find out exactly why.
>
> IIRC, the m2m qbuf function is called (and fails to schedule) when the
> ioctl happens, not when the task is submitted.
>
> This issue is seen with vim2m as well as the rencently-submitted sunxi-
> cedrus driver (with the in-driver calls to v4l2_m2m_try_schedule
> removed, obviously). If needs be, I could provide a standalone test
> program to reproduce it.

If you have a standalone program that can reproduce this on vim2m,
then I would like to see it indeed, if only to understand what I have
missed.

Thanks,
Alex.
