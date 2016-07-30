Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33489 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbcG3V42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jul 2016 17:56:28 -0400
Received: by mail-lf0-f41.google.com with SMTP id b199so92719107lfe.0
        for <linux-media@vger.kernel.org>; Sat, 30 Jul 2016 14:55:08 -0700 (PDT)
Subject: Re: [PATCH 4/6] media: rcar-vin: add support for V4L2_FIELD_ALTERNATE
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
 <20160729174012.14331-5-niklas.soderlund+renesas@ragnatech.se>
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <028d6a5c-d86f-fce6-4278-12c561ebbe0d@cogentembedded.com>
Date: Sun, 31 Jul 2016 00:55:04 +0300
MIME-Version: 1.0
In-Reply-To: <20160729174012.14331-5-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 07/29/2016 08:40 PM, Niklas Söderlund wrote:

> The HW can capture both ODD and EVEN fields in separate buffers so it's
> possible to support this field mode.
>
> Signed-off-by: Niklas Söderlund <niklas.soder

    It's probably worth adding that if the subdevice presents the video data 
in this mode, we prefer to use the hardware de-interlacing.

MBR, Sergei

PS: I think I have a patch adding support for this mode to the old driver, so 
that it doesn't get borked with the patch #6 in this series.

