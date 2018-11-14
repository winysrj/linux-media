Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:41094 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727375AbeKNSLh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 13:11:37 -0500
Received: by mail-yw1-f66.google.com with SMTP id c126-v6so6911607ywd.8
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 00:09:28 -0800 (PST)
Received: from mail-yw1-f41.google.com (mail-yw1-f41.google.com. [209.85.161.41])
        by smtp.gmail.com with ESMTPSA id b144sm483269ywa.33.2018.11.14.00.09.26
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 00:09:26 -0800 (PST)
Received: by mail-yw1-f41.google.com with SMTP id x2so498619ywc.9
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 00:09:26 -0800 (PST)
MIME-Version: 1.0
References: <20180803143626.48191-1-hverkuil@xs4all.nl>
In-Reply-To: <20180803143626.48191-1-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 14 Nov 2018 17:09:13 +0900
Message-ID: <CAAFQd5AnQRKEcfV2FSeTJELpsN2Y4Jx++X2kNqXfvq7r5NjhMQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Media Controller Properties
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Aug 3, 2018 at 11:36 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This RFC patch series implements properties for the media controller.
>
> This is not finished, but I wanted to post this so people can discuss
> this further.
>
> No documentation yet (too early for that).
>
> An updated v4l2-ctl and v4l2-compliance that can report properties
> is available here:
>
> https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=props
>
> There is one main missing piece: currently the properties are effectively
> laid out in random order. My plan is to change that so they are grouped
> by object type and object owner. So first all properties for each entity,
> then for each pad, etc. I started to work on that, but it's a bit more
> work than expected and I wanted to post this before the weekend.
>
> While it is possible to have nested properties, this is not currently
> implemented. Only properties for entities and pads are supported in this
> code, but that's easy to extend to interfaces and links.
>
> I'm not sure about the G_TOPOLOGY ioctl handling: I went with the quickest
> option by renaming the old ioctl and adding a new one with property support.
>
> I think this needs to change (at the very least the old and new should
> share the same ioctl NR), but that's something for the future.
>
> Currently I support u64, s64 and const char * property types. But it
> can be anything including binary data if needed. No array support (as we
> have for controls), but there are enough reserved fields in media_v2_prop
> to add this if needed.
>
> I added properties for entities and pads to vimc, so I could test this.

I think I'm missing the background and the description doesn't mention
it either. What's the use case for those and why not controls?

Best regards,
Tomasz
