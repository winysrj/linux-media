Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36163 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933940AbcKILJj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 06:09:39 -0500
MIME-Version: 1.0
In-Reply-To: <20161108182215.41f1f3d2@vento.lan>
References: <CADDKRnD6sQLsxwObi1Bo6k69P5ceqQHw7beT6C7TqZjUsDby+w@mail.gmail.com>
 <CA+55aFxXoc3GzAXWPZL=RB2xhmhP1acR3m2S_mdoiO97+80kDA@mail.gmail.com> <20161108182215.41f1f3d2@vento.lan>
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Date: Wed, 9 Nov 2016 12:09:37 +0100
Message-ID: <CADDKRnD_+uhQc7GyK3FfnDSRUkL5WkZNV7F+TsEhhDdo6O=Vmw@mail.gmail.com>
Subject: Re: [v4.9-rc4] dvb-usb/cinergyT2 NULL pointer dereference
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-11-08 21:22 GMT+01:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>=
:
> Em Tue, 8 Nov 2016 10:42:03 -0800
> Linus Torvalds <torvalds@linux-foundation.org> escreveu:
>
>> On Sun, Nov 6, 2016 at 7:40 AM, J=C3=B6rg Otte <jrg.otte@gmail.com> wrot=
e:
>> > Since v4.9-rc4 I get following crash in dvb-usb-cinergyT2 module.
>>
>> Looks like it's commit 5ef8ed0e5608f ("[media] cinergyT2-core: don't
>> do DMA on stack"), which movced the DMA data array from the stack to
>> the "private" pointer. In the process it also added serialization in
>> the form of "data_mutex", but and now it oopses on that mutex because
>> the private pointer is NULL.
>>
>> It looks like the "->private" pointer is allocated in dvb_usb_adapter_in=
it()
>>
>> cinergyt2_usb_probe ->
>>   dvb_usb_device_init ->
>>     dvb_usb_init() ->
>>       dvb_usb_adapter_init()
>>
>> but the dvb_usb_init() function calls dvb_usb_device_power_ctrl()
>> (which calls the "power_ctrl" function, which is
>> cinergyt2_power_ctrl() for that drive) *before* it initializes the
>> private field.
>>
>> Mauro, Patrick, could dvb_usb_adapter_init() be called earlier, perhaps?
>
> Calling it earlier won't work, as we need to load the firmware before
> sending the power control commands on some devices.
>
> Probably the best here is to pass an extra optional function parameter
> that will initialize the mutex before calling any functions.
>
> Btw, if it broke here, the DMA fixes will likely break on other drivers.
> So, after J=C3=B6rg tests this patch, I'll work on a patch series address=
ing
> this issue on the other drivers I touched.
>
> Regards,
> Mauro
>
> -
>
> [PATCH RFC] cinergyT2-core: initialize the mutex early
>
> NOTE: don't merge this patch as-is... I actually folded two patches
> together here, in order to make easier to test, but the best is to
> place the changes at the core first, and then the changes at the
> drivers that would need an early init.
>
> The mutex used to protect the URB data buffer needs to be
> inialized early, as otherwise it will cause an OOPS:
>
> dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm =
state.
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffff846617af>] __mutex_lock_slowpath+0x6f/0x100 PGD 0
> Oops: 0002 [#1] SMP
> Modules linked in: dvb_usb_cinergyT2(+) dvb_usb
> CPU: 0 PID: 2029 Comm: modprobe Not tainted 4.9.0-rc4-dvbmod #24
> Hardware name: FUJITSU LIFEBOOK A544/FJNBB35 , BIOS Version 1.17 05/09/20=
14
> task: ffff88020e943840 task.stack: ffff8801f36ec000
> RIP: 0010:[<ffffffff846617af>]  [<ffffffff846617af>] __mutex_lock_slowpat=
h+0x6f/0x100
> RSP: 0018:ffff8801f36efb10  EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff88021509bdc8 RCX: 00000000c0000100
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88021509bdcc
> RBP: ffff8801f36efb58 R08: ffff88021f216320 R09: 0000000000100000
> R10: ffff88021f216320 R11: 00000023fee6c5a1 R12: ffff88020e943840
> R13: ffff88021509bdcc R14: 00000000ffffffff R15: ffff88021509bdd0
> FS:  00007f21adb86740(0000) GS:ffff88021f200000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000215bce000 CR4: 00000000001406f0
> Stack:
>  ffff88021509bdd0 0000000000000000 0000000000000000 ffffffffc0137c80
>  ffff88021509bdc8 ffff8801f5944000 0000000000000001 ffffffffc0136b00
>  ffff880213e52000 ffff88021509bdc8 ffffffff84661856 ffff88021509bd80
> Call Trace:
>  [<ffffffff84661856>] ? mutex_lock+0x16/0x25
>  [<ffffffffc013616f>] ? cinergyt2_power_ctrl+0x1f/0x60 [dvb_usb_cinergyT2=
]
>  [<ffffffffc012e67e>] ? dvb_usb_device_init+0x21e/0x5d0 [dvb_usb]
>  [<ffffffffc0136021>] ? cinergyt2_usb_probe+0x21/0x50 [dvb_usb_cinergyT2]
>  [<ffffffff844326f3>] ? usb_probe_interface+0xf3/0x2a0
>  [<ffffffff8438e348>] ? driver_probe_device+0x208/0x2b0
>  [<ffffffff8438e477>] ? __driver_attach+0x87/0x90
>  [<ffffffff8438e3f0>] ? driver_probe_device+0x2b0/0x2b0
>  [<ffffffff8438c612>] ? bus_for_each_dev+0x52/0x80
>  [<ffffffff8438d983>] ? bus_add_driver+0x1a3/0x220
>  [<ffffffff8438ec06>] ? driver_register+0x56/0xd0
>  [<ffffffff84431527>] ? usb_register_driver+0x77/0x130
>  [<ffffffffc013a000>] ? 0xffffffffc013a000
>  [<ffffffff84000426>] ? do_one_initcall+0x46/0x180
>  [<ffffffff840eb2c8>] ? free_vmap_area_noflush+0x38/0x70
>  [<ffffffff840f3844>] ? kmem_cache_alloc+0x84/0xc0
>  [<ffffffff840b802c>] ? do_init_module+0x50/0x1be
>  [<ffffffff84095adb>] ? load_module+0x1d8b/0x2100
>  [<ffffffff84093020>] ? find_symbol_in_section+0xa0/0xa0
>  [<ffffffff84095fe9>] ? SyS_finit_module+0x89/0x90
>  [<ffffffff846637a0>] ? entry_SYSCALL_64_fastpath+0x13/0x94
> Code: e8 a7 1d 00 00 8b 03 83 f8 01 0f 84 97 00 00 00 48 8b 43 10 4c 8d 7=
b 08 48 89 63 10 4c 89 3c 24 41 be ff ff ff ff 48 89 44 24 08 <48> 89 20 4c=
 89 64 24 10 eb 1a 49 c7 44 24 08 02 00 00 00 c6 43 RIP  [<ffffffff846617af=
>] __mutex_lock_slowpath+0x6f/0x100 RSP <ffff8801f36efb10>
> CR2: 0000000000000000
>
> Reported-by: J=C3=B6rg Otte <jrg.otte@gmail.com>
> Fixes: 6679a901c380 ("[media] cinergyT2-core: don't do DMA on stack")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>
> From cbc7e48a86e8ffd16e49b10061120dfc417397f8 Mon Sep 17 00:00:00 2001
> From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Date: Tue, 8 Nov 2016 18:04:24 -0200
> Subject: [PATCH] [media] dvb-usb: allow early initialization of usb devic=
e
>  priv data
>
> On some drivers, we need to initialize a mutex before calling
> power control or firmware download routines. Add an extra
> parameter to allow it.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>
> diff --git a/drivers/media/usb/dvb-usb/a800.c b/drivers/media/usb/dvb-usb=
/a800.c
> index 7ba975bea96a..1e14f79aa57a 100644
> --- a/drivers/media/usb/dvb-usb/a800.c
> +++ b/drivers/media/usb/dvb-usb/a800.c
> @@ -107,7 +107,7 @@ static int a800_probe(struct usb_interface *intf,
>                 const struct usb_device_id *id)
>  {
>         return dvb_usb_device_init(intf, &a800_properties,
> -                                  THIS_MODULE, NULL, adapter_nr);
> +                                  THIS_MODULE, NULL, adapter_nr, NULL);
>  }
>
>  /* do not change the order of the ID table */
> diff --git a/drivers/media/usb/dvb-usb/af9005.c b/drivers/media/usb/dvb-u=
sb/af9005.c
> index b257780fb380..1625b4714d83 100644
> --- a/drivers/media/usb/dvb-usb/af9005.c
> +++ b/drivers/media/usb/dvb-usb/af9005.c
> @@ -1009,7 +1009,7 @@ static int af9005_usb_probe(struct usb_interface *i=
ntf,
>         int ret;
>
>         ret =3D dvb_usb_device_init(intf, &af9005_properties,
> -                                 THIS_MODULE, &d, adapter_nr);
> +                                 THIS_MODULE, &d, adapter_nr, NULL);
>
>         if (ret < 0)
>                 return ret;
> diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-u=
sb/az6027.c
> index 2e711362847e..e8f73a96efd9 100644
> --- a/drivers/media/usb/dvb-usb/az6027.c
> +++ b/drivers/media/usb/dvb-usb/az6027.c
> @@ -946,7 +946,7 @@ static int az6027_usb_probe(struct usb_interface *int=
f,
>                                    &az6027_properties,
>                                    THIS_MODULE,
>                                    NULL,
> -                                  adapter_nr);
> +                                  adapter_nr, NULL);
>  }
>
>  /* I2C */
> diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/u=
sb/dvb-usb/cinergyT2-core.c
> index 8ac825413d5a..2aa99c52e39d 100644
> --- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
> +++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
> @@ -206,24 +206,21 @@ static int cinergyt2_rc_query(struct dvb_usb_device=
 *d, u32 *event, int *state)
