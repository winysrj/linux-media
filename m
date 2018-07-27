Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:38760 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729445AbeG0JUa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 05:20:30 -0400
Subject: Re: [PATCH 0/2] adv7180: fix format and frame interval
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: linux-renesas-soc@vger.kernel.org
References: <20180717123041.2862-1-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b32a1dfe-62ad-9f43-35fd-299d42a4c862@xs4all.nl>
Date: Fri, 27 Jul 2018 09:59:45 +0200
MIME-Version: 1.0
In-Reply-To: <20180717123041.2862-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 17/07/18 14:30, Niklas Söderlund wrote:
> Hi,
> 
> These first patch fix a issue which was discussed back in 2016 that the 
> field format of the adv7180 should be V4L2_FIELD_ALTERNATE. While the 
> second patch adds support for the g_frame_interval video op.
> 
> Work is loosely based on work by Steve Longerbeam posted in 2016. I have 
> talked to Steven and he have agreed to me taking over the patches as he 
> did not intend to continue his work on the original series.
> 
> The series is based on the latest media-tree and tested on Renesas 
> Koelsch board.
> 
> Niklas Söderlund (2):
>   adv7180: fix field type to V4L2_FIELD_ALTERNATE
>   adv7180: add g_frame_interval support
> 
>  drivers/media/i2c/adv7180.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
> 

I've accepted these patches, but I was wondering if the code correctly
initializes the format? It sets the field in probe(), but where does it
set the initial format?

Should it implement the init_cfg op to initialize the pad configs?

Regards,

	Hans
