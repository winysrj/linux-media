Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363Ab1IHIYH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Sep 2011 04:24:07 -0400
Message-ID: <4E687B93.10005@redhat.com>
Date: Thu, 08 Sep 2011 05:23:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Subject: Re: [PATCH 0/19 v4] s5p-fimc driver conversion to media controller
 and control framework
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com> <4E6256B2.7010407@gmail.com> <4E6687FE.5030607@redhat.com> <4E686537.9050604@samsung.com>
In-Reply-To: <4E686537.9050604@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 08-09-2011 03:48, Sylwester Nawrocki escreveu:
> On 09/06/2011 10:52 PM, Mauro Carvalho Chehab wrote:
>> Em 03-09-2011 13:32, Sylwester Nawrocki escreveu:
>>> On 09/01/2011 05:30 PM, Sylwester Nawrocki wrote:
>>>> Hello,
>>>>
>>>> following is a fourth version of the patchset converting s5p-fimc driver
>>>> to the media controller API and the new control framework.
>>>>
>>>> Mauro, could you please have a look at the patches and let me know of any doubts?
>>>> I tried to provide possibly detailed description of what each patch does and why.
>>>>
>>>> The changeset is available at:
>>>>    http://git.infradead.org/users/kmpark/linux-2.6-samsung
>>>>    branch: v4l_fimc_for_mauro
>>>>
>>>> on top of patches from Marek's 'Videobuf2&  FIMC fixes" pull request
>>>> which this series depends on.
>>> ...
>>>>
>>>> Sylwester Nawrocki (19):
>>>>    s5p-fimc: Remove registration of video nodes from probe()
>>>>    s5p-fimc: Remove sclk_cam clock handling
>>>>    s5p-fimc: Limit number of available inputs to one
>>>>    s5p-fimc: Remove sensor management code from FIMC capture driver
>>>>    s5p-fimc: Remove v4l2_device from video capture and m2m driver
>>>>    s5p-fimc: Add the media device driver
>>>>    s5p-fimc: Conversion to use struct v4l2_fh
>>>>    s5p-fimc: Convert to the new control framework
>>>>    s5p-fimc: Add media operations in the capture entity driver
>>>>    s5p-fimc: Add PM helper function for streaming control
>>>>    s5p-fimc: Correct color format enumeration
>>>>    s5p-fimc: Convert to use media pipeline operations
>>>>    s5p-fimc: Add subdev for the FIMC processing block
>>>>    s5p-fimc: Add support for JPEG capture
>>>>    s5p-fimc: Add v4l2_device notification support for single frame
>>>>      capture
>>>>    s5p-fimc: Use consistent names for the buffer list functions
>>>>    s5p-fimc: Add runtime PM support in the camera capture driver
>>>>    s5p-fimc: Correct crop offset alignment on exynos4
>>>>    s5p-fimc: Remove single-planar capability flags
>>>
>>> oops, I've done this posting wrong, the first patch is missing here :(
>>> -> s5p-fimc: Add media entity initialization
>>>
>>> Still the patch set is complete at git repository as indicated above.
>>> I'm sorry for the confusion.
>>
>> No problem. I always check from git.
>>
>> Patches applied, thanks!
> 
> Thank you! I've received the notice about patches from Marek's pull request,
> but the other 20 patches from this thread are not in staging/for_v3.2 branch.
> Are you planning to handle that later?

Patches were handled. Just pushed upstream.

Thanks,
Mauro.
> 

