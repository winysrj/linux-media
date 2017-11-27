Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:44061 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbdK0OS7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 09:18:59 -0500
Subject: Re: [PATCH v8 0/5] Synopsys Designware HDMI Video Capture Controller
 + PHY
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1499701281.git.joabreu@synopsys.com>
 <6fb1523a-101f-cfe3-51a0-57463b53eb31@xs4all.nl>
 <4e760e10-a00e-0bcb-0141-845db9ca04c9@xs4all.nl>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <8c5ecd0c-49fc-4daf-0a76-9679aa7b6fc1@synopsys.com>
Date: Mon, 27 Nov 2017 14:18:52 +0000
MIME-Version: 1.0
In-Reply-To: <4e760e10-a00e-0bcb-0141-845db9ca04c9@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 27-11-2017 12:05, Hans Verkuil wrote:
> Hi Jose,
>
> Sakari's work was merged. Can you make a v9? Then we can merge this for 4.16.

Yeah, I saw that. Unfortunately due to my schedule I don't have
the time now to make a v9. I will try to make a new version once
possible but I don't know if it will be ready for v4.16 ( and we
also need to consider review time ).

Best Regards,
Jose Miguel Abreu

>
> Thanks!
>
> 	Hans
>
> On 09/22/2017 02:53 PM, Hans Verkuil wrote:
>> Hi Jose,
>>
>> I'm going to mark this patch series as 'Changes Requested' since it depends on
>> Sakari's subnotifier work. Once that is accepted I assume you'll make a v9 on top
>> and then this can hopefully be merged.
>>
>> Regards,
>>
>> 	Hans
>>
>> On 10/07/17 17:46, Jose Abreu wrote:
>>> The Synopsys Designware HDMI RX controller is an HDMI receiver controller that
>>> is responsible to process digital data that comes from a phy. The final result
>>> is a stream of raw video data that can then be connected to a video DMA, for
>>> example, and transfered into RAM so that it can be displayed.
>>>
>>> The controller + phy available in this series natively support all HDMI 1.4 and
>>> HDMI 2.0 modes, including deep color. Although, the driver is quite in its
>>> initial stage and unfortunatelly only non deep color modes are supported. Also,
>>> audio is not yet supported in the driver (the controller has several audio
>>> output interfaces).
>>>
>>> Version 8 addresses review comments from Rob Herring regarding device tree
>>> bindings.
>>>
>>> I also added one patch for cec.h which is needed to fix build errors/warnings.
>>>
>>> This series depends on the patch at [1].
>>>
>>> This series was tested in a FPGA platform using an embedded platform called
>>> ARC AXS101.
>>>
>>> Jose Abreu (5):
>>>   [media] cec.h: Add stub function for cec_register_cec_notifier()
>>>   dt-bindings: media: Document Synopsys Designware HDMI RX
>>>   MAINTAINERS: Add entry for Synopsys Designware HDMI drivers
>>>   [media] platform: Add Synopsys Designware HDMI RX PHY e405 Driver
>>>   [media] platform: Add Synopsys Designware HDMI RX Controller Driver
>>>
>>> Cc: Carlos Palminha <palminha@synopsys.com>
>>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>> Cc: Rob Herring <robh+dt@kernel.org>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
>>>
>>> [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__patchwork.linuxtv.org_patch_41834_&d=DwIC-g&c=DPL6_X_6JkXFx7AXWqB0tg&r=WHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=tFDR8q-niqA9NmwOe-TrIsUMRsdlCFuhK9BrjgBnrfE&s=LRBhbdZgYuMYDoE4DDs5uwO3BHci_7E4vp77UYn8Duo&e=
>>>
>>>  .../devicetree/bindings/media/snps,dw-hdmi-rx.txt  |   58 +
>>>  MAINTAINERS                                        |    7 +
>>>  drivers/media/platform/Kconfig                     |    2 +
>>>  drivers/media/platform/Makefile                    |    2 +
>>>  drivers/media/platform/dwc/Kconfig                 |   23 +
>>>  drivers/media/platform/dwc/Makefile                |    2 +
>>>  drivers/media/platform/dwc/dw-hdmi-phy-e405.c      |  844 +++++++++
>>>  drivers/media/platform/dwc/dw-hdmi-phy-e405.h      |   63 +
>>>  drivers/media/platform/dwc/dw-hdmi-rx.c            | 1823 ++++++++++++++++++++
>>>  drivers/media/platform/dwc/dw-hdmi-rx.h            |  441 +++++
>>>  include/media/cec.h                                |    8 +
>>>  include/media/dwc/dw-hdmi-phy-pdata.h              |  128 ++
>>>  include/media/dwc/dw-hdmi-rx-pdata.h               |   70 +
>>>  13 files changed, 3471 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
>>>  create mode 100644 drivers/media/platform/dwc/Kconfig
>>>  create mode 100644 drivers/media/platform/dwc/Makefile
>>>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.c
>>>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.h
>>>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
>>>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
>>>  create mode 100644 include/media/dwc/dw-hdmi-phy-pdata.h
>>>  create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h
>>>
