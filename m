Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48195 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaBKXjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 18:39:15 -0500
Received: by mail-wi0-f177.google.com with SMTP id e4so5658022wiv.16
        for <linux-media@vger.kernel.org>; Tue, 11 Feb 2014 15:39:14 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Antti =?ISO-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] ir-rc5-sz: Add ir encoding support
Date: Tue, 11 Feb 2014 23:39:04 +0000
Message-ID: <1757001.8sWyckB0oo@radagast>
In-Reply-To: <CAKv9HNbh39=QjyHggge3w-ke658ndCnPP+0EqPL9iUFrf3+imQ@mail.gmail.com>
References: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com> <2457095.pZsX4lrjVF@radagast> <CAKv9HNbh39=QjyHggge3w-ke658ndCnPP+0EqPL9iUFrf3+imQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2040785.NtubJjih8L"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2040785.NtubJjih8L
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Tuesday 11 February 2014 20:14:19 Antti Sepp=E4l=E4 wrote:
> On 10 February 2014 22:50, James Hogan <james.hogan@imgtec.com> wrote=
:
> >> > I suspect it needs some more space at the end too, to be sure th=
at no
> >> > more bits afterwards are accepted.
> >>=20
> >> I'm sorry but I'm not sure I completely understood what you meant
> >> here. For RC-5-SZ the entire scancode gets encoded and nothing mor=
e.
> >> Do you mean that the encoder should append some ir silence to the =
end
> >> result to make sure the ir sample has ended?
> >=20
> > Yeh something like that. Certainly the raw decoders I've looked at =
expect
> > a
> > certain amount of space at the end to avoid decoding part of a long=
er
> > protocol (it's in the pulse distance helper as the trailer space ti=
ming).
> > Similarly the IMG hardware decoder has register fields for the free=
-time
> > to require at the end of the message.
> >=20
> > In fact it becomes a bit awkward for the raw IR driver for the IMG
> > hardware
> > which uses edge interrupts, as it has to have a timeout to emit a f=
inal
> > repeat event after 150ms of inactivity, in order for the raw decode=
rs to
> > accept it (unless you hold the button down in which case the repeat=
 code
> > edges result in the long space).
>=20
> Ok, I understand now.
>=20
> I suppose I can append some IR silence to the encoded result. The
> trailer space timing seems like a good way to do it. I'll create new
> version of my patches sometime later.
>=20
> Are you working on the wakeup protocol selector sysfs interface?

I gave it a try yesterday, but it's a bit of a work in progress at the =
moment.
It's also a bit more effort for img-ir to work properly with it, so I'd=

probably just limit the allowed wakeup protocols to the enabled normal
protocol at first in img-ir.

Here's what I have (hopefully kmail won't corrupt it), feel free to tak=
e and
improve/fix it. I'm not keen on the invasiveness of the
allowed_protos/enabled_protocols change (which isn't complete), but it
should probably be abstracted at some point anyway.

Cheers
James

diff --git a/Documentation/ABI/testing/sysfs-class-rc b/Documentation/A=
BI/testing/sysfs-class-rc
index c0e1d14..1e4ecc8 100644
--- a/Documentation/ABI/testing/sysfs-class-rc
+++ b/Documentation/ABI/testing/sysfs-class-rc
@@ -61,6 +61,25 @@ Description:
 =09=09an error.
 =09=09This value may be reset to 0 if the current protocol is altered.=

=20
+What:=09=09/sys/class/rc/rcN/wakeup_protocol
+Date:=09=09Feb 2014
+KernelVersion:=093.15
+Contact:=09Mauro Carvalho Chehab <m.chehab@samsung.com>
+Description:
+=09=09Reading this file returns a list of available protocols to use
+=09=09for the wakeup filter, something like:
+=09=09    "rc5 rc6 nec jvc [sony]"
+=09=09The enabled wakeup protocol is shown in [] brackets.
+=09=09Writing "+proto" will add a protocol to the list of enabled
+=09=09wakeup protocols.
+=09=09Writing "-proto" will remove a protocol from the list of enabled=

+=09=09wakeup protocols.
+=09=09Writing "proto" will use "proto" for wakeup events.
+=09=09Writing "none" will disable wakeup.
+=09=09Write fails with EINVAL if more than one protocol would be
+=09=09enabled, an unknown protocol name is used, or if wakeup is not
+=09=09supported by the hardware.
+
 What:=09=09/sys/class/rc/rcN/wakeup_filter
 Date:=09=09Jan 2014
 KernelVersion:=093.15
@@ -74,7 +93,7 @@ Description:
 =09=09scancodes which match the filter will wake the system from e.g.
 =09=09suspend to RAM or power off.
 =09=09Otherwise the write will fail with an error.
-=09=09This value may be reset to 0 if the current protocol is altered.=

+=09=09This value may be reset to 0 if the wakeup protocol is altered.
=20
 What:=09=09/sys/class/rc/rcN/wakeup_filter_mask
 Date:=09=09Jan 2014
@@ -89,4 +108,4 @@ Description:
 =09=09scancodes which match the filter will wake the system from e.g.
 =09=09suspend to RAM or power off.
 =09=09Otherwise the write will fail with an error.
-=09=09This value may be reset to 0 if the current protocol is altered.=

+=09=09This value may be reset to 0 if the wakeup protocol is altered.
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jv=
c-decoder.c
index 3948138..7fb9467 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -47,7 +47,7 @@ static int ir_jvc_decode(struct rc_dev *dev, struct i=
r_raw_event ev)
 {
 =09struct jvc_dec *data =3D &dev->raw->jvc;
=20
-=09if (!(dev->enabled_protocols & RC_BIT_JVC))
+=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] & RC_BIT_JVC))
 =09=09return 0;
