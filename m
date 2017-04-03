Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0115.outbound.protection.outlook.com ([104.47.2.115]:53376
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751757AbdDCLNt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 07:13:49 -0400
Subject: Re: [PATCH 9/9] [media] cx231xx: stop double error reporting
To: Wolfram Sang <wsa@the-dreams.de>
References: <1491208718-32068-1-git-send-email-peda@axentia.se>
 <1491208718-32068-10-git-send-email-peda@axentia.se>
 <20170403102646.GA2750@katana>
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
Message-ID: <82a2980a-732e-54f0-22f3-3d54bf99ef37@axentia.se>
Date: Mon, 3 Apr 2017 13:13:41 +0200
MIME-Version: 1.0
In-Reply-To: <20170403102646.GA2750@katana>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-04-03 12:26, Wolfram Sang wrote:
> On Mon, Apr 03, 2017 at 10:38:38AM +0200, Peter Rosin wrote:
>> i2c_mux_add_adapter already logs a message on failure.
>>
>> Signed-off-by: Peter Rosin <peda@axentia.se>
>> ---
>>  drivers/media/usb/cx231xx/cx231xx-i2c.c | 15 ++++-----------
>>  1 file changed, 4 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
>> index 35e9acfe63d3..dff514e147da 100644
>> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
>> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
>> @@ -576,17 +576,10 @@ int cx231xx_i2c_mux_create(struct cx231xx *dev)
>>  
>>  int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
>>  {
>> -	int rc;
>> -
>> -	rc = i2c_mux_add_adapter(dev->muxc,
>> -				 0,
>> -				 mux_no /* chan_id */,
>> -				 0 /* class */);
>> -	if (rc)
>> -		dev_warn(dev->dev,
>> -			 "i2c mux %d register FAILED\n", mux_no);
>> -
>> -	return rc;
>> +	return i2c_mux_add_adapter(dev->muxc,
>> +				   0,
>> +				   mux_no /* chan_id */,
>> +				   0 /* class */);
> 
> Could be argued that the whole function is obsolete now and the
> c231xx-core can call i2c_mux_add_adapter() directly. But maybe this is a
> seperate patch.

Agreed on all counts. BTW, the ..._unregister function below is equally
"obsolete". I'm going to leave the removal of both functions at the
discretion of whomever takes care of cx231xx maintenance...

Cheers,
peda

>>  }
>>  
>>  void cx231xx_i2c_mux_unregister(struct cx231xx *dev)
>> -- 
>> 2.1.4
>>
