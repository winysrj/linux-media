Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39824 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbaJWL5R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 07:57:17 -0400
Message-ID: <1414065430.3854.3.camel@pengutronix.de>
Subject: Re: [PATCH v2] [media] coda: Improve runtime PM support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	Sascha Hauer <kernel@pengutronix.de>
Date: Thu, 23 Oct 2014 13:57:10 +0200
In-Reply-To: <CAPDyKFqSgpOCvXp0aVVTFDj5X6fYkigThXM1VKK_vTWrjhpx6A@mail.gmail.com>
References: <1411401956-29330-1-git-send-email-p.zabel@pengutronix.de>
	 <CAPDyKFqSgpOCvXp0aVVTFDj5X6fYkigThXM1VKK_vTWrjhpx6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulf,

Am Montag, den 22.09.2014, 20:44 +0200 schrieb Ulf Hansson:
> On 22 September 2014 18:05, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > From: Ulf Hansson <ulf.hansson@linaro.org>
> >
> > For several reasons it's good practice to leave devices in runtime PM
> > active state while those have been probed.
> >
> > In this cases we also want to prevent the device from going inactive,
> > until the firmware has been completely installed, especially when using
> > a PM domain.
> >
> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Thanks for moving this to the next version, I have been a bit busy the
> last week.
> 
> Changes looking good!

If I load the coda module on v3.18-rc1 with the GPC power domain patch
applied (at this point the power domain is disabled), the domain's
poweron callback is never called. It does work tough if I switch back to
explicitly calling pm_runtime_get_sync:

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index ac71e11..5421969 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2393,9 +2393,8 @@ static int coda_probe(struct platform_device *pdev)
         * coda_fw_callback regardless of whether CONFIG_PM_RUNTIME is
         * enabled or whether the device is associated with a PM domain.
         */
-       pm_runtime_get_noresume(&pdev->dev);
-       pm_runtime_set_active(&pdev->dev);
        pm_runtime_enable(&pdev->dev);
+       pm_runtime_get_sync(&pdev->dev);

        return coda_firmware_request(dev);
 }

At what point is the pm domain supposed to be enabled when I load the
module?

regards
Philipp

