Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:41486 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750786AbdJOLOC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 07:14:02 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pierre-Hugues Husson <phh@phh.me>,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] Enable CEC on rk3399
Date: Sun, 15 Oct 2017 13:13:57 +0200
Message-ID: <3386486.DJGKCdk2Sx@phil>
In-Reply-To: <4592c26c-3aab-ba86-7e70-de0cac1e2e71@xs4all.nl>
References: <20171013225337.5196-1-phh@phh.me> <2009704.s5LEIeT6xV@phil> <4592c26c-3aab-ba86-7e70-de0cac1e2e71@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am Sonntag, 15. Oktober 2017, 12:31:29 CEST schrieb Hans Verkuil:
> On 10/14/2017 04:52 PM, Heiko Stuebner wrote:
> > Am Samstag, 14. Oktober 2017, 15:14:40 CEST schrieb Pierre-Hugues Husson:
> >>> Nice! I had a similar dw-hdmi.c patch pending but got around to posting it.
> >>>
> >>> I'll brush off my old rk3288 patches and see if I can get CEC enabled
> >>> for my firefly-reload. I was close to getting it work, but I guess
> >>> missed the "enable cec pin" change.
> >> Please note that on rk3288, there are two CEC pins, and you must write
> >> in RK3288_GRF_SOC_CON8 which pin you're using.
> >> On the firefly-reload, the pin used is GPIO7C0, while the default pin
> >> configuration is GPIO7C7.
> > 
> > And as an additional note, later socs have even more of these pin-routing
> > settings and we currently have infrastructure in the pinctrl driver to do
> > this automatically depending on the pinctrl settings.
> > 
> > So most likely this can also be added there for the rk3288.
> > 
> > 
> > Heiko
> > 
> 
> How does 'GPIO7C0' translate to a 'rockchip,pins' line?
> 
> I have this in rk3288-firefly-reload.dts:
> 
>        hdmi {
>                 hdmi_cec: hdmi-cec {
>                         rockchip,pins = <7 16 RK_FUNC_2 &pcfg_pull_none>;
>                 };
>         };
> 
> I think this is correct. You can find my patches for the firefly reload here:

Yep, looks correct (i.e. we have 8 pins per A,B,C,D bank, so C0 is pin 16)
but as a helping measure we now also have constants, RK_PC7 in your case.

> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=firefly2
> 
> I don't have access to my firefly reload until Friday, so I can't test this
> until then.
> 
> I'd be very grateful though if you can check the last three patches in that
> branch. It's just a test branch, so the subject/changelog of those patches
> are incomplete.

While basically ok, I'd suggest having the cec pin definitions in rk3288.dtsi,
like adding entries "hdmi-cec-c0" and "hdmi-cec-c7" or similar and selecting
the correct one per board, so that we don't need to duplicate them into each
and every board dts.

The cec pin function is after all a function of the soc itself.


> The very last patch adds CEC support for the firefly/firefly beta. I don't
> have that hardware, so I won't be able to test that.

at least in the schematics for the old firefly-rk3288 it specifies gpio7c0
as cec pin, similar to the reload but in your patch you selected gpio7c7?

Especially as gpio7c7 is part of the debug uart, this would be quite strange.


Heiko
