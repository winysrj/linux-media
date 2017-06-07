Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53253
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751423AbdFGRNu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 13:13:50 -0400
Date: Wed, 7 Jun 2017 14:13:39 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        posciak@chromium.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, hverkuil@xs4all.nl,
        sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v4 00/18] vb2: Handle user cache hints, allow drivers to
 choose cache coherency
Message-ID: <20170607141334.4ec3b4a3@vento.lan>
In-Reply-To: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Em Mon,  8 May 2017 18:03:12 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hello,
> 
> This is a rebased and partially reworked version of the vb2 cache hints
> support patch series posted by first myself, then Laurent and then myself
> again.
> 
> I'm still posting this as RFC primarily because more testing and driver
> changes will be needed. In particular, a lot of platform drivers assume
> non-coherent memory but are not properly labelled as such.

The main issue I see is that, if the driver doesn't "annotate" if it
is requiring coherent or non-coherent memory, VB2 should be preserving
its old behavior, as, otherwise, it will risk causing regressions. 

So, perhaps instead of creating a single flag
V4L2_BUF_FLAG_NO_CACHE_SYNC, it would make sense to create two
flags, using either one of them on newer drivers. For old drivers
that won't set either, it would keep the current behavior.

Thanks,
Mauro
