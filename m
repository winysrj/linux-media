Return-path: <linux-media-owner@vger.kernel.org>
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58135 "EHLO
        saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdDCTmH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 15:42:07 -0400
Subject: Re: [PATCH 8/9] iio: gyro: mpu3050: stop double error reporting
To: Linus Walleij <linus.walleij@linaro.org>,
        Peter Rosin <peda@axentia.se>
References: <1491208718-32068-1-git-send-email-peda@axentia.se>
 <1491208718-32068-9-git-send-email-peda@axentia.se>
 <CACRpkdZMx4EEXqXzT435mE=yHkgCnFbtU0e__C0WD47L2cmjPw@mail.gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Jonathan Cameron <jic23@kernel.org>
Message-ID: <3b2a98a3-e908-06d7-5c61-9c739f1b7970@kernel.org>
Date: Mon, 3 Apr 2017 20:42:03 +0100
MIME-Version: 1.0
In-Reply-To: <CACRpkdZMx4EEXqXzT435mE=yHkgCnFbtU0e__C0WD47L2cmjPw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/04/17 18:56, Linus Walleij wrote:
> On Mon, Apr 3, 2017 at 10:38 AM, Peter Rosin <peda@axentia.se> wrote:
> 
>> i2c_mux_add_adapter already logs a message on failure.
>>
>> Signed-off-by: Peter Rosin <peda@axentia.se>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Applied to the togreg branch of iio.git.

Can't see any reason not to split this set up and apply through
the various trees so I've picked this one up.

Good little series.  We should do more of these in general!

Jonathan
> 
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
