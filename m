Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:45120 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbeAPCf4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 21:35:56 -0500
Received: by mail-io0-f175.google.com with SMTP id p188so2396741ioe.12
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 18:35:55 -0800 (PST)
Received: from mail-io0-f178.google.com (mail-io0-f178.google.com. [209.85.223.178])
        by smtp.gmail.com with ESMTPSA id z77sm631227ita.19.2018.01.15.18.35.54
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jan 2018 18:35:54 -0800 (PST)
Received: by mail-io0-f178.google.com with SMTP id d11so15156960iog.5
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 18:35:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180115120111.GA9598@jade>
References: <20180110160732.7722-1-gustavo@padovan.org> <20180110160732.7722-2-gustavo@padovan.org>
 <CAPBb6MV6ErW-Z7n1aK55TxJNRDkt2SkWGEJiXkxrLmZ_GabJOA@mail.gmail.com> <20180115120111.GA9598@jade>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 16 Jan 2018 11:35:33 +0900
Message-ID: <CAPBb6MUNPtD-74ON6Wvw4waOuk4YPmYjXgFV=fBeCKTozwHJjw@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] [media] vb2: add is_unordered callback for drivers
To: Gustavo Padovan <gustavo@padovan.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 15, 2018 at 9:01 PM, Gustavo Padovan <gustavo@padovan.org> wrote:
> 2018-01-15 Alexandre Courbot <acourbot@chromium.org>:
>
>> On Thu, Jan 11, 2018 at 1:07 AM, Gustavo Padovan <gustavo@padovan.org> wrote:
>> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
>> >
>> > Explicit synchronization benefits a lot from ordered queues, they fit
>> > better in a pipeline with DRM for example so create a opt-in way for
>> > drivers notify videobuf2 that the queue is unordered.
>> >
>> > Drivers don't need implement it if the queue is ordered.
>>
>> This is going to make user-space believe that *all* vb2 drivers use
>> ordered queues by default, at least until non-ordered drivers catch up
>> with this change. Wouldn't it be less dangerous to do the opposite
>> (make queues non-ordered by default)?
>
> The rational behind this decision was because most formats/drivers are
> ordered so only a small amount of drivers need to changed. I think this
> was proposed by Hans on the Media Summit.

As long as all concerned drivers are updated we should be on the safe
side. At first I was surprised that we expose the ordering feature in
a negative tense, but if the vast majority of devices are ordered this
probably makes sense.
