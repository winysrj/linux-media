Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:35728 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdFZPWt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 11:22:49 -0400
Received: by mail-qk0-f174.google.com with SMTP id 16so3961500qkg.2
        for <linux-media@vger.kernel.org>; Mon, 26 Jun 2017 08:22:43 -0700 (PDT)
Date: Mon, 26 Jun 2017 12:22:39 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 08/12] [media] vb2: add 'ordered' property to queues
Message-ID: <20170626152239.GA3090@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-9-gustavo@padovan.org>
 <1497632193.6020.19.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1497632193.6020.19.camel@ndufresne.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

2017-06-16 Nicolas Dufresne <nicolas@ndufresne.ca>:

> Le vendredi 16 juin 2017 à 16:39 +0900, Gustavo Padovan a écrit :
> > > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > For explicit synchronization (and soon for HAL3/Request API) we need
> > the v4l2-driver to guarantee the ordering which the buffer were queued
> > by userspace. This is already true for many drivers, but we never had
> > the need to say it.
> 
> Phrased this way, that sound like a statement that a m2m decoder
> handling b-frame will just never be supported. I think decoders are a
> very important use case for explicit synchronization.
> 
> What I believe happens with decoders is simply that the allocation
> order (the order in which empty buffers are retrieved from the queue)
> will be different then the actual presentation order. Also, multiple
> buffers endup being filled at the same time. Some firmware may inform
> of the new order at the last minute, making indeed the fence useless,
> but these are firmware and the information can be known earlier. Also,
> this information would be known by userspace for the case (up-coming,
> see STM patches and Rockchip comments [0]) or state-less decoder,
> because it is available while parsing the bitstream. For this last
> scenarios, the fact that ordering is not the same should disable the
> fences since userspace can know which fences to wait for first. Those
> drivers would need to set "ordered" to 0, which would be counter
> intuitive.
> 
> I think this use case is too important to just ignore it. I would
> expect that we at least have a todo with something sensible as a plan
> to cover this.

We definitely need to cover these usecases, I sent the patchset in a
hurry just before going on vacation and forget to lay down any plan for
other things. But for now, I believe we need refine the implementation
of the most common case and then look at expanding it.

	Gustavo
