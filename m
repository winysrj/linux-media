Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60190 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab1ICQc4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2011 12:32:56 -0400
Message-ID: <4E6256B2.7010407@gmail.com>
Date: Sat, 03 Sep 2011 18:32:50 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-samsung-soc@vger.kernel.org, mchehab@redhat.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Subject: Re: [PATCH 0/19 v4] s5p-fimc driver conversion to media controller
 and control framework
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/01/2011 05:30 PM, Sylwester Nawrocki wrote:
> Hello,
>
> following is a fourth version of the patchset converting s5p-fimc driver
> to the media controller API and the new control framework.
>
> Mauro, could you please have a look at the patches and let me know of any doubts?
> I tried to provide possibly detailed description of what each patch does and why.
>
> The changeset is available at:
>    http://git.infradead.org/users/kmpark/linux-2.6-samsung
>    branch: v4l_fimc_for_mauro
>
> on top of patches from Marek's 'Videobuf2&  FIMC fixes" pull request
> which this series depends on.
...
>
> Sylwester Nawrocki (19):
>    s5p-fimc: Remove registration of video nodes from probe()
>    s5p-fimc: Remove sclk_cam clock handling
>    s5p-fimc: Limit number of available inputs to one
>    s5p-fimc: Remove sensor management code from FIMC capture driver
>    s5p-fimc: Remove v4l2_device from video capture and m2m driver
>    s5p-fimc: Add the media device driver
>    s5p-fimc: Conversion to use struct v4l2_fh
>    s5p-fimc: Convert to the new control framework
>    s5p-fimc: Add media operations in the capture entity driver
>    s5p-fimc: Add PM helper function for streaming control
>    s5p-fimc: Correct color format enumeration
>    s5p-fimc: Convert to use media pipeline operations
>    s5p-fimc: Add subdev for the FIMC processing block
>    s5p-fimc: Add support for JPEG capture
>    s5p-fimc: Add v4l2_device notification support for single frame
>      capture
>    s5p-fimc: Use consistent names for the buffer list functions
>    s5p-fimc: Add runtime PM support in the camera capture driver
>    s5p-fimc: Correct crop offset alignment on exynos4
>    s5p-fimc: Remove single-planar capability flags

oops, I've done this posting wrong, the first patch is missing here :(
-> s5p-fimc: Add media entity initialization

Still the patch set is complete at git repository as indicated above.
I'm sorry for the confusion.

--
Regards,
Sylwester





