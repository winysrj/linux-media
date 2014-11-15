Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37056 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaKOMeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 07:34:08 -0500
Received: by mail-lb0-f179.google.com with SMTP id l4so13972304lbv.24
        for <linux-media@vger.kernel.org>; Sat, 15 Nov 2014 04:34:04 -0800 (PST)
Date: Sat, 15 Nov 2014 14:33:58 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: Antti Palosaari <crope@iki.fi>
cc: Olli Salonen <olli.salonen@iki.fi>, CrazyCat <crazycat69@narod.ru>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] tuners: si2157: Si2148 support.
In-Reply-To: <546732BA.8010008@iki.fi>
Message-ID: <alpine.DEB.2.10.1411151431070.1385@dl160.lan>
References: <1918522.5V5b9CGsli@computer> <5466A606.8030805@iki.fi> <525911416014537@web7h.yandex.ru> <CAAZRmGw=uLyS+enctwq0To8Gc1dAeG6EZgE+t0v80gBEXg=H5A@mail.gmail.com> <546732BA.8010008@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Nov 2014, Antti Palosaari wrote:

> Assuming you rename possible new firmware:
> dvb-tuner-si2158-a20-01.fw
> dvb-tuner-si2158-a20-02.fw ?
>
> Basically, you would not like to rename firmware when it is updated if it is 
> compatible with the driver. Lets say firmware gets bug fixes, just introduce 
> new firmware with same name. If driver changes are needed, then you have to 
> rename it. These firmware changes are always problematic as you have to think 
> possible regression - it is regression from the user point of view if kernel 
> driver updates but it does not work as firmware incompatibility.

Indeed, I assumed whenever there's a firmware update, we create a new 
filename for that. If that's not the case, then better to keep Si2148 and 
Si2158 totally separate. At this point the files would be identical of 
course.

> How about Si2146 firmware you are working?

No firmware loaded for that.

Cheers,
-olli
