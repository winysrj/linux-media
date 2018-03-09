Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:60583 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751086AbeCINOE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 08:14:04 -0500
Subject: Re: [PATCH v5 03/16] media: rkisp1: Add user space ABI definitions
To: Jacob Chen <jacobchen110@gmail.com>
Cc: Shunqian Zheng <zhengsq@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?B?6ZKf5Lul5bSH?= <zyc@rock-chips.com>,
        Eddie Cai <eddie.cai.linux@gmail.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        Allon Huang <allon.huang@rock-chips.com>,
        devicetree@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        robh+dt@kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
References: <1514533978-20408-1-git-send-email-zhengsq@rock-chips.com>
 <1514533978-20408-4-git-send-email-zhengsq@rock-chips.com>
 <d98ac356-a482-f26f-fd6b-6142281d99c3@xs4all.nl>
 <CAFLEztSsg+EW97AN93gd-rx7A1bNwfHK5e9MpLnem40ATnfsrw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d1677c06-4e9f-58a9-817d-0a4b8d958285@xs4all.nl>
Date: Fri, 9 Mar 2018 14:14:00 +0100
MIME-Version: 1.0
In-Reply-To: <CAFLEztSsg+EW97AN93gd-rx7A1bNwfHK5e9MpLnem40ATnfsrw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/18 11:00, Jacob Chen wrote:
> Hi Hans,
> 
> 2018-02-07 20:00 GMT+08:00 Hans Verkuil <hverkuil@xs4all.nl>:
>> On 12/29/17 08:52, Shunqian Zheng wrote:
>>> From: Jeffy Chen <jeffy.chen@rock-chips.com>
>>>
>>> Add the header for userspace
>>
>> General note: I saw four cases where this documentation referred to the
>> datasheet. Three comments on that:
>>
>> 1) You don't say which datasheet.
>> 2) I assume the datasheet is under NDA?
> 
> This datasheet can't be got by customers, even under NDA.

OK. This should be mentioned somewhere.

> 
>> 3) You do need to give enough information so a reasonable default can be
>>    used. I mentioned in an earlier review that creating an initial params
>>    struct that can be used as a templete would be helpful (or even
>>    required), and that would be a good place to put such defaults.
>>
> 
> It don't need a default config
> For applcation writers, they can just init it with zero data, and only
> set value for the part they concerned.

This too should be clearly documented. This is very useful information for
users of this API.

> 
> As for ABI, i have checked there is no mismatches.
> Those structures is 32 bit aligned both in 64bit/32bit env, since
> there is no 64bit value.
> "__attribute__ ((packed))" can avoid mismatches happen when we add a
> 64bit value to those structures.
> 
> As robin said, enums and bools are not guaranteed to be consistent
> between different compiler, so it's a potential risk.
> I have replace bools with unsigned char and enums with unsigned int.

Excellent.

Regards,

	Hans