=20
 =09if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/i=
r-mce_kbd-decoder.c
index 9f3c9b5..bc93e11 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -216,7 +216,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, st=
ruct ir_raw_event ev)
 =09u32 scancode;
 =09unsigned long delay;
=20
-=09if (!(dev->enabled_protocols & RC_BIT_MCE_KBD))
+=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] & RC_BIT_MCE_KBD))
 =09=09return 0;
=20
 =09if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-ne=
c-decoder.c
index 5083ed6..f08010d 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -52,7 +52,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct i=
r_raw_event ev)
 =09u8 address, not_address, command, not_command;
 =09bool send_32bits =3D false;
=20
-=09if (!(dev->enabled_protocols & RC_BIT_NEC))
+=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] & RC_BIT_NEC))
 =09=09return 0;
=20
 =09if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index ae7b445..553937e 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -326,7 +326,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 =09=09return -ENOMEM;
=20
 =09dev->raw->dev =3D dev;
-=09dev->enabled_protocols =3D ~0;
+=09dev->enabled_protocols[RC_FILTER_NORMAL] =3D ~0;
 =09rc =3D kfifo_alloc(&dev->raw->kfifo,
 =09=09=09 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
 =09=09=09 GFP_KERNEL);
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc=
5-decoder.c
index 4e53a31..e0e5118 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -52,7 +52,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct i=
r_raw_event ev)
 =09u8 toggle;
 =09u32 scancode;
=20
-=09if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
+=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] & (RC_BIT_RC5 | RC_B=
IT_RC5X)))
 =09=09return 0;
=20
 =09if (!is_timing_event(ev)) {
@@ -128,7 +128,7 @@ again:
 =09=09if (data->wanted_bits =3D=3D RC5X_NBITS) {
 =09=09=09/* RC5X */
 =09=09=09u8 xdata, command, system;
-=09=09=09if (!(dev->enabled_protocols & RC_BIT_RC5X)) {
+=09=09=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] & RC_BIT_RC5X)=
) {
 =09=09=09=09data->state =3D STATE_INACTIVE;
 =09=09=09=09return 0;
 =09=09=09}
@@ -145,7 +145,7 @@ again:
 =09=09} else {
 =09=09=09/* RC5 */
 =09=09=09u8 command, system;
-=09=09=09if (!(dev->enabled_protocols & RC_BIT_RC5)) {
+=09=09=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] & RC_BIT_RC5))=
 {
 =09=09=09=09data->state =3D STATE_INACTIVE;
 =09=09=09=09return 0;
 =09=09=09}
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir=
-rc5-sz-decoder.c
index 865fe84..47de4b3 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -48,7 +48,7 @@ static int ir_rc5_sz_decode(struct rc_dev *dev, struc=
t ir_raw_event ev)
 =09u8 toggle, command, system;
 =09u32 scancode;
