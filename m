Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54598 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab1IHGs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 02:48:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Date: Thu, 08 Sep 2011 08:48:23 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 0/19 v4] s5p-fimc driver conversion to media controller and
 control framework
In-reply-to: <4E6687FE.5030607@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <4E686537.9050604@samsung.com>
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
 <4E6256B2.7010407@gmail.com> <4E6687FE.5030607@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2011 10:52 PM, Mauro Carvalho Chehab wrote:
> Em 03-09-2011 13:32, Sylwester Nawrocki escreveu:
>> On 09/01/2011 05:30 PM, Sylwester Nawrocki wrote:
>>> Hello,
>>>
>>> following is a fourth version of the patchset converting s5p-fimc driver
>>> to the media controller API and the new control framework.
>>>
>>> Mauro, could you please have a look at the patches and let me know of any doubts?
>>> I tried to provide possibly detailed description of what each patch does and why.
>>>
>>> The changeset is available at:
>>>    http://git.infradead.org/users/kmpark/linux-2.6-samsung
>>>    branch: v4l_fimc_for_mauro
>>>
>>> on top of patches from Marek's 'Videobuf2&  FIMC fixes" pull request
>>> which this series depends on.
>> ...
>>>
>>> Sylwester Nawrocki (19):
>>>    s5p-fimc: Remove registration of video nodes from probe()
>>>    s5p-fimc: Remove sclk_cam clock handling
>>>    s5p-fimc: Limit number of available inputs to one
>>>    s5p-fimc: Remove sensor management code from FIMC capture driver
>>>    s5p-fimc: Remove v4l2_device from video capture and m2m driver
>>>    s5p-fimc: Add the media device driver
>>>    s5p-fimc: Conversion to use struct v4l2_fh
>>>    s5p-fimc: Convert to the new control framework
>>>    s5p-fimc: Add media operations in the capture entity driver
>>>    s5p-fimc: Add PM helper function for streaming control
>>>    s5p-fimc: Correct color format enumeration
>>>    s5p-fimc: Convert to use media pipeline operations
>>>    s5p-fimc: Add subdev for the FIMC processing block
>>>    s5p-fimc: Add support for JPEG capture
>>>    s5p-fimc: Add v4l2_device notification support for single frame
>>>      capture
>>>    s5p-fimc: Use consistent names for the buffer list functions
>>>    s5p-fimc: Add runtime PM support in the camera capture driver
>>>    s5p-fimc: Correct crop offset alignment on exynos4
>>>    s5p-fimc: Remove single-planar capability flags
>>
>> oops, I've done this posting wrong, the first patch is missing here :(
>> -> s5p-fimc: Add media entity initialization
>>
>> Still the patch set is complete at git repository as indicated above.
>> I'm sorry for the confusion.
> 
> No problem. I always check from git.
> 
> Patches applied, thanks!

Thank you! I've received the notice about patches from Marek's pull request,
but the other 20 patches from this thread are not in staging/for_v3.2 branch.
Are you planning to handle that later?

-- 
Cheers.
Sylwester
