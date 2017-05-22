Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:59242 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757672AbdEVJl6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 05:41:58 -0400
Subject: Re: [RFC 0/2] Synopsys Designware HDMI Video Capture Controller + PHY
To: <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <cover.1492767176.git.joabreu@synopsys.com>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-kernel@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <9d391e15-7912-426a-eb4e-343d9a65f54f@synopsys.com>
Date: Mon, 22 May 2017 10:41:53 +0100
MIME-Version: 1.0
In-Reply-To: <cover.1492767176.git.joabreu@synopsys.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 21-04-2017 10:53, Jose Abreu wrote:
> Hi All,
>
> This is a RFC series that is intended to collect comments regarding the
> Synopsys Designware HDMI RX controller and Synopsys Designware HDMI RX e405 PHY
> drivers.
>
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
> Feel free to take a look at this series and please leave a comment! I can
> expand a little bit more about design decisions and would like to know wether
> these were the best choices.
>
> With best regards,
> Jose Miguel Abreu
>
> Jose Abreu (2):
>   [media] platform: Add Synopsys Designware HDMI RX PHY e405 Driver
>   [media] platform: Add Synopsys Designware HDMI RX Controller Driver
>
> Cc: Carlos Palminha <palminha@synopsys.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-media@vger.kernel.org
>
>  drivers/media/platform/Kconfig                |    2 +
>  drivers/media/platform/Makefile               |    2 +
>  drivers/media/platform/dwc/Kconfig            |   17 +
>  drivers/media/platform/dwc/Makefile           |    2 +
>  drivers/media/platform/dwc/dw-hdmi-phy-e405.c |  879 ++++++++++++++++
>  drivers/media/platform/dwc/dw-hdmi-phy-e405.h |   63 ++
>  drivers/media/platform/dwc/dw-hdmi-rx.c       | 1396 +++++++++++++++++++++++++
>  drivers/media/platform/dwc/dw-hdmi-rx.h       |  313 ++++++
>  include/media/dwc/dw-hdmi-phy-pdata.h         |   64 ++
>  include/media/dwc/dw-hdmi-rx-pdata.h          |   50 +
>  10 files changed, 2788 insertions(+)
>  create mode 100644 drivers/media/platform/dwc/Kconfig
>  create mode 100644 drivers/media/platform/dwc/Makefile
>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.c
>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.h
>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
>  create mode 100644 include/media/dwc/dw-hdmi-phy-pdata.h
>  create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h
>

Sorry for pinging but could you review this rfc series? This is
not for the controller I mentioned a while ago, its for a
different one which I had a few free time to make a driver.
Though, the behavior and phy interface is similar, and the phy
driver used is the same also.

Best regards,
Jose Miguel Abreu
