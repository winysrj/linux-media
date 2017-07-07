Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:51292 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751057AbdGGJeK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 05:34:10 -0400
Subject: Re: [PATCH v6 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: kbuild test robot <lkp@intel.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
References: <201707070407.vA4LTBMK%fengguang.wu@intel.com>
CC: <kbuild-all@01.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <30db25dd-3ef1-ea85-ed41-97ee315bd5c7@synopsys.com>
Date: Fri, 7 Jul 2017 10:34:04 +0100
MIME-Version: 1.0
In-Reply-To: <201707070407.vA4LTBMK%fengguang.wu@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06-07-2017 21:52, kbuild test robot wrote:
>    drivers/media//platform/dwc/dw-hdmi-rx.c: In function 'dw_hdmi_registered':
>>> drivers/media//platform/dwc/dw-hdmi-rx.c:1452:9: error: implicit declaration of function 'v4l2_async_subnotifier_register' [-Werror=implicit-function-declaration]
>      return v4l2_async_subnotifier_register(&dw_dev->sd,
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/media//platform/dwc/dw-hdmi-rx.c: In function 'dw_hdmi_unregistered':
>>> drivers/media//platform/dwc/dw-hdmi-rx.c:1462:2: error: implicit declaration of function 'v4l2_async_subnotifier_unregister' [-Werror=implicit-function-declaration]
>      v4l2_async_subnotifier_unregister(&dw_dev->v4l2_notifier);

This one is expected. Required patch was not merged yet.

>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/media//platform/dwc/dw-hdmi-rx.c: In function 'dw_hdmi_parse_dt':
>    drivers/media//platform/dwc/dw-hdmi-rx.c:1555:22: warning: unused variable 'notifier' [-Wunused-variable]
>      struct device_node *notifier, *phy_node, *np = dw_dev->of_node;
>                          ^~~~~~~~
>    drivers/media//platform/dwc/dw-hdmi-rx.c: In function 'dw_hdmi_rx_probe':
>    drivers/media//platform/dwc/dw-hdmi-rx.c:1765:1: warning: label 'err_phy' defined but not used [-Wunused-label]
>     err_phy:
>     ^~~~~~~
>    cc1: some warnings being treated as errors
>
>

These two is due to cec not being enabled. I hate to wrap this
around a #ifdef but is either this or extract cec to a separate
file, which I don't think is the best solution because the cec
code is quite small.

Best regards,
Jose Miguel Abreu
