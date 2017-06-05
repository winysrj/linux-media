Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.38]:40882 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751112AbdFEPw6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Jun 2017 11:52:58 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 8D0B36384EF
        for <linux-media@vger.kernel.org>; Mon,  5 Jun 2017 10:52:55 -0500 (CDT)
Date: Mon, 05 Jun 2017 10:52:55 -0500
Message-ID: <20170605105255.Horde.KZhhW9eKbZWevMwnFwN0QUW@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: platform: s3c-camif: fix arguments position in
 function call
References: <CGME20170602034354epcas1p1bfea44bea994a5cbd8095a8f4da09cd0@epcas1p1.samsung.com>
 <20170602034341.GA5349@embeddedgus>
 <593b0303-7273-758c-cb6e-c6f97f66a4b9@samsung.com>
In-Reply-To: <593b0303-7273-758c-cb6e-c6f97f66a4b9@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Quoting Sylwester Nawrocki <s.nawrocki@samsung.com>:

> On 06/02/2017 05:43 AM, Gustavo A. R. Silva wrote:
>> Hi Sylwester,
>>
>> Here is another patch in case you decide that it is
>> better to apply this one.
>
> Thanks, I applied this patch.  In future please put any comments only after
> the scissors ("---") line, the comments can be then discarded automatically
> and there will be no need for manually editing the patch before applying.
>

OK, I will do that.

> --
> Regards,
> Sylwester
>
>> Fix the position of the arguments in function call.
>>
>> Addresses-Coverity-ID: 1248800
>> Addresses-Coverity-ID: 1269141
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>> ---
> ^^^^^
>

I got it.

Thank you
--
Gustavo A. R. Silva
