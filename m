Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f44.google.com ([209.85.161.44]:44883 "EHLO
        mail-yw1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbeJOQRe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 12:17:34 -0400
Received: by mail-yw1-f44.google.com with SMTP id s73-v6so7210897ywg.11
        for <linux-media@vger.kernel.org>; Mon, 15 Oct 2018 01:33:18 -0700 (PDT)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id l138-v6sm2624650ywe.50.2018.10.15.01.33.16
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 01:33:16 -0700 (PDT)
Received: by mail-yw1-f51.google.com with SMTP id d126-v6so7227632ywa.5
        for <linux-media@vger.kernel.org>; Mon, 15 Oct 2018 01:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <b9b2f5ea-8593-d1bf-6d4f-c2efddaa7002@xs4all.nl> <fe5f3088-84cc-b15d-a8a7-a9557aeb7246@xs4all.nl>
In-Reply-To: <fe5f3088-84cc-b15d-a8a7-a9557aeb7246@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 15 Oct 2018 17:33:04 +0900
Message-ID: <CAAFQd5AnAFjAiMTLbHm9bc9K34sqZ2y18b8oOZ0_o52GeJ=sBw@mail.gmail.com>
Subject: Re: [RFC] Informal meeting during ELCE to discuss userspace support
 for stateless codecs
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>
Cc: nicolas@ndufresne.ca, maxime.ripard@free-electrons.com,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        vjaquez@igalia.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+Alexandre Courbot
On Wed, Oct 10, 2018 at 3:55 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 10/08/2018 01:53 PM, Hans Verkuil wrote:
> > Hi all,
> >
> > I would like to meet up somewhere during the ELCE to discuss userspace support
> > for stateless (and perhaps stateful as well?) codecs.
> >
> > It is also planned as a topic during the summit, but I would prefer to prepare
> > for that in advance, esp. since I myself do not have any experience writing
> > userspace SW for such devices.
> >
> > Nicolas, it would be really great if you can participate in this meeting
> > since you probably have the most experience with this by far.
> >
> > Looking through the ELCE program I found two timeslots that are likely to work
> > for most of us (because the topics in the program appear to be boring for us
> > media types!):
> >
> > Tuesday from 10:50-15:50
>
> Let's do this Tuesday. Let's meet at the Linux Foundation Registration
> Desk at 11:00. I'll try to figure out where we can sit the day before.
> Please check your email Tuesday morning for any last minute changes.
>
> Tomasz, it would be nice indeed if we can get you and Paul in as well
> using Hangouts on my laptop.

That would be great. Please let me know if you need any help with setup.

Best regards,
Tomasz

>
> I would very much appreciate it if those who have experience with the
> userspace support think about this beforehand and make some requirements
> list of what you would like to see.
>
> Regards,
>
>         Hans
>
> >
> > or:
> >
> > Monday from 15:45 onward
> >
> > My guess is that we need 2-3 hours or so. Hard to predict.
> >
> > The basic question that I would like to have answered is what the userspace
> > component should look like? libv4l-like plugin or a library that userspace can
> > link with? Do we want more general support for stateful codecs as well that deals
> > with resolution changes and the more complex parts of the codec API?
> >
> > I've mailed this directly to those that I expect are most interested in this,
> > but if someone want to join in let me know.
> >
> > I want to keep the group small though, so you need to bring relevant experience
> > to the table.
> >
> > Regards,
> >
> >       Hans
> >
>
