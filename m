Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:45610 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754153AbdLTKYh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 05:24:37 -0500
Received: by mail-qt0-f195.google.com with SMTP id g10so27608982qtj.12
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 02:24:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171220045416.qbge74ntj4s4zlcm@mwanda>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
 <20171219205957.10933-5-andriy.shevchenko@linux.intel.com> <20171220045416.qbge74ntj4s4zlcm@mwanda>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 20 Dec 2017 12:24:36 +0200
Message-ID: <CAHp75VcoYnvwrdVQnMmtPfuiRg0AFOSa5WwfhTk3HP0ww7x5VA@mail.gmail.com>
Subject: Re: [PATCH v1 05/10] staging: atomisp: Remove non-ACPI leftovers
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 20, 2017 at 6:54 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Dec 19, 2017 at 10:59:52PM +0200, Andy Shevchenko wrote:
>> @@ -1147,10 +1145,8 @@ static int gc2235_probe(struct i2c_client *client)
>>       if (ret)
>>               gc2235_remove(client);
>
> This error handling is probably wrong...
>

Thanks for pointing to this, but I'm not going to fix this by the
following reasons:
1. I admit the driver's code is ugly
2. It's staging code
3. My patch does not touch those lines
4. My purpose is to get it working first.

Feel free to send a followup with a good clean up which I agree with.

>>
>> -     if (ACPI_HANDLE(&client->dev))
>> -             ret = atomisp_register_i2c_module(&dev->sd, gcpdev, RAW_CAMERA);
>> +     return atomisp_register_i2c_module(&dev->sd, gcpdev, RAW_CAMERA);
>
> In the end this should look something like:
>
>         ret = atomisp_register_i2c_module(&dev->sd, gcpdev, RAW_CAMERA);
>         if (ret)
>                 goto err_free_something;
>
>         return 0;
>
>>
>> -     return ret;
>>  out_free:
>>       v4l2_device_unregister_subdev(&dev->sd);
>>       kfree(dev);
>
> regards,
> dan carpenter
>



-- 
With Best Regards,
Andy Shevchenko
