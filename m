Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:45402 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730984AbeITSN1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 14:13:27 -0400
Subject: Re: [V2, 1/5] media: platform: Add a DesignWare folder to have
 Synopsys drivers
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
 <20180920111648.27000-2-lolivei@synopsys.com> <5939502.lGiqCuzIrn@avalon>
From: Luis Oliveira <Luis.Oliveira@synopsys.com>
Message-ID: <2e28c0fd-d9d9-c78a-3163-536e97a17c9b@synopsys.com>
Date: Thu, 20 Sep 2018 13:30:05 +0100
MIME-Version: 1.0
In-Reply-To: <5939502.lGiqCuzIrn@avalon>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20-Sep-18 13:26, Laurent Pinchart wrote:
> Hi Luis,
> 
> Thank you for the patch.
> 
> 
> On Thursday, 20 September 2018 14:16:39 EEST Luis Oliveira wrote:
>> This patch has the intention of make the patch series more clear by creating
>> a dwc folder.
>>
>> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
> 
> No issue with the content, but you should fold this in patch 3/5, it doesn't 
> deserve a patch on its own.
> 

Thank you, I will do that in V3.

>> ---
>> Changelog
>> v2:
>> - Fix Kbuild error with no Makefile present
>>
>>  drivers/media/platform/Kconfig      | 1 +
>>  drivers/media/platform/Makefile     | 3 +++
>>  drivers/media/platform/dwc/Kconfig  | 0
>>  drivers/media/platform/dwc/Makefile | 0
>>  4 files changed, 4 insertions(+)
>>  create mode 100644 drivers/media/platform/dwc/Kconfig
>>  create mode 100644 drivers/media/platform/dwc/Makefile
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index f627587..f627a27 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -137,6 +137,7 @@ source "drivers/media/platform/am437x/Kconfig"
>>  source "drivers/media/platform/xilinx/Kconfig"
>>  source "drivers/media/platform/rcar-vin/Kconfig"
>>  source "drivers/media/platform/atmel/Kconfig"
>> +source "drivers/media/platform/dwc/Kconfig"
>>
>>  config VIDEO_TI_CAL
>>  	tristate "TI CAL (Camera Adaptation Layer) driver"
>> diff --git a/drivers/media/platform/Makefile
>> b/drivers/media/platform/Makefile index 6ab6200..def2f33 100644
>> --- a/drivers/media/platform/Makefile
>> +++ b/drivers/media/platform/Makefile
>> @@ -98,3 +98,6 @@ obj-$(CONFIG_VIDEO_QCOM_VENUS)		+= qcom/venus/
>>  obj-y					+= meson/
>>
>>  obj-y					+= cros-ec-cec/
>> +
>> +obj-y					+= dwc/
>> +
>> diff --git a/drivers/media/platform/dwc/Kconfig
>> b/drivers/media/platform/dwc/Kconfig new file mode 100644
>> index 0000000..e69de29
>> diff --git a/drivers/media/platform/dwc/Makefile
>> b/drivers/media/platform/dwc/Makefile new file mode 100644
>> index 0000000..e69de29
> 
