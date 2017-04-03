Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0136.outbound.protection.outlook.com ([104.47.2.136]:64472
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751342AbdDCL15 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 07:27:57 -0400
Subject: Re: [PATCH 0/9] Unify i2c_mux_add_adapter error reporting
To: Wolfram Sang <wsa@the-dreams.de>
References: <1491208718-32068-1-git-send-email-peda@axentia.se>
 <20170403102722.GB2750@katana>
CC: <linux-kernel@vger.kernel.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-media@vger.kernel.org>
From: Peter Rosin <peda@axentia.se>
Message-ID: <8022ae03-c8cc-181f-ae16-c9e6584f43b2@axentia.se>
Date: Mon, 3 Apr 2017 13:27:48 +0200
MIME-Version: 1.0
In-Reply-To: <20170403102722.GB2750@katana>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-04-03 12:27, Wolfram Sang wrote:
> On Mon, Apr 03, 2017 at 10:38:29AM +0200, Peter Rosin wrote:
>> Hi!
>>
>> Many users of the i2c_mux_add_adapter interface log a message
>> on failure, but the function already logs such a message. One
>> or two of those users actually add more information than already
>> provided by the central failure message.
>>
>> So, first fix the central error reporting to provide as much
>> information as any current user, and then remove the surplus
>> error reporting at the call sites.
> 
> Yes, I like.
> 
> Reviewed-by: Wolfram Sang <wsa@the-dreams.de>

Thanks!

BTW, the improved error reporting in patch 1/9 is not needed for
patches 8/9 and 9/9 to make sense, the existing central error
message is already good enough. So, iio and media maintainers,
feel free to just grab those two patches. Or, they can go via
Wolfram and the i2c tree with the rest of the series. Either way
is fine with me, just let me know.

Cheers,
peda
