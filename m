Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:45722 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751483AbeAOR4N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 12:56:13 -0500
Date: Mon, 15 Jan 2018 15:55:54 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH v7 1/6] [media] vb2: add is_unordered callback for drivers
Message-ID: <20180115175554.GB9598@jade>
References: <20180110160732.7722-1-gustavo@padovan.org>
 <20180110160732.7722-2-gustavo@padovan.org>
 <CAPBb6MV6ErW-Z7n1aK55TxJNRDkt2SkWGEJiXkxrLmZ_GabJOA@mail.gmail.com>
 <20180115120111.GA9598@jade>
 <373924ea-a35c-78f5-dd0c-e5f36623cb84@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <373924ea-a35c-78f5-dd0c-e5f36623cb84@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-01-15 Hans Verkuil <hverkuil@xs4all.nl>:

> On 01/15/2018 01:01 PM, Gustavo Padovan wrote:
> > 2018-01-15 Alexandre Courbot <acourbot@chromium.org>:
> > 
> >> On Thu, Jan 11, 2018 at 1:07 AM, Gustavo Padovan <gustavo@padovan.org> wrote:
> >>> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> >>>
> >>> Explicit synchronization benefits a lot from ordered queues, they fit
> >>> better in a pipeline with DRM for example so create a opt-in way for
> >>> drivers notify videobuf2 that the queue is unordered.
> >>>
> >>> Drivers don't need implement it if the queue is ordered.
> >>
> >> This is going to make user-space believe that *all* vb2 drivers use
> >> ordered queues by default, at least until non-ordered drivers catch up
> >> with this change. Wouldn't it be less dangerous to do the opposite
> >> (make queues non-ordered by default)?
> > 
> > The rational behind this decision was because most formats/drivers are
> > ordered so only a small amount of drivers need to changed. I think this
> > was proposed by Hans on the Media Summit.
> > 
> > I understand your concern. My question is how dangerous will it be. If
> > you are building a product you will make the changes in the driver if
> > they are not there yet, or if it is a distribution you'd never know
> > which driver/format you are using so you should be prepared for
> > everything.
> > 
> > AFAIK all Capture drivers are ordered and that is where I think fences
> > is most useful.
> 
> Right. What could be done is to mark all codec drivers as unordered initially
> ask the driver authors to verify this. All capture drivers using vb2 and not
> using REQUEUE are ordered.

That is a good way out.

> 
> One thing we haven't looked at is what to do with drivers that do not use vb2.
> Those won't support fences, but how will userspace know that fences are not
> supported? I'm not sure what the best method is for that.
> 
> I am leaning towards a new capability since this has to be advertised clearly.

The capability flag makes sense to me, I'll incorporate it as part of my
next patchset.

Gustavo