=20
-=09if (!(dev->enabled_protocols & RC_BIT_RC5_SZ))
+=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] & RC_BIT_RC5_SZ))
 =09=09return 0;
=20
 =09if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc=
6-decoder.c
index 7cba7d3..e2cee1d 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -89,7 +89,7 @@ static int ir_rc6_decode(struct rc_dev *dev, struct i=
r_raw_event ev)
 =09u32 scancode;
 =09u8 toggle;
=20
-=09if (!(dev->enabled_protocols &
+=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] &
 =09      (RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
 =09       RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)))
 =09=09return 0;
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-=
sanyo-decoder.c
index 0a06205..352bd37 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -58,7 +58,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct=
 ir_raw_event ev)
 =09u32 scancode;
 =09u8 address, command, not_command;
=20
-=09if (!(dev->enabled_protocols & RC_BIT_SANYO))
+=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] & RC_BIT_SANYO))
 =09=09return 0;
=20
 =09if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-=
sharp-decoder.c
index 4c17be5..e4e66f6 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -48,7 +48,7 @@ static int ir_sharp_decode(struct rc_dev *dev, struct=
 ir_raw_event ev)
 =09struct sharp_dec *data =3D &dev->raw->sharp;
 =09u32 msg, echo, address, command, scancode;
=20
-=09if (!(dev->enabled_protocols & RC_BIT_SHARP))
+=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] & RC_BIT_SHARP))
 =09=09return 0;
=20
 =09if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-s=
ony-decoder.c
index 29ab9c2..1c586603 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -45,7 +45,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct =
ir_raw_event ev)
 =09u32 scancode;
 =09u8 device, subdevice, function;
=20
-=09if (!(dev->enabled_protocols &
+=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] &
 =09      (RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20)))
 =09=09return 0;
=20
@@ -124,7 +124,8 @@ static int ir_sony_decode(struct rc_dev *dev, struc=
t ir_raw_event ev)
=20
 =09=09switch (data->count) {
 =09=09case 12:
-=09=09=09if (!(dev->enabled_protocols & RC_BIT_SONY12)) {
+=09=09=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] &
+=09=09=09=09=09=09=09RC_BIT_SONY12)) {
 =09=09=09=09data->state =3D STATE_INACTIVE;
 =09=09=09=09return 0;
 =09=09=09}
@@ -133,7 +134,8 @@ static int ir_sony_decode(struct rc_dev *dev, struc=
t ir_raw_event ev)
 =09=09=09function  =3D bitrev8((data->bits >>  4) & 0xFE);
 =09=09=09break;
 =09=09case 15:
-=09=09=09if (!(dev->enabled_protocols & RC_BIT_SONY15)) {
+=09=09=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] &
+=09=09=09=09=09=09=09RC_BIT_SONY15)) {
 =09=09=09=09data->state =3D STATE_INACTIVE;
 =09=09=09=09return 0;
 =09=09=09}
@@ -142,7 +144,8 @@ static int ir_sony_decode(struct rc_dev *dev, struc=
t ir_raw_event ev)
 =09=09=09function  =3D bitrev8((data->bits >>  7) & 0xFE);
 =09=09=09break;
 =09=09case 20:
