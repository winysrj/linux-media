Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34744 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932864AbcKKQnt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 11:43:49 -0500
MIME-Version: 1.0
In-Reply-To: <20161111115535.6aebf1e2@vela.lan>
References: <CADDKRnD6sQLsxwObi1Bo6k69P5ceqQHw7beT6C7TqZjUsDby+w@mail.gmail.com>
 <CA+55aFxXoc3GzAXWPZL=RB2xhmhP1acR3m2S_mdoiO97+80kDA@mail.gmail.com>
 <20161108182215.41f1f3d2@vento.lan> <CADDKRnD_+uhQc7GyK3FfnDSRUkL5WkZNV7F+TsEhhDdo6O=Vmw@mail.gmail.com>
 <CA+55aFwsYHbXFimTL137Zwbc0bhOmR+XzDnUBmM=Pgn+8xBnWw@mail.gmail.com>
 <20161110064047.1e0a6b4b@vento.lan> <CADDKRnCfHL6P=g87+04XimCUvPcD2GQgGmrQwm4Mq_OjvLD5rA@mail.gmail.com>
 <20161111115535.6aebf1e2@vela.lan>
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Date: Fri, 11 Nov 2016 17:43:47 +0100
Message-ID: <CADDKRnBkwiScZP0uStqdbNkd0jgqKKcJd4_dLLLMGx43b+_YUA@mail.gmail.com>
Subject: Re: [v4.9-rc4] dvb-usb/cinergyT2 NULL pointer dereference
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Benjamin Larsson <benjamin@southpole.se>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-11-11 14:55 GMT+01:00 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> Em Thu, 10 Nov 2016 12:15:39 +0100
> J=C3=B6rg Otte <jrg.otte@gmail.com> escreveu:
>
>> 2016-11-10 9:40 GMT+01:00 Mauro Carvalho Chehab <mchehab@s-opensource.co=
m>:
>> > Em Wed, 9 Nov 2016 11:07:35 -0800
>> > Linus Torvalds <torvalds@linux-foundation.org> escreveu:
>> >
>> >> On Wed, Nov 9, 2016 at 3:09 AM, J=C3=B6rg Otte <jrg.otte@gmail.com> w=
rote:
>> >> >
>> >> > Tried patch with no success. Again a NULL ptr dereferece.
>> >>
>> >> I suspect a much simpler approach is to just miove the "data_mutex"
>> >> away from the priv area and into "struct dvb_usb_device" and
>> >> "dvb_usb_adapter". Sure, that grows those structures a tiny bit, and
>> >> not every driver may need that mutex, but it simplifies things
>> >> enormously. Mauro?
>> >>
>> >>              Linus
>
>> The patch works for me.
>
> Thanks for testing! That's the (hopefully) final version of it,
> with the fix applied to the other dvb-usb drivers that use
> data_mutex (except for the frontend ones, with uses a different
> private structure, and where the mutex is initialized at attach).
>
> Benjamin,
>
> Could you please test it?
>
> Thanks!
> Mauro
>
> -
>
> [PATCH] dvb-usb: move data_mutex to struct dvb_usb_device
>
> The data_mutex is initialized too late, as it is needed for
> each device driver's power control, causing an OOPS:
>
>         dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' =
in warm state.
>         BUG: unable to handle kernel NULL pointer dereference at         =
  (null)
