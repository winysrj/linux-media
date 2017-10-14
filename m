Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:38042 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753840AbdJNOwg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Oct 2017 10:52:36 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: Pierre-Hugues Husson <phh@phh.me>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] Enable CEC on rk3399
Date: Sat, 14 Oct 2017 16:52:29 +0200
Message-ID: <2009704.s5LEIeT6xV@phil>
In-Reply-To: <CAJ-oXjQ3e1UHVGq=uV=yAK9Bu=ZoiNZaEbnHyvNtyc15RQQSKg@mail.gmail.com>
References: <20171013225337.5196-1-phh@phh.me> <9833f103-769f-b9b9-05c7-4d75bd7e487c@xs4all.nl> <CAJ-oXjQ3e1UHVGq=uV=yAK9Bu=ZoiNZaEbnHyvNtyc15RQQSKg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, 14. Oktober 2017, 15:14:40 CEST schrieb Pierre-Hugues Husson:
> Hi Hans,
> 
> > Nice! I had a similar dw-hdmi.c patch pending but got around to posting it.
> >
> > I'll brush off my old rk3288 patches and see if I can get CEC enabled
> > for my firefly-reload. I was close to getting it work, but I guess
> > missed the "enable cec pin" change.
> Please note that on rk3288, there are two CEC pins, and you must write
> in RK3288_GRF_SOC_CON8 which pin you're using.
> On the firefly-reload, the pin used is GPIO7C0, while the default pin
> configuration is GPIO7C7.

And as an additional note, later socs have even more of these pin-routing
settings and we currently have infrastructure in the pinctrl driver to do
this automatically depending on the pinctrl settings.

So most likely this can also be added there for the rk3288.


Heiko
