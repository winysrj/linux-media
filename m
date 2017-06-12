Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:51120 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752158AbdFLKEG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 06:04:06 -0400
Subject: Re: [PATCH v5 0/8] Add support for DCMI camera interface of
 STMicroelectronics STM32 SoC series
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
References: <1493998287-5828-1-git-send-email-hugues.fruchet@st.com>
From: Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <f50a3320-a0ef-bdef-d236-f57fd477bccc@st.com>
Date: Mon, 12 Jun 2017 12:03:31 +0200
MIME-Version: 1.0
In-Reply-To: <1493998287-5828-1-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues

On 05/05/2017 05:31 PM, Hugues Fruchet wrote:
> This patchset introduces a basic support for Digital Camera Memory Interface
> (DCMI) of STMicroelectronics STM32 SoC series.
> 
> This first basic support implements RGB565 & YUV frame grabbing.
> Cropping and JPEG support will be added later on.
> 
> This has been tested on STM324x9I-EVAL evaluation board embedding
> an OV2640 camera sensor.
> 
.....
> 
> Hugues Fruchet (8):
>    dt-bindings: Document STM32 DCMI bindings
>    [media] stm32-dcmi: STM32 DCMI camera interface driver
>    ARM: dts: stm32: Enable DCMI support on STM32F429 MCU
>    ARM: dts: stm32: Enable DCMI camera interface on STM32F429-EVAL board
>    ARM: dts: stm32: Enable STMPE1600 gpio expander of STM32F429-EVAL
>      board
>    ARM: dts: stm32: Enable OV2640 camera support of STM32F429-EVAL board
>    ARM: configs: stm32: STMPE1600 GPIO expander
>    ARM: configs: stm32: DCMI + OV2640 camera support
> 
>   .../devicetree/bindings/media/st,stm32-dcmi.txt    |   46 +
>   arch/arm/boot/dts/stm32429i-eval.dts               |   56 +
>   arch/arm/boot/dts/stm32f429.dtsi                   |   37 +
>   arch/arm/configs/stm32_defconfig                   |    9 +
>   drivers/media/platform/Kconfig                     |   12 +
>   drivers/media/platform/Makefile                    |    2 +
>   drivers/media/platform/stm32/Makefile              |    1 +
>   drivers/media/platform/stm32/stm32-dcmi.c          | 1403 ++++++++++++++++++++
>   8 files changed, 1566 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
>   create mode 100644 drivers/media/platform/stm32/Makefile
>   create mode 100644 drivers/media/platform/stm32/stm32-dcmi.c
> 

Patches 3, 4, 5, 6 applied on stm32-dt-for-v4.13

Patch 7 applied on stm32-defconfig-for-v4.13

Patch 8 will not be applied: As SDRAM used on STM32 MCUs is small,
I don't want to penalize other users:
  - by increasing static kernel size
  - by enabling devices which consume dynamically lot of memory

User will be free to enable it through menuconfig.

Regards
Alex
