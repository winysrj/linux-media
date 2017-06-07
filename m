Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:51092 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751808AbdFGU42 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 16:56:28 -0400
Subject: Re: [RFC v4 00/18] vb2: Handle user cache hints, allow drivers to
 choose cache coherency
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        posciak@chromium.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, hverkuil@xs4all.nl,
        sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        laurent.pinchart@ideasonboard.com
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
 <20170607141334.4ec3b4a3@vento.lan>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <b201f845-39c0-5c56-1dc1-546e1b645e67@linux.intel.com>
Date: Wed, 7 Jun 2017 23:56:19 +0300
MIME-Version: 1.0
In-Reply-To: <20170607141334.4ec3b4a3@vento.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:
> Hi Sakari,
>
> Em Mon,  8 May 2017 18:03:12 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
>
>> Hello,
>>
>> This is a rebased and partially reworked version of the vb2 cache hints
>> support patch series posted by first myself, then Laurent and then myself
>> again.
>>
>> I'm still posting this as RFC primarily because more testing and driver
>> changes will be needed. In particular, a lot of platform drivers assume
>> non-coherent memory but are not properly labelled as such.
>
> The main issue I see is that, if the driver doesn't "annotate" if it
> is requiring coherent or non-coherent memory, VB2 should be preserving
> its old behavior, as, otherwise, it will risk causing regressions.

Some of the assumptions in VB2 mirror the particular design choices made 
in ARM DMA API implementation. This was found out during the review. The 
set requires further work in order to be mergeable to get around these 
issues, until then this remains in RFC stage.

I posted the three first patches separately --- these do not change how 
cache management works.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
