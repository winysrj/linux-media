Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:35579 "EHLO
        www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754067AbcHSOlx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 10:41:53 -0400
Subject: Re: [PATCH v4 1/8] media: adv7180: fix field type
To: Steve Longerbeam <slongerbeam@gmail.com>
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
 <1470247430-11168-2-git-send-email-steve_longerbeam@mentor.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <fdd525c7-be79-0ab0-f6eb-4c71bec1dc85@metafoo.de>
Date: Fri, 19 Aug 2016 16:40:17 +0200
MIME-Version: 1.0
In-Reply-To: <1470247430-11168-2-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2016 08:03 PM, Steve Longerbeam wrote:
> From: Steve Longerbeam <slongerbeam@gmail.com>
> 
> The ADV7180 and ADV7182 transmit whole fields, bottom field followed
> by top (or vice-versa, depending on detected video standard). So
> for chips that do not have support for explicitly setting the field
> mode via I2P, set the field mode to V4L2_FIELD_ALTERNATE.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.
