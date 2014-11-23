Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49500 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbaKWVcA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 16:32:00 -0500
Message-ID: <5472524D.5070303@iki.fi>
Date: Sun, 23 Nov 2014 23:31:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] si2157: Add support for Si2146-A10
References: <1416773873-27221-1-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1416773873-27221-1-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/23/2014 10:17 PM, Olli Salonen wrote:
> The Silicon Labs Si2146 tuner seems to work with the same driver as the Si2157, but there a few exceptions. The powerup command seems to be quite a bit different. In addition there's a property 0207 that requires a different value. Thus another entry is created in the si2157_id table to support also si2146 in this driver.
>
> The datasheet is available on manufacturer's website:
> http://www.silabs.com/support%20documents/technicaldocs/Si2146-short.pdf
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


-- 
http://palosaari.fi/
