Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:50443 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdJWTDa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 15:03:30 -0400
Date: Mon, 23 Oct 2017 17:03:23 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] V4L2 Jobs API WIP
Message-ID: <20171023190323.GA25210@jade>
References: <20170928095027.127173-1-acourbot@chromium.org>
 <0442082f-f176-2be7-89c0-ccf6f563917a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0442082f-f176-2be7-89c0-ccf6f563917a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-10-16 Hans Verkuil <hverkuil@xs4all.nl>:

> Hi Alexandre,
> 
> Thank you very much for working on this. Much appreciated!
> 
> I only did a very high-level review of the patch series: there is not much
> point IMHO of doing a detailed review given the upcoming discussions in
> Prague. It's better to wait until we agree with the high-level API.
> 
> Regarding the public API: the ioctls seem sane. It's all very similar to the
> other implementations we've seen.
> 
> I'm still not sure about the name 'job', but this is 'just' a naming issue.
> 
> The part where I have more doubts is the need to create a new device node.
> 
> For the upcoming meeting I would like to discuss whether this cannot be added
> to the media API.
> 
> Originally the plan was that the media API would be subsystem-agnostic and could
> also be used by ALSA/DRM/etc. This never happened and I also am not aware of any
> movement in that area.
> 
> I am wondering whether we should just be realistic and abandon the 'subsystem
> agnostic' part and be willing to add e.g. the job support to the media API.

Stupid question here: is there any techinically possible way to support
it through the media API while being subsystem agnostic?

Gustavo
