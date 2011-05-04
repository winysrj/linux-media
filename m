Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44445 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1EDHwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 03:52:10 -0400
Received: by qyg14 with SMTP id 14so599235qyg.19
        for <linux-media@vger.kernel.org>; Wed, 04 May 2011 00:52:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com>
References: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com>
Date: Wed, 4 May 2011 09:52:08 +0200
Message-ID: <BANLkTi=YBKUsYR=0T8uexEVmm11F=PdF6Q@mail.gmail.com>
Subject: Re: Current status report of mt9p031.
From: Bastian Hecht <hechtb@googlemail.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Javier,

2011/5/4 javier Martin <javier.martin@vista-silicon.com>:
> Hi,
> for those interested on mt9p031 working on the Beagleboard xM. I
> attach 2 patches here that must be applied to kernel-2.6.39-rc commit
> e8dad69408a9812d6bb42d03e74d2c314534a4fa
> These patches include a fix for the USB ethernet.
>
> What currently works:
> - Test suggested by Guennadi
> (http://download.open-technology.de/BeagleBoard_xM-MT9P031/).
>
> Known problems:
> 1. You might be required to create device node for the sensor manually:
>
> mknod /dev/v4l-subdev8 c 81 15
> chown root:video /dev/v4l-subdev8
>
> 2. Images captured seem to be too dull and dark. Values of pixels seem
> always to low, it seems to me like MSB of each pixel were stuck at 0.
> I hope someone can help here.

I once had a similar problem and found out that I had configured the
shifter in the device-setup wrong. So 2 bits were shifted out and I
had a dark image.

best regards,

 Bastian Hecht

> Thank you.
>
> --
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com
>
