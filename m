Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.31]:44731 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753012AbeBSQsN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 11:48:13 -0500
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 89222400FFDCE
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 10:48:12 -0600 (CST)
Subject: Re: [PATCH] staging: imx-media-vdic: fix inconsistent IS_ERR and
 PTR_ERR
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20180124004340.GA25212@embeddedgus>
 <5e53d6d8-d336-da37-fe12-0638904e1799@gmail.com>
 <4305212e-5946-0bb3-1624-ec23a0f37708@embeddedor.com>
 <1519050231.3408.21.camel@pengutronix.de>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <3bccf3a8-2dd4-ed59-7a37-1ca30741efcb@embeddedor.com>
Date: Mon, 19 Feb 2018 10:48:09 -0600
MIME-Version: 1.0
In-Reply-To: <1519050231.3408.21.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 02/19/2018 08:23 AM, Philipp Zabel wrote:
> Hi Gustavo,
> 
> On Wed, 2018-02-14 at 14:57 -0600, Gustavo A. R. Silva wrote:
>> Hi all,
>>
>> I was just wondering about the status of this patch.
> 
> It is en route as commit dcd71a9292b1 ("staging: imx-media-vdic: fix
> inconsistent IS_ERR and PTR_ERR") in Hans' for-v4.17a branch:
>    git://linuxtv.org/hverkuil/media_tree.git for-v4.17a
> 

Awesome.

Thanks for the info.
--
Gustavo
