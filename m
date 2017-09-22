Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:39709 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752148AbdIVMxf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 08:53:35 -0400
Subject: Re: [PATCH v8 0/5] Synopsys Designware HDMI Video Capture Controller
 + PHY
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1499701281.git.joabreu@synopsys.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6fb1523a-101f-cfe3-51a0-57463b53eb31@xs4all.nl>
Date: Fri, 22 Sep 2017 14:53:32 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1499701281.git.joabreu@synopsys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jose,

I'm going to mark this patch series as 'Changes Requested' since it depends on
Sakari's subnotifier work. Once that is accepted I assume you'll make a v9 on top
and then this can hopefully be merged.

Regards,

	Hans

On 10/07/17 17:46, Jose Abreu wrote:
> The Synopsys Designware HDMI RX controller is an HDMI receiver controller that
> is responsible to process digital data that comes from a phy. The final result
> is a stream of raw video data that can then be connected to a video DMA, for
> example, and transfered into RAM so that it can be displayed.
> 
> The controller + phy available in this series natively support all HDMI 1.4 and
> HDMI 2.0 modes, including deep color. Although, the driver is quite in its
> initial stage and unfortunatelly only non deep color modes are supported. Also,
> audio is not yet supported in the driver (the controller has several audio
> output interfaces).
> 
> Version 8 addresses review comments from Rob Herring regarding device tree
> bindings.
> 
> I also added one patch for cec.h which is needed to fix build errors/warnings.
> 
> This series depends on the patch at [1].
> 
> This series was tested in a FPGA platform using an embedded platform called
> ARC AXS101.
> 
> Jose Abreu (5):
>   [media] cec.h: Add stub function for cec_register_cec_notifier()
>   dt-bindings: media: Document Synopsys Designware HDMI RX
>   MAINTAINERS: Add entry for Synopsys Designware HDMI drivers
>   [media] platform: Add Synopsys Designware HDMI RX PHY e405 Driver
>   [media] platform: Add Synopsys Designware HDMI RX Controller Driver
> 
> Cc: Carlos Palminha <palminha@synopsys.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
> 
> [1] https://patchwork.linuxtv.org/patch/41834/
> 
>  .../devicetree/bindings/media/snps,dw-hdmi-rx.txt  |   58 +
>  MAINTAINERS                                        |    7 +
>  drivers/media/platform/Kconfig                     |    2 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/dwc/Kconfig                 |   23 +
>  drivers/media/platform/dwc/Makefile                |    2 +
>  drivers/media/platform/dwc/dw-hdmi-phy-e405.c      |  844 +++++++++
>  drivers/media/platform/dwc/dw-hdmi-phy-e405.h      |   63 +
>  drivers/media/platform/dwc/dw-hdmi-rx.c            | 1823 ++++++++++++++++++++
>  drivers/media/platform/dwc/dw-hdmi-rx.h            |  441 +++++
>  include/media/cec.h                                |    8 +
>  include/media/dwc/dw-hdmi-phy-pdata.h              |  128 ++
>  include/media/dwc/dw-hdmi-rx-pdata.h               |   70 +
>  13 files changed, 3471 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
>  create mode 100644 drivers/media/platform/dwc/Kconfig
>  create mode 100644 drivers/media/platform/dwc/Makefile
>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.c
>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.h
>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
>  create mode 100644 include/media/dwc/dw-hdmi-phy-pdata.h
>  create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h
> 