>         IP: [<ffffffff846617af>] __mutex_lock_slowpath+0x6f/0x100 PGD 0
>         Oops: 0002 [#1] SMP
>         Modules linked in: dvb_usb_cinergyT2(+) dvb_usb
>         CPU: 0 PID: 2029 Comm: modprobe Not tainted 4.9.0-rc4-dvbmod #24
>         Hardware name: FUJITSU LIFEBOOK A544/FJNBB35 , BIOS Version 1.17 =
05/09/2014
>         task: ffff88020e943840 task.stack: ffff8801f36ec000
>         RIP: 0010:[<ffffffff846617af>]  [<ffffffff846617af>] __mutex_lock=
_slowpath+0x6f/0x100
>         RSP: 0018:ffff8801f36efb10  EFLAGS: 00010282
>         RAX: 0000000000000000 RBX: ffff88021509bdc8 RCX: 00000000c0000100
>         RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88021509bdcc
>         RBP: ffff8801f36efb58 R08: ffff88021f216320 R09: 0000000000100000
>         R10: ffff88021f216320 R11: 00000023fee6c5a1 R12: ffff88020e943840
>         R13: ffff88021509bdcc R14: 00000000ffffffff R15: ffff88021509bdd0
>         FS:  00007f21adb86740(0000) GS:ffff88021f200000(0000) knlGS:00000=
00000000000
>         CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>         CR2: 0000000000000000 CR3: 0000000215bce000 CR4: 00000000001406f0
>         Stack:
>          ffff88021509bdd0 0000000000000000 0000000000000000 ffffffffc0137=
c80
>          ffff88021509bdc8 ffff8801f5944000 0000000000000001 ffffffffc0136=
b00
>          ffff880213e52000 ffff88021509bdc8 ffffffff84661856 ffff88021509b=
d80
>         Call Trace:
>          [<ffffffff84661856>] ? mutex_lock+0x16/0x25
>          [<ffffffffc013616f>] ? cinergyt2_power_ctrl+0x1f/0x60 [dvb_usb_c=
inergyT2]
>          [<ffffffffc012e67e>] ? dvb_usb_device_init+0x21e/0x5d0 [dvb_usb]
>          [<ffffffffc0136021>] ? cinergyt2_usb_probe+0x21/0x50 [dvb_usb_ci=
nergyT2]
>          [<ffffffff844326f3>] ? usb_probe_interface+0xf3/0x2a0
>          [<ffffffff8438e348>] ? driver_probe_device+0x208/0x2b0
>          [<ffffffff8438e477>] ? __driver_attach+0x87/0x90
>          [<ffffffff8438e3f0>] ? driver_probe_device+0x2b0/0x2b0
>          [<ffffffff8438c612>] ? bus_for_each_dev+0x52/0x80
>          [<ffffffff8438d983>] ? bus_add_driver+0x1a3/0x220
>          [<ffffffff8438ec06>] ? driver_register+0x56/0xd0
>          [<ffffffff84431527>] ? usb_register_driver+0x77/0x130
>          [<ffffffffc013a000>] ? 0xffffffffc013a000
>          [<ffffffff84000426>] ? do_one_initcall+0x46/0x180
>          [<ffffffff840eb2c8>] ? free_vmap_area_noflush+0x38/0x70
>          [<ffffffff840f3844>] ? kmem_cache_alloc+0x84/0xc0
>          [<ffffffff840b802c>] ? do_init_module+0x50/0x1be
>          [<ffffffff84095adb>] ? load_module+0x1d8b/0x2100
>          [<ffffffff84093020>] ? find_symbol_in_section+0xa0/0xa0
>          [<ffffffff84095fe9>] ? SyS_finit_module+0x89/0x90
>          [<ffffffff846637a0>] ? entry_SYSCALL_64_fastpath+0x13/0x94
>         Code: e8 a7 1d 00 00 8b 03 83 f8 01 0f 84 97 00 00 00 48 8b 43 10=
 4c 8d 7b 08 48 89 63 10 4c 89 3c 24 41 be ff ff ff ff 48 89 44 24 08 <48> =
89 20 4c 89 64 24 10 eb 1a 49 c7 44 24 08 02 00 00 00 c6 43 RIP  [<ffffffff=
846617af>] __mutex_lock_slowpath+0x6f/0x100 RSP <ffff8801f36efb10>
>         CR2: 0000000000000000
>
> So, move it to the struct dvb_usb_device and initialize it
> before calling the driver's callbacks.
>
> Reported-by: J=C3=B6rg Otte <jrg.otte@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>
> diff --git a/drivers/media/usb/dvb-usb/af9005.c b/drivers/media/usb/dvb-u=
sb/af9005.c
> index b257780fb380..7853261906b1 100644
> --- a/drivers/media/usb/dvb-usb/af9005.c
> +++ b/drivers/media/usb/dvb-usb/af9005.c
> @@ -53,7 +53,6 @@ struct af9005_device_state {
>         u8 sequence;
>         int led_state;
>         unsigned char data[256];
> -       struct mutex data_mutex;
>  };
>
>  static int af9005_generic_read_write(struct dvb_usb_device *d, u16 reg,
> @@ -72,7 +71,7 @@ static int af9005_generic_read_write(struct dvb_usb_dev=
ice *d, u16 reg,
>                 return -EINVAL;
>         }
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>         st->data[0] =3D 14;               /* rest of buffer length low */
>         st->data[1] =3D 0;                /* rest of buffer length high *=
/
>
> @@ -140,7 +139,7 @@ static int af9005_generic_read_write(struct dvb_usb_d=
evice *d, u16 reg,
>                         values[i] =3D st->data[8 + i];
>
>  ret:
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>         return ret;
>
>  }
> @@ -481,7 +480,7 @@ int af9005_send_command(struct dvb_usb_device *d, u8 =
command, u8 * wbuf,
>         }
>         packet_len =3D wlen + 5;
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>
>         st->data[0] =3D (u8) (packet_len & 0xff);
>         st->data[1] =3D (u8) ((packet_len & 0xff00) >> 8);
> @@ -512,7 +511,7 @@ int af9005_send_command(struct dvb_usb_device *d, u8 =
command, u8 * wbuf,
>                         rbuf[i] =3D st->data[i + 7];
>         }
>
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>         return ret;
>  }
>
> @@ -523,7 +522,7 @@ int af9005_read_eeprom(struct dvb_usb_device *d, u8 a=
ddress, u8 * values,
>         u8 seq;
>         int ret, i;
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>
>         memset(st->data, 0, sizeof(st->data));
>
> @@ -559,7 +558,7 @@ int af9005_read_eeprom(struct dvb_usb_device *d, u8 a=
ddress, u8 * values,
>                 for (i =3D 0; i < len; i++)
>                         values[i] =3D st->data[6 + i];
>         }
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>
>         return ret;
>  }
> @@ -847,7 +846,7 @@ static int af9005_rc_query(struct dvb_usb_device *d, =
u32 * event, int *state)
>                 return 0;
>         }
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>
>         /* deb_info("rc_query\n"); */
>         st->data[0] =3D 3;                /* rest of packet length low */
> @@ -890,7 +889,7 @@ static int af9005_rc_query(struct dvb_usb_device *d, =
u32 * event, int *state)
>         }
>
>  ret:
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>         return ret;
>  }
>
> @@ -1004,20 +1003,8 @@ static struct dvb_usb_device_properties af9005_pro=
perties;
>  static int af9005_usb_probe(struct usb_interface *intf,
>                             const struct usb_device_id *id)
>  {
> -       struct dvb_usb_device *d;
> -       struct af9005_device_state *st;
> -       int ret;
> -
> -       ret =3D dvb_usb_device_init(intf, &af9005_properties,
> -                                 THIS_MODULE, &d, adapter_nr);
> -
> -       if (ret < 0)
> -               return ret;
> -
> -       st =3D d->priv;
> -       mutex_init(&st->data_mutex);
> -
> -       return 0;
> +       return dvb_usb_device_init(intf, &af9005_properties,
> +                                 THIS_MODULE, NULL, adapter_nr);
>  }
>
>  enum af9005_usb_table_entry {
> diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/u=
sb/dvb-usb/cinergyT2-core.c
> index 8ac825413d5a..290275bc7fde 100644
> --- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
> +++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
> @@ -42,7 +42,6 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  struct cinergyt2_state {
>         u8 rc_counter;
>         unsigned char data[64];
> -       struct mutex data_mutex;
>  };
>
>  /* We are missing a release hook with usb_device data */
> @@ -56,12 +55,12 @@ static int cinergyt2_streaming_ctrl(struct dvb_usb_ad=
apter *adap, int enable)
>         struct cinergyt2_state *st =3D d->priv;
>         int ret;
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>         st->data[0] =3D CINERGYT2_EP1_CONTROL_STREAM_TRANSFER;
>         st->data[1] =3D enable ? 1 : 0;
>
>         ret =3D dvb_usb_generic_rw(d, st->data, 2, st->data, 64, 0);
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>
>         return ret;
>  }
> @@ -71,12 +70,12 @@ static int cinergyt2_power_ctrl(struct dvb_usb_device=
 *d, int enable)
