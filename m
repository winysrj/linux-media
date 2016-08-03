Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33774 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbcHCRR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 13:17:28 -0400
Received: by mail-lf0-f53.google.com with SMTP id b199so166190126lfe.0
        for <linux-media@vger.kernel.org>; Wed, 03 Aug 2016 10:17:27 -0700 (PDT)
Subject: Re: [PATCHv2 4/7] media: rcar-vin: fix height for TOP and BOTTOM
 fields
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
 <20160802145107.24829-5-niklas.soderlund+renesas@ragnatech.se>
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <b343cd90-05db-a6d5-2e4d-ba345e18bde9@cogentembedded.com>
Date: Wed, 3 Aug 2016 19:54:11 +0300
MIME-Version: 1.0
In-Reply-To: <20160802145107.24829-5-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2016 05:51 PM, Niklas Söderlund wrote:

> The height used for V4L2_FIELD_TOP and V4L2_FIELD_BOTTOM where wrong.
> The frames only contain one filed so the height should be half of the

    s/filed/field/.

> frame.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
[...]

MBR, Sergei

