Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:56767 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750976AbbFKDre (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 23:47:34 -0400
Message-ID: <557904CC.2090106@atmel.com>
Date: Thu, 11 Jun 2015 11:47:24 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 0/3] media: atmel-isi: rework on the clock part and
 add runtime pm support
References: <1432634087-3356-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1432634087-3356-1-git-send-email-josh.wu@atmel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Any feedback for this patch series?

Best Regards,
Josh Wu

On 5/26/2015 5:54 PM, Josh Wu wrote:
> This patch series fix the peripheral clock code and enable runtime support.
> Also it clean up the code which is for the compatiblity of mck.
>
> Changes in v5:
> - add new patch to fix the condition that codec request still in work.
> - fix the error path in start_streaming() thanks to Laurent.
>
> Changes in v4:
> - need to call pm_runtime_disable() in atmel_isi_remove().
> - merged the patch which remove isi disable code in atmel_isi_probe() as
>    isi peripherial clock is not enabled in this moment.
> - refine the commit log
>
> Changes in v3:
> - remove useless definition: ISI_DEFAULT_MCLK_FREQ
>
> Changes in v2:
> - merged v1 two patch into one.
> - use runtime_pm_put() instead of runtime_pm_put_sync()
> - enable peripheral clock before access ISI registers.
> - totally remove clock_start()/clock_stop() as they are optional.
>
> Josh Wu (3):
>    media: atmel-isi: disable ISI even it has codec request in
>      stop_streaming()
>    media: atmel-isi: add runtime pm support
>    media: atmel-isi: remove mck back compatiable code as it's not need
>
>   drivers/media/platform/soc_camera/atmel-isi.c | 105 ++++++++++++--------------
>   1 file changed, 48 insertions(+), 57 deletions(-)
>

