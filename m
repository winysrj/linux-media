Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51565 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751657AbcJCVy3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Oct 2016 17:54:29 -0400
Date: Mon, 3 Oct 2016 22:52:11 +0100
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Harman Kalra <harman4linux@gmail.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] : Removing warnings caught by checkpatch.pl
Message-ID: <20161003215211.okrvsky5bgglm75p@acer>
References: <1475355646-6378-1-git-send-email-harman4linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475355646-6378-1-git-send-email-harman4linux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 02, 2016 at 02:30:45AM +0530, Harman Kalra wrote:
>  static int iss_video_queue_setup(struct vb2_queue *vq,
> -				 unsigned int *count, unsigned int *num_planes,
> -				 unsigned int sizes[], struct device *alloc_devs[])
> +			unsigned int *count, unsigned int *num_planes,
> +			unsigned int sizes[], struct device *alloc_devs[])

2 spaces + 3 tabs -> 2 spaces + 2 tabs? Am I seeing this correctly?
Both ways are against CodingStyle.

> -	/* Try the get selection operation first and fallback to get format if not
> -	 * implemented.
> +	/* Try the get selection operation first and
> +	 * fallback to get format if not implemented.
>  	 */

This comment style is discouraged so this is at lease not perfect.
Doesn't checkpatch complain with this change? If it doesn't, could you
please also check with --strict, as long as you're working on style.
