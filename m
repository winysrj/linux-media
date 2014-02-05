Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3479 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBEHKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 02:10:46 -0500
Message-ID: <52F1E3DC.30507@xs4all.nl>
Date: Wed, 05 Feb 2014 08:10:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Dean Anderson <linux-dev@sensoray.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] s2255drv: file handle cleanup
References: <1391553393-17672-1-git-send-email-linux-dev@sensoray.com>
In-Reply-To: <1391553393-17672-1-git-send-email-linux-dev@sensoray.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/2014 11:36 PM, Dean Anderson wrote:
> Removes most parameters from s2255_fh.  These elements belong in s2255_ch.
> In the future, s2255_fh will be removed when videobuf2 is used. videobuf2
> has convenient and safe functions for locking streaming resources.
> 
> The removal of s2255_fh (and s2255_fh->resources) was not done now to
> avoid using videobuf_queue_is_busy.
> 
> videobuf_queue_is busy may be unsafe as noted by the following comment 
> in videobuf-core.c:
> "/* Locking: Only usage in bttv unsafe find way to remove */"
> 
> Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
> ---
>  drivers/media/usb/s2255/s2255drv.c |  224 +++++++++++++++++-------------------
>  1 file changed, 105 insertions(+), 119 deletions(-)
> 
> diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
> index 2e24aee..3ea1bd5e 100644
> --- a/drivers/media/usb/s2255/s2255drv.c
> +++ b/drivers/media/usb/s2255/s2255drv.c
> @@ -251,6 +251,8 @@ struct s2255_vc {
>  	unsigned int		height;
>  	const struct s2255_fmt	*fmt;
>  	int idx; /* channel number on device, 0-3 */
> +	struct videobuf_queue	vb_vidq;
> +	enum v4l2_buf_type	type;

The whole type field can be dropped completely. This driver only support the
VIDEO_CAPTURE type anyway.

>  };

Thank you for splitting up the large patch into smaller pieces. I plan to
review them Friday or Monday.

Regards,

	Hans

