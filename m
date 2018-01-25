Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.145.239]:34476 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751188AbeAYOAH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 09:00:07 -0500
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 5A720AC66A
        for <linux-media@vger.kernel.org>; Thu, 25 Jan 2018 06:56:14 -0600 (CST)
Date: Thu, 25 Jan 2018 06:56:13 -0600
Message-ID: <20180125065613.Horde.iaJcFihjM6uy53ZmIg91TxT@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: imx-media-vdic: fix inconsistent IS_ERR and
 PTR_ERR
References: <20180124004340.GA25212@embeddedgus>
 <CAK8P3a3-Cx0Az9d6rpVUA4dRtCH7kghS65MOEGp0zd5tyU2FFQ@mail.gmail.com>
In-Reply-To: <CAK8P3a3-Cx0Az9d6rpVUA4dRtCH7kghS65MOEGp0zd5tyU2FFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Quoting Arnd Bergmann <arnd@arndb.de>:

> On Wed, Jan 24, 2018 at 1:43 AM, Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
>> Fix inconsistent IS_ERR and PTR_ERR in vdic_get_ipu_resources.
>> The proper pointer to be passed as argument is ch.
>>
>> This issue was detected with the help of Coccinelle.
>>
>> Fixes: 0b2e9e7947e7 ("media: staging/imx: remove confusing  
>> IS_ERR_OR_NULL usage")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>
> good catch!
>

:)

> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks, Arnd.
--
Gustavo
