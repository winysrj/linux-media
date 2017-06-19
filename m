Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45586 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751090AbdFSJuh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 05:50:37 -0400
Subject: Re: [PATCH] [media] ov2640: make GPIOLIB an optional dependency
To: Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Bhumika Goyal <bhumirks@gmail.com>
References: <a463ea990d2138ca93027b006be96a0324b77fe4.1492602584.git.mchehab@s-opensource.com>
 <20170419132339.GA31747@amd> <20170419110300.2dbbf784@vento.lan>
 <20170421063312.GA21434@amd>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <153c35bf-b6bd-eb97-d72e-bab05e96e267@xs4all.nl>
Date: Mon, 19 Jun 2017 11:50:25 +0200
MIME-Version: 1.0
In-Reply-To: <20170421063312.GA21434@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

I'm dropping this from patchwork since this no longer applies now that ov2640
has been moved out of soc_camera.

If you still want this (it is a reasonable patch), then please respin.

Regards,

	Hans

On 04/21/2017 08:33 AM, Pavel Machek wrote:
> Hi!
> 
>>> Better solution would be for VIDEO_EM28XX_V4L2 to depend on GPIOLIB,
>>> too, no? If not, should there be BUG_ON(priv->pwdn_gpio);
>>> BUG_ON(priv->resetb_gpio);?
>>
>> Pavel,
>>
>> The em28xx driver was added upstream several years the gpio driver.
>> It controls GPIO using a different logic. It makes no sense to make
>> it dependent on GPIOLIB, except if someone converts it to use it.
> 
> At least comment in the sourcecode...? Remove pwdn_gpio fields from
> structure in !GPIOLIB case, because otherwise they are trap for the
> programmer trying to understand what is going on?
> 
> Plus, something like this, because otherwise it is quite confusing?
> 
> Thanks,
> 								Pavel
> 
> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
> index 56de182..85620e1 100644
> --- a/drivers/media/i2c/soc_camera/ov2640.c
> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> @@ -1060,7 +1060,7 @@ static int ov2640_hw_reset(struct device *dev)
>   		/* Active the resetb pin to perform a reset pulse */
>   		gpiod_direction_output(priv->resetb_gpio, 1);
>   		usleep_range(3000, 5000);
> -		gpiod_direction_output(priv->resetb_gpio, 0);
> +		gpiod_set_value(priv->resetb_gpio, 0);
>   	}
>   
>   	return 0;
> 
