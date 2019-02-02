Return-Path: <SRS0=sYKt=QJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3806CC282D7
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 20:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7DB42082F
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 20:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="U03Jr1F7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfBBU7g (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Feb 2019 15:59:36 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44508 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfBBU7g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Feb 2019 15:59:36 -0500
Received: by mail-qt1-f194.google.com with SMTP id n32so11629547qte.11
        for <linux-media@vger.kernel.org>; Sat, 02 Feb 2019 12:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=R9wonfs41zIRl9APAUdmIaayYuLCASEhOxo+kFzf+vY=;
        b=U03Jr1F7qaa1BIPJuiaFIJGgzUghEWnxxfO3Dlu+zvgtstJcKJkLWF4ajw5PB4TBf9
         taI3dUsnZWfa3x6ZLCgwdwWvTGCSfps70pOaG42CykG4GLTY9kKj1fiQbbQpXW2b4B+p
         9Ch9M/9GFv9b3O0e+iNKELboyYi/tflFPXSQHWx8alF28m4WeOBRAM0ejMyQbLSx5IJU
         KYo5ixJhJJ6klAPfmz/2nsY1AcrgDChMrMSL5e1s0OjoHp+0ySlR4xDMhwJHJDZR5v7u
         HARTcwhCnIsp38lOv8OB/zKBpr6yDgpt1nBPnk5G+fn5PhpknnsBYreqJa6uNPLB6jd8
         yVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=R9wonfs41zIRl9APAUdmIaayYuLCASEhOxo+kFzf+vY=;
        b=uZgvVr0DuePCDvHJNIFrO1CkCYtk1qSOMpprXIoHSfR2WNZxNXb6UHB9nFt72QsBOF
         4HrTFZZKmEuqn0PQJgdabBFIx/aGHgKpt+Cw7dvrLmNGYFM1q57fllQd+I8Qc0i1+CDw
         n8h3bVUdBEw8B+75HcW2gYvMkX8FOX0ApIE+qLydiPYF8fhSaAKfHrSS67SckcnB3T+W
         e8sIrUoT5qzVBpeHvVv7kIU/54hq9ppqJjA74Fi5gUdUkh5aIHnnPaOJqb8qXtNSp19e
         ErSwAPD9WAiDuMOvC/wtLTwCai86ytZdMd83M79lFAFkwdEaFOc8a10YBSfdG0NoR6I9
         DO4w==
X-Gm-Message-State: AJcUukfTD84dVgL4QyF8QS+WhagXdlX8InrEWmGvhvah+dyOfqtSQN77
        6mDNa7n712bU5i7mnMPVFxqzaA==
X-Google-Smtp-Source: ALg8bN6gJiEJgMQWM5zwSFNwLJaCJI4c+CkSd9pHA/UBXkP+sRf0UPpU+sj14gXBHI95FsSuujSn5A==
X-Received: by 2002:aed:27d9:: with SMTP id m25mr43853085qtg.303.1549141174643;
        Sat, 02 Feb 2019 12:59:34 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id r18sm12073167qta.83.2019.02.02.12.59.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 02 Feb 2019 12:59:33 -0800 (PST)
Message-ID: <ea67d53e4acce742f916021c4f2ff918938608fe.camel@ndufresne.ca>
Subject: Re: [PATCH] vb2: clear timestamp if buffer mem is reacquired
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Date:   Sat, 02 Feb 2019 15:59:32 -0500
In-Reply-To: <59fc9777-41f3-5f87-2d84-f9375d8a2895@xs4all.nl>
References: <59fc9777-41f3-5f87-2d84-f9375d8a2895@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le samedi 02 février 2019 à 18:03 +0100, Hans Verkuil a écrit :
> Stateless codecs have to find buffers based on a timestamp (vb2_find_timestamp).
> The timestamp is set to 0 initially, so prohibit finding timestamp 0 since it
> could find unused buffers without associated memory (userptr or dmabuf).
> 
> The memory associated with a buffer will also disappear if the same buffer was
> requeued with a different userptr address or dmabuf fd. Detect this and set the
> timestamp of that buffer to 0 if this happens.

Just a small concern, does it mean 0 is considered an invalid timestamp
? In streaming it would be quite normal for a first picture to have PTS
0.

Nicolas

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> Note: I think it is still necessary to lock a buffer when it is in use as
> a reference frame, otherwise a userspace application can queue it again with
> a different dmabuf fd, which could free the memory of the old dmabuf.
> 
> vb2_find_buffer should probably do that.
> ---
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index e07b6bdb6982..b664d9790330 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1043,6 +1043,8 @@ static int __prepare_userptr(struct vb2_buffer *vb)
>  				reacquired = true;
>  				call_void_vb_qop(vb, buf_cleanup, vb);
>  			}
> +			if (!q->is_output)
> +				vb->timestamp = 0;
>  			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
>  		}
> 
> @@ -1157,6 +1159,8 @@ static int __prepare_dmabuf(struct vb2_buffer *vb)
>  		/* Skip the plane if already verified */
>  		if (dbuf == vb->planes[plane].dbuf &&
>  			vb->planes[plane].length == planes[plane].length) {
> +			if (!q->is_output)
> +				vb->timestamp = 0;
>  			dma_buf_put(dbuf);
>  			continue;
>  		}
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 3aeaea3af42a..8e966fa81b7e 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -603,6 +603,9 @@ int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>  {
>  	unsigned int i;
> 
> +	if (!timestamp)
> +		return -1;
> +
>  	for (i = start_idx; i < q->num_buffers; i++)
>  		if (q->bufs[i]->timestamp == timestamp)
>  			return i;
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> index 8a10889dc2fd..01bf4b2199c7 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -59,14 +59,14 @@ struct vb2_v4l2_buffer {
>   * vb2_find_timestamp() - Find buffer with given timestamp in the queue
>   *
>   * @q:		pointer to &struct vb2_queue with videobuf2 queue.
> - * @timestamp:	the timestamp to find.
> + * @timestamp:	the timestamp to find. Must be > 0.
>   * @start_idx:	the start index (usually 0) in the buffer array to start
>   *		searching from. Note that there may be multiple buffers
>   *		with the same timestamp value, so you can restart the search
>   *		by setting @start_idx to the previously found index + 1.
>   *
>   * Returns the buffer index of the buffer with the given @timestamp, or
> - * -1 if no buffer with @timestamp was found.
> + * -1 if no buffer with @timestamp was found or if @timestamp was 0.
>   */
>  int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>  		       unsigned int start_idx);

