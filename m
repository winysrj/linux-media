Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:27723 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbeJLKyV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 06:54:21 -0400
Subject: Re: question about V4L2_MEMORY_USERPTR on 64bit applications
To: "Zhang, Ning A" <ning.a.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1539313441.21249.3.camel@intel.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <91f5d31a-d60e-c810-6b0c-23edddef6f1c@linux.intel.com>
Date: Fri, 12 Oct 2018 11:25:56 +0800
MIME-Version: 1.0
In-Reply-To: <1539313441.21249.3.camel@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Ning,

unsigned long   userptr; <<<--- this is a 32bit addr.

I think it's wrong here,for LP64 data modelmachine(unix-like systems), the
actual size ofdata type 'unsigned long'is 8(64bits value)whichis equal
to pointer.
 

On 10/12/2018 11:04 AM, Zhang, Ning A wrote:
> Hi,
>
> I have question about V4L2_MEMORY_USERPTR on 64bit applications.
>
> struct v4l2_buffer {
> 	__u32			index;
> 	__u32			type;
> 	__u32			bytesused;
> 	__u32			flags;
> 	__u32			field;
> 	struct timeval		timestamp;
> 	struct v4l2_timecode	timecode;
> 	__u32			sequence;
>
> 	/* memory location */
> 	__u32			memory;
> 	union {
> 		__u32           offset;
> 		unsigned long   userptr;   <<<--- this is a 32bit addr.
> 		struct v4l2_plane *planes;
> 		__s32		fd;
> 	} m;
> 	__u32			length;
> 	__u32			reserved2;
> 	__u32			reserved;
> };
>
> when use a 64bit application, memory from malloc is 64bit address.
> memory from GPU (eg, intel i915) are also 64bit address.
>
> when use these kind of memory as V4L2_MEMORY_USERPTR, address will be
> truncated into 32bit.
>
> this would be error, but actually not. I really don't understand.
>
> BR.
> Ning.
