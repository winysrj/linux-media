Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34037 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbeHAIjO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 04:39:14 -0400
Subject: Re: [PATCH v6 0/4] IR support for A83T
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        wens@csie.org, linux@armlinux.org.uk, sean@mess.org,
        p.zabel@pengutronix.de, andi.shyti@samsung.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
References: <20180731092258.2279-1-embed3d@gmail.com>
 <20180731123452.74jyxc4q3ewig35z@flea>
From: Philipp Rossak <embed3d@gmail.com>
Message-ID: <92b74230-285e-74c3-c89a-e194a8eabc52@gmail.com>
Date: Wed, 1 Aug 2018 08:55:00 +0200
MIME-Version: 1.0
In-Reply-To: <20180731123452.74jyxc4q3ewig35z@flea>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks,
I will fix this today.

Philipp

On 31.07.2018 14:34, Maxime Ripard wrote:
> On Tue, Jul 31, 2018 at 11:22:54AM +0200, Philipp Rossak wrote:
>> This patch series adds support for the sunxi A83T ir module and enhances
>> the sunxi-ir driver. Right now the base clock frequency for the ir driver
>> is a hard coded define and is set to 8 MHz.
>> This works for the most common ir receivers. On the Sinovoip Bananapi M3
>> the ir receiver needs, a 3 MHz base clock frequency to work without
>> problems with this driver.
>>
>> This patch series adds support for an optinal property that makes it able
>> to override the default base clock frequency and enables the ir interface
>> on the a83t and the Bananapi M3.
> 
> Once the minor comment on patch 2 has been fixed,
> Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
> 
> Maxime
> 
