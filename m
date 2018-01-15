Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:44544 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752357AbeAOMBW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 07:01:22 -0500
Date: Mon, 15 Jan 2018 10:01:11 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Alexandre Courbot <acourbot@chromium.org>
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
Subject: Re: [PATCH v7 1/6] [media] vb2: add is_unordered callback for drivers
Message-ID: <20180115120111.GA9598@jade>
References: <20180110160732.7722-1-gustavo@padovan.org>
 <20180110160732.7722-2-gustavo@padovan.org>
 <CAPBb6MV6ErW-Z7n1aK55TxJNRDkt2SkWGEJiXkxrLmZ_GabJOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPBb6MV6ErW-Z7n1aK55TxJNRDkt2SkWGEJiXkxrLmZ_GabJOA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-01-15 Alexandre Courbot <acourbot@chromium.org>:

> On Thu, Jan 11, 2018 at 1:07 AM, Gustavo Padovan <gustavo@padovan.org> wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> >
> > Explicit synchronization benefits a lot from ordered queues, they fit
> > better in a pipeline with DRM for example so create a opt-in way for
> > drivers notify videobuf2 that the queue is unordered.
> >
> > Drivers don't need implement it if the queue is ordered.
> 
> This is going to make user-space believe that *all* vb2 drivers use
> ordered queues by default, at least until non-ordered drivers catch up
> with this change. Wouldn't it be less dangerous to do the opposite
> (make queues non-ordered by default)?

The rational behind this decision was because most formats/drivers are
ordered so only a small amount of drivers need to changed. I think this
was proposed by Hans on the Media Summit.

I understand your concern. My question is how dangerous will it be. If
you are building a product you will make the changes in the driver if
they are not there yet, or if it is a distribution you'd never know
which driver/format you are using so you should be prepared for
everything.

AFAIK all Capture drivers are ordered and that is where I think fences
is most useful.

Gustavo
