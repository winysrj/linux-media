Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53366 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304Ab1JBMLc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Oct 2011 08:11:32 -0400
Subject: Re: [RFCv4 PATCH 2/6] ivtv: only start streaming in poll() if
 polling for input.
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Date: Sun, 02 Oct 2011 08:13:11 -0400
In-Reply-To: <32566dbc40ed36da1ef324afd8a09813c1bc080c.1317281827.git.hans.verkuil@cisco.com>
References: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
	 <32566dbc40ed36da1ef324afd8a09813c1bc080c.1317281827.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1317557592.2328.0.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-09-29 at 09:44 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

FWIW:

Acked-by: Andy Walls <awalls@md.metrocast.net>

-Andy


> ---
>  drivers/media/video/ivtv/ivtv-fileops.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
> index 38f0522..a931ecf 100644
> --- a/drivers/media/video/ivtv/ivtv-fileops.c
> +++ b/drivers/media/video/ivtv/ivtv-fileops.c
> @@ -744,8 +744,9 @@ unsigned int ivtv_v4l2_dec_poll(struct file *filp, poll_table *wait)
>  	return res;
>  }
>  
> -unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
> +unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table *wait)
>  {
> +	unsigned long req_events = poll_requested_events(wait);
>  	struct ivtv_open_id *id = fh2id(filp->private_data);
>  	struct ivtv *itv = id->itv;
>  	struct ivtv_stream *s = &itv->streams[id->type];
> @@ -753,7 +754,8 @@ unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
>  	unsigned res = 0;
>  
>  	/* Start a capture if there is none */
> -	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags)) {
> +	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags) &&
> +			(req_events & (POLLIN | POLLRDNORM))) {
>  		int rc;
>  
>  		mutex_lock(&itv->serialize_lock);


