Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33270 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933037AbeCSJSA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 05:18:00 -0400
Received: by mail-io0-f180.google.com with SMTP id l3so3282133iog.0
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2018 02:18:00 -0700 (PDT)
Received: from mail-it0-f50.google.com (mail-it0-f50.google.com. [209.85.214.50])
        by smtp.gmail.com with ESMTPSA id l3sm5481456ioa.59.2018.03.19.02.17.58
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Mar 2018 02:17:59 -0700 (PDT)
Received: by mail-it0-f50.google.com with SMTP id z7-v6so8614840iti.1
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2018 02:17:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521033957.1130.5.camel@bootlin.com>
References: <20180220044425.169493-20-acourbot@chromium.org>
 <1520440654.1092.15.camel@bootlin.com> <CAPBb6MUeUaHZj9y1N7wJk9yS8QL+zTqWCGvujcKCY0YpdeiyWg@mail.gmail.com>
 <1520606128.15946.22.camel@bootlin.com> <CAPBb6MWAXjCWJB6x-osFKZ-wGzMiucL6oa1ZHEzTgscpJTs35Q@mail.gmail.com>
 <1521033957.1130.5.camel@bootlin.com>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 19 Mar 2018 18:17:37 +0900
Message-ID: <CAPBb6MUXGyQiU26fxChbLBU9cRKRMGZWa-CNvL0GM1s94Y98rA@mail.gmail.com>
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

On Wed, Mar 14, 2018 at 10:25 PM, Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
> Hi,
>
> On Tue, 2018-03-13 at 19:24 +0900, Alexandre Courbot wrote:
>> On Fri, Mar 9, 2018 at 11:35 PM, Paul Kocialkowski
>> <paul.kocialkowski@bootlin.com> wrote:
>> > Hi,
>> >
>> > On Thu, 2018-03-08 at 22:48 +0900, Alexandre Courbot wrote:
>> > > Hi Paul!
>> > >
>> > > Thanks a lot for taking the time to try this! I am also working on
>> > > getting it to work with an actual driver, but you apparently found
>> > > rough edges that I missed.
>> > >
>> > > On Thu, Mar 8, 2018 at 1:37 AM, Paul Kocialkowski
>> > > <paul.kocialkowski@bootlin.com> wrote:
>> > > > On Tue, 2018-02-20 at 13:44 +0900, Alexandre Courbot wrote:
>
> [...]
>
>> > > > > +static int vim2m_request_submit(struct media_request *req,
>> > > > > +                             struct media_request_entity_data
>> > > > > *_data)
>> > > > > +{
>> > > > > +     struct v4l2_request_entity_data *data;
>> > > > > +
>> > > > > +     data = to_v4l2_entity_data(_data);
>> > > >
>> > > > We need to call v4l2_m2m_try_schedule here so that m2m
>> > > > scheduling
>> > > > can
>> > > > happen when only 2 buffers were queued and no other action was
>> > > > taken
>> > > > from usespace. In that scenario, m2m scheduling currently
>> > > > doesn't
>> > > > happen.
>> > >
>> > > I don't think I understand the sequence of events that results in
>> > > v4l2_m2m_try_schedule() not being called. Do you mean something
>> > > like:
>> > >
>> > > *
>> > > * QBUF on output queue with request set
>> > > * QBUF on capture queue
>> > > * SUBMIT_REQUEST
>> > >
>> > > ?
>> > >
>> > > The call to vb2_request_submit() right after should trigger
>> > > v4l2_m2m_try_schedule(), since the buffers associated to the
>> > > request
>> > > will enter the vb2 queue and be passed to the m2m framework, which
>> > > will then call v4l2_m2m_try_schedule(). Or maybe you are thinking
>> > > about a different sequence of events?
>> >
>> > This is indeed the sequence of events that I'm seeing, but the
>> > scheduling call simply did not happen on vb2_request_submit. I
>> > suppose I will need to investigate some more to find out exactly
>> > why.
>> >
>> > IIRC, the m2m qbuf function is called (and fails to schedule) when
>> > the
>> > ioctl happens, not when the task is submitted.
>> >
>> > This issue is seen with vim2m as well as the rencently-submitted
>> > sunxi-
>> > cedrus driver (with the in-driver calls to v4l2_m2m_try_schedule
>> > removed, obviously). If needs be, I could provide a standalone test
>> > program to reproduce it.
>>
>> If you have a standalone program that can reproduce this on vim2m,
>> then I would like to see it indeed, if only to understand what I have
>> missed.
>
> You can find the test file for this use case at:
> https://gist.github.com/paulkocialkowski/4cfa350e1bbe8e3bf714480bba83ea72

Thanks, I have been able to see what the issue was. One indeed needs
to call v4l2_m2m_try_schedule() when the request is queued, since the
driver qbuf() hook does not do it automatically.
