Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20715 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751866AbdHUHx7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 03:53:59 -0400
Subject: Re: [v4l-utils PATCH 1/1] v4l2-compliance: Add support for metadata
 output
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: tfiga@chromium.org, yong.zhi@intel.com
References: <20170821073849.20487-1-sakari.ailus@linux.intel.com>
 <1257cee2-63fb-23ce-fc81-908b660467c0@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <11845397-7b4c-0539-9b20-f19a646b2d37@linux.intel.com>
Date: Mon, 21 Aug 2017 10:53:36 +0300
MIME-Version: 1.0
In-Reply-To: <1257cee2-63fb-23ce-fc81-908b660467c0@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi Sakari,
>
> Thanks for the patch, but it is not complete. Most importantly the V4L2_BUF_TYPE_LAST
> define in v4l2-compliance.h isn't updated to V4L2_BUF_TYPE_META_OUTPUT.
>
> It's best to just do a 'git grep META_CAPTURE' in v4l-utils and check each place it
> is used whether META_OUTPUT support should also be added.

That's what I did but I somehow missed META_OUTPUT in v4l2-compliance.h. 
I'll update the set, but I don't expect this to be merged until the 
kernel support for metadata output goes in with Yong's ipu3 patchset.

>
> Note for v4l2-ctl-meta.cpp: interestingly the usage help for meta formats already
> includes support for meta output, but no where else in v4l2-ctl is there meta output
> support.
>
> It appears to be unintentional that this was committed.

Seems so. This set is (so far) only adding support for v4l2-compliance.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
