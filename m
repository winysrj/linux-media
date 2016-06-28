Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50023 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbcF1L75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 07:59:57 -0400
Subject: Re: [GIT PULL FOR v4.8] rcar-vin patches
To: linux-media <linux-media@vger.kernel.org>
References: <577264F9.5040506@xs4all.nl>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <577266B6.2030509@xs4all.nl>
Date: Tue, 28 Jun 2016 13:59:50 +0200
MIME-Version: 1.0
In-Reply-To: <577264F9.5040506@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Try again, this time Cc-ed to Ulrich's correct email address.

Sorry Ulrich,

	Hans

On 06/28/16 13:52, Hans Verkuil wrote:
> Updated these patches.
> 
> Ulrich, sorry, the compile error was my fault: I added these patches in the
> wrong order.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 904aef0f9f6deff94223c0ce93eb598c47dd3aad:
> 
>   [media] v4l2-ctrl.h: fix comments (2016-06-28 08:07:04 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v4.8c
> 
> for you to fetch changes up to e86f5324263ff8a3f1a49dbada27f076c4327005:
> 
>   media: rcar-vin: add DV timings support (2016-06-28 13:50:35 +0200)
> 
> ----------------------------------------------------------------
> Ulrich Hecht (3):
>       media: rcar-vin: pad-aware driver initialisation
>       media: rcar_vin: Use correct pad number in try_fmt
>       media: rcar-vin: add DV timings support
> 
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  drivers/media/platform/rcar-vin/rcar-vin.h  |   2 ++
>  2 files changed, 111 insertions(+), 3 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
