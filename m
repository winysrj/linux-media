Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.184.48]:16833 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750832AbdEDUi1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 16:38:27 -0400
Received: from cm6.websitewelcome.com (cm6.websitewelcome.com [108.167.139.19])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 6B7FD1A204
        for <linux-media@vger.kernel.org>; Thu,  4 May 2017 14:50:06 -0500 (CDT)
Date: Thu, 04 May 2017 14:50:04 -0500
Message-ID: <20170504145004.Horde.gvFfFeEbpRydR4Pody_ABxy@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [media-s3c-camif] question about arguments position
References: <20170504140502.Horde.e_TqvS0_CEqTDsNh1soDOGo@gator4166.hostgator.com>
 <e2137221-f094-530b-e61c-70e28f22a83f@gmail.com>
In-Reply-To: <e2137221-f094-530b-e61c-70e28f22a83f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sylwester,

Quoting Sylwester Nawrocki <sylvester.nawrocki@gmail.com>:

> Hi Gustavo,
>
> On 05/04/2017 09:05 PM, Gustavo A. R. Silva wrote:
>> The issue here is that the position of arguments in the call to
>> camif_hw_set_effect() function do not match the order of the parameters:
>>
>> camif->colorfx_cb is passed to cr
>> camif->colorfx_cr is passed to cb
>>
>> This is the function prototype:
>>
>> void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
>>             unsigned int cr, unsigned int cb)
>>
>> My question here is if this is intentional?
>>
>> In case it is not, I will send a patch to fix it. But first it would be
>> great to hear any comment about it.
>
> You are right, it seems you have found a real bug. Feel free to send a patch.
> The best thing to do now might be to change the function prototype to:
>
> void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
>              unsigned int cb, unsigned int cr)
>

OK, I'll send a patch for this shortly.

Thanks for clarifying.
--
Gustavo A. R. Silva
