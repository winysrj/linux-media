Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:34861 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbbEALVL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2015 07:21:11 -0400
Received: by qcbgu10 with SMTP id gu10so2305141qcb.2
        for <linux-media@vger.kernel.org>; Fri, 01 May 2015 04:21:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E1Yo8JY-0000If-JA@www.linuxtv.org>
References: <E1Yo8JY-0000If-JA@www.linuxtv.org>
Date: Fri, 1 May 2015 07:21:09 -0400
Message-ID: <CALzAhNX1Se4AwixOikf8CGY=a_7hOFbe20C=o=BOxqT5QTiUeA@mail.gmail.com>
Subject: Re: [git:media_tree/master] saa7164: Fix CodingStyle issues added on
 previous patches
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>
Cc: linuxtv-commits@linuxtv.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 1, 2015 at 6:33 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
>
> Subject: saa7164: Fix CodingStyle issues added on previous patches
> Author:  Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Date:    Fri May 1 07:30:40 2015 -0300
>
> The patches that added support for HVR2255 and HVR2205 added
> some CodingStyle issues.
>
> Better to fix it sooner than latter.
>
> Cc: Steven Toth <stoth@kernellabs.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-By: Steven Toth <stoth@kernellabs.com>

>
>  drivers/media/pci/saa7164/saa7164-api.c |    3 +-
>  drivers/media/pci/saa7164/saa7164-dvb.c |   34 ++++++++++++++++++------------
>  2 files changed, 22 insertions(+), 15 deletions(-)
>
> ---
>
> http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=3600433f19f59410010770d61ead509d785b8a6e
>
> diff --git a/drivers/media/pci/saa7164/saa7164-api.c b/drivers/media/pci/saa7164/saa7164-api.c
> index a992af6..e807703 100644
> --- a/drivers/media/pci/saa7164/saa7164-api.c
> +++ b/drivers/media/pci/saa7164/saa7164-api.c
> @@ -1467,7 +1467,8 @@ int saa7164_api_i2c_write(struct saa7164_i2c *bus, u8 addr, u32 datalen,
>                 return -EIO;
>         }
>
> -       dprintk(DBGLVL_API, "%s() len = %d bytes unitid=0x%x\n", __func__, len, unitid);
> +       dprintk(DBGLVL_API, "%s() len = %d bytes unitid=0x%x\n", __func__,
> +               len, unitid);
>
>         /* Prepare the send buffer */
>         /* Bytes 00-03 dest register length
> diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c b/drivers/media/pci/saa7164/saa7164-dvb.c
> index 0fdc944..c68ce26 100644
> --- a/drivers/media/pci/saa7164/saa7164-dvb.c
> +++ b/drivers/media/pci/saa7164/saa7164-dvb.c
> @@ -629,11 +629,13 @@ int saa7164_dvb_register(struct saa7164_port *port)
>                 if (port->dvb.frontend != NULL) {
>
>                         if (port->nr == 0) {
> -                               si2157_attach(port, &dev->i2c_bus[0].i2c_adap, port->dvb.frontend,
> -                                       0xc0, &hauppauge_hvr2255_tuner_config);
> +                               si2157_attach(port, &dev->i2c_bus[0].i2c_adap,
> +                                             port->dvb.frontend, 0xc0,
> +                                             &hauppauge_hvr2255_tuner_config);
>                         } else {
> -                               si2157_attach(port, &dev->i2c_bus[1].i2c_adap, port->dvb.frontend,
> -                                       0xc0, &hauppauge_hvr2255_tuner_config);
> +                               si2157_attach(port, &dev->i2c_bus[1].i2c_adap,
> +                                             port->dvb.frontend, 0xc0,
> +                                             &hauppauge_hvr2255_tuner_config);
>                         }
>                 }
>                 break;
> @@ -650,10 +652,11 @@ int saa7164_dvb_register(struct saa7164_port *port)
>                         info.addr = 0xc8 >> 1;
>                         info.platform_data = &si2168_config;
>                         request_module(info.type);
> -                       client_demod = i2c_new_device(&dev->i2c_bus[2].i2c_adap, &info);
> -                       if (client_demod == NULL || client_demod->dev.driver == NULL) {
> +                       client_demod = i2c_new_device(&dev->i2c_bus[2].i2c_adap,
> +                                                     &info);
> +                       if (!client_demod || !client_demod->dev.driver)
>                                 goto frontend_detach;
> -                       }
> +
>                         if (!try_module_get(client_demod->dev.driver->owner)) {
>                                 i2c_unregister_device(client_demod);
>                                 goto frontend_detach;
> @@ -668,8 +671,9 @@ int saa7164_dvb_register(struct saa7164_port *port)
>                         info.addr = 0xc0 >> 1;
>                         info.platform_data = &si2157_config;
>                         request_module(info.type);
> -                       client_tuner = i2c_new_device(&dev->i2c_bus[0].i2c_adap, &info);
> -                       if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
> +                       client_tuner = i2c_new_device(&dev->i2c_bus[0].i2c_adap,
> +                                                     &info);
> +                       if (!client_tuner || !client_tuner->dev.driver) {
>                                 module_put(client_demod->dev.driver->owner);
>                                 i2c_unregister_device(client_demod);
>                                 goto frontend_detach;
> @@ -692,10 +696,11 @@ int saa7164_dvb_register(struct saa7164_port *port)
>                         info.addr = 0xcc >> 1;
>                         info.platform_data = &si2168_config;
>                         request_module(info.type);
> -                       client_demod = i2c_new_device(&dev->i2c_bus[2].i2c_adap, &info);
> -                       if (client_demod == NULL || client_demod->dev.driver == NULL) {
> +                       client_demod = i2c_new_device(&dev->i2c_bus[2].i2c_adap,
> +                                                     &info);
> +                       if (!client_tuner || !client_tuner->dev.driver)
>                                 goto frontend_detach;
> -                       }
> +
>                         if (!try_module_get(client_demod->dev.driver->owner)) {
>                                 i2c_unregister_device(client_demod);
>                                 goto frontend_detach;
> @@ -710,8 +715,9 @@ int saa7164_dvb_register(struct saa7164_port *port)
>                         info.addr = 0xc0 >> 1;
>                         info.platform_data = &si2157_config;
>                         request_module(info.type);
> -                       client_tuner = i2c_new_device(&dev->i2c_bus[1].i2c_adap, &info);
> -                       if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
> +                       client_tuner = i2c_new_device(&dev->i2c_bus[1].i2c_adap,
> +                                                     &info);
> +                       if (!client_tuner || !client_tuner->dev.driver) {
>                                 module_put(client_demod->dev.driver->owner);
>                                 i2c_unregister_device(client_demod);
>                                 goto frontend_detach;



-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
