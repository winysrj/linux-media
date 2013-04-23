Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53889 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3DWM0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 08:26:04 -0400
Date: Tue, 23 Apr 2013 14:25:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Katsuya Matsubara <matsu@igel.co.jp>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix some bugs in the sh_veu driver
In-Reply-To: <1366714297-2784-1-git-send-email-matsu@igel.co.jp>
Message-ID: <Pine.LNX.4.64.1304231421420.1422@axis700.grange>
References: <1366714297-2784-1-git-send-email-matsu@igel.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matsubara-san

On Tue, 23 Apr 2013, Katsuya Matsubara wrote:

> Hi Guennadi,
> 
> This patch set fixes some small bugs in the sh_veu driver.
> They have been tested on the Mackerel board.
> 
> Thanks,
> 
> Katsuya Matsubara (3):
>   [media] sh_veu: invoke v4l2_m2m_job_finish() even if a job has been
>     aborted
>   [media] sh_veu: keep power supply until the m2m context is released
>   [media] sh_veu: fix the buffer size calculation

Thanks for your patches. I don't think we should push them to 3.9, I'll 
get them queued to 3.10 as fixes, after 3.9 is released we can also send 
them to stable, do you think they are important enough?

Thanks
Guennadi

>  drivers/media/platform/sh_veu.c |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)
> 
> ---
> Katsuya Matsubara / IGEL Co., Ltd

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
