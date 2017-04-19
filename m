Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58928
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1762199AbdDSK3s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 06:29:48 -0400
Date: Wed, 19 Apr 2017 07:29:39 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Peter Rosin <peda@axentia.se>
Cc: Wolfram Sang <wsa@the-dreams.de>, <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH 0/9] Unify i2c_mux_add_adapter error reporting
Message-ID: <20170419072939.3724397f@vento.lan>
In-Reply-To: <8022ae03-c8cc-181f-ae16-c9e6584f43b2@axentia.se>
References: <1491208718-32068-1-git-send-email-peda@axentia.se>
        <20170403102722.GB2750@katana>
        <8022ae03-c8cc-181f-ae16-c9e6584f43b2@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 3 Apr 2017 13:27:48 +0200
Peter Rosin <peda@axentia.se> escreveu:

> On 2017-04-03 12:27, Wolfram Sang wrote:
> > On Mon, Apr 03, 2017 at 10:38:29AM +0200, Peter Rosin wrote:  
> >> Hi!
> >>
> >> Many users of the i2c_mux_add_adapter interface log a message
> >> on failure, but the function already logs such a message. One
> >> or two of those users actually add more information than already
> >> provided by the central failure message.
> >>
> >> So, first fix the central error reporting to provide as much
> >> information as any current user, and then remove the surplus
> >> error reporting at the call sites.  
> > 
> > Yes, I like.
> > 
> > Reviewed-by: Wolfram Sang <wsa@the-dreams.de>  
> 
> Thanks!
> 
> BTW, the improved error reporting in patch 1/9 is not needed for
> patches 8/9 and 9/9 to make sense, the existing central error
> message is already good enough. So, iio and media maintainers,
> feel free to just grab those two patches. Or, they can go via
> Wolfram and the i2c tree with the rest of the series. Either way
> is fine with me, just let me know.

Feel free to submit via I2C tree, together with the patch series:

Reviewed-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

> 
> Cheers,
> peda



Thanks,
Mauro
