Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:9270 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393Ab0KPWey (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 17:34:54 -0500
Subject: Re: [RFCv2 PATCH 15/15] cx18: convert to unlocked_ioctl.
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <0819999d64a0e2c9b092c60602d32e2d7ab7ad25.1289944160.git.hverkuil@xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
	 <0819999d64a0e2c9b092c60602d32e2d7ab7ad25.1289944160.git.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 17:35:24 -0500
Message-ID: <1289946924.9534.20.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2010-11-16 at 22:56 +0100, Hans Verkuil wrote:
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/cx18/cx18-streams.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
> index 9045f1e..ab461e2 100644
> --- a/drivers/media/video/cx18/cx18-streams.c
> +++ b/drivers/media/video/cx18/cx18-streams.c
> @@ -41,7 +41,7 @@ static struct v4l2_file_operations cx18_v4l2_enc_fops = {
>  	.read = cx18_v4l2_read,
>  	.open = cx18_v4l2_open,
>  	/* FIXME change to video_ioctl2 if serialization lock can be removed */
> -	.ioctl = cx18_v4l2_ioctl,
> +	.unlocked_ioctl = cx18_v4l2_ioctl,
>  	.release = cx18_v4l2_close,
>  	.poll = cx18_v4l2_enc_poll,
>  };

Hans,

Because I haven't done my homework on the ALSA API, could you also add
snd_cx18_lock()/snd_cx18_unlock() in snd_cx18_pcm_ioctl()?

Devin,

Do you know off the top of your head if any other operations in
cx18-alsa-* may need additional locking?

I am an ALSA API callback idiot. :)

Regards,
Andy




