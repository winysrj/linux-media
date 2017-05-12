Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45323 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755771AbdELI5s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 04:57:48 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OPU00LXR0W9Z3B0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 12 May 2017 17:57:45 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4] dw9714: Initial driver for dw9714 VCM
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rajmohan Mani <rajmohan.mani@intel.com>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org,
        mchehab@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <8a1a65d6-6b56-6471-1216-b42adcd5a693@samsung.com>
Date: Fri, 12 May 2017 10:57:39 +0200
MIME-version: 1.0
In-reply-to: <20170511145913.GI3227@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <1494478820-22199-1-git-send-email-rajmohan.mani@intel.com>
 <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
 <CGME20170511143945epcas1p26203dff026b3dc9c2f65c5ca0be7967b@epcas1p2.samsung.com>
 <9fc11dec-8c64-a681-21f9-2602fb1132c1@samsung.com>
 <20170511145913.GI3227@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/11/2017 04:59 PM, Sakari Ailus wrote:
>> On 05/11/2017 08:30 AM, Tomasz Figa wrote:
[...]
>>>     rval = pm_runtime_get_sync(dev);
>>>     if (rval < 0) {
>>>         pm_runtime_put(dev);
>>>         return rval;
>>>     }
>> Aren't we supposed to call pm_runtime_put() only when corresponding
>> pm_runtime_get() succeeds? I think the pm_runtime_put() call above
>> is not needed.
  >
> pm_runtime_get() increments the usage_count independently of whether it
> succeeded. See __pm_runtime_resume().

You're right, sorry. I'd expect such things to be better covered in
the API documentation.  Probably pm_runtime_put_noidle() is a better
match for just decreasing usage_count.  Now many drivers appear to not
be balancing usage_count when when pm_runtime_get_sync() fails.

-- 
Regards,
Sylwester