>         struct cinergyt2_state *st =3D d->priv;
>         int ret;
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>         st->data[0] =3D CINERGYT2_EP1_SLEEP_MODE;
>         st->data[1] =3D enable ? 0 : 1;
>
>         ret =3D dvb_usb_generic_rw(d, st->data, 2, st->data, 3, 0);
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>
>         return ret;
>  }
> @@ -89,7 +88,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_ada=
pter *adap)
>
>         adap->fe_adap[0].fe =3D cinergyt2_fe_attach(adap->dev);
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>         st->data[0] =3D CINERGYT2_EP1_GET_FIRMWARE_VERSION;
>
>         ret =3D dvb_usb_generic_rw(d, st->data, 1, st->data, 3, 0);
> @@ -97,7 +96,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_ada=
pter *adap)
>                 deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep "
>                         "state info\n");
>         }
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>
>         /* Copy this pointer as we are gonna need it in the release phase=
 */
>         cinergyt2_usb_device =3D adap->dev;
> @@ -166,7 +165,7 @@ static int cinergyt2_rc_query(struct dvb_usb_device *=
d, u32 *event, int *state)
>
>         *state =3D REMOTE_NO_KEY_PRESSED;
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>         st->data[0] =3D CINERGYT2_EP1_GET_RC_EVENTS;
>
>         ret =3D dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
> @@ -202,29 +201,17 @@ static int cinergyt2_rc_query(struct dvb_usb_device=
 *d, u32 *event, int *state)
