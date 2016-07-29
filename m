Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34710 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbcG2TKx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2016 15:10:53 -0400
Received: by mail-lf0-f41.google.com with SMTP id l69so77574978lfg.1
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2016 12:10:52 -0700 (PDT)
Subject: Re: [PATCH 6/6] media: adv7180: fix field type
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
 <20160729174012.14331-7-niklas.soderlund+renesas@ragnatech.se>
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com,
	Steve Longerbeam <steve_longerbeam@mentor.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <cc084571-3063-a883-b731-0ffe01c4fefa@cogentembedded.com>
Date: Fri, 29 Jul 2016 22:10:48 +0300
MIME-Version: 1.0
In-Reply-To: <20160729174012.14331-7-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/29/2016 08:40 PM, Niklas Söderlund wrote:

> From: Steve Longerbeam <slongerbeam@gmail.com>
>
> The ADV7180 and ADV7182 transmit whole fields, bottom field followed
> by top (or vice-versa, depending on detected video standard). So
> for chips that do not have support for explicitly setting the field
> mode, set the field mode to V4L2_FIELD_ALTERNATE.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> [Niklas: changed filed type from V4L2_FIELD_SEQ_{TB,BT} to
> V4L2_FIELD_ALTERNATE]
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Tested-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

    IIUC, it's a 4th version of this patch; you should have kept the original 
change log (below --- tearline) and indicated that in the subject.

MBR, Sergei

