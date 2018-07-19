Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39512 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbeGSX5c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 19:57:32 -0400
Message-ID: <dbfe848770746c385221b3c95b4dba6726ca057b.camel@collabora.com>
Subject: Re: [PATCH 1/2] v4l2-core: Simplify v4l2_m2m_try_{schedule,run}
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: kernel@collabora.com, paul.kocialkowski@bootlin.com,
        maxime.ripard@bootlin.com, Hans Verkuil <hans.verkuil@cisco.com>
Date: Thu, 19 Jul 2018 20:12:07 -0300
In-Reply-To: <1a9c086f-c664-70cd-62c1-59ca24d6b2a0@xs4all.nl>
References: <20180712154322.30237-1-ezequiel@collabora.com>
         <20180712154322.30237-2-ezequiel@collabora.com>
         <1a9c086f-c664-70cd-62c1-59ca24d6b2a0@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-07-18 at 12:23 +0200, Hans Verkuil wrote:
> On 12/07/18 17:43, Ezequiel Garcia wrote:
> > v4l2_m2m_try_run() has only one caller and so it's possible
> > to move its contents.
> > 
> > Although this de-modularization change could reduce clarity,
> > in this case it allows to remove a spinlock lock/unlock pair
> > and an unneeded sanity check.
> > 
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> 
> This patch no longer applies, can you respin?
> 

I think that is because it applies on top of:

    v4l2-mem2mem: Simplify exiting the function in v4l2_m2m_try_schedule
    
    The v4l2_m2m_try_schedule function acquires and releases multiple
    spinlocks; simplify unlocking the job lock by adding a label to unlock the
    job lock and exit the function.

which I cherry-picked from the Request API series.

I will include this patch in my next submit, in case you want
to take the series soon(ishly).

Thanks,
Ezequiel
