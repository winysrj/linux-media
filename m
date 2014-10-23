Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:35463 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbaJWMPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 08:15:03 -0400
Received: by mail-qc0-f170.google.com with SMTP id l6so856362qcy.1
        for <linux-media@vger.kernel.org>; Thu, 23 Oct 2014 05:15:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1414065430.3854.3.camel@pengutronix.de>
References: <1411401956-29330-1-git-send-email-p.zabel@pengutronix.de>
	<CAPDyKFqSgpOCvXp0aVVTFDj5X6fYkigThXM1VKK_vTWrjhpx6A@mail.gmail.com>
	<1414065430.3854.3.camel@pengutronix.de>
Date: Thu, 23 Oct 2014 14:15:02 +0200
Message-ID: <CAPDyKFropocTuz-3rsQU_Ft-eTQAavn+P4ef4d2Qd0kuhSK3WQ@mail.gmail.com>
Subject: Re: [PATCH v2] [media] coda: Improve runtime PM support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	Sascha Hauer <kernel@pengutronix.de>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Kevin Hilman <khilman@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 October 2014 13:57, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Ulf,
>
> Am Montag, den 22.09.2014, 20:44 +0200 schrieb Ulf Hansson:
>> On 22 September 2014 18:05, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>> > From: Ulf Hansson <ulf.hansson@linaro.org>
>> >
>> > For several reasons it's good practice to leave devices in runtime PM
>> > active state while those have been probed.
>> >
>> > In this cases we also want to prevent the device from going inactive,
>> > until the firmware has been completely installed, especially when using
>> > a PM domain.
>> >
>> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>
>> Thanks for moving this to the next version, I have been a bit busy the
>> last week.
>>
>> Changes looking good!
>
> If I load the coda module on v3.18-rc1 with the GPC power domain patch
> applied (at this point the power domain is disabled), the domain's
> poweron callback is never called. It does work tough if I switch back to
> explicitly calling pm_runtime_get_sync:
>
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index ac71e11..5421969 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -2393,9 +2393,8 @@ static int coda_probe(struct platform_device *pdev)
>          * coda_fw_callback regardless of whether CONFIG_PM_RUNTIME is
>          * enabled or whether the device is associated with a PM domain.
>          */
> -       pm_runtime_get_noresume(&pdev->dev);
> -       pm_runtime_set_active(&pdev->dev);
>         pm_runtime_enable(&pdev->dev);
> +       pm_runtime_get_sync(&pdev->dev);
>
>         return coda_firmware_request(dev);
>  }
>
> At what point is the pm domain supposed to be enabled when I load the
> module?

Hi Philipp,

The PM domain shall be powered on prior your driver starts probing.
This is a common problem when using the generic PM domain. The
workaround, which is causing other issues, is a pm_runtime_get_sync().

Now, could you please try to apply the below patchset, that should
hopefully fix your issue:

[PATCH v3 0/9] PM / Domains: Fix race conditions during boot
http://marc.info/?l=linux-pm&m=141320895122707&w=2

Kind regards
Uffe
