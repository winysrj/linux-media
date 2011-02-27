Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47011 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1B0Tk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 14:40:27 -0500
Received: by iyb26 with SMTP id 26so2322654iyb.19
        for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 11:40:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20110224T142616-389@post.gmane.org>
References: <AANLkTincndvx154DXHgeNCnxe+KhtaH+tFUTfqXufFdp@mail.gmail.com>
	<AANLkTikVTgo48gfSUc9DyOhTCwSOuGS0gnjP6xTomor-@mail.gmail.com>
	<loom.20110224T142616-389@post.gmane.org>
Date: Sun, 27 Feb 2011 20:40:26 +0100
Message-ID: <AANLkTikFk73n87XHbfVVT37mDBd-3jMSBg1j=SKQJr8_@mail.gmail.com>
Subject: Re: omap3-isp: can't register subdev for new sensor driver mt9t001
From: Bastian Hecht <hechtb@googlemail.com>
To: =?ISO-8859-1?Q?Lo=EFc_Akue?= <akue.loic@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

fail or success in registering these subdevs depend on the sensor code
probe() function (at least I think so).
When the isp already mentions your driver name saa7113 check your
saa7113 driver code and see what can fail in the probe function and
add some debug output. Probably the i2c communication doesn't work,
but I do not know the code.

good luck,

 Bastian




2011/2/24 Loïc Akue <akue.loic@gmail.com>:
>
> Hello Bastian,
>
> As a newbie in kernel development, I'm facing the same issue about subdev
> registration.
> I'm trying to capture some raw video from a SAA7113 connected to the ISP of an
> omap3530. May I please have your help with this problem?
>
> root@cm-t35:~# modprobe iommu
> [ 8409.776123] omap-iommu omap-iommu.0: isp registered
>
> root@cm-t35:~# modprobe omap3_isp
> [ 8451.821533] omap3isp omap3isp: Revision 2.0 found
> [ 8451.827056] omap-iommu omap-iommu.0: isp: version 1.1
> [ 8453.291992] isp_register_subdev_group: Unable to register subdev saa7113
>
> Regards
>
> Loïc Akue
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
