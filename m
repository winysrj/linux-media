Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34482 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbcHCNa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 09:30:27 -0400
Received: by mail-lf0-f52.google.com with SMTP id l69so161109387lfg.1
        for <linux-media@vger.kernel.org>; Wed, 03 Aug 2016 06:30:26 -0700 (PDT)
Subject: Re: [PATCHv2 5/7] media: rcar-vin: add support for
 V4L2_FIELD_ALTERNATE
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
 <20160802145107.24829-6-niklas.soderlund+renesas@ragnatech.se>
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <0bfd0a3b-a5ac-e9f3-1295-72c7b0063e68@cogentembedded.com>
Date: Wed, 3 Aug 2016 16:22:22 +0300
MIME-Version: 1.0
In-Reply-To: <20160802145107.24829-6-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 08/02/2016 05:51 PM, Niklas Söderlund wrote:

> The HW can capture both ODD and EVEN fields in separate buffers so it's
> possible to support V4L2_FIELD_ALTERNATE. This patch add support for
> this mode.
>
> At probe time and when S_STD is called the driver will default to use
> V4L2_FIELD_INTERLACED if the subdevice reports V4L2_FIELD_ALTERNATE. The
> driver will only change the field type if the subdevice implements
> G_STD, if not it will keep the default at V4L2_FIELD_ALTERNATE.
>
> The user can always explicitly ask for V4L2_FIELD_ALTERNATE in S_FTM and

    S_FMT?

> the driver will use that field format.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
[...]

MBR, Sergei