-=09=09=09if (!(dev->enabled_protocols & RC_BIT_SONY20)) {
+=09=09=09if (!(dev->enabled_protocols[RC_FILTER_NORMAL] &
+=09=09=09=09=09=09=09RC_BIT_SONY20)) {
 =09=09=09=09data->state =3D STATE_INACTIVE;
 =09=09=09=09return 0;
 =09=09=09}
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopb=
ack.c
index 53d0282..b447045 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -195,7 +195,7 @@ static int __init loop_init(void)
 =09rc->map_name=09=09=3D RC_MAP_EMPTY;
 =09rc->priv=09=09=3D &loopdev;
 =09rc->driver_type=09=09=3D RC_DRIVER_IR_RAW;
-=09rc->allowed_protos=09=3D RC_BIT_ALL;
+=09rc->allowed_protos[RC_FILTER_NORMAL]=09=3D RC_BIT_ALL;
 =09rc->timeout=09=09=3D 100 * 1000 * 1000; /* 100 ms */
 =09rc->min_timeout=09=09=3D 1;
 =09rc->max_timeout=09=09=3D UINT_MAX;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 25b3f8f..4594b61 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -793,13 +793,38 @@ static struct {
 };
=20
 /**
- * show_protocols() - shows the current IR protocol(s)
+ * struct rc_filter_attribute - Device attribute relating to a filter =
type.
+ * @attr:=09Device attribute.
+ * @type:=09Filter type.
+ * @mask:=09false for filter value, true for filter mask.
+ */
+struct rc_filter_attribute {
+=09struct device_attribute=09=09attr;
+=09enum rc_filter_type=09=09type;
+=09bool=09=09=09=09mask;
+};
+#define to_rc_filter_attr(a) container_of(a, struct rc_filter_attribut=
e, attr)
+
+#define RC_PROTO_ATTR(_name, _mode, _show, _store, _type)=09=09\
+=09struct rc_filter_attribute dev_attr_##_name =3D {=09=09=09\
+=09=09.attr =3D __ATTR(_name, _mode, _show, _store),=09=09\
+=09=09.type =3D (_type),=09=09=09=09=09\
+=09}
+#define RC_FILTER_ATTR(_name, _mode, _show, _store, _type, _mask)=09\
+=09struct rc_filter_attribute dev_attr_##_name =3D {=09=09=09\
+=09=09.attr =3D __ATTR(_name, _mode, _show, _store),=09=09\
+=09=09.type =3D (_type),=09=09=09=09=09\
+=09=09.mask =3D (_mask),=09=09=09=09=09\
+=09}
+
+/**
+ * show_protocols() - shows the current/wakeup IR protocol(s)
  * @device:=09the device descriptor
  * @mattr:=09the device attribute struct (unused)
  * @buf:=09a pointer to the output buffer
  *
  * This routine is a callback routine for input read the IR protocol t=
ype(s).
- * it is trigged by reading /sys/class/rc/rc?/protocols.
+ * it is trigged by reading /sys/class/rc/rc?/[wakeup_]protocols.
  * It returns the protocol names of supported protocols.
  * Enabled protocols are printed in brackets.
  *
@@ -810,6 +835,7 @@ static ssize_t show_protocols(struct device *device=
,
 =09=09=09      struct device_attribute *mattr, char *buf)
 {
 =09struct rc_dev *dev =3D to_rc_dev(device);
+=09struct rc_filter_attribute *fattr =3D to_rc_filter_attr(mattr);
 =09u64 allowed, enabled;
 =09char *tmp =3D buf;
 =09int i;
@@ -820,11 +846,13 @@ static ssize_t show_protocols(struct device *devi=
ce,
=20
 =09mutex_lock(&dev->lock);
=20
-=09enabled =3D dev->enabled_protocols;
+=09enabled =3D dev->enabled_protocols[fattr->type];
 =09if (dev->driver_type =3D=3D RC_DRIVER_SCANCODE)
-=09=09allowed =3D dev->allowed_protos;
+=09=09allowed =3D dev->allowed_protos[fattr->type];
 =09else if (dev->raw)
-=09=09allowed =3D ir_raw_get_allowed_protocols();
+=09=09allowed =3D (fattr->type =3D=3D RC_FILTER_NORMAL)
+=09=09=09? ir_raw_get_allowed_protocols()
+=09=09=09: 0;
 =09else {
 =09=09mutex_unlock(&dev->lock);
 =09=09return -ENODEV;
@@ -854,14 +882,14 @@ static ssize_t show_protocols(struct device *devi=
ce,
 }
=20
 /**
- * store_protocols() - changes the current IR protocol(s)
+ * store_protocols() - changes the current/wakeup IR protocol(s)
  * @device:=09the device descriptor
  * @mattr:=09the device attribute struct (unused)
  * @buf:=09a pointer to the input buffer
  * @len:=09length of the input buffer
  *
  * This routine is for changing the IR protocol type.
- * It is trigged by writing to /sys/class/rc/rc?/protocols.
+ * It is trigged by writing to /sys/class/rc/rc?/[wakeup_]protocols.
  * Writing "+proto" will add a protocol to the list of enabled protoco=
ls.
  * Writing "-proto" will remove a protocol from the list of enabled pr=
otocols.
  * Writing "proto" will enable only "proto".
@@ -878,6 +906,7 @@ static ssize_t store_protocols(struct device *devic=
e,
 =09=09=09       size_t len)
 {
 =09struct rc_dev *dev =3D to_rc_dev(device);
+=09struct rc_filter_attribute *fattr =3D to_rc_filter_attr(mattr);
 =09bool enable, disable;
 =09const char *tmp;
 =09u64 type;
@@ -896,7 +925,7 @@ static ssize_t store_protocols(struct device *devic=
e,
 =09=09ret =3D -EINVAL;
 =09=09goto out;
 =09}
-=09type =3D dev->enabled_protocols;
+=09type =3D dev->enabled_protocols[fattr->type];
=20
 =09while ((tmp =3D strsep((char **) &data, " \n")) !=3D NULL) {
 =09=09if (!*tmp)
@@ -945,7 +974,7 @@ static ssize_t store_protocols(struct device *devic=
e,
 =09}
=20
 =09if (dev->change_protocol) {
-=09=09rc =3D dev->change_protocol(dev, &type);
+=09=09rc =3D dev->change_protocol(dev, fattr->type, &type);
 =09=09if (rc < 0) {
 =09=09=09IR_dprintk(1, "Error setting protocols to 0x%llx\n",
 =09=09=09=09   (long long)type);
@@ -954,7 +983,7 @@ static ssize_t store_protocols(struct device *devic=
e,
 =09=09}
 =09}
=20
-=09dev->enabled_protocols =3D type;
+=09dev->enabled_protocols[fattr->type] =3D type;
 =09IR_dprintk(1, "Current protocol(s): 0x%llx\n",
 =09=09   (long long)type);
=20
@@ -966,26 +995,6 @@ out:
 }
=20
 /**
- * struct rc_filter_attribute - Device attribute relating to a filter =
type.
- * @attr:=09Device attribute.
- * @type:=09Filter type.
- * @mask:=09false for filter value, true for filter mask.
- */
-struct rc_filter_attribute {
-=09struct device_attribute=09=09attr;
-=09enum rc_filter_type=09=09type;
-=09bool=09=09=09=09mask;
-};
-#define to_rc_filter_attr(a) container_of(a, struct rc_filter_attribut=
e, attr)
-
-#define RC_FILTER_ATTR(_name, _mode, _show, _store, _type, _mask)=09\
-=09struct rc_filter_attribute dev_attr_##_name =3D {=09=09=09\
-=09=09.attr =3D __ATTR(_name, _mode, _show, _store),=09=09\
-=09=09.type =3D (_type),=09=09=09=09=09\
-=09=09.mask =3D (_mask),=09=09=09=09=09\
-=09}
-
-/**
  * show_filter() - shows the current scancode filter value or mask
  * @device:=09the device descriptor
  * @attr:=09the device attribute struct
@@ -1118,8 +1127,10 @@ static int rc_dev_uevent(struct device *device, =
struct kobj_uevent_env *env)
 /*
  * Static device attribute struct with the sysfs attributes for IR's
  */
