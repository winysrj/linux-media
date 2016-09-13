Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:38904 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752067AbcIMCMO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 22:12:14 -0400
Subject: Re: [PATCH 2/2] [media] atmel-isc: mark PM functions as
 __maybe_unused
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20160912153322.3098750-1-arnd@arndb.de>
 <20160912153322.3098750-2-arnd@arndb.de>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
From: "Wu, Songjun" <Songjun.Wu@microchip.com>
Message-ID: <a89552fc-6048-4a43-ed4f-40cf19875b1f@microchip.com>
Date: Tue, 13 Sep 2016 10:11:48 +0800
MIME-Version: 1.0
In-Reply-To: <20160912153322.3098750-2-arnd@arndb.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thank you for your patch.
I think it's better to add switch CONFIG_PM, but the PM feature is a 
must, or the ISC can not work, maybe the best choice is to add 'depends 
on PM' in Kconfig.

#ifdef CONFIG_PM
isc_runtime_suspend
{
	XXX
}

isc_runtime_resume
{
	XXX
}

static const struct dev_pm_ops atmel_isc_dev_pm_ops = {
	SET_RUNTIME_PM_OPS(isc_runtime_suspend, isc_runtime_resume, NULL)
};
#define ATMEL_ISC_PM_OPS	(&atmel_isc_dev_pm_ops)
#else
#define ATMEL_ISC_PM_OPS	NULL
#endif

static struct platform_driver atmel_isc_driver = {
	.probe	= atmel_isc_probe,
	.remove	= atmel_isc_remove,
	.driver	= {
		.name		= ATMEL_ISC_NAME,
		.pm		= ATMEL_ISC_PM_OPS,
		.of_match_table = of_match_ptr(atmel_isc_of_match),
	},
};

On 9/12/2016 23:32, Arnd Bergmann wrote:
> The newly added atmel-isc driver uses SET_RUNTIME_PM_OPS() to
> refer to its suspend/resume functions, causing a warning when
> CONFIG_PM is not set:
>
> media/platform/atmel/atmel-isc.c:1477:12: error: 'isc_runtime_resume' defined but not used [-Werror=unused-function]
> media/platform/atmel/atmel-isc.c:1467:12: error: 'isc_runtime_suspend' defined but not used [-Werror=unused-function]
>
> This adds __maybe_unused annotations to avoid the warning without
> adding an error-prone #ifdef around it.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/atmel/atmel-isc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> index db6773de92f0..a9ab7ae89f04 100644
> --- a/drivers/media/platform/atmel/atmel-isc.c
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -1464,7 +1464,7 @@ static int atmel_isc_remove(struct platform_device *pdev)
>  	return 0;
>  }
>
> -static int isc_runtime_suspend(struct device *dev)
> +static int __maybe_unused isc_runtime_suspend(struct device *dev)
>  {
>  	struct isc_device *isc = dev_get_drvdata(dev);
>
> @@ -1474,7 +1474,7 @@ static int isc_runtime_suspend(struct device *dev)
>  	return 0;
>  }
>
> -static int isc_runtime_resume(struct device *dev)
> +static int __maybe_unused isc_runtime_resume(struct device *dev)
>  {
>  	struct isc_device *isc = dev_get_drvdata(dev);
>  	int ret;
>
