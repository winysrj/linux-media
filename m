Return-path: <mchehab@gaivota>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54649 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0LVOKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 09:10:00 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sergei Shtylyov'" <sshtylyov@mvista.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Wed, 22 Dec 2010 19:39:41 +0530
Subject: RE: [PATCH v8 6/8] davinci vpbe: board specific additions
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930247F9A80F@dbde02.ent.ti.com>
In-Reply-To: <4D1092E2.7070900@mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Sergei,
 Only one comment. For others I have done the fixes.
Thanks and Regards,
-Manju

Others On Tue, Dec 21, 2010 at 17:13:30, Sergei Shtylyov wrote:
> Hello.
> 
> On 20-12-2010 16:54, Manjunath Hadli wrote:
> 
> > This patch implements tables for display timings,outputs and other 
> > board related functionalities.
> 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> > Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> [...]
> 
> > diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c 
> > b/arch/arm/mach-davinci/board-dm644x-evm.c
> > index 34c8b41..e9b1243 100644
> > --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> > +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
> [...]
> > @@ -606,8 +594,71 @@ static void __init evm_init_i2c(void)
> >   	i2c_register_board_info(1, i2c_info, ARRAY_SIZE(i2c_info));
> >   }
> >
> > +#define VENC_STD_ALL    (V4L2_STD_NTSC | V4L2_STD_PAL)
> 
>     Insert an empty line here, please.
> 
> > +/* venc standards timings */
> > +static struct vpbe_enc_mode_info vbpe_enc_std_timings[] = {
> > +	{"ntsc", VPBE_ENC_STD, {V4L2_STD_525_60}, 1, 720, 480,
> > +	{11, 10}, {30000, 1001}, 0x79, 0, 0x10, 0, 0, 0, 0},
> > +	{"pal", VPBE_ENC_STD, {V4L2_STD_625_50}, 1, 720, 576,
> > +	{54, 59}, {25, 1}, 0x7E, 0, 0x16, 0, 0, 0, 0}, };
> > +
> > +/* venc dv preset timings */
> > +static struct vpbe_enc_mode_info vbpe_enc_preset_timings[] = {
> > +	{"480p59_94", VPBE_ENC_DV_PRESET, {V4L2_DV_480P59_94}, 0, 720, 480,
> > +	{1, 1}, {5994, 100}, 0x80, 0, 0x20, 0, 0, 0, 0},
> > +	{"576p50", VPBE_ENC_DV_PRESET, {V4L2_DV_576P50}, 0, 720, 576,
> > +	{1, 1}, {50, 1}, 0x7E, 0, 0x30, 0, 0, 0, 0}, };
> > +
> > +/*
> > + * The outputs available from VPBE + ecnoders. Keep the
> > + * the  order same as that of encoders. First that from venc followed 
> > +by that
>        ^^^ duplicate
These are actually 2 different structures, the second one holding high def
Standards - 480p and 576p and use DV_PRESETS whicle the first is used for
SD modes. 
> 
> > +static struct vpbe_display_config vpbe_display_cfg = {
> > +	.module_name = "dm644x-vpbe-display",
> > +	.i2c_adapter_id = 1,
> > +	.osd = {
> > +		.module_name = VPBE_OSD_SUBDEV_NAME,
> > +	},
> > +	.venc = {
> > +		.module_name = VPBE_VENC_SUBDEV_NAME,
> > +	},
> > +	.num_outputs = ARRAY_SIZE(dm644x_vpbe_outputs),
> > +	.outputs = dm644x_vpbe_outputs,
> > +};
> 
>     Insert an empty line here, please.
> 
> >   static struct platform_device *davinci_evm_devices[] __initdata = {
> > -	&davinci_fb_device,
> >   	&rtc_dev,
> >   };
> 
> WBR, Sergei
> 

