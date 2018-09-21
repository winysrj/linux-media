Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37360 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725991AbeIUFsk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 01:48:40 -0400
Date: Fri, 21 Sep 2018 03:02:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] vidioc-dqevent.rst: clarify V4L2_EVENT_SRC_CH_RESOLUTION
Message-ID: <20180921000236.khsdtjlsxjckivrq@valkosipuli.retiisi.org.uk>
References: <c93de92e-443f-9597-268f-d68294b2f42d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c93de92e-443f-9597-268f-d68294b2f42d@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2018 at 01:37:18PM +0200, Hans Verkuil wrote:
> Clarify that when you receive V4L2_EVENT_SOURCE_CHANGE with flag
> V4L2_EVENT_SRC_CH_RESOLUTION set, and the new resolution appears
> identical to the old resolution, then you still must restart the
> streaming I/O.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
