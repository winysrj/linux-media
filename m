Return-path: <mchehab@gaivota>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2658 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0LVUi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 15:38:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH 02/13] v4l: Add multi-planar ioctl handling code
Date: Wed, 22 Dec 2010 21:38:43 +0100
Cc: m.szyprowski@samsung.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	andrzej.p@samsung.com
References: <201012221601.37554.hverkuil@xs4all.nl> <1293037826-13420-1-git-send-email-pawel@osciak.com>
In-Reply-To: <1293037826-13420-1-git-send-email-pawel@osciak.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012222138.43382.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wednesday, December 22, 2010 18:10:26 Pawel Osciak wrote:
> From: Pawel Osciak <p.osciak@samsung.com>
> 
> Add multi-planar API core ioctl handling and conversion functions.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |  453 ++++++++++++++++++++++++++++++++++----
>  include/media/v4l2-ioctl.h       |   16 ++
>  2 files changed, 425 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 8516669..e2f6abb 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c

<snip>

OK, looks good.

Marek, this patch + the other patches from your v8 patch series are good to
go as far as I am concerned. So you can add my tag to the whole series:

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

The only note I want to make is that the V4L2 DocBook spec needs to be updated
for the multiplanar API. But in my opinion that patch can be done in January.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
