Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f198.google.com ([209.85.210.198]:43654 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZFQVvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 17:51:42 -0400
Received: by yxe36 with SMTP id 36so269585yxe.33
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 14:51:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245269484-8325-4-git-send-email-m-karicheri2@ti.com>
References: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com>
	 <1245269484-8325-2-git-send-email-m-karicheri2@ti.com>
	 <1245269484-8325-3-git-send-email-m-karicheri2@ti.com>
	 <1245269484-8325-4-git-send-email-m-karicheri2@ti.com>
Date: Thu, 18 Jun 2009 01:51:43 +0400
Message-ID: <208cbae30906171451x789f00ak94799447c9a012a5@mail.gmail.com>
Subject: Re: [PATCH 3/11 - v3] dm355 ccdc module for vpfe capture driver
From: Alexey Klimov <klimov.linux@gmail.com>
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
one more small comment

On Thu, Jun 18, 2009 at 12:11 AM, <m-karicheri2@ti.com> wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> DM355 CCDC hw module
>
> Adds ccdc hw module for DM355 CCDC. This registers with the bridge
> driver a set of hw_ops for configuring the CCDC for a specific
> decoder device connected to vpfe.
>
> The module description and owner information added


<snip>


> +static int dm355_ccdc_init(void)
> +{
> +       printk(KERN_NOTICE "dm355_ccdc_init\n");
> +       if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
> +               return -1;

Don't you want to rewrite this to return good error code?
int ret;
printk();
ret = vpfe_register_ccdc_device();
if (ret < 0)
return ret;

I know you have tight/fast track/hard schedule, so you can do this
improvement later, after merging this patch.

> +       printk(KERN_NOTICE "%s is registered with vpfe.\n",
> +               ccdc_hw_dev.name);
> +       return 0;
> +}
> +
> +static void dm355_ccdc_exit(void)
> +{
> +       vpfe_unregister_ccdc_device(&ccdc_hw_dev);
> +}


-- 
Best regards, Klimov Alexey
