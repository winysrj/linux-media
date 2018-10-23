Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41912 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbeJWS2T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Oct 2018 14:28:19 -0400
Received: by mail-yw1-f67.google.com with SMTP id 135-v6so290085ywo.8
        for <linux-media@vger.kernel.org>; Tue, 23 Oct 2018 03:05:35 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id y130-v6sm179231ywc.69.2018.10.23.03.05.33
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Oct 2018 03:05:34 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id o8-v6so292230ybk.13
        for <linux-media@vger.kernel.org>; Tue, 23 Oct 2018 03:05:33 -0700 (PDT)
MIME-Version: 1.0
References: <b9b2f5ea-8593-d1bf-6d4f-c2efddaa7002@xs4all.nl>
 <fe5f3088-84cc-b15d-a8a7-a9557aeb7246@xs4all.nl> <5266630e-d1f8-8613-98e7-5def3c34fb4a@xs4all.nl>
In-Reply-To: <5266630e-d1f8-8613-98e7-5def3c34fb4a@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 23 Oct 2018 19:05:21 +0900
Message-ID: <CAAFQd5B26nZDnnZ2yLvAqhknN3Wdp-DSOLcknR7n+DijZ4pWvw@mail.gmail.com>
Subject: Re: [RFC] Informal meeting during ELCE to discuss userspace support
 for stateless codecs
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: nicolas@ndufresne.ca, maxime.ripard@free-electrons.com,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?B?VsOtY3RvciBKw6FxdWV6?= <vjaquez@igalia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 23, 2018 at 6:17 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> A quick update:
>
> As said in my previous email: we'll meet at 11 am at the registration desk.
> From there we go to the Platform 5 Cafe. If that's too crowded/noisy, then
> we'll try the Sheraton hotel.
>
> Tomasz, I'll ping you on irc when we found a good spot and we can setup the
> Hangouts meeting.

Thanks.

In case of anyone else interested in joining, please use this link:
http://bit.ly/elce-codecs

Best regards,
Tomasz

>
> Hope to see you all tomorrow,
>
> Regards,
>
>         Hans
>
> On 10/10/2018 07:55 AM, Hans Verkuil wrote:
> > On 10/08/2018 01:53 PM, Hans Verkuil wrote:
> >> Hi all,
> >>
> >> I would like to meet up somewhere during the ELCE to discuss userspace support
> >> for stateless (and perhaps stateful as well?) codecs.
> >>
> >> It is also planned as a topic during the summit, but I would prefer to prepare
> >> for that in advance, esp. since I myself do not have any experience writing
> >> userspace SW for such devices.
> >>
> >> Nicolas, it would be really great if you can participate in this meeting
> >> since you probably have the most experience with this by far.
> >>
> >> Looking through the ELCE program I found two timeslots that are likely to work
> >> for most of us (because the topics in the program appear to be boring for us
> >> media types!):
> >>
> >> Tuesday from 10:50-15:50
> >
> > Let's do this Tuesday. Let's meet at the Linux Foundation Registration
> > Desk at 11:00. I'll try to figure out where we can sit the day before.
> > Please check your email Tuesday morning for any last minute changes.
> >
> > Tomasz, it would be nice indeed if we can get you and Paul in as well
> > using Hangouts on my laptop.
> >
> > I would very much appreciate it if those who have experience with the
> > userspace support think about this beforehand and make some requirements
> > list of what you would like to see.
> >
> > Regards,
> >
> >       Hans
> >
> >>
> >> or:
> >>
> >> Monday from 15:45 onward
> >>
> >> My guess is that we need 2-3 hours or so. Hard to predict.
> >>
> >> The basic question that I would like to have answered is what the userspace
> >> component should look like? libv4l-like plugin or a library that userspace can
> >> link with? Do we want more general support for stateful codecs as well that deals
> >> with resolution changes and the more complex parts of the codec API?
> >>
> >> I've mailed this directly to those that I expect are most interested in this,
> >> but if someone want to join in let me know.
> >>
> >> I want to keep the group small though, so you need to bring relevant experience
> >> to the table.
> >>
> >> Regards,
> >>
> >>      Hans
> >>
> >
>
