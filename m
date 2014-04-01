Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:42202 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaDANv6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 09:51:58 -0400
Message-ID: <533AC435.8040604@cisco.com>
Date: Tue, 01 Apr 2014 15:50:45 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] v4l2-compliance: fix function pointer prototype
References: <1396359906-6311-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1396359906-6311-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On 04/01/14 15:45, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> There was a conflict between the mmap function pointer prototype of
> struct v4l_fd and the actual function used. Make sure it is in sync
> with the prototype of v4l2_mmap.

The prototype of v4l2_mmap uses int64_t, so I don't understand this
patch.

Regards,

	Hans

> 
> This patch fixes following build error,
> 
> v4l2-compliance.cpp: In function 'void v4l_fd_test_init(v4l_fd*, int)':
> v4l2-compliance.cpp:132: error: invalid conversion from
> 'void* (*)(void*, size_t, int, int, int, int64_t)' to
> 'void* (*)(void*, size_t, int, int, int, off_t)'
> 
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  utils/v4l2-compliance/v4l-helpers.h     |    2 +-
>  utils/v4l2-compliance/v4l2-compliance.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/utils/v4l2-compliance/v4l-helpers.h b/utils/v4l2-compliance/v4l-helpers.h
> index 48ea602..b2ce6c0 100644
> --- a/utils/v4l2-compliance/v4l-helpers.h
> +++ b/utils/v4l2-compliance/v4l-helpers.h
> @@ -10,7 +10,7 @@ struct v4l_fd {
>  	int fd;
>  	int (*ioctl)(int fd, unsigned long cmd, ...);
>  	void *(*mmap)(void *addr, size_t length, int prot, int flags,
> -		      int fd, int64_t offset);
> +		      int fd, off_t offset);
>  	int (*munmap)(void *addr, size_t length);
>  };
>  
> diff --git a/utils/v4l2-compliance/v4l2-compliance.h b/utils/v4l2-compliance/v4l2-compliance.h
> index f2f7072..b6d4dae 100644
> --- a/utils/v4l2-compliance/v4l2-compliance.h
> +++ b/utils/v4l2-compliance/v4l2-compliance.h
> @@ -137,7 +137,7 @@ static inline int test_ioctl(int fd, unsigned long cmd, ...)
>  }
>  
>  static inline void *test_mmap(void *start, size_t length, int prot, int flags,
> -		int fd, int64_t offset)
> +		int fd, off_t offset)
>  {
>   	return wrapper ? v4l2_mmap(start, length, prot, flags, fd, offset) :
>  		mmap(start, length, prot, flags, fd, offset);
> 
