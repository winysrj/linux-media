Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f198.google.com ([209.85.210.198]:42990 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZFQV7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 17:59:16 -0400
Received: by yxe36 with SMTP id 36so276329yxe.33
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 14:59:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245269484-8325-5-git-send-email-m-karicheri2@ti.com>
References: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com>
	 <1245269484-8325-2-git-send-email-m-karicheri2@ti.com>
	 <1245269484-8325-3-git-send-email-m-karicheri2@ti.com>
	 <1245269484-8325-4-git-send-email-m-karicheri2@ti.com>
	 <1245269484-8325-5-git-send-email-m-karicheri2@ti.com>
Date: Thu, 18 Jun 2009 01:59:17 +0400
Message-ID: <208cbae30906171459p68b2953fg607fdb3979d20eff@mail.gmail.com>
Subject: Re: [PATCH 4/11 - v3] dm644x ccdc module for vpfe capture driver
From: Alexey Klimov <klimov.linux@gmail.com>
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 18, 2009 at 12:11 AM, <m-karicheri2@ti.com> wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> DM644x CCDC hw module
>
> This is the hw module for DM644x CCDC. This registers with the
> vpfe capture driver and provides a set of hw_ops to configure
> CCDC for a specific decoder device connected to the VPFE
>
> Module description, GPL and owner information MACROs added at the top

<snip>

> +static int dm644x_ccdc_init(void)
> +{
> +       printk(KERN_NOTICE "dm644x_ccdc_init\n");
> +       if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
> +               return -1;

The same small idea like in "[PATCH 3/11 - v3] dm355 ccdc module for
vpfe capture driver" about this function. What do you think about
introducing ret variable and returning good error code?

> +       printk(KERN_NOTICE "%s is registered with vpfe.\n",
> +               ccdc_hw_dev.name);
> +       return 0;
> +}
> +
> +static void dm644x_ccdc_exit(void)
> +{
> +       vpfe_unregister_ccdc_device(&ccdc_hw_dev);
> +}


-- 
Best regards, Klimov Alexey
