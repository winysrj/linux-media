Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38919 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754259AbdLTEyt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 23:54:49 -0500
Date: Wed, 20 Dec 2017 07:54:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Subject: Re: [PATCH v1 05/10] staging: atomisp: Remove non-ACPI leftovers
Message-ID: <20171220045416.qbge74ntj4s4zlcm@mwanda>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
 <20171219205957.10933-5-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219205957.10933-5-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 19, 2017 at 10:59:52PM +0200, Andy Shevchenko wrote:
> @@ -1147,10 +1145,8 @@ static int gc2235_probe(struct i2c_client *client)
>  	if (ret)
>  		gc2235_remove(client);

This error handling is probably wrong...

>  
> -	if (ACPI_HANDLE(&client->dev))
> -		ret = atomisp_register_i2c_module(&dev->sd, gcpdev, RAW_CAMERA);
> +	return atomisp_register_i2c_module(&dev->sd, gcpdev, RAW_CAMERA);

In the end this should look something like:

	ret = atomisp_register_i2c_module(&dev->sd, gcpdev, RAW_CAMERA);
	if (ret)
		goto err_free_something;

	return 0;

>  
> -	return ret;
>  out_free:
>  	v4l2_device_unregister_subdev(&dev->sd);
>  	kfree(dev);

regards,
dan carpenter
