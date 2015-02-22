Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:48269 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbbBVUEI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 15:04:08 -0500
Message-ID: <54EA3633.3030805@southpole.se>
Date: Sun, 22 Feb 2015 21:04:03 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Gilles Risch <gilles.risch@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
CC: Olli Salonen <olli.salonen@iki.fi>
Subject: Re: Linux TV support Elgato EyeTV hybrid
References: <CALnjqVkteEsFGQXRdh3exzGrqdC=Qw4guSGRT_pCF50WjGqy1g@mail.gmail.com> <CAAZRmGwmNhczjXNXdKkotS0YZ8Tc+kKb4b+SyNN_8KVj2H8xuQ@mail.gmail.com> <54E9DDFE.4010507@gmail.com>
In-Reply-To: <54E9DDFE.4010507@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/22/2015 02:47 PM, Gilles Risch wrote:
> Hi,
>
> most of the used components are identified:
> - USB Controller: Empia EM2884
> - Stereo A/V Decoder: Micronas AVF 49x0B
> - Hybrid Channel Decoder: Micronas DRX-K DRX3926K:A3 0.9.0
> The only ambiguity is the tuner, but I think it could be a Xceive XC5000

This sounds like the Hauppauge WinTV HVR-930C:

http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-930C

> because the windows driver comprises the xc5000 firmware and it is 100%
> identical:
>      $ mkdir extract-xc5000-fw
>      $ cd extract-xc5000-fw
>      $ wget http://linuxtv.org/downloads/firmware/dvb-fe-xc5000-1.6.114.fw
>      $ wget
> http://elgatoweb.s3.amazonaws.com/Documents/Support/EyeTV_Hybrid/EyeTV_Hybrid_2008_509081301_W8.exe
>
>      $ 7z -y e EyeTV_Hybrid_2008_509081301_W8.exe
>      $ dd if=emBDA.sys of=dvb-fe-xc5000-test.fw bs=1 skip=518800
> count=12401 >/dev/null 2>&1
>      $ md5sum dvb-fe-xc5000-1.6.114.fw dvb-fe-xc5000-test.fw
>      b1ac8f759020523ebaaeff3fdf4789ed  dvb-fe-xc5000-1.6.114.fw
>      b1ac8f759020523ebaaeff3fdf4789ed  dvb-fe-xc5000-test.fw
>
> The Elgato_EyeTV_Hybrid.inf file contains a comment with "TerraTec H5",
> which components are assembled on that USB stick?

The TerraTec H5 has a TDA18271 tuner.

>
>
> Regards,
> Gilles


So most likely the Elgato EyeTV hybrid is one of these combinations. And 
it should quite feasible to add support for someone who knows the Empia 
EM2884.

MvH
Benjamin Larsson
