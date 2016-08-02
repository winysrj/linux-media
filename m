Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41120 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795AbcHBJqi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2016 05:46:38 -0400
Subject: Re: [PATCH 0/6] Fix adv7180 and rcar-vin field handling
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <011bd5e7-3da0-4370-10f5-3e37be6a19ba@xs4all.nl>
Date: Tue, 2 Aug 2016 11:43:54 +0200
MIME-Version: 1.0
In-Reply-To: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/29/2016 07:40 PM, Niklas Söderlund wrote:
> Hi,
> 
> This series add V4L2_FIELD_ALTERNATE support to the rcar-vin driver and 
> changes the field mode reported by adv7180 from V4L2_FIELD_INTERLACED to 
> V4L2_FIELD_ALTERNATE.
> 
> The change field mode reported by adv7180 was first done by Steve 
> Longerbeam (https://lkml.org/lkml/2016/7/23/107), I have keept and 
> reworked Steves patch to report V4L2_FIELD_ALTERNATE instead of 
> V4L2_FIELD_SEQ_{TB,BT}, after discussions on #v4l this seems more
> correct.
> 
> The rcar-vin changes contains some bug fixes needed to enable 
> V4L2_FIELD_ALTERNATE.
> 
> All work is based on top of media-next and is tested on Koelsch.
> 
> This series touch two drivers which is not a good thing. But I could not 
> figure out a good way to post them separately since if the adv7180 parts 
> where too be merged before the rcar-vin changes the driver would stop to 
> work on the Koelsch. If some one wants this series split in two let me 
> know.

When you post v2, please also run 'v4l2-compliance -f': this will test all
format/field combinations.

I also recommend testing with qv4l2 if you can to verify that it looks
correct. The qv4l2 utility is guaranteed to handle all field settings
correctly.

Regards,

	Hans

> 
> Niklas Söderlund (5):
>   media: rcar-vin: allow field to be changed
>   media: rcar-vin: fix bug in scaling
>   media: rcar-vin: fix height for TOP and BOTTOM fields
>   media: rcar-vin: add support for V4L2_FIELD_ALTERNATE
>   media: adv7180: fill in mbus format in set_fmt
> 
> Steve Longerbeam (1):
>   media: adv7180: fix field type
> 
>  drivers/media/i2c/adv7180.c                 |  21 ++--
>  drivers/media/platform/rcar-vin/rcar-dma.c  |  26 +++--
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 151 ++++++++++++++++------------
>  3 files changed, 123 insertions(+), 75 deletions(-)
> 
