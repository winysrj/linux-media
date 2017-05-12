Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40498 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757491AbdELLxK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 07:53:10 -0400
Date: Fri, 12 May 2017 14:52:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Rajmohan Mani <rajmohan.mani@intel.com>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org,
        mchehab@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4] dw9714: Initial driver for dw9714 VCM
Message-ID: <20170512115234.GK3227@valkosipuli.retiisi.org.uk>
References: <1494478820-22199-1-git-send-email-rajmohan.mani@intel.com>
 <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
 <CGME20170511143945epcas1p26203dff026b3dc9c2f65c5ca0be7967b@epcas1p2.samsung.com>
 <9fc11dec-8c64-a681-21f9-2602fb1132c1@samsung.com>
 <20170511145913.GI3227@valkosipuli.retiisi.org.uk>
 <8a1a65d6-6b56-6471-1216-b42adcd5a693@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a1a65d6-6b56-6471-1216-b42adcd5a693@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, May 12, 2017 at 10:57:39AM +0200, Sylwester Nawrocki wrote:
> On 05/11/2017 04:59 PM, Sakari Ailus wrote:
> >>On 05/11/2017 08:30 AM, Tomasz Figa wrote:
> [...]
> >>>    rval = pm_runtime_get_sync(dev);
> >>>    if (rval < 0) {
> >>>        pm_runtime_put(dev);
> >>>        return rval;
> >>>    }
> >>Aren't we supposed to call pm_runtime_put() only when corresponding
> >>pm_runtime_get() succeeds? I think the pm_runtime_put() call above
> >>is not needed.
>  >
> >pm_runtime_get() increments the usage_count independently of whether it
> >succeeded. See __pm_runtime_resume().
> 
> You're right, sorry. I'd expect such things to be better covered in
> the API documentation.  Probably pm_runtime_put_noidle() is a better

Well, the documentation tells what the function does. It'd be good if it
pointed that the usage count needs to be decremented if the function fails.

I guess the reason is that it's just a synchronous variant of
pm_runtime_get(), which could not handle the error anyway.

> match for just decreasing usage_count.  Now many drivers appear to not
> be balancing usage_count when when pm_runtime_get_sync() fails.

Ah, quite a few drivers seem to be using pm_runtime_put_noidle() which seems
to be the correct thing to do as the device won't be on then anyway.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
