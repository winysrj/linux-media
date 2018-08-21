Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:38419 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbeHULwc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 07:52:32 -0400
Subject: Re: [PATCH 0/6] vicodec improvements
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
References: <20180821073119.3662-1-hverkuil@xs4all.nl>
Message-ID: <238019e3-589c-2a61-9e17-db3fd4dddb74@xs4all.nl>
Date: Tue, 21 Aug 2018 10:33:15 +0200
MIME-Version: 1.0
In-Reply-To: <20180821073119.3662-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just ignore this series, I need to make some more improvements
so there will be a v2 later.

Regards,

	Hans

On 08/21/18 09:31, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> - add support for quantization parameters
> - support many more pixel formats
> - code simplifications
> - rename source and use proper prefixes for the codec: this makes it
>   independent from the vicodec driver and easier to reuse in userspace
>   (similar to what we do for the v4l2-tpg code).
> 
> Hans Verkuil (6):
>   vicodec: add QP controls
>   vicodec: add support for more pixel formats
>   vicodec: simplify flags handling
>   vicodec: simplify blocktype checking
>   vicodec: improve handling of uncompressable planes
>   vicodec: rename and use proper fwht prefix for codec
> 
>  drivers/media/platform/vicodec/Makefile       |   2 +-
>  .../vicodec/{vicodec-codec.c => codec-fwht.c} | 148 ++++--
>  .../vicodec/{vicodec-codec.h => codec-fwht.h} |  76 ++-
>  drivers/media/platform/vicodec/vicodec-core.c | 482 +++++++++++++-----
>  4 files changed, 488 insertions(+), 220 deletions(-)
>  rename drivers/media/platform/vicodec/{vicodec-codec.c => codec-fwht.c} (85%)
>  rename drivers/media/platform/vicodec/{vicodec-codec.h => codec-fwht.h} (67%)
> 
