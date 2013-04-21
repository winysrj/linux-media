Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:58331 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3DUKXa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 06:23:30 -0400
Received: by mail-lb0-f179.google.com with SMTP id t1so4874659lbd.38
        for <linux-media@vger.kernel.org>; Sun, 21 Apr 2013 03:23:28 -0700 (PDT)
Message-ID: <5173BE0B.8090001@cogentembedded.com>
Date: Sun, 21 Apr 2013 14:23:07 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org, matsu@igel.co.jp
Subject: Re: [PATCH 1/5] V4L2: I2C: ML86V7667 video decoder driver
References: <201304210013.46110.sergei.shtylyov@cogentembedded.com> <201304210016.33720.sergei.shtylyov@cogentembedded.com> <51730324.8090403@gmail.com>
In-Reply-To: <51730324.8090403@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thank you for the review.

Sylwester Nawrocki wrote
>
>> +static struct v4l2_subdev_video_ops ml86v7667_subdev_video_ops = {
>> +    .querystd = ml86v7667_querystd,
>> +    .g_input_status = ml86v7667_g_input_status,
>> +    .enum_mbus_fmt = ml86v7667_enum_mbus_fmt,
>> +    .try_mbus_fmt = ml86v7667_try_mbus_fmt,
>> +    .g_mbus_fmt = ml86v7667_g_mbus_fmt,
>> +    .s_mbus_fmt = ml86v7667_s_mbus_fmt,
>> +    .cropcap = ml86v7667_cropcap,
>> +    .g_mbus_config = ml86v7667_g_mbus_config,
>> +};
>
> Why do you need .cropcap when there is no s_crop/g_crop ops ? Is it
> only for pixel aspect ratio ?
Yes it is.
>
> Also, new drivers are supposed to use the selections API instead
> (set/get_selection ops). However this requires pad level ops support
> in your host driver, hence might be a bigger issue.
Yes, since the host driver (rcar_vin is already send for review) is 
designed for soc-camera layer that does not use the pad level ops but 
needs at least cropcap to get the pixel aspect ratio.
The soc-camera has it's own set/get_selection in soc_camera_host_ops and 
it is possible to use it like all i2c/soc_camera sensors can/do.
But we would not like to design the ml86v7667 as soc-camera device since 
it will not be available for all non soc-camera v4l2 hosts.

Regards,
Vladimir
