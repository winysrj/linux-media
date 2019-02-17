Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4158CC43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 20:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0051E2173C
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 20:35:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="A84Zjthe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfBQUfb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 15:35:31 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59054 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfBQUfb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 15:35:31 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id E482D49;
        Sun, 17 Feb 2019 21:35:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550435728;
        bh=cyIMm5muhRYPbpfgXFM/OiXGCFiDQUeU2FzEgDi4IIA=;
        h=Reply-To:Subject:To:References:From:Date:In-Reply-To:From;
        b=A84ZjtheH/jm+845/dpMpBLNGEnXUF6v4X4QnAKfGDNXmoa9AmfIQjT9DL8zxZduq
         EPy027EGzuGSznMg+nUvDJG4ojvZ43EBN0GEdVA2pFJdeySrO4Dk07c9Hf9QDe0GaI
         cdZqdj0JvjZg28dTF7/VoX6178O+vkYgj9TA9iEI=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v4 5/7] media: vsp1: Refactor vsp1_video_complete_buffer()
 for later reuse
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190217024852.23328-6-laurent.pinchart+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <7b388ea1-fc35-01b9-64a4-7710068cb5e1@ideasonboard.com>
Date:   Sun, 17 Feb 2019 20:35:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190217024852.23328-6-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent

On 17/02/2019 02:48, Laurent Pinchart wrote:
> The vsp1_video_complete_buffer() function completes the current buffer
> and returns a pointer to the next buffer. Split the code that completes
> the buffer to a separate function for later reuse, and rename
> vsp1_video_complete_buffer() to vsp1_video_complete_next_buffer().
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

This looks good to me - except perhaps the documentation /might/ need
some refresh. With or without updates there, the code changes look good
to me:

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_video.c | 35 ++++++++++++++----------
>  1 file changed, 20 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index 328d686189be..cfbab16c4820 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -300,8 +300,22 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
>   * Pipeline Management
>   */
>  
> +static void vsp1_video_complete_buffer(struct vsp1_video *video,
> +				       struct vsp1_vb2_buffer *buffer)
> +{
> +	struct vsp1_pipeline *pipe = video->rwpf->entity.pipe;
> +	unsigned int i;
> +
> +	buffer->buf.sequence = pipe->sequence;
> +	buffer->buf.vb2_buf.timestamp = ktime_get_ns();
> +	for (i = 0; i < buffer->buf.vb2_buf.num_planes; ++i)
> +		vb2_set_plane_payload(&buffer->buf.vb2_buf, i,
> +				      vb2_plane_size(&buffer->buf.vb2_buf, i));
> +	vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_DONE);
> +}
> +
>  /*
> - * vsp1_video_complete_buffer - Complete the current buffer
> + * vsp1_video_complete_next_buffer - Complete the current buffer

Should the brief be updated?
It looks quite odd to call the function "complete next buffer" but with
a brief saying "complete the current buffer".

Technically it's still correct, but it's more like
"Complete the current buffer and return the next buffer"
or such.


>   * @video: the video node
>   *
>   * This function completes the current buffer by filling its sequence number,

Is this still accurate enough to keep the text as is ?



> @@ -310,13 +324,11 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
>   * Return the next queued buffer or NULL if the queue is empty.
>   */
>  static struct vsp1_vb2_buffer *
> -vsp1_video_complete_buffer(struct vsp1_video *video)
> +vsp1_video_complete_next_buffer(struct vsp1_video *video)
>  {
> -	struct vsp1_pipeline *pipe = video->rwpf->entity.pipe;
> -	struct vsp1_vb2_buffer *next = NULL;
> +	struct vsp1_vb2_buffer *next;
>  	struct vsp1_vb2_buffer *done;
>  	unsigned long flags;
> -	unsigned int i;
>  
>  	spin_lock_irqsave(&video->irqlock, flags);
>  
> @@ -327,21 +339,14 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
>  
>  	done = list_first_entry(&video->irqqueue,
>  				struct vsp1_vb2_buffer, queue);
> -
>  	list_del(&done->queue);
>  
> -	if (!list_empty(&video->irqqueue))
> -		next = list_first_entry(&video->irqqueue,
> +	next = list_first_entry_or_null(&video->irqqueue,

That's a nice way to save a line.


>  					struct vsp1_vb2_buffer, queue);
>  
>  	spin_unlock_irqrestore(&video->irqlock, flags);
>  
> -	done->buf.sequence = pipe->sequence;
> -	done->buf.vb2_buf.timestamp = ktime_get_ns();
> -	for (i = 0; i < done->buf.vb2_buf.num_planes; ++i)
> -		vb2_set_plane_payload(&done->buf.vb2_buf, i,
> -				      vb2_plane_size(&done->buf.vb2_buf, i));
> -	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
> +	vsp1_video_complete_buffer(video, done);
>  
>  	return next;
>  }
> @@ -352,7 +357,7 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
>  	struct vsp1_video *video = rwpf->video;
>  	struct vsp1_vb2_buffer *buf;
>  
> -	buf = vsp1_video_complete_buffer(video);
> +	buf = vsp1_video_complete_next_buffer(video);
>  	if (buf == NULL)
>  		return;
>  
> 

-- 
Regards
--
Kieran
