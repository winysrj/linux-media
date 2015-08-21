Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47408 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbbHUMGx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 08:06:53 -0400
Message-ID: <55D71432.3040001@xs4all.nl>
Date: Fri, 21 Aug 2015 14:06:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2-compat-ioctl32: fix struct v4l2_event32 alignment
References: <55D70787.2080508@xs4all.nl> <1440158630-29620-1-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1440158630-29620-1-git-send-email-a.hajda@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2015 02:03 PM, Andrzej Hajda wrote:
> Union v4l2_event::u is aligned to 8 bytes on arm32. On arm64 v4l2_event32::u
> is aligned to 4 bytes. As a result structures v4l2_event and v4l2_event32 have
> different sizes and VIDOC_DQEVENT ioctl does not work from arm32 apps running
> on arm64 kernel. The patch fixes it. Using compat_s64 allows to retain 4 bytes
> alignment on x86 architecture.

What about v4l2_standard32 and v4l2_ext_control32? I very strongly suspect that
those will break for arm32 apps on an arm64 as well.

I prefer a patch that fixes all three...

Regards,

	Hans

> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> Hi Hans,
> 
> Tested successfully on arm32 app / arm64 kernel.
> Thanks for help.
> 
> Regards
> Andrzej
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index af63543..52afffe 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -738,6 +738,7 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
>  struct v4l2_event32 {
>  	__u32				type;
>  	union {
> +		compat_s64		value64;
>  		__u8			data[64];
>  	} u;
>  	__u32				pending;
> 

