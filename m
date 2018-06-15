Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35988 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936269AbeFOTVD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 15:21:03 -0400
Message-ID: <3065e23714a9e913e3f443b7166734164dc54dd4.camel@collabora.com>
Subject: Re: [PATCH 2/3] mem2mem: Make .job_abort optional
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: kernel@collabora.com
Date: Fri, 15 Jun 2018 16:20:56 -0300
In-Reply-To: <326c082b-44e7-60d7-9d36-2d5f4713709f@xs4all.nl>
References: <20180614153405.5697-1-ezequiel@collabora.com>
         <20180614153405.5697-3-ezequiel@collabora.com>
         <326c082b-44e7-60d7-9d36-2d5f4713709f@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-06-15 at 10:43 +0200, Hans Verkuil wrote:
> On 14/06/18 17:34, Ezequiel Garcia wrote:
> > Implementing job_abort() does not make sense on some drivers.
> > This is not a problem, as the abort is not required to
> > wait for the job to finish. Quite the opposite, drivers
> > are encouraged not to wait.
> > 
> > Demote v4l2_m2m_ops.job_abort from required to optional, and
> > clean all drivers with dummy or wrong implementations.
> 
> Can you split off the rcar_jpu.c and g2d.c changes into separate
> patches?
> The others are trivial, but those two need a more precise commit log
> and
> I would like to have Acks of the driver maintainers before merging.
> 

Yes, that makes sense.

> I'm going to take the first and third patches of this series, so you
> only have to post a v2 for this patch.
> 

OK.

Thanks,
Eze
