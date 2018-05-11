Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:38258 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbeEKPTi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 11:19:38 -0400
Received: by mail-lf0-f65.google.com with SMTP id z142-v6so8464309lff.5
        for <linux-media@vger.kernel.org>; Fri, 11 May 2018 08:19:38 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] rcar-vin: fix crop and compose handling for Gen3
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180511144126.24804-1-niklas.soderlund+renesas@ragnatech.se>
 <20180511144126.24804-3-niklas.soderlund+renesas@ragnatech.se>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <2fdeeccf-3418-3a1d-0be2-95e999974f19@cogentembedded.com>
Date: Fri, 11 May 2018 18:19:35 +0300
MIME-Version: 1.0
In-Reply-To: <20180511144126.24804-3-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 05/11/2018 05:41 PM, Niklas Söderlund wrote:

> When refactoring the Gen3 enablement series crop and compose handling
> where broken. This went unnoticed but can result in writing out side the

   s/Where/Were/?

> capture buffer. Fix this by restoring the crop and compose to reflect
> the format dimensions as we have not yet enabled the scaler for Gen3.
> 
> Fixes: 5e7c623632fcf8f5 ("media: rcar-vin: use different v4l2 operations in media controller mode")
> Reported-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
[...]

MBR, Sergei
