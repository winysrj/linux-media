Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37596 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751069AbdGNWEI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 18:04:08 -0400
Date: Sat, 15 Jul 2017 01:04:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javierm@redhat.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCH] [media] vimc: set id_table for platform drivers
Message-ID: <20170714220404.5ibxhkuzfgfpsnhu@valkosipuli.retiisi.org.uk>
References: <20170714085839.4322-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170714085839.4322-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 10:58:39AM +0200, Javier Martinez Canillas wrote:
> The vimc platform drivers define a platform device ID table but these
> are not set to the .id_table field in the platform driver structure.
> 
> So the platform device ID table is only used to fill the aliases in
> the module but are not used for matching (works because the platform
> subsystem fallbacks to the driver's name if no .id_table is set).
> 
> But this also means that the platform device ID table isn't used if
> the driver is built-in, which leads to the following build warning:
> 
> This causes the following build warnings when the driver is built-in:
> 
> drivers/media/platform/vimc//vimc-capture.c:528:40: warning: ‘vimc_cap_driver_ids’ defined but not used [-Wunused-const-variable=]
>  static const struct platform_device_id vimc_cap_driver_ids[] = {
>                                         ^~~~~~~~~~~~~~~~~~~
> drivers/media/platform/vimc//vimc-debayer.c:588:40: warning: ‘vimc_deb_driver_ids’ defined but not used [-Wunused-const-variable=]
>  static const struct platform_device_id vimc_deb_driver_ids[] = {
>                                         ^~~~~~~~~~~~~~~~~~~
> drivers/media/platform/vimc//vimc-scaler.c:442:40: warning: ‘vimc_sca_driver_ids’ defined but not used [-Wunused-const-variable=]
>  static const struct platform_device_id vimc_sca_driver_ids[] = {
>                                         ^~~~~~~~~~~~~~~~~~~
> drivers/media/platform/vimc//vimc-sensor.c:376:40: warning: ‘vimc_sen_driver_ids’ defined but not used [-Wunused-const-variable=]
>  static const struct platform_device_id vimc_sen_driver_ids[] = {
>                                         ^~~~~~~~~~~~~~~~~~~
> 
> Reported-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Suggested-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
