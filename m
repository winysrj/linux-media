Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CB9C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 10:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90A052087C
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 10:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfBYKiy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 05:38:54 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36360 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726648AbfBYKiy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 05:38:54 -0500
Received: from [IPv6:2001:983:e9a7:1:187c:1a74:db21:99] ([IPv6:2001:983:e9a7:1:187c:1a74:db21:99])
        by smtp-cloud8.xs4all.net with ESMTPA
        id yDetgKjXo4HFnyDeugJtdb; Mon, 25 Feb 2019 11:38:52 +0100
Subject: Re: [v4l-utils PATCH v3 5/8] (c)v4l-helpers.h: Add support for the
 request api
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190224084126.19412-1-dafna3@gmail.com>
 <20190224084126.19412-6-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <abed7258-069a-57e7-9b82-427d1c4ffde5@xs4all.nl>
Date:   Mon, 25 Feb 2019 11:38:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190224084126.19412-6-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGFKRm+SwvDtjjNc04MkSszFN5QLN4YOxYkpAxZRYqTPE/6I1h+8v2NZIDp8nFa4Ubly6F4nOYBd0v9U0G0jf3QwxHKoi+J8udN6TTim18jAc2ZwHrBl
 Qf5Ub/OlohZrP850Cbf8UXDMztbbSMAIfxVln+/fMiY48DSIFISkSJdiy+S0GKhlv0YPpFggRoyIpkGUgQtNV8nwwzq5CJy4XhfX9BPejqY25dp2z37eRHeO
 fPfEelyc1h2V0ZhRnP7eU0vkhi11GnIFY0h/3YQ/vJeinE82RFdzdBXn5Y/zOimQCKXFOywkNXLjLmbqlzPvTtwN0zlY7idaYQh3Ufmc2O0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/24/19 9:41 AM, Dafna Hirschfeld wrote:
> Add an array of request file descriptors to v4l_queue
> and add methods to allocate and get them.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>

This patch isn't right, just drop it altogether. These helpers are for v4l2 devices,
not for a media device.

Just use the media ioctls directly in v4l2-ctl and make the req_fds array a local
array in a function or perhaps a global in v4l2-ctl-streaming.cpp.

Regards,

	Hans

> ---
>  utils/common/cv4l-helpers.h |  5 +++++
>  utils/common/v4l-helpers.h  | 22 ++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/utils/common/cv4l-helpers.h b/utils/common/cv4l-helpers.h
> index 1cd2b6b2..551d4673 100644
> --- a/utils/common/cv4l-helpers.h
> +++ b/utils/common/cv4l-helpers.h
> @@ -745,6 +745,7 @@ public:
>  	unsigned g_capabilities() const { return v4l_queue_g_capabilities(this); }
>  	unsigned g_length(unsigned plane) const { return v4l_queue_g_length(this, plane); }
>  	unsigned g_mem_offset(unsigned index, unsigned plane) const { return v4l_queue_g_mem_offset(this, index, plane); }
> +	unsigned g_req_fd(unsigned index) const { return v4l_queue_g_req_fd(this, index); }
>  	void *g_mmapping(unsigned index, unsigned plane) const { return v4l_queue_g_mmapping(this, index, plane); }
>  	void s_mmapping(unsigned index, unsigned plane, void *m) { v4l_queue_s_mmapping(this, index, plane, m); }
>  	void *g_userptr(unsigned index, unsigned plane) const { return v4l_queue_g_userptr(this, index, plane); }
> @@ -797,6 +798,10 @@ public:
>  	{
>  		return v4l_queue_export_bufs(fd->g_v4l_fd(), this, exp_type);
>  	}
> +	int alloc_req(int media_fd, unsigned index)
> +	{
> +		return v4l_queue_alloc_req(this, media_fd, index);
> +	}
>  	void close_exported_fds()
>  	{
>  		v4l_queue_close_exported_fds(this);
> diff --git a/utils/common/v4l-helpers.h b/utils/common/v4l-helpers.h
> index 59d8566a..daa49a1f 100644
> --- a/utils/common/v4l-helpers.h
> +++ b/utils/common/v4l-helpers.h
> @@ -10,6 +10,7 @@
>  #define _V4L_HELPERS_H_
>  
>  #include <linux/videodev2.h>
> +#include <linux/media.h>
>  #include <string.h>
>  #include <stdlib.h>
>  #include <stdio.h>
> @@ -1414,6 +1415,7 @@ struct v4l_queue {
>  	void *mmappings[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
>  	unsigned long userptrs[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
>  	int fds[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
> +	int req_fds[VIDEO_MAX_FRAME];
>  };
>  
>  static inline void v4l_queue_init(struct v4l_queue *q,
> @@ -1445,6 +1447,11 @@ static inline __u32 v4l_queue_g_mem_offset(const struct v4l_queue *q, unsigned i
>  	return q->mem_offsets[index][plane];
>  }
>  
> +static inline unsigned v4l_queue_g_req_fd(const struct v4l_queue *q, unsigned index)
> +{
> +	return q->req_fds[index];
> +}
> +
>  static inline void v4l_queue_s_mmapping(struct v4l_queue *q, unsigned index, unsigned plane, void *m)
>  {
>  	q->mmappings[index][plane] = m;
> @@ -1701,6 +1708,21 @@ static inline int v4l_queue_export_bufs(struct v4l_fd *f, struct v4l_queue *q,
>  	return 0;
>  }
>  
> +static inline int v4l_queue_alloc_req(struct v4l_queue *q, int media_fd, unsigned index)
> +{
> +	int rc = 0;
> +
> +	rc = ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &q->req_fds[index]);
> +	if (rc < 0) {
> +		fprintf(stderr, "Unable to allocate media request: %s\n",
> +			strerror(errno));
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +
>  static inline void v4l_queue_close_exported_fds(struct v4l_queue *q)
>  {
>  	unsigned b, p;
> 

