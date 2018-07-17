Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44602 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbeGQMzf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 08:55:35 -0400
MIME-Version: 1.0
In-Reply-To: <20180709151947.940759-1-arnd@arndb.de>
References: <20180709151947.940759-1-arnd@arndb.de>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 17 Jul 2018 13:22:37 +0100
Message-ID: <CA+V-a8vw_4t7srk2wxp_W7QDN8-Vwj=OC8bvyvpzyTyhXnHLEA@mail.gmail.com>
Subject: Re: [PATCH] headers: fix linux/mod_devicetable.h inclusions
To: Arnd Bergmann <arnd@arndb.de>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gabriel Somlo <somlo@cmu.edu>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        qemu-devel@nongnu.org, LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 9, 2018 at 4:19 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> A couple of drivers produced build errors after the mod_devicetable.h
> header was split out from the platform_device one, e.g.
>
> drivers/media/platform/davinci/vpbe_osd.c:42:40: error: array type has incomplete element type 'struct platform_device_id'
> drivers/media/platform/davinci/vpbe_venc.c:42:40: error: array type has incomplete element type 'struct platform_device_id'
>

For the above fixes,

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> This adds the inclusion where needed.
>
> Fixes: ac3167257b9f ("headers: separate linux/mod_devicetable.h from linux/platform_device.h")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/firmware/qemu_fw_cfg.c             | 1 +
>  drivers/media/platform/davinci/vpbe_osd.c  | 1 +
>  drivers/media/platform/davinci/vpbe_venc.c | 1 +
>  drivers/media/platform/qcom/venus/vdec.c   | 1 +
>  drivers/media/platform/qcom/venus/venc.c   | 1 +
>  drivers/media/platform/sti/hva/hva-v4l2.c  | 1 +
>  drivers/platform/x86/intel_punit_ipc.c     | 1 +
>  7 files changed, 7 insertions(+)
>
> diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
> index 14fedbeca724..039e0f91dba8 100644
> --- a/drivers/firmware/qemu_fw_cfg.c
> +++ b/drivers/firmware/qemu_fw_cfg.c
> @@ -28,6 +28,7 @@
>   */
>
>  #include <linux/module.h>
> +#include <linux/mod_devicetable.h>
>  #include <linux/platform_device.h>
>  #include <linux/acpi.h>
>  #include <linux/slab.h>
> diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
> index 7f610320426d..c551a25d90d9 100644
> --- a/drivers/media/platform/davinci/vpbe_osd.c
> +++ b/drivers/media/platform/davinci/vpbe_osd.c
> @@ -18,6 +18,7 @@
>   *
>   */
>  #include <linux/module.h>
> +#include <linux/mod_devicetable.h>
>  #include <linux/kernel.h>
>  #include <linux/interrupt.h>
>  #include <linux/platform_device.h>
> diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
> index ba157827192c..ddcad7b3e76c 100644
> --- a/drivers/media/platform/davinci/vpbe_venc.c
> +++ b/drivers/media/platform/davinci/vpbe_venc.c
> @@ -11,6 +11,7 @@
>   * GNU General Public License for more details.
>   */
>  #include <linux/module.h>
> +#include <linux/mod_devicetable.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/ctype.h>
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index f89a91d43cc9..d4e23c7df347 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -14,6 +14,7 @@
>   */
>  #include <linux/clk.h>
>  #include <linux/module.h>
> +#include <linux/mod_devicetable.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index f7a87a3dbb46..0522cf202b75 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -14,6 +14,7 @@
>   */
>  #include <linux/clk.h>
>  #include <linux/module.h>
> +#include <linux/mod_devicetable.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
> diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
> index 15080cb00fa7..5a807c7c5e79 100644
> --- a/drivers/media/platform/sti/hva/hva-v4l2.c
> +++ b/drivers/media/platform/sti/hva/hva-v4l2.c
> @@ -6,6 +6,7 @@
>   */
>
>  #include <linux/module.h>
> +#include <linux/mod_devicetable.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <media/v4l2-event.h>
> diff --git a/drivers/platform/x86/intel_punit_ipc.c b/drivers/platform/x86/intel_punit_ipc.c
> index b5b890127479..f1afc0ebbc68 100644
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
> --
> 2.9.0
>
