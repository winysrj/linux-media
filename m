Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:44128 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388909AbeIUVQy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 17:16:54 -0400
Subject: Re: [V2, 0/5] platform: dwc: Add of DesignWare MIPI CSI-2 Host
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Luis Oliveira <Luis.Oliveira@synopsys.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Joao.Pinto@synopsys.com>, <festevam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>
References: <20180920111648.27000-1-lolivei@synopsys.com>
 <20180921143708.tw62sci3il5ydmlq@flea>
From: Luis Oliveira <Luis.Oliveira@synopsys.com>
Message-ID: <efe3aeb4-af2a-a010-e8aa-12097e8816a0@synopsys.com>
Date: Fri, 21 Sep 2018 16:27:23 +0100
MIME-Version: 1.0
In-Reply-To: <20180921143708.tw62sci3il5ydmlq@flea>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21-Sep-18 15:37, Maxime Ripard wrote:
> Hi Luis,
> 
> On Thu, Sep 20, 2018 at 01:16:38PM +0200, Luis Oliveira wrote:
>> This adds support for Synopsys MIPI CSI-2 Host and MIPI D-PHY.
>> The patch series include support for initialization/configuration of the
>> DW MIPI CSI-2 controller and DW MIPI D-PHY and both include a reference
>> platform driver.
>>
>> This will enable future SoCs to use this standard approach and possibly
>> create a more clean environment.
>>
>> This series also documents the dt-bindings needed for the platform drivers.
>>
>> This was applied in: https://git.linuxtv.org/media_tree.git
> 
> I'm currently working on some MIPI D-PHY support through the generic
> phy framework that could benefit your patches.
> 
> https://lwn.net/Articles/764173/
> 
> Feel free to comment on that serie if you have any particular
> constraints or if you believe that some issues should be addressed.

Hi Maxime,

I will check that, thanks!

> 
> Thanks!
> Maxime
> 
