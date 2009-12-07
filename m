Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:33390 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935309AbZLGXrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 18:47:43 -0500
Received: by gxk26 with SMTP id 26so4644045gxk.1
        for <linux-media@vger.kernel.org>; Mon, 07 Dec 2009 15:47:50 -0800 (PST)
To: "Karicheri\, Muralidharan" <m-karicheri2@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Hiremath\, Vaibhav" <hvaibhav@ti.com>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source\@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: architecture part of video driver patch
References: <A69FA2915331DC488A831521EAE36FE40155B7686A@dlee06.ent.ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Mon, 07 Dec 2009 15:47:46 -0800
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155B7686A@dlee06.ent.ti.com> (Muralidharan Karicheri's message of "Tue\, 1 Dec 2009 09\:42\:12 -0600")
Message-ID: <87638i73dp.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:

> Kevin,
>
> Following patch merged to v4l-dvb linux-next has an architectural 
> part as attached. If you have not merged it to your next branch
> for linux-davinci tree, please do so at your earliest convenience
> so that they are in sync.

OK, applying to davinci git, and queuing for 2.6.34.

> Patch merged to linux-next is available at
>
> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commitdiff;h=600cc66f7f3ec93ab4f09cf6b63980f4c5e8f8db
>
> I will be pushing some more patches to upstream that are having
> changes to arch part. I will notify once they are merged to linux-next.

OK, thanks,

Kevin

> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> phone: 301-407-9583
> email: m-karicheri2@ti.com
>
> From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
> Subject: [PATCH 3/6] Davinci VPFE Capture: Take i2c adapter id through platform data
> To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
> CC: "davinci-linux-open-source@linux.davincidsp.com" <davinci-linux-open-source@linux.davincidsp.com>
> Date: Tue, 13 Oct 2009 10:08:54 -0500
>
> From: Vaibhav Hiremath <hvaibhav@ti.com>
>
> The I2C adapter ID is actually depends on Board and may vary, Davinci
> uses id=1, but in case of AM3517 id=3.
>
> So modified respective davinci board files.
>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  arch/arm/mach-davinci/board-dm355-evm.c  |    1 +
>  arch/arm/mach-davinci/board-dm644x-evm.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
> index f683559..4a9252a 100644
> --- a/arch/arm/mach-davinci/board-dm355-evm.c
> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> @@ -372,6 +372,7 @@ static struct vpfe_subdev_info vpfe_sub_devs[] = {
>  
>  static struct vpfe_config vpfe_cfg = {
>  	.num_subdevs = ARRAY_SIZE(vpfe_sub_devs),
> +	.i2c_adapter_id = 1,
>  	.sub_devs = vpfe_sub_devs,
>  	.card_name = "DM355 EVM",
>  	.ccdc = "DM355 CCDC",
> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
> index cfd9afa..fed64e2 100644
> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
> @@ -257,6 +257,7 @@ static struct vpfe_subdev_info vpfe_sub_devs[] = {
>  
>  static struct vpfe_config vpfe_cfg = {
>  	.num_subdevs = ARRAY_SIZE(vpfe_sub_devs),
> +	.i2c_adapter_id = 1,
>  	.sub_devs = vpfe_sub_devs,
>  	.card_name = "DM6446 EVM",
>  	.ccdc = "DM6446 CCDC",
> -- 
> 1.6.2.4
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> ----------
