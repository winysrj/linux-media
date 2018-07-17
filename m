Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:33783 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729754AbeGQWLl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 18:11:41 -0400
MIME-Version: 1.0
In-Reply-To: <20180709151947.940759-1-arnd@arndb.de>
References: <20180709151947.940759-1-arnd@arndb.de>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 18 Jul 2018 00:37:05 +0300
Message-ID: <CAHp75VdHZ4jCMLZn3RwhQ3ZCabZVsPMMUUOeXLvKT1y=m_z+WQ@mail.gmail.com>
Subject: Re: [PATCH] headers: fix linux/mod_devicetable.h inclusions
To: Arnd Bergmann <arnd@arndb.de>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gabriel Somlo <somlo@cmu.edu>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        qemu-devel@nongnu.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Platform Driver <platform-driver-x86@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 9, 2018 at 6:19 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> A couple of drivers produced build errors after the mod_devicetable.h
> header was split out from the platform_device one, e.g.
>
> drivers/media/platform/davinci/vpbe_osd.c:42:40: error: array type has incomplete element type 'struct platform_device_id'
> drivers/media/platform/davinci/vpbe_venc.c:42:40: error: array type has incomplete element type 'struct platform_device_id'
>
> This adds the inclusion where needed.
>
> Fixes: ac3167257b9f ("headers: separate linux/mod_devicetable.h from linux/platform_device.h")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

>  drivers/platform/x86/intel_punit_ipc.c     | 1 +


> --- a/drivers/platform/x86/intel_punit_ipc.c
> +++ b/drivers/platform/x86/intel_punit_ipc.c
> @@ -12,6 +12,7 @@
>   */
>
>  #include <linux/module.h>
> +#include <linux/mod_devicetable.h>
>  #include <linux/acpi.h>
>  #include <linux/delay.h>
>  #include <linux/bitops.h>

Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>

for the above bits.

-- 
With Best Regards,
Andy Shevchenko
