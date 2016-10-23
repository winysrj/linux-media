Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:62389 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754033AbcJWMCo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 08:02:44 -0400
Reply-To: <ps00de@yahoo.de>
From: <ps00de@yahoo.de>
To: "'Olli Salonen'" <olli.salonen@iki.fi>,
        "'Andrey Utkin'" <andrey_utkin@fastmail.com>
Cc: <ps00de@yahoo.de>,
        "'Mauro Carvalho Chehab'" <mchehab@s-opensource.com>,
        "'linux-media'" <linux-media@vger.kernel.org>
References: <000901d22a39$9de21e70$d9a65b50$@yahoo.de> <20161019171419.3343cdd5@vento.lan> <009201d22c8a$c93b9580$5bb2c080$@yahoo.de> <20161023100312.GA6792@dell-m4800.home> <CAAZRmGzT_8LUB8-gJPfwMS0m2VME5Frp-FBugbnr-YCsQ+VE=A@mail.gmail.com>
In-Reply-To: <CAAZRmGzT_8LUB8-gJPfwMS0m2VME5Frp-FBugbnr-YCsQ+VE=A@mail.gmail.com>
Subject: AW: em28xx WinTV dualHD in Raspbian
Date: Sun, 23 Oct 2016 14:02:25 +0200
Message-ID: <00c001d22d25$52636050$f72a20f0$@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey and Olli,

sorry, didn't described that, it's written down in the patch (here: https://patchwork.linuxtv.org/patch/33811/).

I never have written drivers before so I think I shouldn't start with it now because I have to ask too many questions... So hopefully olli or someone else can rewrite the driver to support this device. If I can help with anything, just ask.

The dualHD is a great device to insert dvb signals in home environments because it's small and not very expensive. E.g. together with and RPI and SATPI you can put it in a wall-mounted media box if you have such one for your home network.



-----Ursprüngliche Nachricht-----
Von: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] Im Auftrag von Olli Salonen
Gesendet: Sonntag, 23. Oktober 2016 12:14
An: Andrey Utkin
Cc: ps00de@yahoo.de; Mauro Carvalho Chehab; linux-media
Betreff: Re: em28xx WinTV dualHD in Raspbian

Hi Andrey,

When I submitted the original patch to add support for this device I stated that it only supports the first tuner. The em28xx driver is not built with dual-tuner support in mind and I had not enough interest to start changing it (the driver supports like 100 devices and is quite massive). There should not be many issues in using the second tuner itself on this device, it's just another I2C bus...

Cheers,
-olli


On 23 October 2016 at 13:03, Andrey Utkin <andrey_utkin@fastmail.com> wrote:
> On Sat, Oct 22, 2016 at 07:36:13PM +0200, ps00de@yahoo.de wrote:
>> Hopefully some driver expert can get the second tuner working, that 
>> would be awesome
>
> What's the problem? I don't see it described in this discussion thread.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

