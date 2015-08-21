Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:57864 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbbHULMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 07:12:49 -0400
Message-ID: <55D70787.2080508@xs4all.nl>
Date: Fri, 21 Aug 2015 13:12:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] v4l2-compat-ioctl32: fix struct v4l2_event32 alignment
References: <1440150609-23312-1-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1440150609-23312-1-git-send-email-a.hajda@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2015 11:50 AM, Andrzej Hajda wrote:
> Union v4l2_event::u is aligned to 8 bytes on arm32. On arm64 v4l2_event32::u
> is aligned to 4 bytes. As a result structures v4l2_event and v4l2_event32 have
> different sizes and VIDOC_DQEVENT ioctl does not work from arm32 apps running
> on arm64 kernel. The patch fixes it.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> Hi Hans,
> 
> It seems there is problem with VIDIOC_DQEVENT called from arm32 apps on arm64
> kernel. After tracking down the issue it seems v4l2_event32 on arm64 have
> different field alignment/size than v4l2_event on arm32. The patch fixes it.
> But i guess it can break ABI on other architectures. Simple tests shows:
> 
> i386:
> sizeof(struct v4l2_event)=0x78
> offsetof(struct v4l2_event::u)=0x4
> 
> amd64:
> sizeof(struct v4l2_event)=0x88
> offsetof(struct v4l2_event::u)=0x8
> 
> arm:
> sizeof(struct v4l2_event)=0x80
> offsetof(struct v4l2_event::u)=0x8
> 
> arm64:
> sizeof(struct v4l2_event)=0x88
> offsetof(struct v4l2_event::u)=0x8
> 
> Any advices how to fix it in arch compatible way?

I noticed a compat_s64 type that knows about the 4-byte alignment on i386.

So I think this can be solved by declaring v4l2_event32 as follows:

struct v4l2_event32 {
        __u32                           type;
        union {
		compat_s64		value64;
                __u8                    data[64];
        } u;
        __u32                           pending;
        __u32                           sequence;
        struct compat_timespec          timestamp;
        __u32                           id;
        __u32                           reserved[8];
};

I think that this will force the correct alignment. Can you check this?

Good catch BTW.

Looking at v4l2-compat-ioctl32.c I suspect that compat_u/s64 will need to be
used in more places: v4l2_standard32 (replace the id[2] array by compat_u64 id)
and v4l2_ext_control32 are both almost certainly wrong for arm64. I would check
those two.

Regards,

	Hans

> 
> Regards
> Andrzej
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index af63543..a4a1856 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -739,7 +739,7 @@ struct v4l2_event32 {
>  	__u32				type;
>  	union {
>  		__u8			data[64];
> -	} u;
> +	} u __attribute__((aligned(8)));
>  	__u32				pending;
>  	__u32				sequence;
>  	struct compat_timespec		timestamp;
> 