>         }
>
>  ret:
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>         return ret;
>  }
>
>  static int cinergyt2_usb_probe(struct usb_interface *intf,
>                                 const struct usb_device_id *id)
>  {
> -       struct dvb_usb_device *d;
> -       struct cinergyt2_state *st;
> -       int ret;
> -
> -       ret =3D dvb_usb_device_init(intf, &cinergyt2_properties,
> -                                 THIS_MODULE, &d, adapter_nr);
> -       if (ret < 0)
> -               return ret;
> -
> -       st =3D d->priv;
> -       mutex_init(&st->data_mutex);
> -
> -       return 0;
> +       return dvb_usb_device_init(intf, &cinergyt2_properties,
> +                                  THIS_MODULE, NULL, adapter_nr);
>  }
>
> -
>  static struct usb_device_id cinergyt2_usb_table[] =3D {
>         { USB_DEVICE(USB_VID_TERRATEC, 0x0038) },
>         { 0 }
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-us=
b/cxusb.c
> index 39772812269d..243403081fa5 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -68,7 +68,7 @@ static int cxusb_ctrl_msg(struct dvb_usb_device *d,
>
>         wo =3D (rbuf =3D=3D NULL || rlen =3D=3D 0); /* write-only */
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>         st->data[0] =3D cmd;
>         memcpy(&st->data[1], wbuf, wlen);
>         if (wo)
> @@ -77,7 +77,7 @@ static int cxusb_ctrl_msg(struct dvb_usb_device *d,
>                 ret =3D dvb_usb_generic_rw(d, st->data, 1 + wlen,
>                                          rbuf, rlen, 0);
>
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>         return ret;
>  }
>
> @@ -1461,43 +1461,36 @@ static struct dvb_usb_device_properties cxusb_myg=
ica_t230_properties;
>  static int cxusb_probe(struct usb_interface *intf,
>                        const struct usb_device_id *id)
>  {
> -       struct dvb_usb_device *d;
> -       struct cxusb_state *st;
> -
>         if (0 =3D=3D dvb_usb_device_init(intf, &cxusb_medion_properties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_lgh064f_pr=
operties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_dee1601_pr=
operties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_lgz201_pro=
perties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_dtt7579_pr=
operties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_dualdig4_p=
roperties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_bluebird_nano2_prop=
erties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf,
>                                 &cxusb_bluebird_nano2_needsfirmware_prope=
rties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_aver_a868r_properti=
es,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf,
>                                      &cxusb_bluebird_dualdig4_rev2_proper=
ties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_d680_dmb_properties=
,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_mygica_d689_propert=
ies,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &cxusb_mygica_t230_propert=
ies,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> -           0) {
> -               st =3D d->priv;
> -               mutex_init(&st->data_mutex);
> -
> +                                    THIS_MODULE, NULL, adapter_nr) ||
> +           0)
>                 return 0;
> -       }
>
>         return -EINVAL;
>  }
> diff --git a/drivers/media/usb/dvb-usb/cxusb.h b/drivers/media/usb/dvb-us=
b/cxusb.h
> index 9f3ee0e47d5c..18acda19527a 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.h
> +++ b/drivers/media/usb/dvb-usb/cxusb.h
> @@ -37,7 +37,6 @@ struct cxusb_state {
>         struct i2c_client *i2c_client_tuner;
>
>         unsigned char data[MAX_XFER_SIZE];
> -       struct mutex data_mutex;
>  };
>
>  #endif
> diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-=
usb/dtt200u.c
> index f88572c7ae7c..fcbff7fb0c4e 100644
> --- a/drivers/media/usb/dvb-usb/dtt200u.c
> +++ b/drivers/media/usb/dvb-usb/dtt200u.c
> @@ -22,7 +22,6 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>
>  struct dtt200u_state {
>         unsigned char data[80];
> -       struct mutex data_mutex;
>  };
>
>  static int dtt200u_power_ctrl(struct dvb_usb_device *d, int onoff)
> @@ -30,23 +29,24 @@ static int dtt200u_power_ctrl(struct dvb_usb_device *=
d, int onoff)
>         struct dtt200u_state *st =3D d->priv;
>         int ret =3D 0;
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>
>         st->data[0] =3D SET_INIT;
>
>         if (onoff)
>                 ret =3D dvb_usb_generic_write(d, st->data, 2);
>
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>         return ret;
>  }
>
>  static int dtt200u_streaming_ctrl(struct dvb_usb_adapter *adap, int onof=
f)
>  {
> -       struct dtt200u_state *st =3D adap->dev->priv;
> +       struct dvb_usb_device *d =3D adap->dev;
> +       struct dtt200u_state *st =3D d->priv;
>         int ret;
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>         st->data[0] =3D SET_STREAMING;
>         st->data[1] =3D onoff;
>
> @@ -61,26 +61,27 @@ static int dtt200u_streaming_ctrl(struct dvb_usb_adap=
ter *adap, int onoff)
>         ret =3D dvb_usb_generic_write(adap->dev, st->data, 1);
>
>  ret:
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>
>         return ret;
>  }
>
>  static int dtt200u_pid_filter(struct dvb_usb_adapter *adap, int index, u=
16 pid, int onoff)
>  {
> -       struct dtt200u_state *st =3D adap->dev->priv;
> +       struct dvb_usb_device *d =3D adap->dev;
> +       struct dtt200u_state *st =3D d->priv;
>         int ret;
>
>         pid =3D onoff ? pid : 0;
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>         st->data[0] =3D SET_PID_FILTER;
>         st->data[1] =3D index;
>         st->data[2] =3D pid & 0xff;
>         st->data[3] =3D (pid >> 8) & 0x1f;
>
>         ret =3D dvb_usb_generic_write(adap->dev, st->data, 4);
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>
>         return ret;
>  }
> @@ -91,7 +92,7 @@ static int dtt200u_rc_query(struct dvb_usb_device *d)
>         u32 scancode;
>         int ret;
>
> -       mutex_lock(&st->data_mutex);
> +       mutex_lock(&d->data_mutex);
>         st->data[0] =3D GET_RC_CODE;
>
>         ret =3D dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
> @@ -126,7 +127,7 @@ static int dtt200u_rc_query(struct dvb_usb_device *d)
>                 deb_info("st->data: %*ph\n", 5, st->data);
>
>  ret:
> -       mutex_unlock(&st->data_mutex);
> +       mutex_unlock(&d->data_mutex);
>         return ret;
>  }
>
> @@ -145,24 +146,17 @@ static struct dvb_usb_device_properties wt220u_migl=
ia_properties;
>  static int dtt200u_usb_probe(struct usb_interface *intf,
>                 const struct usb_device_id *id)
>  {
> -       struct dvb_usb_device *d;
> -       struct dtt200u_state *st;
> -
>         if (0 =3D=3D dvb_usb_device_init(intf, &dtt200u_properties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &wt220u_properties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &wt220u_fc_properties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &wt220u_zl0353_properties,
> -                                    THIS_MODULE, &d, adapter_nr) ||
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0 =3D=3D dvb_usb_device_init(intf, &wt220u_miglia_properties,
> -                                    THIS_MODULE, &d, adapter_nr)) {
> -               st =3D d->priv;
> -               mutex_init(&st->data_mutex);
> -
> +                                    THIS_MODULE, NULL, adapter_nr))
>                 return 0;
> -       }
>
>         return -ENODEV;
>  }
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb=
/dvb-usb/dvb-usb-init.c
> index 3896ba9a4179..84308569e7dc 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
> +++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
> @@ -142,6 +142,7 @@ static int dvb_usb_init(struct dvb_usb_device *d, sho=
rt *adapter_nums)
>  {
>         int ret =3D 0;
>
> +       mutex_init(&d->data_mutex);
>         mutex_init(&d->usb_mutex);
>         mutex_init(&d->i2c_mutex);
>
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-=
usb/dvb-usb.h
> index 1448c3d27ea2..67f898b6f6d0 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb.h
> +++ b/drivers/media/usb/dvb-usb/dvb-usb.h
> @@ -404,8 +404,12 @@ struct dvb_usb_adapter {
>   *  Powered is in/decremented for each call to modify the state.
>   * @udev: pointer to the device's struct usb_device.
>   *
> - * @usb_mutex: semaphore of USB control messages (reading needs two mess=
ages)
> - * @i2c_mutex: semaphore for i2c-transfers
> + * @data_mutex: mutex to protect the data structure used to store URB da=
ta
> + * @usb_mutex: mutex of USB control messages (reading needs two messages=
).
> + *     Please notice that this mutex is used internally at the generic
> + *     URB control functions. So, drivers using dvb_usb_generic_rw() and
> + *     derivated functions should not lock it internally.
> + * @i2c_mutex: mutex for i2c-transfers
>   *
>   * @i2c_adap: device's i2c_adapter if it uses I2CoverUSB
>   *
> @@ -433,6 +437,7 @@ struct dvb_usb_device {
>         int powered;
>
>         /* locking */
> +       struct mutex data_mutex;
>         struct mutex usb_mutex;
>
>         /* i2c */

The patch works for me.
Note that my build environment builds a minimum kernel and only
compiles cinergyT2 parts of the patch.

Thanks, J=C3=B6rg