>         return ret;
>  }
>
> -static int cinergyt2_usb_probe(struct usb_interface *intf,
> -                               const struct usb_device_id *id)
> +static int cinergyT2_init_mutex(struct dvb_usb_device *d)
>  {
> -       struct dvb_usb_device *d;
> -       struct cinergyt2_state *st;
> -       int ret;
> -
> -       ret =3D dvb_usb_device_init(intf, &cinergyt2_properties,
> -                                 THIS_MODULE, &d, adapter_nr);
> -       if (ret < 0)
> -               return ret;
> +       struct cinergyt2_state *st =3D d->priv;
>
> -       st =3D d->priv;
>         mutex_init(&st->data_mutex);
> -
>         return 0;
>  }
>
> +static int cinergyt2_usb_probe(struct usb_interface *intf,
> +                               const struct usb_device_id *id)
> +{
> +       return dvb_usb_device_init(intf, &cinergyt2_properties,
> +                                  THIS_MODULE, NULL, adapter_nr,
> +                                  cinergyT2_init_mutex);
> +}
>
>  static struct usb_device_id cinergyt2_usb_table[] =3D {
>         { USB_DEVICE(USB_VID_TERRATEC, 0x0038) },
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-us=
b/cxusb.c
> index 39772812269d..73c1a8568b55 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -1465,33 +1465,33 @@ static int cxusb_probe(struct usb_interface *intf=
,
>         struct cxusb_state *st;
>
>         if (0 =3D=3D dvb_usb_device_init(intf, &cxusb_medion_properties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_lgh064f_pr=
operties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_dee1601_pr=
operties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_lgz201_pro=
perties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_dtt7579_pr=
operties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_dualdig4_p=
roperties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_nano2_prop=
erties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf,
>                                 &cxusb_bluebird_nano2_needsfirmware_prope=
rties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_aver_a868r_properti=
es,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf,
>                                      &cxusb_bluebird_dualdig4_rev2_proper=
ties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_d680_dmb_properties=
,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_mygica_d689_propert=
ies,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_mygica_t230_propert=
ies,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0) {
>                 st =3D d->priv;
>                 mutex_init(&st->data_mutex);
> diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb=
/dvb-usb/dib0700_core.c
> index 92d5408684ac..3423b56c92b3 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_core.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_core.c
> @@ -871,7 +871,7 @@ static int dib0700_probe(struct usb_interface *intf,
>
>         for (i =3D 0; i < dib0700_device_count; i++)
>                 if (dvb_usb_device_init(intf, &dib0700_devices[i], THIS_M=
ODULE,
> -                   &dev, adapter_nr) =3D=3D 0) {
> +                   &dev, adapter_nr, NULL) =3D=3D 0) {
>                         struct dib0700_state *st =3D dev->priv;
>                         u32 hwversion, romversion, fw_version, fwtype;
>
> diff --git a/drivers/media/usb/dvb-usb/dibusb-mb.c b/drivers/media/usb/dv=
b-usb/dibusb-mb.c
> index a0057641cc86..de4ffe81e8d7 100644
> --- a/drivers/media/usb/dvb-usb/dibusb-mb.c
> +++ b/drivers/media/usb/dvb-usb/dibusb-mb.c
> @@ -111,13 +111,13 @@ static int dibusb_probe(struct usb_interface *intf,
>                 const struct usb_device_id *id)
>  {
>         if (0 =3D=3D dvb_usb_device_init(intf, &dibusb1_1_properties,
> -                                    THIS_MODULE, NULL, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr, NULL)=
 ||
>             0 =3D=3D dvb_usb_device_init(intf, &dibusb1_1_an2235_properti=
es,
> -                                    THIS_MODULE, NULL, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr, NULL)=
 ||
>             0 =3D=3D dvb_usb_device_init(intf, &dibusb2_0b_properties,
> -                                    THIS_MODULE, NULL, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr, NULL)=
 ||
>             0 =3D=3D dvb_usb_device_init(intf, &artec_t1_usb2_properties,
> -                                    THIS_MODULE, NULL, adapter_nr))
> +                                    THIS_MODULE, NULL, adapter_nr, NULL)=
)
>                 return 0;
>
>         return -EINVAL;
> diff --git a/drivers/media/usb/dvb-usb/dibusb-mc.c b/drivers/media/usb/dv=
b-usb/dibusb-mc.c
> index 08fb8a3f6e0c..d50731bb5372 100644
> --- a/drivers/media/usb/dvb-usb/dibusb-mc.c
> +++ b/drivers/media/usb/dvb-usb/dibusb-mc.c
> @@ -23,7 +23,7 @@ static int dibusb_mc_probe(struct usb_interface *intf,
>                 const struct usb_device_id *id)
>  {
>         return dvb_usb_device_init(intf, &dibusb_mc_properties, THIS_MODU=
LE,
> -                                  NULL, adapter_nr);
> +                                  NULL, adapter_nr, NULL);
>  }
>
>  /* do not change the order of the ID table */
> diff --git a/drivers/media/usb/dvb-usb/digitv.c b/drivers/media/usb/dvb-u=
sb/digitv.c
> index 4284f6984dc1..3dad2293e598 100644
> --- a/drivers/media/usb/dvb-usb/digitv.c
> +++ b/drivers/media/usb/dvb-usb/digitv.c
> @@ -269,7 +269,7 @@ static int digitv_probe(struct usb_interface *intf,
>  {
>         struct dvb_usb_device *d;
>         int ret =3D dvb_usb_device_init(intf, &digitv_properties, THIS_MO=
DULE, &d,
> -                                     adapter_nr);
> +                                     adapter_nr, NULL);
>         if (ret =3D=3D 0) {
>                 u8 b[4] =3D { 0 };
>
> diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-=
usb/dtt200u.c
> index f88572c7ae7c..3255fee31433 100644
> --- a/drivers/media/usb/dvb-usb/dtt200u.c
> +++ b/drivers/media/usb/dvb-usb/dtt200u.c
> @@ -149,15 +149,15 @@ static int dtt200u_usb_probe(struct usb_interface *=
intf,
>         struct dtt200u_state *st;
>
>         if (0 =3D=3D dvb_usb_device_init(intf, &dtt200u_properties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &wt220u_properties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &wt220u_fc_properties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &wt220u_zl0353_properties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, &d, adapter_nr, NULL) |=
|
>             0 =3D=3D dvb_usb_device_init(intf, &wt220u_miglia_properties,
> -                                    THIS_MODULE, &d, adapter_nr)) {
> +                                    THIS_MODULE, &d, adapter_nr, NULL)) =
{
>                 st =3D d->priv;
>                 mutex_init(&st->data_mutex);
>
> diff --git a/drivers/media/usb/dvb-usb/dtv5100.c b/drivers/media/usb/dvb-=
usb/dtv5100.c
> index c60fb54f445f..36b553cb3133 100644
> --- a/drivers/media/usb/dvb-usb/dtv5100.c
> +++ b/drivers/media/usb/dvb-usb/dtv5100.c
> @@ -165,7 +165,7 @@ static int dtv5100_probe(struct usb_interface *intf,
>         }
>
>         ret =3D dvb_usb_device_init(intf, &dtv5100_properties,
> -                                 THIS_MODULE, NULL, adapter_nr);
> +                                 THIS_MODULE, NULL, adapter_nr, NULL);
>         if (ret)
>                 return ret;
>
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb=
/dvb-usb/dvb-usb-init.c
> index 3896ba9a4179..66493fb25645 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
> +++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
> @@ -138,23 +138,14 @@ static int dvb_usb_exit(struct dvb_usb_device *d)
>         return 0;
>  }
>
> -static int dvb_usb_init(struct dvb_usb_device *d, short *adapter_nums)
> +static int dvb_usb_init(struct dvb_usb_device *d, short *adapter_nums,
> +                       int (init_device)(struct dvb_usb_device *d))
>  {
>         int ret =3D 0;
>
>         mutex_init(&d->usb_mutex);
>         mutex_init(&d->i2c_mutex);
>
> -       d->state =3D DVB_USB_STATE_INIT;
> -
> -       if (d->props.size_of_priv > 0) {
> -               d->priv =3D kzalloc(d->props.size_of_priv, GFP_KERNEL);
> -               if (d->priv =3D=3D NULL) {
> -                       err("no memory for priv in 'struct dvb_usb_device=
'");
> -                       return -ENOMEM;
> -               }
> -       }
> -
>         /* check the capabilities and set appropriate variables */
>         dvb_usb_device_power_ctrl(d, 1);
>
> @@ -233,7 +224,8 @@ int dvb_usb_device_power_ctrl(struct dvb_usb_device *=
d, int onoff)
>  int dvb_usb_device_init(struct usb_interface *intf,
>                         struct dvb_usb_device_properties *props,
>                         struct module *owner, struct dvb_usb_device **du,
> -                       short *adapter_nums)
> +                       short *adapter_nums,
> +                       int (init_device)(struct dvb_usb_device *d))
>  {
>         struct usb_device *udev =3D interface_to_usbdev(intf);
>         struct dvb_usb_device *d =3D NULL;
> @@ -249,19 +241,42 @@ int dvb_usb_device_init(struct usb_interface *intf,
>                 return -ENODEV;
>         }
>
> -       if (cold) {
> -               info("found a '%s' in cold state, will try to load a firm=
ware", desc->name);
> -               ret =3D dvb_usb_download_firmware(udev, props);
> -               if (!props->no_reconnect || ret !=3D 0)
> -                       return ret;
> -       }
> -
> -       info("found a '%s' in warm state.", desc->name);
>         d =3D kzalloc(sizeof(struct dvb_usb_device), GFP_KERNEL);
>         if (d =3D=3D NULL) {
>                 err("no memory for 'struct dvb_usb_device'");
>                 return -ENOMEM;
>         }
> +       d->state =3D DVB_USB_STATE_INIT;
> +
> +       if (d->props.size_of_priv > 0) {
> +               d->priv =3D kzalloc(d->props.size_of_priv, GFP_KERNEL);
> +               if (d->priv =3D=3D NULL) {
> +                       err("no memory for priv in 'struct dvb_usb_device=
'");
> +                       ret =3D -ENOMEM;
> +                       goto err;
> +               }
> +       }
> +
> +       /*
> +        * Some drivers may need to early initialize the device private d=
ata,
> +        * for example, when a mutex is serializing URB reads/writes,
> +        * in order for dvb_usb_device_power_ctrl() or firmware load to w=
ork.
> +        */
> +       if (init_device) {
> +               ret =3D init_device(d);
> +               if (ret < 0)
> +                       goto err;
> +       }
> +
> +       if (cold) {
> +               info("found a '%s' in cold state, will try to load a firm=
ware",
> +                    desc->name);
> +               ret =3D dvb_usb_download_firmware(udev, props);
> +               if (!props->no_reconnect || ret !=3D 0)
> +                       goto err;
> +       } else {
> +               info("found a '%s' in warm state.", desc->name);
> +       }
>
>         d->udev =3D udev;
>         memcpy(&d->props, props, sizeof(struct dvb_usb_device_properties)=
);
> @@ -273,12 +288,17 @@ int dvb_usb_device_init(struct usb_interface *intf,
>         if (du !=3D NULL)
>                 *du =3D d;
>
> -       ret =3D dvb_usb_init(d, adapter_nums);
> +       ret =3D dvb_usb_init(d, adapter_nums, init_device);
>
> -       if (ret =3D=3D 0)
> +       if (!ret) {
>                 info("%s successfully initialized and connected.", desc->=
name);
> -       else
> -               info("%s error while loading driver (%d)", desc->name, re=
t);
> +               return 0;
> +       }
> +err:
> +       info("%s error while loading driver (%d)", desc->name, ret);
> +
> +       kfree(d->priv);
> +       kfree(d);
>         return ret;
>  }
>  EXPORT_SYMBOL(dvb_usb_device_init);
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-=
usb/dvb-usb.h
> index 1448c3d27ea2..02c4dd3c206a 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb.h
> +++ b/drivers/media/usb/dvb-usb/dvb-usb.h
> @@ -458,7 +458,9 @@ struct dvb_usb_device {
>  extern int dvb_usb_device_init(struct usb_interface *,
>                                struct dvb_usb_device_properties *,
>                                struct module *, struct dvb_usb_device **,
> -                              short *adapter_nums);
> +                              short *adapter_nums,
> +                              int (init_device)(struct dvb_usb_device *d=
));
> +
>  extern void dvb_usb_device_exit(struct usb_interface *);
>
>  /* the generic read/write method for device control */
> diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-u=
sb/dw2102.c
> index 2c720cb2fb00..1cb8d96f485e 100644
> --- a/drivers/media/usb/dvb-usb/dw2102.c
> +++ b/drivers/media/usb/dvb-usb/dw2102.c
> @@ -2284,27 +2284,27 @@ static int dw2102_probe(struct usb_interface *int=
f,
>         s421->adapter->fe[0].frontend_attach =3D m88rs2000_frontend_attac=
h;
>
>         if (0 =3D=3D dvb_usb_device_init(intf, &dw2102_properties,
> -                       THIS_MODULE, NULL, adapter_nr) ||
> +                       THIS_MODULE, NULL, adapter_nr, NULL) ||
>             0 =3D=3D dvb_usb_device_init(intf, &dw2104_properties,
> -                       THIS_MODULE, NULL, adapter_nr) ||
> +                       THIS_MODULE, NULL, adapter_nr, NULL) ||
>             0 =3D=3D dvb_usb_device_init(intf, &dw3101_properties,
> -                       THIS_MODULE, NULL, adapter_nr) ||
> +                       THIS_MODULE, NULL, adapter_nr, NULL) ||
>             0 =3D=3D dvb_usb_device_init(intf, &s6x0_properties,
> -                       THIS_MODULE, NULL, adapter_nr) ||
> +                       THIS_MODULE, NULL, adapter_nr, NULL) ||
>             0 =3D=3D dvb_usb_device_init(intf, p1100,
> -                       THIS_MODULE, NULL, adapter_nr) ||
> +                       THIS_MODULE, NULL, adapter_nr, NULL) ||
>             0 =3D=3D dvb_usb_device_init(intf, s660,
> -                       THIS_MODULE, NULL, adapter_nr) ||
> +                       THIS_MODULE, NULL, adapter_nr, NULL) ||
>             0 =3D=3D dvb_usb_device_init(intf, p7500,
> -                       THIS_MODULE, NULL, adapter_nr) ||
> +                       THIS_MODULE, NULL, adapter_nr, NULL) ||
>             0 =3D=3D dvb_usb_device_init(intf, s421,
> -                       THIS_MODULE, NULL, adapter_nr) ||
> +                       THIS_MODULE, NULL, adapter_nr, NULL) ||
>             0 =3D=3D dvb_usb_device_init(intf, &su3000_properties,
> -                        THIS_MODULE, NULL, adapter_nr) ||
> +                        THIS_MODULE, NULL, adapter_nr, NULL) ||
>             0 =3D=3D dvb_usb_device_init(intf, &t220_properties,
> -                        THIS_MODULE, NULL, adapter_nr) ||
> +                        THIS_MODULE, NULL, adapter_nr, NULL) ||
>             0 =3D=3D dvb_usb_device_init(intf, &tt_s2_4600_properties,
> -                        THIS_MODULE, NULL, adapter_nr))
> +                        THIS_MODULE, NULL, adapter_nr, NULL))
>                 return 0;
>
>         return -ENODEV;
> diff --git a/drivers/media/usb/dvb-usb/friio.c b/drivers/media/usb/dvb-us=
b/friio.c
> index 474a17e4db0c..3854ac7434ad 100644
> --- a/drivers/media/usb/dvb-usb/friio.c
> +++ b/drivers/media/usb/dvb-usb/friio.c
> @@ -437,7 +437,7 @@ static int friio_probe(struct usb_interface *intf,
>         }
>
>         ret =3D dvb_usb_device_init(intf, &friio_properties,
> -                                 THIS_MODULE, &d, adapter_nr);
> +                                 THIS_MODULE, &d, adapter_nr, NULL);
>         if (ret =3D=3D 0)
>                 friio_streaming_ctrl(&d->adapter[0], 1);
>
> diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-u=
sb/gp8psk.c
> index 2829e3082d15..cede0d8b0f8a 100644
> --- a/drivers/media/usb/dvb-usb/gp8psk.c
> +++ b/drivers/media/usb/dvb-usb/gp8psk.c
> @@ -262,7 +262,7 @@ static int gp8psk_usb_probe(struct usb_interface *int=
f,
>         int ret;
>         struct usb_device *udev =3D interface_to_usbdev(intf);
>         ret =3D dvb_usb_device_init(intf, &gp8psk_properties,
> -                                 THIS_MODULE, NULL, adapter_nr);
> +                                 THIS_MODULE, NULL, adapter_nr, NULL);
>         if (ret =3D=3D 0) {
>                 info("found Genpix USB device pID =3D %x (hex)",
>                         le16_to_cpu(udev->descriptor.idProduct));
> diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-us=
b/m920x.c
> index eafc5c82467f..b4c83f36abee 100644
> --- a/drivers/media/usb/dvb-usb/m920x.c
> +++ b/drivers/media/usb/dvb-usb/m920x.c
> @@ -835,14 +835,14 @@ static int m920x_probe(struct usb_interface *intf,
>                  */
>
>                 ret =3D dvb_usb_device_init(intf, &megasky_properties,
> -                                         THIS_MODULE, &d, adapter_nr);
> +                                         THIS_MODULE, &d, adapter_nr, NU=
LL);
>                 if (ret =3D=3D 0) {
>                         rc_init_seq =3D megasky_rc_init;
>                         goto found;
>                 }
>
>                 ret =3D dvb_usb_device_init(intf, &digivox_mini_ii_proper=
ties,
> -                                         THIS_MODULE, &d, adapter_nr);
> +                                         THIS_MODULE, &d, adapter_nr, NU=
LL);
>                 if (ret =3D=3D 0) {
>                         /* No remote control, so no rc_init_seq */
>                         goto found;
> @@ -850,28 +850,28 @@ static int m920x_probe(struct usb_interface *intf,
>
>                 /* This configures both tuners on the TV Walker Twin */
>                 ret =3D dvb_usb_device_init(intf, &tvwalkertwin_propertie=
s,
> -                                         THIS_MODULE, &d, adapter_nr);
> +                                         THIS_MODULE, &d, adapter_nr, NU=
LL);
>                 if (ret =3D=3D 0) {
>                         rc_init_seq =3D tvwalkertwin_rc_init;
>                         goto found;
>                 }
>
>                 ret =3D dvb_usb_device_init(intf, &dposh_properties,
> -                                         THIS_MODULE, &d, adapter_nr);
> +                                         THIS_MODULE, &d, adapter_nr, NU=
LL);
>                 if (ret =3D=3D 0) {
>                         /* Remote controller not supported yet. */
>                         goto found;
>                 }
>
>                 ret =3D dvb_usb_device_init(intf, &pinnacle_pctv310e_prop=
erties,
> -                                         THIS_MODULE, &d, adapter_nr);
> +                                         THIS_MODULE, &d, adapter_nr, NU=
LL);
>                 if (ret =3D=3D 0) {
>                         rc_init_seq =3D pinnacle310e_init;
>                         goto found;
>                 }
>
>                 ret =3D dvb_usb_device_init(intf, &vp7049_properties,
> -                                         THIS_MODULE, &d, adapter_nr);
> +                                         THIS_MODULE, &d, adapter_nr, NU=
LL);
>                 if (ret =3D=3D 0) {
>                         rc_init_seq =3D vp7049_rc_init;
>                         goto found;
> diff --git a/drivers/media/usb/dvb-usb/nova-t-usb2.c b/drivers/media/usb/=
dvb-usb/nova-t-usb2.c
> index 1babd3341910..0d8f06430ca5 100644
> --- a/drivers/media/usb/dvb-usb/nova-t-usb2.c
> +++ b/drivers/media/usb/dvb-usb/nova-t-usb2.c
> @@ -157,7 +157,7 @@ static int nova_t_probe(struct usb_interface *intf,
>                 const struct usb_device_id *id)
>  {
>         return dvb_usb_device_init(intf, &nova_t_properties,
> -                                  THIS_MODULE, NULL, adapter_nr);
> +                                  THIS_MODULE, NULL, adapter_nr, NULL);
>  }
>
>  /* do not change the order of the ID table */
> diff --git a/drivers/media/usb/dvb-usb/opera1.c b/drivers/media/usb/dvb-u=
sb/opera1.c
> index 2566d2f1c2ad..9f2f156e2939 100644
> --- a/drivers/media/usb/dvb-usb/opera1.c
> +++ b/drivers/media/usb/dvb-usb/opera1.c
> @@ -563,7 +563,7 @@ static int opera1_probe(struct usb_interface *intf,
>         }
>
>         if (0 !=3D dvb_usb_device_init(intf, &opera1_properties,
> -                                    THIS_MODULE, NULL, adapter_nr))
> +                                    THIS_MODULE, NULL, adapter_nr, NULL)=
)
>                 return -EINVAL;
>         return 0;
>  }
> diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb=
-usb/pctv452e.c
> index 07fa08be9e99..2f844ff39840 100644
> --- a/drivers/media/usb/dvb-usb/pctv452e.c
> +++ b/drivers/media/usb/dvb-usb/pctv452e.c
> @@ -1059,9 +1059,9 @@ static int pctv452e_usb_probe(struct usb_interface =
*intf,
>                                 const struct usb_device_id *id)
>  {
>         if (0 =3D=3D dvb_usb_device_init(intf, &pctv452e_properties,
> -                                       THIS_MODULE, NULL, adapter_nr) ||
> +                                       THIS_MODULE, NULL, adapter_nr, NU=
LL) ||
>             0 =3D=3D dvb_usb_device_init(intf, &tt_connect_s2_3600_proper=
ties,
> -                                       THIS_MODULE, NULL, adapter_nr))
> +                                       THIS_MODULE, NULL, adapter_nr, NU=
LL))
>                 return 0;
>
>         return -ENODEV;
> diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/u=
sb/dvb-usb/technisat-usb2.c
> index 4706628a3ed5..80fc5043e4cf 100644
> --- a/drivers/media/usb/dvb-usb/technisat-usb2.c
> +++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
> @@ -765,7 +765,7 @@ static int technisat_usb2_probe(struct usb_interface =
*intf,
>         struct dvb_usb_device *dev;
>
>         if (dvb_usb_device_init(intf, &technisat_usb2_devices, THIS_MODUL=
E,
> -                               &dev, adapter_nr) !=3D 0)
> +                               &dev, adapter_nr, NULL) !=3D 0)
>                 return -ENODEV;
>
>         if (dev) {
> diff --git a/drivers/media/usb/dvb-usb/ttusb2.c b/drivers/media/usb/dvb-u=
sb/ttusb2.c
> index ecc207fbaf3c..192057ea58c0 100644
> --- a/drivers/media/usb/dvb-usb/ttusb2.c
> +++ b/drivers/media/usb/dvb-usb/ttusb2.c
> @@ -604,11 +604,11 @@ static int ttusb2_probe(struct usb_interface *intf,
>                 const struct usb_device_id *id)
>  {
>         if (0 =3D=3D dvb_usb_device_init(intf, &ttusb2_properties,
> -                                    THIS_MODULE, NULL, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr, NULL)=
 ||
>             0 =3D=3D dvb_usb_device_init(intf, &ttusb2_properties_s2400,
> -                                    THIS_MODULE, NULL, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr, NULL)=
 ||
>             0 =3D=3D dvb_usb_device_init(intf, &ttusb2_properties_ct3650,
> -                                    THIS_MODULE, NULL, adapter_nr))
> +                                    THIS_MODULE, NULL, adapter_nr, NULL)=
)
>                 return 0;
>         return -ENODEV;
>  }
> diff --git a/drivers/media/usb/dvb-usb/umt-010.c b/drivers/media/usb/dvb-=
usb/umt-010.c
> index 58ad5b4f856c..9af8cca5f2d2 100644
> --- a/drivers/media/usb/dvb-usb/umt-010.c
> +++ b/drivers/media/usb/dvb-usb/umt-010.c
> @@ -78,7 +78,7 @@ static int umt_probe(struct usb_interface *intf,
>                 const struct usb_device_id *id)
>  {
>         if (0 =3D=3D dvb_usb_device_init(intf, &umt_properties,
> -                                    THIS_MODULE, NULL, adapter_nr))
> +                                    THIS_MODULE, NULL, adapter_nr, NULL)=
)
>                 return 0;
>         return -EINVAL;
>  }
> diff --git a/drivers/media/usb/dvb-usb/vp702x.c b/drivers/media/usb/dvb-u=
sb/vp702x.c
> index 40de33de90a7..e95a84e3f9de 100644
> --- a/drivers/media/usb/dvb-usb/vp702x.c
> +++ b/drivers/media/usb/dvb-usb/vp702x.c
> @@ -337,7 +337,7 @@ static int vp702x_usb_probe(struct usb_interface *int=
f,
>         int ret;
>
>         ret =3D dvb_usb_device_init(intf, &vp702x_properties,
> -                                  THIS_MODULE, &d, adapter_nr);
> +                                  THIS_MODULE, &d, adapter_nr, NULL);
>         if (ret)
>                 goto out;
>
> diff --git a/drivers/media/usb/dvb-usb/vp7045.c b/drivers/media/usb/dvb-u=
sb/vp7045.c
> index 13340af0d39c..350603bbe3da 100644
> --- a/drivers/media/usb/dvb-usb/vp7045.c
> +++ b/drivers/media/usb/dvb-usb/vp7045.c
> @@ -225,7 +225,7 @@ static int vp7045_usb_probe(struct usb_interface *int=
f,
>                 const struct usb_device_id *id)
>  {
>         return dvb_usb_device_init(intf, &vp7045_properties,
> -                                  THIS_MODULE, NULL, adapter_nr);
> +                                  THIS_MODULE, NULL, adapter_nr, NULL);
>  }
>
>  static struct usb_device_id vp7045_usb_table [] =3D {


Tried patch with no success. Again a NULL ptr dereferece.
Thanks J=C3=B6rg

Hardware name: FUJITSU LIFEBOOK A544/FJNBB35 , BIOS Version 1.17 05/09/2014
task: ffff8802134ac380 task.stack: ffff8801ed878000
RIP: 0010:[<ffffffffa406b444>]  [<ffffffffa406b444>] __mutex_init+0x4/0x30
RSP: 0018:ffff8801ed87bb98  EFLAGS: 00010206
RAX: 0000000000000050 RBX: ffff8801ef23c000 RCX: ffffea0007bc8f01
RDX: ffffffffc035ef84 RSI: ffffffffc035d772 RDI: 0000000000000048
RBP: ffffffffc035db00 R08: ffffffffffffffe1 R09: ffffffffa4c5fa90
R10: 0000000000000004 R11: 0000000000000000 R12: ffffffffc035d030
R13: ffff880214c93000 R14: 0000000000000000 R15: ffff88020d942400
FS:  00007fb1359ae880(0000) GS:ffff88021f380000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000048 CR3: 00000001f53a2000 CR4: 00000000001406e0
Stack:
 ffffffffc035d04e ffffffffc03555f0 ffffffffc035e970 ffffffffc035ddd0
 ffffffffc035ec80 00000000a4397a2f ffffffffc035ddd0 ffff880214c93098
 ffff880214c93000 ffffffffc035d8e8 ffff88020d942400 ffffffffc035d980
Call Trace:
 [<ffffffffc035d04e>] ? cinergyT2_init_mutex+0x1e/0x30 [dvb_usb_cinergyT2]
 [<ffffffffc03555f0>] ? dvb_usb_device_init+0x190/0x640 [dvb_usb]
 [<ffffffffa44326f3>] ? usb_probe_interface+0xf3/0x2a0
 [<ffffffffa438e348>] ? driver_probe_device+0x208/0x2b0
 [<ffffffffa438e477>] ? __driver_attach+0x87/0x90
 [<ffffffffa438e3f0>] ? driver_probe_device+0x2b0/0x2b0
 [<ffffffffa438c612>] ? bus_for_each_dev+0x52/0x80
 [<ffffffffa438d983>] ? bus_add_driver+0x1a3/0x220
 [<ffffffffa438ec06>] ? driver_register+0x56/0xd0
 [<ffffffffa4431527>] ? usb_register_driver+0x77/0x130
 [<ffffffffc0361000>] ? 0xffffffffc0361000
 [<ffffffffa4000426>] ? do_one_initcall+0x46/0x180
 [<ffffffffa40eb2c8>] ? free_vmap_area_noflush+0x38/0x70
 [<ffffffffa40f3844>] ? kmem_cache_alloc+0x84/0xc0
 [<ffffffffa40b802c>] ? do_init_module+0x50/0x1be
 [<ffffffffa4095adb>] ? load_module+0x1d8b/0x2100
 [<ffffffffa4093020>] ? find_symbol_in_section+0xa0/0xa0
 [<ffffffffa4095fe9>] ? SyS_finit_module+0x89/0x90
 [<ffffffffa46637a0>] ? entry_SYSCALL_64_fastpath+0x13/0x94
Code: 5b 48 89 ee 89 c2 5d e9 bb f9 ff ff 41 b8 00 04 00 00 eb b1 c6
83 a1 00 00 00 00 c7 43 38 ff ff ff ff e9 2f ff ff ff 48 8d 47 08 <c7>
07 01 00 00 00 c7 47 04 00 00 00 00 48 89 47 08 48 89 47 10
RIP  [<ffffffffa406b444>] __mutex_init+0x4/0x30
 RSP <ffff8801ed87bb98>
CR2: 0000000000000048
---[ end trace 03576741447cea2c ]---
