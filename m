Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42974 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101AbbCPRqO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 13:46:14 -0400
Message-ID: <550716E3.6020007@iki.fi>
Date: Mon, 16 Mar 2015 19:46:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] dw2102: store i2c client for tuner into dw2102_state
References: <1426526046-2063-1-git-send-email-olli.salonen@iki.fi> <1426526046-2063-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1426526046-2063-2-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 07:14 PM, Olli Salonen wrote:
> Prepare the dw2102 driver for tuner drivers that are implemented as I2C drivers (such as
> m88ts2022). The I2C client is stored in to the state and released at disconnect.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti
-- 
http://palosaari.fi/
