Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3244 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab1CZS3c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 14:29:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: Re: [PATCH] [media] cpia2: fix typo in variable initialisation
Date: Sat, 26 Mar 2011 19:28:52 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1301163624-7362-1-git-send-email-mk@lab.zgora.pl>
In-Reply-To: <1301163624-7362-1-git-send-email-mk@lab.zgora.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103261928.52677.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mariusz,

On Saturday, March 26, 2011 19:20:24 Mariusz Kozlowski wrote:
> Currently 'fh' initialises to whatever happens to be on stack. This
> looks like a typo and this patch fixes that.
> 
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>

If you don't mind then I'll take this patch. Although I'll probably drop it,
not because it is wrong as such but because the priority handling in cpia2
is broken big time. I intend to rewrite it using the new prio framework that
was just merged.

Luckily I finally found someone who can test this driver, so that should be
very helpful.

I hope to work on this next weekend.

Regards,

	Hans

> ---
>  drivers/media/video/cpia2/cpia2_v4l.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
> index 5111bbc..0073a8c 100644
> --- a/drivers/media/video/cpia2/cpia2_v4l.c
> +++ b/drivers/media/video/cpia2/cpia2_v4l.c
> @@ -1313,7 +1313,7 @@ static int cpia2_g_priority(struct file *file, void *_fh, enum v4l2_priority *p)
>  static int cpia2_s_priority(struct file *file, void *_fh, enum v4l2_priority prio)
>  {
>  	struct camera_data *cam = video_drvdata(file);
> -	struct cpia2_fh *fh = fh;
> +	struct cpia2_fh *fh = _fh;
>  
>  	if (cam->streaming && prio != fh->prio &&
>  			fh->prio == V4L2_PRIORITY_RECORD)
> 
