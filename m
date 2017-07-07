Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:36408 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750778AbdGGJwm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 05:52:42 -0400
Subject: Re: [PATCH v6 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>,
        kbuild test robot <lkp@intel.com>
References: <201707070407.vA4LTBMK%fengguang.wu@intel.com>
 <30db25dd-3ef1-ea85-ed41-97ee315bd5c7@synopsys.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <03ac0247-ca38-6f33-8a20-36f2d941a35b@xs4all.nl>
Date: Fri, 7 Jul 2017 11:52:30 +0200
MIME-Version: 1.0
In-Reply-To: <30db25dd-3ef1-ea85-ed41-97ee315bd5c7@synopsys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/17 11:34, Jose Abreu wrote:
> On 06-07-2017 21:52, kbuild test robot wrote:
>>    drivers/media//platform/dwc/dw-hdmi-rx.c: In function 'dw_hdmi_registered':
>>>> drivers/media//platform/dwc/dw-hdmi-rx.c:1452:9: error: implicit declaration of function 'v4l2_async_subnotifier_register' [-Werror=implicit-function-declaration]
>>      return v4l2_async_subnotifier_register(&dw_dev->sd,
>>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>    drivers/media//platform/dwc/dw-hdmi-rx.c: In function 'dw_hdmi_unregistered':
>>>> drivers/media//platform/dwc/dw-hdmi-rx.c:1462:2: error: implicit declaration of function 'v4l2_async_subnotifier_unregister' [-Werror=implicit-function-declaration]
>>      v4l2_async_subnotifier_unregister(&dw_dev->v4l2_notifier);
> 
> This one is expected. Required patch was not merged yet.
> 
>>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>    drivers/media//platform/dwc/dw-hdmi-rx.c: In function 'dw_hdmi_parse_dt':
>>    drivers/media//platform/dwc/dw-hdmi-rx.c:1555:22: warning: unused variable 'notifier' [-Wunused-variable]
>>      struct device_node *notifier, *phy_node, *np = dw_dev->of_node;
>>                          ^~~~~~~~
>>    drivers/media//platform/dwc/dw-hdmi-rx.c: In function 'dw_hdmi_rx_probe':
>>    drivers/media//platform/dwc/dw-hdmi-rx.c:1765:1: warning: label 'err_phy' defined but not used [-Wunused-label]
>>     err_phy:
>>     ^~~~~~~
>>    cc1: some warnings being treated as errors
>>
>>
> 
> These two is due to cec not being enabled. I hate to wrap this
> around a #ifdef but is either this or extract cec to a separate
> file, which I don't think is the best solution because the cec
> code is quite small.

The notifier functions can also be used if CEC_NOTIFIER isn't set.
See cec-notifier.h for the stub functions.

That will help somewhat.

Regards,

	Hans
