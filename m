Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57306 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353AbbIOQ2k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 12:28:40 -0400
Message-ID: <55F846E7.2040006@xs4all.nl>
Date: Tue, 15 Sep 2015 18:27:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 6/7] [RFC] [media]: v4l2: introduce v4l2_timeval
References: <1442332148-488079-1-git-send-email-arnd@arndb.de> <1442332148-488079-7-git-send-email-arnd@arndb.de>
In-Reply-To: <1442332148-488079-7-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/15/2015 05:49 PM, Arnd Bergmann wrote:
> The v4l2 API uses a 'struct timeval' to communicate time stamps to user
> space. This is broken on 32-bit architectures as soon as we have a C library
> that defines time_t as 64 bit, which then changes the structure layout of
> struct v4l2_buffer.
> 
> Fortunately, almost all v4l2 drivers use monotonic timestamps and call
> v4l2_get_timestamp(), which means they don't also have a y2038 problem.
> This means we can keep using the existing binary layout of the structure
> and do not need to worry about defining a new kernel interface for
> userland with 64-bit time_t.
> 
> A possible downside of this approach is that it breaks any user space
> that tries to assign the timeval structure returned from the kernel
> to another timeval, or to pass a pointer to it into a function that
> expects a timeval. Those will cause a build-time warning or error
> that can be fixed up in a backwards compatible way.
> 
> The alternative to this patch is to leave the structure using
> 'struct timeval', but then we have to rework the kernel to let
> it handle both 32-bit and 64-bit time_t for 32-bit user space
> processes.

Cool. Only this morning I was thinking about what would be needed in v4l2
to be y2038 safe, and here it is!

> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 3228fbebcd63..b02cf054fbb8 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -803,6 +803,12 @@ struct v4l2_plane {
>  	__u32			reserved[11];
>  };
>  
> +/* used for monotonic times, therefore y2038 safe */
> +struct v4l2_timeval {
> +	long tv_sec;
> +	long tv_usec;
> +};
> +
>  /**
>   * struct v4l2_buffer - video buffer info
>   * @index:	id number of the buffer
> @@ -839,7 +845,7 @@ struct v4l2_buffer {
>  	__u32			bytesused;
>  	__u32			flags;
>  	__u32			field;
> -	struct timeval		timestamp;
> +	struct v4l2_timeval	timestamp;
>  	struct v4l2_timecode	timecode;
>  	__u32			sequence;
>  
> 

I suspect that quite a few apps use assign the timestamp to another timeval
struct. A quick grep in v4l-utils (which we maintain) shows at least two of
those assignments. Ditto for xawtv3.

So I don't think v4l2_timeval is an option as it would break userspace too badly.

An alternative to supporting a 64-bit timeval for 32-bit userspace is to make a
new y2038-aware struct and a new set of ioctls and use this opportunity to clean
up and extend the v4l2_buffer struct.

So any 32-bit app that needs to be y2038 compliant would just use the new
struct and ioctls.

But this is something to discuss among the v4l2 developers.

Regards,

	Hans