-static DEVICE_ATTR(protocols, S_IRUGO | S_IWUSR,
-=09=09   show_protocols, store_protocols);
+static RC_PROTO_ATTR(protocols, S_IRUGO | S_IWUSR,
+=09=09     show_protocols, store_protocols, RC_FILTER_NORMAL);
+static RC_PROTO_ATTR(wakeup_protocol, S_IRUGO | S_IWUSR,
+=09=09     show_protocols, store_protocols, RC_FILTER_WAKEUP);
 static RC_FILTER_ATTR(filter, S_IRUGO|S_IWUSR,
 =09=09      show_filter, store_filter, RC_FILTER_NORMAL, false);
 static RC_FILTER_ATTR(filter_mask, S_IRUGO|S_IWUSR,
@@ -1130,7 +1141,8 @@ static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO=
|S_IWUSR,
 =09=09      show_filter, store_filter, RC_FILTER_WAKEUP, true);
=20
 static struct attribute *rc_dev_attrs[] =3D {
-=09&dev_attr_protocols.attr,
+=09&dev_attr_protocols.attr.attr,
+=09&dev_attr_wakeup_protocol.attr.attr,
 =09&dev_attr_filter.attr.attr,
 =09&dev_attr_filter_mask.attr.attr,
 =09&dev_attr_wakeup_filter.attr.attr,
@@ -1296,10 +1308,10 @@ int rc_register_device(struct rc_dev *dev)
=20
 =09if (dev->change_protocol) {
 =09=09u64 rc_type =3D (1 << rc_map->rc_type);
-=09=09rc =3D dev->change_protocol(dev, &rc_type);
+=09=09rc =3D dev->change_protocol(dev, RC_FILTER_NORMAL, &rc_type);
 =09=09if (rc < 0)
 =09=09=09goto out_raw;
-=09=09dev->enabled_protocols =3D rc_type;
+=09=09dev->enabled_protocols[RC_FILTER_NORMAL] =3D rc_type;
 =09}
=20
 =09mutex_unlock(&dev->lock);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 7bd66be..eb47584 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -124,8 +124,8 @@ struct rc_dev {
 =09struct input_dev=09=09*input_dev;
 =09enum rc_driver_type=09=09driver_type;
 =09bool=09=09=09=09idle;
-=09u64=09=09=09=09allowed_protos;
-=09u64=09=09=09=09enabled_protocols;
+=09u64=09=09=09=09allowed_protos[RC_FILTER_MAX];
+=09u64=09=09=09=09enabled_protocols[RC_FILTER_MAX];
 =09u32=09=09=09=09users;
 =09u32=09=09=09=09scanmask;
 =09void=09=09=09=09*priv;
@@ -142,7 +142,9 @@ struct rc_dev {
 =09u32=09=09=09=09rx_resolution;
 =09u32=09=09=09=09tx_resolution;
 =09struct rc_scancode_filter=09scancode_filters[RC_FILTER_MAX];
-=09int=09=09=09=09(*change_protocol)(struct rc_dev *dev, u64 *rc_type)=
;
+=09int=09=09=09=09(*change_protocol)(struct rc_dev *dev,
+=09=09=09=09=09=09=09   enum rc_filter_type type,
+=09=09=09=09=09=09=09   u64 *rc_type);
 =09int=09=09=09=09(*open)(struct rc_dev *dev);
 =09void=09=09=09=09(*close)(struct rc_dev *dev);
 =09int=09=09=09=09(*s_tx_mask)(struct rc_dev *dev, u32 mask);

--nextPart2040785.NtubJjih8L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJS+rSfAAoJEKHZs+irPybf+SYP/2rsbBmDFNmdSbdw9JbZaFsU
+1g5q7VGdRXIcr3RbBj8twVmDzlYI9PsxlYOOBvpCVBEyZcMBJdOpAytYK7dglVA
bsKR94WGJglg1Ag1/eyCpMeGLbEikHfSoo5/G1wvUPu/pEgmVinza8/CCImCXBz/
Goaib4V0oZ9Z6Yorr4KfneT7nxZ8waUIabTmC3nm7ykQZuaG2mXsYRNqeLvF4Hpk
vPjc+n9Ejx3Yymx55CGPVDOpVwdYHTb6q+7ohPXyt23CTBiw6tL/2itygEukoowX
pa2bVecexQeAL9RwnBFaDdYMkqynZqiBykiXCU1wS9i/gGtHdeA9DG86cSNbXVhP
/J9amOAkp9zg8uhIN5tASm3ngOviOr4GpZwikoZwZ55AFZZI895viGzB6dXONq17
t5kW9/bwRRlyg0pl5GSeGiWjAAOGk1DR7ZrfLxmFQYMAmyiHdvA8yCKQYGDE4eoz
zOe8B5taHCVKgd7rt68E9hC5be/vsn3eMynG4tbI5tp3CeSBD8jsS+3a+L2aH9ak
SAQelOaS3nYRACbe4sIq5OKQ5HTsQyTOjldCwXWoMtevriKxTXfFnI291ATLt53w
vWjG0SREXItZAQoOB6SLAbHni13iTIfJjz/Kds/B+eHlFC6bxKO6WWTHF+gOTxTH
Ycjt4sr3KBWkRE6hSJlG
=4Qh+
-----END PGP SIGNATURE-----

--nextPart2040785.NtubJjih8L--

