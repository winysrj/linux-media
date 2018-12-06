Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30314C65BAF
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 15:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECB892082B
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 15:08:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECB892082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbeLFPII (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 10:08:08 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:34386 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbeLFPII (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 10:08:08 -0500
Received: from [IPv6:2001:420:44c1:2579:8806:8651:4d22:9eb3] ([IPv6:2001:420:44c1:2579:8806:8651:4d22:9eb3])
        by smtp-cloud8.xs4all.net with ESMTPA
        id UvFygasdoO44XUvG1gVKX3; Thu, 06 Dec 2018 16:08:06 +0100
Subject: Invite for IRC meeting: Re: [PATCHv4 01/10] videodev2.h: add tag
 support
To:     Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
 <20181205102040.11741-2-hverkuil-cisco@xs4all.nl>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <dee778ea-89d5-ddaf-c5d9-6423b7dee005@xs4all.nl>
Date:   Thu, 6 Dec 2018 16:08:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181205102040.11741-2-hverkuil-cisco@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJ8E9Vk10fXQS6PEEEfdhBj6/PLHYWAvVR2ua0gWwRifIedTA2XZPwhsPxA+JEJcZ33l5ruH9fVrCh2BZ/xs0+XwtvUBmvkZfMndNYi8xwR2F2IX+/zN
 G7TFGrRCEBGKuBFQTK93w0yTSlMJwqkARt8W6gRlArSVdmEC4Yqu/AlOtZj7ttkPYDd3jSP9he1FlMLHv4DuKdUj+g15f6r/yHOHjy1k2hvMv9K0TIEjwcXn
 BSoZj8JCzo3kTHy7G+/qsJW8CVmgqSsRT1+HQ7IiD+88F15X/d8EBUK8oG50IRFi1sy8cn+3PyepBvr0nDHizt9/VKuGQg9lJk4WGINndIQVAVsURuqAy/cd
 qCdgxZlFr+gVHnNMPji3YwqAvBpf6JtLWoHBaMMjy0sdsPqHysSPPd23+704SxcC/uQ9D87hDkKsotcCJ/JnrJ6bY43RJIP6w1IAL7r733RJC45ggJ9VkQid
 1pCek3jiaZT0TBMvz7Wp0BH9UYC9jGWHpVU+7UInUuQc9hzTRIIDTCoXtR6+5fvoxGT3SDmetNYQRwLN
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Mauro raised a number of objections on irc regarding tags:

https://linuxtv.org/irc/irclogger_log/media-maint?date=2018-12-06,Thu

I would like to setup an irc meeting to discuss this and come to a
conclusion, since we need to decide this soon since this is critical
for stateless codec support.

Unfortunately timezone-wise this is a bit of a nightmare. I think
that at least Mauro, myself and Tomasz Figa should be there, so UTC-2,
UTC+1 and UTC+9 (if I got that right).

I propose 9 AM UTC which I think will work for everyone except Nicolas.
Any day next week works for me, and (for now) as well for Mauro. Let's pick
Monday to start with, and if you want to join in, then let me know. If that
day doesn't work for you, let me know what other days next week do work for
you.

Regards,

	Hans

On 12/05/18 11:20, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Add support for 'tags' to struct v4l2_buffer. These can be used
> by m2m devices so userspace can set a tag for an output buffer and
> this value will then be copied to the capture buffer(s).
> 
> This tag can be used to refer to capture buffers, something that
> is needed by stateless HW codecs.
> 
> The new V4L2_BUF_CAP_SUPPORTS_TAGS capability indicates whether
> or not tags are supported.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  include/uapi/linux/videodev2.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 2db1635de956..9095d7abe10d 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -881,6 +881,7 @@ struct v4l2_requestbuffers {
>  #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
>  #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
>  #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
> +#define V4L2_BUF_CAP_SUPPORTS_TAGS	(1 << 5)
>  
>  /**
>   * struct v4l2_plane - plane info for multi-planar buffers
> @@ -940,6 +941,7 @@ struct v4l2_plane {
>   * @length:	size in bytes of the buffer (NOT its payload) for single-plane
>   *		buffers (when type != *_MPLANE); number of elements in the
>   *		planes array for multi-plane buffers
> + * @tag:	buffer tag
>   * @request_fd: fd of the request that this buffer should use
>   *
>   * Contains data exchanged by application and driver using one of the Streaming
> @@ -964,7 +966,10 @@ struct v4l2_buffer {
>  		__s32		fd;
>  	} m;
>  	__u32			length;
> -	__u32			reserved2;
> +	union {
> +		__u32		reserved2;
> +		__u32		tag;
> +	};
>  	union {
>  		__s32		request_fd;
>  		__u32		reserved;
> @@ -990,6 +995,8 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_IN_REQUEST		0x00000080
>  /* timecode field is valid */
>  #define V4L2_BUF_FLAG_TIMECODE			0x00000100
> +/* tag field is valid */
> +#define V4L2_BUF_FLAG_TAG			0x00000200
>  /* Buffer is prepared for queuing */
>  #define V4L2_BUF_FLAG_PREPARED			0x00000400
>  /* Cache handling flags */
> 

