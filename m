Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kmu-office.ch ([178.209.48.109]:60124 "EHLO
        mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbdHFXbo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Aug 2017 19:31:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Sun, 06 Aug 2017 16:29:22 -0700
From: Stefan Agner <stefan@agner.ch>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Pavel Machek <pavel@ucw.cz>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Revert "[media] et8ek8: Export OF device ID as module aliases"
In-Reply-To: <20170608090156.2373326-1-arnd@arndb.de>
References: <20170608090156.2373326-1-arnd@arndb.de>
Message-ID: <aae480c52bd7e9e4772b3c9c76420435@agner.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just hit this issue too. This seems not to have made it into v4.13 as of
today yet, any chance to get it still in?

--
Stefan

On 2017-06-08 02:01, Arnd Bergmann wrote:
> This one got applied twice, causing a build error with clang:
> 
> drivers/media/i2c/et8ek8/et8ek8_driver.c:1499:1: error: redefinition
> of '__mod_of__et8ek8_of_table_device_table'
> 
> Fixes: 9ae05fd1e791 ("[media] et8ek8: Export OF device ID as module aliases")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  drivers/media/i2c/et8ek8/et8ek8_driver.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c
> b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> index 6e313d5243a0..f39f5179dd95 100644
> --- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
> +++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> @@ -1496,7 +1496,6 @@ MODULE_DEVICE_TABLE(i2c, et8ek8_id_table);
>  static const struct dev_pm_ops et8ek8_pm_ops = {
>  	SET_SYSTEM_SLEEP_PM_OPS(et8ek8_suspend, et8ek8_resume)
>  };
> -MODULE_DEVICE_TABLE(of, et8ek8_of_table);
>  
>  static struct i2c_driver et8ek8_i2c_driver = {
>  	.driver		= {
