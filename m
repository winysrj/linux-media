Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:29558 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab2AGW7l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 17:59:41 -0500
Message-ID: <4F08CE57.6020600@maxwell.research.nokia.com>
Date: Sun, 08 Jan 2012 00:59:35 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com
Subject: Re: [RFC 17/17] rm680: Add camera init
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-17-git-send-email-sakari.ailus@maxwell.research.nokia.com> <4F070C1D.4060300@gmail.com>
In-Reply-To: <4F070C1D.4060300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the review!

Sylwester Nawrocki wrote:
> On 12/20/2011 09:28 PM, Sakari Ailus wrote:
>> +
>> +static int rm680_sec_camera_set_xshutdown(struct v4l2_subdev *subdev,
>> u8 set)
> 
> It may be more efficient to just use u32.

The function got removed already. ;-)

>> +{
>> +    gpio_set_value(SEC_CAMERA_RESET_GPIO, !!set);
>> +    return 0;
>> +}
>> +
> ...
>> +void __init rm680_camera_init(void)
>> +{
>> +    struct isp_platform_data *pdata;
>> +    int rval;
>> +
>> +    rval = rm680_camera_hw_init();
>> +    if (rval) {
>> +        printk(KERN_WARNING "%s: unable to initialise camera\n",
> 
> pr_warn is preferred for new code.

Fixed.

>> +               __func__);
>> +        return;
>> +    }
>> +
>> +    if (board_is_rm680())
>> +        pdata =&rm680_isp_platform_data;
>> +    else
>> +        pdata =&rm696_isp_platform_data;
>> +
>> +    if (omap3_init_camera(pdata)<  0)
>> +        printk(KERN_WARNING
> 
> pr_warn

Ditto.

>> +               "%s: unable to register camera platform device\n",
>> +               __func__);
>> +}
> ...
>> +static struct regulator_consumer_supply rm680_vaux2_consumers[] = {
>> +    REGULATOR_SUPPLY("VDD_CSIPHY1", "omap3isp"),    /* OMAP ISP */
>> +    REGULATOR_SUPPLY("VDD_CSIPHY2", "omap3isp"),    /* OMAP ISP */
>> +    {
>> +        .supply        = "vaux2",
>> +    },
> 
> Could also be
>     REGULATOR_SUPPLY("vaux2", NULL),

Fixed.

>> +};
>> +REGULATOR_INIT_DATA_FIXED(rm680_vaux2, 1800000);
>> +
>> +static struct regulator_consumer_supply rm680_vaux3_consumers[] = {
>> +    REGULATOR_SUPPLY("VANA", "2-0037"),    /* Main Camera Sensor */
>> +    REGULATOR_SUPPLY("VANA", "2-000e"),    /* Main Camera Lens */
>> +    REGULATOR_SUPPLY("VANA", "2-0010"),    /* Front Camera */
>> +    {
>> +        .supply        = "vaux3",
>> +    },
> 
> and     REGULATOR_SUPPLY("vaux3", NULL),

Ditto.

>> +};
> 
> -- 
> Regards,
> Sylwester
> 


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
