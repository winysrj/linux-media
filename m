Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:53676 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750722AbdJOKbf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 06:31:35 -0400
Subject: Re: [PATCH 0/3] Enable CEC on rk3399
To: Heiko Stuebner <heiko@sntech.de>, Pierre-Hugues Husson <phh@phh.me>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <20171013225337.5196-1-phh@phh.me>
 <9833f103-769f-b9b9-05c7-4d75bd7e487c@xs4all.nl>
 <CAJ-oXjQ3e1UHVGq=uV=yAK9Bu=ZoiNZaEbnHyvNtyc15RQQSKg@mail.gmail.com>
 <2009704.s5LEIeT6xV@phil>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4592c26c-3aab-ba86-7e70-de0cac1e2e71@xs4all.nl>
Date: Sun, 15 Oct 2017 12:31:29 +0200
MIME-Version: 1.0
In-Reply-To: <2009704.s5LEIeT6xV@phil>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/14/2017 04:52 PM, Heiko Stuebner wrote:
> Am Samstag, 14. Oktober 2017, 15:14:40 CEST schrieb Pierre-Hugues Husson:
>> Hi Hans,
>>
>>> Nice! I had a similar dw-hdmi.c patch pending but got around to posting it.
>>>
>>> I'll brush off my old rk3288 patches and see if I can get CEC enabled
>>> for my firefly-reload. I was close to getting it work, but I guess
>>> missed the "enable cec pin" change.
>> Please note that on rk3288, there are two CEC pins, and you must write
>> in RK3288_GRF_SOC_CON8 which pin you're using.
>> On the firefly-reload, the pin used is GPIO7C0, while the default pin
>> configuration is GPIO7C7.
> 
> And as an additional note, later socs have even more of these pin-routing
> settings and we currently have infrastructure in the pinctrl driver to do
> this automatically depending on the pinctrl settings.
> 
> So most likely this can also be added there for the rk3288.
> 
> 
> Heiko
> 

How does 'GPIO7C0' translate to a 'rockchip,pins' line?

I have this in rk3288-firefly-reload.dts:

       hdmi {
                hdmi_cec: hdmi-cec {
                        rockchip,pins = <7 16 RK_FUNC_2 &pcfg_pull_none>;
                };
        };

I think this is correct. You can find my patches for the firefly reload here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=firefly2

I don't have access to my firefly reload until Friday, so I can't test this
until then.

I'd be very grateful though if you can check the last three patches in that
branch. It's just a test branch, so the subject/changelog of those patches
are incomplete.

The very last patch adds CEC support for the firefly/firefly beta. I don't
have that hardware, so I won't be able to test that.

Regards,

	Hans
