Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52350 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab2DFUr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2012 16:47:59 -0400
Received: by wejx9 with SMTP id x9so1643210wej.19
        for <linux-media@vger.kernel.org>; Fri, 06 Apr 2012 13:47:57 -0700 (PDT)
Message-ID: <4F7F567B.1040305@gmail.com>
Date: Fri, 06 Apr 2012 22:47:55 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PATCHES FOR 3.4] s5p/exynos fimc driver updates
References: <4F69F9ED.8080306@samsung.com>
In-Reply-To: <4F69F9ED.8080306@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 03/21/2012 04:55 PM, Sylwester Nawrocki wrote:
> The following changes since commit bcc15c27c75187016f4402d94967f74b7571bacc:
>
>    Merge remote-tracking branch 'linuxtv/staging/for_v3.4' into fimc-for-next (2012-03-21 10:19:36 +0100)
>
> are available in the git repository at:
>
>
>    git://git.infradead.org/users/kmpark/linux-samsung fimc-for-next
>
> for you to fetch changes up to 6576f95e4d74877cf8b385e7591959f78f300dc7:
>
>    s5p-fimc: Handle sub-device interdependencies using deferred probing (2012-03-21 13:58:09 +0100)
>
> ----------------------------------------------------------------
> Sylwester Nawrocki (6):
>        s5p-fimc: Don't use platform data for CSI data alignment configuration
>        s5p-fimc: Reinitialize the pipeline properly after VIDIOC_STREAMOFF

Could you please pick this one bug fix patch for 3.4-rcX ? And ignore
the other 5, I would add them to another pull request.

>        s5p-fimc: Simplify locking by removing the context data structure spinlock
>        s5p-fimc: Refactor hardware setup for m2m transaction
>        s5p-fimc: Remove unneeded fields from struct fimc_dev
>        s5p-fimc: Handle sub-device interdependencies using deferred probing


Thanks,
Sylwester
