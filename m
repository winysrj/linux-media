Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2108 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab3JQR1p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 13:27:45 -0400
Message-ID: <5b441bfc95ea3d9500c0eb7b68134c51.squirrel@webmail.xs4all.nl>
In-Reply-To: <52601C1B.6080802@samsung.com>
References: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
    <52601C1B.6080802@samsung.com>
Date: Thu, 17 Oct 2013 19:27:33 +0200
Subject: Re: [PATCH RFC v2 00/10] V4L2 mem-to-mem ioctl helpers
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Sylwester Nawrocki" <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	p.zabel@pengutronix.de, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

> Hi Hans,
>
> Can I still add your Ack to updated patches 2, 3, 4, 10 ?

Yes, that's OK.

Regards,

    Hans

>
> Thanks,
> Sylwester
>
> On 12/10/13 14:31, Sylwester Nawrocki wrote:
>> Hello,
>>
>> This patch set adds ioctl helpers to the v4l2-mem2mem module so the
>> video mem-to-mem drivers can be simplified by removing functions that
>> are only a pass-through to the v4l2_m2m_* calls. In addition some of
>> the vb2 helper functions can be used as well.
>>
>> These helpers are similar to the videobuf2 ioctl helpers introduced
>> in commit 4c1ffcaad5 "[media] videobuf2-core: add helper functions".
>>
>> Currently the requirements to use helper function introduced in this
>> patch set is that both OUTPUT and CAPTURE vb2 buffer queues must use
>> same lock and the driver uses struct v4l2_fh.
>>
>> I have only tested the first four patches in this series, Tested-by
>> for the mx2-emmaprp, exynos-gsc, s5p-g2d drivers are appreciated.
>>
>> This patch series can be also found at:
>>  git://linuxtv.org/snawrocki/samsung.git m2m-helpers-v3
>>
>> Changes since original version include addition of related cleanup
>> patches, added helper function for create_buf ioctl and m2m context
>> pointer from struct v4l2_fh is now reused and related field from the
>> drivers' private data structure is removed.
>>
>> Thank you for all reviews. I plan to queue the first four patches for
>> next kernel release early this week. For the mx2-emmaprp, exynos-gsc,
>> s5p-g2d driver feedback is needed from someone who can actually test
>> the changes. Any Tested-by for those drivers would be appreciated.
>>
>> Thanks,
>> Sylwester
>>
>> Sylwester Nawrocki (10):
>>   V4L: Add mem2mem ioctl and file operation helpers
>>   mem2mem_testdev: Use mem-to-mem ioctl and vb2 helpers
>>   exynos4-is: Use mem-to-mem ioctl helpers
>>   s5p-jpeg: Use mem-to-mem ioctl helpers
>>   mx2-emmaprp: Use struct v4l2_fh
>>   mx2-emmaprp: Use mem-to-mem ioctl helpers
>>   exynos-gsc: Configure default image format at device open()
>>   exynos-gsc: Remove GSC_{SRC, DST}_FMT flags
>>   exynos-gsc: Use mem-to-mem ioctl helpers
>>   s5p-g2d: Use mem-to-mem ioctl helpers
>>
>>  drivers/media/platform/exynos-gsc/gsc-core.c  |   10 +-
>>  drivers/media/platform/exynos-gsc/gsc-core.h  |   14 --
>>  drivers/media/platform/exynos-gsc/gsc-m2m.c   |  232
>> ++++++++-----------------
>>  drivers/media/platform/exynos4-is/fimc-core.h |    2 -
>>  drivers/media/platform/exynos4-is/fimc-m2m.c  |  148 +++-------------
>>  drivers/media/platform/mem2mem_testdev.c      |  152 +++-------------
>>  drivers/media/platform/mx2_emmaprp.c          |  185
>> ++++++--------------
>>  drivers/media/platform/s5p-g2d/g2d.c          |  124 +++-----------
>>  drivers/media/platform/s5p-g2d/g2d.h          |    1 -
>>  drivers/media/platform/s5p-jpeg/jpeg-core.c   |  134 +++------------
>>  drivers/media/platform/s5p-jpeg/jpeg-core.h   |    2 -
>>  drivers/media/v4l2-core/v4l2-mem2mem.c        |  118 +++++++++++++
>>  include/media/v4l2-fh.h                       |    4 +
>>  include/media/v4l2-mem2mem.h                  |   24 +++
>>  14 files changed, 382 insertions(+), 768 deletions(-)
>>
>> --
>> 1.7.4.1
>
> --
> Sylwester Nawrocki
> Samsung R&D Institute Poland
>


