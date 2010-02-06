Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43210 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab0BFF0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 00:26:33 -0500
Received: by bwz19 with SMTP id 19so414948bwz.28
        for <linux-media@vger.kernel.org>; Fri, 05 Feb 2010 21:26:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B6C931D.9020208@redhat.com>
References: <55a3e0ce1002050945k7595d541lb04976344ff91431@mail.gmail.com>
	 <4B6C931D.9020208@redhat.com>
Date: Sat, 6 Feb 2010 00:26:31 -0500
Message-ID: <55a3e0ce1002052126j2f6332bbw490f4d14e2cbbe16@mail.gmail.com>
Subject: Re: [GIT PATCHES FOR 2.6.34] Support for vpfe-capture on DM365
From: Muralidharan Karicheri <mkaricheri@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, khilman@deeprootsystems.com,
	hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,


On Fri, Feb 5, 2010 at 4:52 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Muralidharan Karicheri wrote:
>> Mauro,
>>
>> Please pull from the following:-
>>
>> The following changes since commit 84b74782ace1ae091c1b0e14ae2ee9bb720532ba:
>>   Douglas Schilling Landgraf (1):
>>         V4L/DVB: Fix logic for Leadtek winfast tv usbii deluxe
>>
>> are available in the git repository at:
>>
>>   git://linuxtv.org/mkaricheri/vpfe-vpbe-video.git for_upstream
>>
>> Murali Karicheri (6):
>>       DaVinci - Adding platform & board changes for vpfe capture on DM365
>>       V4L - vpfe capture - header files for ISIF driver
>>       V4L - vpfe capture - source for ISIF driver on DM365
>
> Hmm...
> +static int isif_get_params(void __user *params)
> +{
> +       /* only raw module parameters can be set through the IOCTL */
> +       if (isif_cfg.if_type != VPFE_RAW_BAYER)
> +               return -EINVAL;
> +
> +       if (copy_to_user(params,
> +                       &isif_cfg.bayer.config_params,
> +                       sizeof(isif_cfg.bayer.config_params))) {
>
> +/* Parameter operations */
> +static int isif_set_params(void __user *params)
> +{
> +       struct isif_config_params_raw *isif_raw_params;
> +       int ret = -EINVAL;
> +
> +       /* only raw module parameters can be set through the IOCTL */
> +       if (isif_cfg.if_type != VPFE_RAW_BAYER)
> +               return ret;
> +
> +       isif_raw_params = kzalloc(sizeof(*isif_raw_params), GFP_KERNEL);
> +       if (NULL == isif_raw_params)
> +               return -ENOMEM;
> +
> +       ret = copy_from_user(isif_raw_params,
>
>
> It seems that you're defining some undocumented new userspace API here.
>
Yes. This supports an experimental, but necessary API that configures
the ISIF (Image sensor Interface) image tuning parameters from
User Space. These parameters are used when converting Bayer RGB image
to UYVY format when capturing from sensors such as MT9T031.
For SoCs like TI's DMxxx series, the user needs to have full control
over these parameters to get desired image quality.
This had been discussed during the initial version of vpfe-capture
driver discussion and it was decided to keep them as experimental. So
no
documentation is provided at this time. The ioctls are defined in the
vpfe_capture.h header file and the user space structures are under
ccdc.h and isif.h under include/media/davinci and are marked as
experimental.  This was also discussed  in this mailing list before
and the decision taken at that time was to do it properly as part of
media soc framework. In this framework, isif and other similar SoC
hardware IPs will have a device node to configure these parameters
and therefore will have to be re-worked once media soc framework is
available.  Until then vpfe-capture users need to have a way to
configure the ISIF or such hardware IPs.

Regards,

Murali
> Cheers,
> Mauro
>



-- 
Murali Karicheri
mkaricheri@gmail.com
