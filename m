Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34813 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbcG2VEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2016 17:04:38 -0400
Received: by mail-lf0-f41.google.com with SMTP id l69so79237521lfg.1
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2016 14:04:37 -0700 (PDT)
Subject: Re: [PATCH 1/6] media: rcar-vin: allow field to be changed
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
 <20160729174012.14331-2-niklas.soderlund+renesas@ragnatech.se>
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <1f735458-9ff3-f3fc-e349-20ac0b57cde1@cogentembedded.com>
Date: Sat, 30 Jul 2016 00:04:33 +0300
MIME-Version: 1.0
In-Reply-To: <20160729174012.14331-2-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/29/2016 08:40 PM, Niklas Söderlund wrote:

> The driver forced whatever field was set by the source subdevice to be
> used. This patch allows the user to change from the default field.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

    I didn't apply this patch at first (thinking it was unnecessary), and the 
capture worked fine. The field order appeared swapped again after I did import 
this patch as well. :-(

MBR, Sergei

