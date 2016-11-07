Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:64605 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751704AbcKGUEH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Nov 2016 15:04:07 -0500
Reply-To: <ps00de@yahoo.de>
From: <ps00de@yahoo.de>
To: "'Christian Steiner'" <christian.steiner@outlook.de>,
        "'Olli Salonen'" <olli.salonen@iki.fi>
Cc: "'Andrey Utkin'" <andrey_utkin@fastmail.com>,
        "'Mauro Carvalho Chehab'" <mchehab@s-opensource.com>,
        "'linux-media'" <linux-media@vger.kernel.org>
References: <000901d22a39$9de21e70$d9a65b50$@yahoo.de> <20161019171419.3343cdd5@vento.lan> <009201d22c8a$c93b9580$5bb2c080$@yahoo.de> <20161023100312.GA6792@dell-m4800.home> <CAAZRmGzT_8LUB8-gJPfwMS0m2VME5Frp-FBugbnr-YCsQ+VE=A@mail.gmail.com> <AM2PR05MB0689253D427DB1D3FA8D22FB91A30@AM2PR05MB0689.eurprd05.prod.outlook.com>
In-Reply-To: <AM2PR05MB0689253D427DB1D3FA8D22FB91A30@AM2PR05MB0689.eurprd05.prod.outlook.com>
Subject: AW: em28xx WinTV dualHD in Raspbian
Date: Mon, 7 Nov 2016 21:02:56 +0100
Message-ID: <008b01d23931$ef7d1b20$ce775160$@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wow, interesting offer from this guy! Hopefully this is a motivation for Olli. Maybe I also can offer beer or sth. else or help to test a new version of the driver.

With single tuner support it works great since june 24/7 (except my last upgrade of the rpi with mismatched modules...)

Cheers,
Patrick

-----Ursprüngliche Nachricht-----
Von: Christian Steiner [mailto:christian.steiner@outlook.de] 
Gesendet: Donnerstag, 3. November 2016 21:46
An: Olli Salonen
Cc: Andrey Utkin; ps00de@yahoo.de; Mauro Carvalho Chehab; linux-media
Betreff: Re: em28xx WinTV dualHD in Raspbian

Hi Olli,

On 23.10.2016 12:14, Olli Salonen wrote:
> When I submitted the original patch to add support for this device I 
> stated that it only supports the first tuner. The em28xx driver is not 
> built with dual-tuner support in mind and I had not enough interest to 
> start changing it (the driver supports like 100 devices and is quite 
> massive).

have you seen http://www.spinics.net/lists/linux-media/msg105939.html?
The guy is offering USD$200 for working dual tuner support of the ATSC version. The ATSC version has different tuners, but maybe it is no big deal. Would that be a little motivation for you? Or what could motivate you? Do you like German beer? ;-)

Dual tuner support would be awesome. The device is perfect for building a low-power VDR client or streaming server using a Raspberry Pi/Banana Pi.

Best,
Christian

