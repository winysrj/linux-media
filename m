Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36669 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S980600AbdDYH6O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 03:58:14 -0400
Mime-Version: 1.0
Date: Tue, 25 Apr 2017 07:58:09 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <b5d0d7993ee9c705783e63ab228425d3@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [PATCH] rc-core: use the full 32 bits for NEC scancodes
To: "Sean Young" <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
In-Reply-To: <20170424155746.GA12437@gofer.mess.org>
References: <20170424155746.GA12437@gofer.mess.org>
 <149253062750.8732.14617348605110322157.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

April 24, 2017 5:58 PM, "Sean Young" <sean@mess.org> wrote:=0A> On Tue, A=
pr 18, 2017 at 05:50:27PM +0200, David H=C3=A4rdeman wrote:=0A>> Using th=
e full 32 bits for all kinds of NEC scancodes simplifies rc-core=0A>> and=
 the nec decoder without any loss of functionality. At the same time=0A>>=
 it ensures that scancodes for NEC16/NEC24/NEC32 do not overlap and=0A>> =
removes lots of duplication (as you can see from the patch, the same NEC=
=0A>> disambiguation logic is contained in several different drivers).=0A=
>> =0A>> Using NEC32 also removes ambiguity. For example, consider these =
two NEC=0A>> messages:=0A>> NEC16 message to address 0x05, command 0x03=
=0A>> NEC24 message to address 0x0005, command 0x03=0A>> =0A>> They'll bo=
th have scancode 0x00000503, and there's no way to tell which=0A>> messag=
e was received.=0A> =0A> More precisely, there is no way to tell which pr=
otocol variant it was sent=0A> with.=0A=0AOh, but there is. The driver/rc=
-core will know. It's just that userspace cannot ever know.=0A=0A> With t=
he Sony and rc6 protocols, you can also get the same scancode from=0A> di=
fferent protocol variants. I think the right solution is to pass the prot=
ocol=0A> variant to user space (and the keymap mapper).=0A=0AYes, I'm wor=
king on refreshing my patches to add a new EVIOCGKEYCODE_V2/EVIOCSKEYCODE=
_V2 ioctl which includes the protocol. And actually, those patches are gr=
eatly simplified by only using NEC32.=0A =0A> This also solves some other=
 problems, e.g. rc6_6a_20:0x75460 is also decoded=0A> by the sony protoco=
l decoder (as scancode 0).=0A=0AI know. And it also makes it possible to =
make /sys/class/rc/rc0/protocols fully automatic. And we could theoretica=
lly also refuse to set unsupported protocols in the keytable (not sure ye=
t if that's something we should do).=0A=0A>> In order to maintain backwar=
ds compatibility, some heuristics are added=0A>> in rc-main.c to convert =
scancodes to NEC32 as necessary when userspace=0A>> adds entries to the k=
eytable using the regular input ioctls.=0A> =0A> This is where it falls a=
part. In the patch below, you guess the protocol=0A> variant from the sca=
ncode value. By your own example above, nec24 with=0A> an address of 0x00=
05 would be not be possible in a keymap since it would=0A> guessed as nec=
16 (see to_nec32() below) and expanded to 0x05fb03fc. An=0A> actual nec24=
 would be 0x000503fc.=0A=0AIt's not 100% bulletproof. There's no way to f=
ix this issue in a 100% backwards compatible manner. But the future EVIOC=
GKEYCODE_V2/EVIOCSKEYCODE_V2 ioctl would make the heuristics unnecessary.=
=0A=0A>> These=0A>> heuristics are essentially the same as the ones that =
are currently in=0A>> drivers/media/rc/img-ir/img-ir-nec.c (which are ren=
dered unecessary=0A>> with this patch).=0A> =0A> Rendered unnecessary sin=
ce you moved it to core code. You've changed the=0A> img-ir filter functi=
onality in the process, breaking userspace.=0A=0AI doubt it can be fixed =
in a way which doesn't involve some userspace changes. But the breakage c=
an be minimized.=0A=0A> This is the scancode filter in the img-ir which a=
dmittedly isn't great,=0A> so I don't think we should introduce it elsewh=
ere. What would be much=0A> better would be if we could specify the proto=
col variants for ir decoding,=0A> rather than just "nec" or "sony" or "rc=
6". I'm not sure how to do this=0A> without breaking userspace though.=0A=
=0AI think the best way is by introducing the new ioctls.=0A=0AAnyway, I'=
ll try to post the whole patchset later today, then it should be clearer =
why this is a good change.=0A=0A>> The reason this has to be done now is =
that the newer sysfs wakefilter API=0A>> will expose the difference betwe=
en the NEC protocols to userspace for no=0A>> good reason and once expose=
d, it will be much more difficult to change the=0A>> logic.=0A>> =0A>> Si=
gned-off-by: David H=C3=A4rdeman <david@hardeman.nu>=0A>> ---=0A>> driver=
s/media/rc/igorplugusb.c | 4 +=0A>> drivers/media/rc/img-ir/img-ir-nec.c =
| 92 +++++++---------------------------=0A>> drivers/media/rc/ir-nec-deco=
der.c | 63 ++++-------------------=0A>> drivers/media/rc/rc-main.c | 74 +=
+++++++++++++++++++-------=0A>> drivers/media/rc/winbond-cir.c | 32 +----=
-------=0A>> 5 files changed, 89 insertions(+), 176 deletions(-)=0A>> =0A=
>> diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/c=
x88/cx88-input.c=0A>> index 01f2e472a2a0..61c46763ac97 100644=0A>> --- a/=
drivers/media/pci/cx88/cx88-input.c=0A>> +++ b/drivers/media/pci/cx88/cx8=
8-input.c=0A>> @@ -146,7 +146,7 @@ static void cx88_ir_handle_key(struct =
cx88_IR *ir)=0A>> scancode =3D RC_SCANCODE_NECX(addr, cmd);=0A>> =0A>> if=
 (0 =3D=3D (gpio & ir->mask_keyup))=0A>> - rc_keydown_notimeout(ir->dev, =
RC_TYPE_NECX, scancode,=0A>> + rc_keydown_notimeout(ir->dev, RC_TYPE_NEC,=
 scancode,=0A>> 0);=0A>> else=0A>> rc_keyup(ir->dev);=0A>> @@ -348,7 +348=
,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)=0A>> =
* 002-T mini RC, provided with newer PV hardware=0A>> */=0A>> ir_codes =
=3D RC_MAP_PIXELVIEW_MK12;=0A>> - rc_type =3D RC_BIT_NECX;=0A>> + rc_type=
 =3D RC_BIT_NEC;=0A>> ir->gpio_addr =3D MO_GP1_IO;=0A>> ir->mask_keyup =
=3D 0x80;=0A>> ir->polling =3D 10; /* ms */=0A>> diff --git a/drivers/med=
ia/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.=
c=0A>> index 78849c19f68a..47d8e055ddd3 100644=0A>> --- a/drivers/media/p=
ci/saa7134/saa7134-input.c=0A>> +++ b/drivers/media/pci/saa7134/saa7134-i=
nput.c=0A>> @@ -338,7 +338,7 @@ static int get_key_beholdm6xx(struct IR_i=
2c *ir, enum rc_type *protocol,=0A>> if (data[9] !=3D (unsigned char)(~da=
ta[8]))=0A>> return 0;=0A>> =0A>> - *protocol =3D RC_TYPE_NECX;=0A>> + *p=
rotocol =3D RC_TYPE_NEC;=0A>> *scancode =3D RC_SCANCODE_NECX(data[11] << =
8 | data[10], data[9]);=0A>> *toggle =3D 0;=0A>> return 1;=0A>> @@ -1028,=
7 +1028,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)=0A>> dev-=
>init_data.name =3D "BeholdTV";=0A>> dev->init_data.get_key =3D get_key_b=
eholdm6xx;=0A>> dev->init_data.ir_codes =3D RC_MAP_BEHOLD;=0A>> - dev->in=
it_data.type =3D RC_BIT_NECX;=0A>> + dev->init_data.type =3D RC_BIT_NEC;=
=0A>> info.addr =3D 0x2d;=0A>> break;=0A>> case SAA7134_BOARD_AVERMEDIA_C=
ARDBUS_501:=0A>> diff --git a/drivers/media/rc/igorplugusb.c b/drivers/me=
dia/rc/igorplugusb.c=0A>> index cb6d4f1247da..9e3119c94368 100644=0A>> --=
- a/drivers/media/rc/igorplugusb.c=0A>> +++ b/drivers/media/rc/igorplugus=
b.c=0A>> @@ -203,8 +203,8 @@ static int igorplugusb_probe(struct usb_inte=
rface *intf,=0A>> * for the NEC protocol and many others.=0A>> */=0A>> rc=
->allowed_protocols =3D RC_BIT_ALL_IR_DECODER & ~(RC_BIT_NEC |=0A>> - RC_=
BIT_NECX | RC_BIT_NEC32 | RC_BIT_RC6_6A_20 |=0A>> - RC_BIT_RC6_6A_24 | RC=
_BIT_RC6_6A_32 | RC_BIT_RC6_MCE |=0A>> + RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A=
_24 |=0A>> + RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE |=0A>> RC_BIT_SONY20 | RC_=
BIT_SANYO);=0A>> =0A>> rc->priv =3D ir;=0A>> diff --git a/drivers/media/r=
c/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c=0A>> index 0=
44fd42b22a0..56159bb44f9c 100644=0A>> --- a/drivers/media/rc/img-ir/img-i=
r-nec.c=0A>> +++ b/drivers/media/rc/img-ir/img-ir-nec.c=0A>> @@ -28,28 +2=
8,15 @@ static int img_ir_nec_scancode(int len, u64 raw, u64 enabled_prot=
ocols,=0A>> addr_inv =3D (raw >> 8) & 0xff;=0A>> data =3D (raw >> 16) & 0=
xff;=0A>> data_inv =3D (raw >> 24) & 0xff;=0A>> - if ((data_inv ^ data) !=
=3D 0xff) {=0A>> - /* 32-bit NEC (used by Apple and TiVo remotes) */=0A>>=
 - /* scan encoding: as transmitted, MSBit =3D first received bit */=0A>>=
 - request->scancode =3D bitrev8(addr) << 24 |=0A>> - bitrev8(addr_inv) <=
< 16 |=0A>> - bitrev8(data) << 8 |=0A>> - bitrev8(data_inv);=0A>> - reque=
st->protocol =3D RC_TYPE_NEC32;=0A>> - } else if ((addr_inv ^ addr) !=3D =
0xff) {=0A>> - /* Extended NEC */=0A>> - /* scan encoding: AAaaDD */=0A>>=
 - request->scancode =3D addr << 16 |=0A>> - addr_inv << 8 |=0A>> - data;=
=0A>> - request->protocol =3D RC_TYPE_NECX;=0A>> - } else {=0A>> - /* Nor=
mal NEC */=0A>> - /* scan encoding: AADD */=0A>> - request->scancode =3D =
addr << 8 |=0A>> - data;=0A>> - request->protocol =3D RC_TYPE_NEC;=0A>> -=
 }=0A>> +=0A>> + /* 32-bit NEC */=0A>> + /* scan encoding: as transmitted=
, MSBit =3D first received bit */=0A>> + request->scancode =3D=0A>> + bit=
rev8(addr) << 24 |=0A>> + bitrev8(addr_inv) << 16 |=0A>> + bitrev8(data) =
<< 8 |=0A>> + bitrev8(data_inv);=0A>> + request->protocol =3D RC_TYPE_NEC=
;=0A>> return IMG_IR_SCANCODE;=0A>> }=0A>> =0A>> @@ -60,55 +47,16 @@ stat=
ic int img_ir_nec_filter(const struct rc_scancode_filter *in,=0A>> unsign=
ed int addr, addr_inv, data, data_inv;=0A>> unsigned int addr_m, addr_inv=
_m, data_m, data_inv_m;=0A>> =0A>> - data =3D in->data & 0xff;=0A>> - dat=
a_m =3D in->mask & 0xff;=0A>> -=0A>> - protocols &=3D RC_BIT_NEC | RC_BIT=
_NECX | RC_BIT_NEC32;=0A>> -=0A>> - /*=0A>> - * If only one bit is set, w=
e were requested to do an exact=0A>> - * protocol. This should be the cas=
e for wakeup filters; for=0A>> - * normal filters, guess the protocol fro=
m the scancode.=0A>> - */=0A>> - if (!is_power_of_2(protocols)) {=0A>> - =
if ((in->data | in->mask) & 0xff000000)=0A>> - protocols =3D RC_BIT_NEC32=
;=0A>> - else if ((in->data | in->mask) & 0x00ff0000)=0A>> - protocols =
=3D RC_BIT_NECX;=0A>> - else=0A>> - protocols =3D RC_BIT_NEC;=0A>> - }=0A=
>> -=0A>> - if (protocols =3D=3D RC_BIT_NEC32) {=0A>> - /* 32-bit NEC (us=
ed by Apple and TiVo remotes) */=0A>> - /* scan encoding: as transmitted,=
 MSBit =3D first received bit */=0A>> - addr =3D bitrev8(in->data >> 24);=
=0A>> - addr_m =3D bitrev8(in->mask >> 24);=0A>> - addr_inv =3D bitrev8(i=
n->data >> 16);=0A>> - addr_inv_m =3D bitrev8(in->mask >> 16);=0A>> - dat=
a =3D bitrev8(in->data >> 8);=0A>> - data_m =3D bitrev8(in->mask >> 8);=
=0A>> - data_inv =3D bitrev8(in->data >> 0);=0A>> - data_inv_m =3D bitrev=
8(in->mask >> 0);=0A>> - } else if (protocols =3D=3D RC_BIT_NECX) {=0A>> =
- /* Extended NEC */=0A>> - /* scan encoding AAaaDD */=0A>> - addr =3D (i=
n->data >> 16) & 0xff;=0A>> - addr_m =3D (in->mask >> 16) & 0xff;=0A>> - =
addr_inv =3D (in->data >> 8) & 0xff;=0A>> - addr_inv_m =3D (in->mask >> 8=
) & 0xff;=0A>> - data_inv =3D data ^ 0xff;=0A>> - data_inv_m =3D data_m;=
=0A>> - } else {=0A>> - /* Normal NEC */=0A>> - /* scan encoding: AADD */=
=0A>> - addr =3D (in->data >> 8) & 0xff;=0A>> - addr_m =3D (in->mask >> 8=
) & 0xff;=0A>> - addr_inv =3D addr ^ 0xff;=0A>> - addr_inv_m =3D addr_m;=
=0A>> - data_inv =3D data ^ 0xff;=0A>> - data_inv_m =3D data_m;=0A>> - }=
=0A>> + /* 32-bit NEC */=0A>> + /* scan encoding: as transmitted, MSBit =
=3D first received bit */=0A>> + addr =3D bitrev8(in->data >> 24);=0A>> +=
 addr_m =3D bitrev8(in->mask >> 24);=0A>> + addr_inv =3D bitrev8(in->data=
 >> 16);=0A>> + addr_inv_m =3D bitrev8(in->mask >> 16);=0A>> + data =3D b=
itrev8(in->data >> 8);=0A>> + data_m =3D bitrev8(in->mask >> 8);=0A>> + d=
ata_inv =3D bitrev8(in->data >> 0);=0A>> + data_inv_m =3D bitrev8(in->mas=
k >> 0);=0A> =0A> If someone sets the filter and filter_mask to (say) 0xe=
100 and 0xff00=0A> respectively, then your change just broke it.=0A> =0A>=
> /* raw encoding: ddDDaaAA */=0A>> out->data =3D data_inv << 24 |=0A>> @=
@ -128,7 +76,7 @@ static int img_ir_nec_filter(const struct rc_scancode_f=
ilter *in,=0A>> * http://wiki.altium.com/display/ADOH/NEC+Infrared+Transm=
ission+Protocol=0A>> */=0A>> struct img_ir_decoder img_ir_nec =3D {=0A>> =
- .type =3D RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32,=0A>> + .type =3D RC_=
BIT_NEC,=0A>> .control =3D {=0A>> .decoden =3D 1,=0A>> .code_type =3D IMG=
_IR_CODETYPE_PULSEDIST,=0A>> diff --git a/drivers/media/rc/ir-nec-decoder=
.c b/drivers/media/rc/ir-nec-decoder.c=0A>> index 3ce850314dca..1f137dfa3=
eb3 100644=0A>> --- a/drivers/media/rc/ir-nec-decoder.c=0A>> +++ b/driver=
s/media/rc/ir-nec-decoder.c=0A>> @@ -49,9 +49,7 @@ static int ir_nec_deco=
de(struct rc_dev *dev, struct ir_raw_event ev)=0A>> {=0A>> struct nec_dec=
 *data =3D &dev->raw->nec;=0A>> u32 scancode;=0A>> - enum rc_type rc_type=
;=0A>> u8 address, not_address, command, not_command;=0A>> - bool send_32=
bits =3D false;=0A>> =0A>> if (!is_timing_event(ev)) {=0A>> if (ev.reset)=
=0A>> @@ -161,39 +159,14 @@ static int ir_nec_decode(struct rc_dev *dev, =
struct ir_raw_event ev)=0A>> command =3D bitrev8((data->bits >> 8) & 0xff=
);=0A>> not_command =3D bitrev8((data->bits >> 0) & 0xff);=0A>> =0A>> - i=
f ((command ^ not_command) !=3D 0xff) {=0A>> - IR_dprintk(1, "NEC checksu=
m error: received 0x%08x\n",=0A>> - data->bits);=0A>> - send_32bits =3D t=
rue;=0A>> - }=0A>> -=0A>> - if (send_32bits) {=0A>> - /* NEC transport, b=
ut modified protocol, used by at=0A>> - * least Apple and TiVo remotes */=
=0A>> - scancode =3D not_address << 24 |=0A>> - address << 16 |=0A>> - no=
t_command << 8 |=0A>> - command;=0A>> - IR_dprintk(1, "NEC (modified) sca=
ncode 0x%08x\n", scancode);=0A>> - rc_type =3D RC_TYPE_NEC32;=0A>> - } el=
se if ((address ^ not_address) !=3D 0xff) {=0A>> - /* Extended NEC */=0A>=
> - scancode =3D address << 16 |=0A>> - not_address << 8 |=0A>> - command=
;=0A>> - IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);=0A>> - r=
c_type =3D RC_TYPE_NECX;=0A>> - } else {=0A>> - /* Normal NEC */=0A>> - s=
cancode =3D address << 8 | command;=0A>> - IR_dprintk(1, "NEC scancode 0x=
%04x\n", scancode);=0A>> - rc_type =3D RC_TYPE_NEC;=0A>> - }=0A>> + scanc=
ode =3D RC_SCANCODE_NEC32(address << 24 | not_address << 16 |=0A>> + comm=
and << 8 | not_command);=0A>> + IR_dprintk(1, "NEC scancode 0x%08x\n", sc=
ancode);=0A>> =0A>> if (data->is_nec_x)=0A>> data->necx_repeat =3D true;=
=0A>> =0A>> - rc_keydown(dev, rc_type, scancode, 0);=0A>> + rc_keydown(de=
v, RC_TYPE_NEC, scancode, 0);=0A>> data->state =3D STATE_INACTIVE;=0A>> r=
eturn 0;=0A>> }=0A>> @@ -214,27 +187,11 @@ static u32 ir_nec_scancode_to_=
raw(enum rc_type protocol, u32 scancode)=0A>> {=0A>> unsigned int addr, a=
ddr_inv, data, data_inv;=0A>> =0A>> - data =3D scancode & 0xff;=0A>> -=0A=
>> - if (protocol =3D=3D RC_TYPE_NEC32) {=0A>> - /* 32-bit NEC (used by A=
pple and TiVo remotes) */=0A>> - /* scan encoding: aaAAddDD */=0A>> - add=
r_inv =3D (scancode >> 24) & 0xff;=0A>> - addr =3D (scancode >> 16) & 0xf=
f;=0A>> - data_inv =3D (scancode >> 8) & 0xff;=0A>> - } else if (protocol=
 =3D=3D RC_TYPE_NECX) {=0A>> - /* Extended NEC */=0A>> - /* scan encoding=
 AAaaDD */=0A>> - addr =3D (scancode >> 16) & 0xff;=0A>> - addr_inv =3D (=
scancode >> 8) & 0xff;=0A>> - data_inv =3D data ^ 0xff;=0A>> - } else {=
=0A>> - /* Normal NEC */=0A>> - /* scan encoding: AADD */=0A>> - addr =3D=
 (scancode >> 8) & 0xff;=0A>> - addr_inv =3D addr ^ 0xff;=0A>> - data_inv=
 =3D data ^ 0xff;=0A>> - }=0A>> + /* 32-bit NEC, scan encoding: aaAAddDD =
*/=0A>> + addr_inv =3D (scancode >> 24) & 0xff;=0A>> + addr =3D (scancode=
 >> 16) & 0xff;=0A>> + data_inv =3D (scancode >> 8) & 0xff;=0A>> + data =
=3D (scancode >> 0) & 0xff;=0A>> =0A>> /* raw encoding: ddDDaaAA */=0A>> =
return data_inv << 24 |=0A>> @@ -285,7 +242,7 @@ static int ir_nec_encode=
(enum rc_type protocol, u32 scancode,=0A>> }=0A>> =0A>> static struct ir_=
raw_handler nec_handler =3D {=0A>> - .protocols =3D RC_BIT_NEC | RC_BIT_N=
ECX | RC_BIT_NEC32,=0A>> + .protocols =3D RC_BIT_NEC,=0A>> .decode =3D ir=
_nec_decode,=0A>> .encode =3D ir_nec_encode,=0A>> };=0A>> diff --git a/dr=
ivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c=0A>> index 6ec73357=
fa47..196843c5a886 100644=0A>> --- a/drivers/media/rc/rc-main.c=0A>> +++ =
b/drivers/media/rc/rc-main.c=0A>> @@ -327,6 +327,49 @@ static unsigned in=
t ir_establish_scancode(struct rc_dev *dev,=0A>> }=0A>> =0A>> /**=0A>> + =
* guess_protocol() - heuristics to guess the protocol for a scancode=0A>>=
 + * @rdev: the struct rc_dev device descriptor=0A>> + * @return: the gue=
ssed RC_TYPE_* protocol=0A>> + *=0A>> + * Internal routine to guess the c=
urrent IR protocol for legacy ioctls.=0A>> + */=0A>> +static inline enum =
rc_type guess_protocol(struct rc_dev *rdev)=0A>> +{=0A>> + struct rc_map =
*rc_map =3D &rdev->rc_map;=0A>> +=0A>> + if (hweight64(rdev->enabled_prot=
ocols) =3D=3D 1)=0A>> + return rc_bitmap_to_type(rdev->enabled_protocols)=
;=0A>> + else if (hweight64(rdev->allowed_protocols) =3D=3D 1)=0A>> + ret=
urn rc_bitmap_to_type(rdev->allowed_protocols);=0A>> + else=0A>> + return=
 rc_map->rc_type;=0A>> +}=0A>> +=0A>> +/**=0A>> + * to_nec32() - helper f=
unction to try to convert misc NEC scancodes to NEC32=0A>> + * @orig: ori=
ginal scancode=0A>> + * @return: NEC32 scancode=0A>> + *=0A>> + * This he=
lper routine is used to provide backwards compatibility.=0A>> + */=0A>> +=
static u64 to_nec32(u64 orig)=0A>> +{=0A>> + u8 b3 =3D (u8)(orig >> 16);=
=0A>> + u8 b2 =3D (u8)(orig >> 8);=0A>> + u8 b1 =3D (u8)(orig >> 0);=0A>>=
 +=0A>> + if (orig <=3D 0xffff)=0A>> + /* Plain old NEC */=0A>> + return =
b2 << 24 | ((u8)~b2) << 16 | b1 << 8 | ((u8)~b1);=0A>> + else if (orig <=
=3D 0xffffff)=0A>> + /* NEC extended */=0A>> + return b3 << 24 | b2 << 16=
 | b1 << 8 | ((u8)~b1);=0A>> + else=0A>> + /* NEC32 */=0A>> + return orig=
;=0A>> +}=0A> =0A> So what about extended nec with an address < 0x100? Or=
 an nec32 with the=0A> upper 8 bits set to 0? This is no longer possible.=
=0A> =0A>> +=0A>> +/**=0A>> * ir_setkeycode() - set a keycode in the scan=
code->keycode table=0A>> * @idev: the struct input_dev device descriptor=
=0A>> * @scancode: the desired scancode=0A>> @@ -359,6 +402,9 @@ static i=
nt ir_setkeycode(struct input_dev *idev,=0A>> if (retval)=0A>> goto out;=
=0A>> =0A>> + if (guess_protocol(rdev) =3D=3D RC_TYPE_NEC)=0A>> + scancod=
e =3D to_nec32(scancode);=0A>> +=0A>> index =3D ir_establish_scancode(rde=
v, rc_map, scancode, true);=0A>> if (index >=3D rc_map->len) {=0A>> retva=
l =3D -ENOMEM;=0A>> @@ -399,7 +445,10 @@ static int ir_setkeytable(struct=
 rc_dev *dev,=0A>> =0A>> for (i =3D 0; i < from->size; i++) {=0A>> index =
=3D ir_establish_scancode(dev, rc_map,=0A>> - from->scan[i].scancode, fal=
se);=0A>> + from->rc_type =3D=3D RC_TYPE_NEC ?=0A>> + to_nec32(from->scan=
[i].scancode) :=0A>> + from->scan[i].scancode,=0A>> + false);=0A>> if (in=
dex >=3D rc_map->len) {=0A>> rc =3D -ENOMEM;=0A>> break;=0A>> @@ -473,6 +=
522,8 @@ static int ir_getkeycode(struct input_dev *idev,=0A>> if (retval=
)=0A>> goto out;=0A>> =0A>> + if (guess_protocol(rdev) =3D=3D RC_TYPE_NEC=
)=0A>> + scancode =3D to_nec32(scancode);=0A>> index =3D ir_lookup_by_sca=
ncode(rc_map, scancode);=0A>> }=0A>> =0A>> @@ -669,7 +720,6 @@ static voi=
d ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,=0A>> =0A>> led=
_trigger_event(led_feedback, LED_FULL);=0A>> }=0A>> -=0A>> input_sync(dev=
->input_dev);=0A>> }=0A>> =0A>> @@ -742,9 +792,7 @@ static int rc_validat=
e_filter(struct rc_dev *dev,=0A>> [RC_TYPE_SONY15] =3D 0xff007f,=0A>> [RC=
_TYPE_SONY20] =3D 0x1fff7f,=0A>> [RC_TYPE_JVC] =3D 0xffff,=0A>> - [RC_TYP=
E_NEC] =3D 0xffff,=0A>> - [RC_TYPE_NECX] =3D 0xffffff,=0A>> - [RC_TYPE_NE=
C32] =3D 0xffffffff,=0A>> + [RC_TYPE_NEC] =3D 0xffffffff,=0A>> [RC_TYPE_S=
ANYO] =3D 0x1fffff,=0A>> [RC_TYPE_MCIR2_KBD] =3D 0xffff,=0A>> [RC_TYPE_MC=
IR2_MSE] =3D 0x1fffff,=0A>> @@ -759,14 +807,6 @@ static int rc_validate_f=
ilter(struct rc_dev *dev,=0A>> enum rc_type protocol =3D dev->wakeup_prot=
ocol;=0A>> =0A>> switch (protocol) {=0A>> - case RC_TYPE_NECX:=0A>> - if =
((((s >> 16) ^ ~(s >> 8)) & 0xff) =3D=3D 0)=0A>> - return -EINVAL;=0A>> -=
 break;=0A>> - case RC_TYPE_NEC32:=0A>> - if ((((s >> 24) ^ ~(s >> 16)) &=
 0xff) =3D=3D 0)=0A>> - return -EINVAL;=0A>> - break;=0A>> case RC_TYPE_R=
C6_MCE:=0A>> if ((s & 0xffff0000) !=3D 0x800f0000)=0A>> return -EINVAL;=
=0A>> @@ -865,9 +905,7 @@ static const struct {=0A>> { RC_BIT_UNKNOWN, "u=
nknown", NULL },=0A>> { RC_BIT_RC5 |=0A>> RC_BIT_RC5X_20, "rc-5", "ir-rc5=
-decoder" },=0A>> - { RC_BIT_NEC |=0A>> - RC_BIT_NECX |=0A>> - RC_BIT_NEC=
32, "nec", "ir-nec-decoder" },=0A>> + { RC_BIT_NEC, "nec", "ir-nec-decode=
r" },=0A>> { RC_BIT_RC6_0 |=0A>> RC_BIT_RC6_6A_20 |=0A>> RC_BIT_RC6_6A_24=
 |=0A>> @@ -1330,7 +1368,7 @@ static ssize_t store_filter(struct device *=
device,=0A>> /*=0A>> * This is the list of all variants of all protocols,=
 which is used by=0A>> * the wakeup_protocols sysfs entry. In the protoco=
ls sysfs entry some=0A>> - * some protocols are grouped together (e.g. ne=
c =3D nec + necx + nec32).=0A>> + * some protocols are grouped together.=
=0A>> *=0A>> * For wakeup we need to know the exact protocol variant so t=
he hardware=0A>> * can be programmed exactly what to expect.=0A>> @@ -134=
6,8 +1384,6 @@ static const char * const proto_variant_names[] =3D {=0A>>=
 [RC_TYPE_SONY15] =3D "sony-15",=0A>> [RC_TYPE_SONY20] =3D "sony-20",=0A>=
> [RC_TYPE_NEC] =3D "nec",=0A>> - [RC_TYPE_NECX] =3D "nec-x",=0A>> - [RC_=
TYPE_NEC32] =3D "nec-32",=0A>> [RC_TYPE_SANYO] =3D "sanyo",=0A>> [RC_TYPE=
_MCIR2_KBD] =3D "mcir2-kbd",=0A>> [RC_TYPE_MCIR2_MSE] =3D "mcir2-mse",=0A=
>> diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond=
-cir.c=0A>> index 5a4d4a611197..914eab8df819 100644=0A>> --- a/drivers/me=
dia/rc/winbond-cir.c=0A>> +++ b/drivers/media/rc/winbond-cir.c=0A>> @@ -7=
15,34 +715,6 @@ wbcir_shutdown(struct pnp_dev *device)=0A>> break;=0A>> =
=0A>> case RC_TYPE_NEC:=0A>> - mask[1] =3D bitrev8(mask_sc);=0A>> - mask[=
0] =3D mask[1];=0A>> - mask[3] =3D bitrev8(mask_sc >> 8);=0A>> - mask[2] =
=3D mask[3];=0A>> -=0A>> - match[1] =3D bitrev8(wake_sc);=0A>> - match[0]=
 =3D ~match[1];=0A>> - match[3] =3D bitrev8(wake_sc >> 8);=0A>> - match[2=
] =3D ~match[3];=0A>> -=0A>> - proto =3D IR_PROTOCOL_NEC;=0A>> - break;=
=0A>> -=0A>> - case RC_TYPE_NECX:=0A>> - mask[1] =3D bitrev8(mask_sc);=0A=
>> - mask[0] =3D mask[1];=0A>> - mask[2] =3D bitrev8(mask_sc >> 8);=0A>> =
- mask[3] =3D bitrev8(mask_sc >> 16);=0A>> -=0A>> - match[1] =3D bitrev8(=
wake_sc);=0A>> - match[0] =3D ~match[1];=0A>> - match[2] =3D bitrev8(wake=
_sc >> 8);=0A>> - match[3] =3D bitrev8(wake_sc >> 16);=0A>> -=0A>> - prot=
o =3D IR_PROTOCOL_NEC;=0A>> - break;=0A>> -=0A>> - case RC_TYPE_NEC32:=0A=
>> mask[0] =3D bitrev8(mask_sc);=0A>> mask[1] =3D bitrev8(mask_sc >> 8);=
=0A>> mask[2] =3D bitrev8(mask_sc >> 16);=0A>> @@ -1087,8 +1059,8 @@ wbci=
r_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)=0A>> =
data->dev->max_timeout =3D 10 * IR_DEFAULT_TIMEOUT;=0A>> data->dev->rx_re=
solution =3D US_TO_NS(2);=0A>> data->dev->allowed_protocols =3D RC_BIT_AL=
L_IR_DECODER;=0A>> - data->dev->allowed_wakeup_protocols =3D RC_BIT_NEC |=
 RC_BIT_NECX |=0A>> - RC_BIT_NEC32 | RC_BIT_RC5 | RC_BIT_RC6_0 |=0A>> + d=
ata->dev->allowed_wakeup_protocols =3D=0A>> + RC_BIT_NEC | RC_BIT_RC5 | R=
C_BIT_RC6_0 |=0A>> RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |=0A>> RC_BIT_RC6_=
6A_32 | RC_BIT_RC6_MCE;=0A>> data->dev->wakeup_protocol =3D RC_TYPE_RC6_M=
CE;=0A>> diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/m=
edia/usb/au0828/au0828-input.c=0A>> index 9ec919c68482..545741feff2f 1006=
44=0A>> --- a/drivers/media/usb/au0828/au0828-input.c=0A>> +++ b/drivers/=
media/usb/au0828/au0828-input.c=0A>> @@ -343,8 +343,7 @@ int au0828_rc_re=
gister(struct au0828_dev *dev)=0A>> rc->input_id.product =3D le16_to_cpu(=
dev->usbdev->descriptor.idProduct);=0A>> rc->dev.parent =3D &dev->usbdev-=
>dev;=0A>> rc->driver_name =3D "au0828-input";=0A>> - rc->allowed_protoco=
ls =3D RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 |=0A>> - RC_BIT_RC5;=0A>> =
+ rc->allowed_protocols =3D RC_BIT_NEC | RC_BIT_RC5;=0A>> =0A>> /* all do=
ne */=0A>> err =3D rc_register_device(rc);=0A>> diff --git a/drivers/medi=
a/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c=0A>> in=
dex caa1e6101f58..ef1800206ca6 100644=0A>> --- a/drivers/media/usb/dvb-us=
b-v2/af9015.c=0A>> +++ b/drivers/media/usb/dvb-usb-v2/af9015.c=0A>> @@ -1=
218,7 +1218,6 @@ static int af9015_rc_query(struct dvb_usb_device *d)=0A>=
> =0A>> /* Only process key if canary killed */=0A>> if (buf[16] !=3D 0xf=
f && buf[0] !=3D 0x01) {=0A>> - enum rc_type proto;=0A>> dev_dbg(&d->udev=
->dev, "%s: key pressed %*ph\n",=0A>> __func__, 4, buf + 12);=0A>> =0A>> =
@@ -1229,28 +1228,11 @@ static int af9015_rc_query(struct dvb_usb_device =
*d)=0A>> =0A>> /* Remember this key */=0A>> memcpy(state->rc_last, &buf[1=
2], 4);=0A>> - if (buf[14] =3D=3D (u8) ~buf[15]) {=0A>> - if (buf[12] =3D=
=3D (u8) ~buf[13]) {=0A>> - /* NEC */=0A>> - state->rc_keycode =3D RC_SCA=
NCODE_NEC(buf[12],=0A>> - buf[14]);=0A>> - proto =3D RC_TYPE_NEC;=0A>> - =
} else {=0A>> - /* NEC extended*/=0A>> - state->rc_keycode =3D RC_SCANCOD=
E_NECX(buf[12] << 8 |=0A>> - buf[13],=0A>> - buf[14]);=0A>> - proto =3D R=
C_TYPE_NECX;=0A>> - }=0A>> - } else {=0A>> - /* 32 bit NEC */=0A>> - stat=
e->rc_keycode =3D RC_SCANCODE_NEC32(buf[12] << 24 |=0A>> - buf[13] << 16 =
|=0A>> - buf[14] << 8 |=0A>> - buf[15]);=0A>> - proto =3D RC_TYPE_NEC32;=
=0A>> - }=0A>> - rc_keydown(d->rc_dev, proto, state->rc_keycode, 0);=0A>>=
 + state->rc_keycode =3D RC_SCANCODE_NEC32(buf[12] << 24 |=0A>> + buf[13]=
 << 16 |=0A>> + buf[14] << 8 |=0A>> + buf[15]);=0A>> + rc_keydown(d->rc_d=
ev, RC_TYPE_NEC, state->rc_keycode, 0);=0A>> } else {=0A>> dev_dbg(&d->ud=
ev->dev, "%s: no key press\n", __func__);=0A>> /* Invalidate last keypres=
s */=0A>> @@ -1317,7 +1299,7 @@ static int af9015_get_rc_config(struct dv=
b_usb_device *d, struct dvb_usb_rc=0A>> *rc)=0A>> if (!rc->map_name)=0A>>=
 rc->map_name =3D RC_MAP_EMPTY;=0A>> =0A>> - rc->allowed_protos =3D RC_BI=
T_NEC | RC_BIT_NECX | RC_BIT_NEC32;=0A>> + rc->allowed_protos =3D RC_BIT_=
NEC;=0A>> rc->query =3D af9015_rc_query;=0A>> rc->interval =3D 500;=0A>> =
=0A>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/=
usb/dvb-usb-v2/af9035.c=0A>> index 4df9486e19b9..ccb2b4c673db 100644=0A>>=
 --- a/drivers/media/usb/dvb-usb-v2/af9035.c=0A>> +++ b/drivers/media/usb=
/dvb-usb-v2/af9035.c=0A>> @@ -1828,8 +1828,6 @@ static int af9035_rc_quer=
y(struct dvb_usb_device *d)=0A>> {=0A>> struct usb_interface *intf =3D d-=
>intf;=0A>> int ret;=0A>> - enum rc_type proto;=0A>> - u32 key;=0A>> u8 b=
uf[4];=0A>> struct usb_req req =3D { CMD_IR_GET, 0, 0, NULL, 4, buf };=0A=
>> =0A>> @@ -1839,26 +1837,12 @@ static int af9035_rc_query(struct dvb_us=
b_device *d)=0A>> else if (ret < 0)=0A>> goto err;=0A>> =0A>> - if ((buf[=
2] + buf[3]) =3D=3D 0xff) {=0A>> - if ((buf[0] + buf[1]) =3D=3D 0xff) {=
=0A>> - /* NEC standard 16bit */=0A>> - key =3D RC_SCANCODE_NEC(buf[0], b=
uf[2]);=0A>> - proto =3D RC_TYPE_NEC;=0A>> - } else {=0A>> - /* NEC exten=
ded 24bit */=0A>> - key =3D RC_SCANCODE_NECX(buf[0] << 8 | buf[1], buf[2]=
);=0A>> - proto =3D RC_TYPE_NECX;=0A>> - }=0A>> - } else {=0A>> - /* NEC =
full code 32bit */=0A>> - key =3D RC_SCANCODE_NEC32(buf[0] << 24 | buf[1]=
 << 16 |=0A>> - buf[2] << 8 | buf[3]);=0A>> - proto =3D RC_TYPE_NEC32;=0A=
>> - }=0A>> -=0A>> dev_dbg(&intf->dev, "%*ph\n", 4, buf);=0A>> =0A>> - rc=
_keydown(d->rc_dev, proto, key, 0);=0A>> + rc_keydown(d->rc_dev, RC_TYPE_=
NEC,=0A>> + RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |=0A>> + buf[2]=
 << 8 | buf[3]),=0A>> + 0);=0A>> =0A>> return 0;=0A>> =0A>> @@ -1881,8 +1=
865,7 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct=
 dvb_usb_rc=0A>> *rc)=0A>> switch (state->ir_type) {=0A>> case 0: /* NEC =
*/=0A>> default:=0A>> - rc->allowed_protos =3D RC_BIT_NEC | RC_BIT_NECX |=
=0A>> - RC_BIT_NEC32;=0A>> + rc->allowed_protos =3D RC_BIT_NEC;=0A>> brea=
k;=0A>> case 1: /* RC6 */=0A>> rc->allowed_protos =3D RC_BIT_RC6_MCE;=0A>=
> diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/=
dvb-usb-v2/az6007.c=0A>> index 50c07fe7dacb..7e3827843042 100644=0A>> ---=
 a/drivers/media/usb/dvb-usb-v2/az6007.c=0A>> +++ b/drivers/media/usb/dvb=
-usb-v2/az6007.c=0A>> @@ -208,31 +208,18 @@ static int az6007_rc_query(st=
ruct dvb_usb_device *d)=0A>> {=0A>> struct az6007_device_state *st =3D d_=
to_priv(d);=0A>> unsigned code;=0A>> - enum rc_type proto;=0A>> =0A>> az6=
007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);=0A>> =0A>> if (st->data[=
1] =3D=3D 0x44)=0A>> return 0;=0A>> =0A>> - if ((st->data[3] ^ st->data[4=
]) =3D=3D 0xff) {=0A>> - if ((st->data[1] ^ st->data[2]) =3D=3D 0xff) {=
=0A>> - code =3D RC_SCANCODE_NEC(st->data[1], st->data[3]);=0A>> - proto =
=3D RC_TYPE_NEC;=0A>> - } else {=0A>> - code =3D RC_SCANCODE_NECX(st->dat=
a[1] << 8 | st->data[2],=0A>> - st->data[3]);=0A>> - proto =3D RC_TYPE_NE=
CX;=0A>> - }=0A>> - } else {=0A>> - code =3D RC_SCANCODE_NEC32(st->data[1=
] << 24 |=0A>> - st->data[2] << 16 |=0A>> - st->data[3] << 8 |=0A>> - st-=
>data[4]);=0A>> - proto =3D RC_TYPE_NEC32;=0A>> - }=0A>> + code =3D RC_SC=
ANCODE_NEC32(st->data[1] << 24 |=0A>> + st->data[2] << 16 |=0A>> + st->da=
ta[3] << 8 |=0A>> + st->data[4]);=0A>> =0A>> - rc_keydown(d->rc_dev, prot=
o, code, st->data[5]);=0A>> + rc_keydown(d->rc_dev, RC_TYPE_NEC, code, st=
->data[5]);=0A>> =0A>> return 0;=0A>> }=0A>> @@ -241,7 +228,7 @@ static i=
nt az6007_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc=0A>> =
*rc)=0A>> {=0A>> pr_debug("Getting az6007 Remote Control properties\n");=
=0A>> =0A>> - rc->allowed_protos =3D RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NE=
C32;=0A>> + rc->allowed_protos =3D RC_BIT_NEC;=0A>> rc->query =3D az6007_=
rc_query;=0A>> rc->interval =3D 400;=0A>> =0A>> diff --git a/drivers/medi=
a/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c=0A>> =
index 924adfdb660d..860e9cf2ee4e 100644=0A>> --- a/drivers/media/usb/dvb-=
usb-v2/lmedm04.c=0A>> +++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c=0A>> @=
@ -349,8 +349,7 @@ static void lme2510_int_response(struct urb *lme_urb)=
=0A>> ibuf[5]);=0A>> =0A>> deb_info(1, "INT Key =3D 0x%08x", key);=0A>> -=
 rc_keydown(adap_to_d(adap)->rc_dev, RC_TYPE_NEC32, key,=0A>> - 0);=0A>> =
+ rc_keydown(adap_to_d(adap)->rc_dev, RC_TYPE_NEC, key, 0);=0A>> break;=
=0A>> case 0xbb:=0A>> switch (st->tuner_config) {=0A>> @@ -1233,7 +1232,7=
 @@ static int lme2510_get_stream_config(struct dvb_frontend *fe, u8 *ts_=
type,=0A>> static int lme2510_get_rc_config(struct dvb_usb_device *d,=0A>=
> struct dvb_usb_rc *rc)=0A>> {=0A>> - rc->allowed_protos =3D RC_BIT_NEC3=
2;=0A>> + rc->allowed_protos =3D RC_BIT_NEC;=0A>> return 0;=0A>> }=0A>> =
=0A>> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/medi=
a/usb/dvb-usb-v2/rtl28xxu.c=0A>> index e16ca07acf1d..06219abaef7b 100644=
=0A>> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c=0A>> +++ b/drivers/me=
dia/usb/dvb-usb-v2/rtl28xxu.c=0A>> @@ -1597,7 +1597,7 @@ static int rtl28=
31u_rc_query(struct dvb_usb_device *d)=0A>> int ret, i;=0A>> struct rtl28=
xxu_dev *dev =3D d->priv;=0A>> u8 buf[5];=0A>> - u32 rc_code;=0A>> + u64 =
rc_code;=0A>> struct rtl28xxu_reg_val rc_nec_tab[] =3D {=0A>> { 0x3033, 0=
x80 },=0A>> { 0x3020, 0x43 },=0A>> @@ -1631,27 +1631,12 @@ static int rtl=
2831u_rc_query(struct dvb_usb_device *d)=0A>> goto err;=0A>> =0A>> if (bu=
f[4] & 0x01) {=0A>> - enum rc_type proto;=0A>> + rc_code =3D RC_SCANCODE_=
NEC32(buf[0] << 24 |=0A>> + buf[1] << 16 |=0A>> + buf[2] << 8 |=0A>> + bu=
f[3]);=0A>> =0A>> - if (buf[2] =3D=3D (u8) ~buf[3]) {=0A>> - if (buf[0] =
=3D=3D (u8) ~buf[1]) {=0A>> - /* NEC standard (16 bit) */=0A>> - rc_code =
=3D RC_SCANCODE_NEC(buf[0], buf[2]);=0A>> - proto =3D RC_TYPE_NEC;=0A>> -=
 } else {=0A>> - /* NEC extended (24 bit) */=0A>> - rc_code =3D RC_SCANCO=
DE_NECX(buf[0] << 8 | buf[1],=0A>> - buf[2]);=0A>> - proto =3D RC_TYPE_NE=
CX;=0A>> - }=0A>> - } else {=0A>> - /* NEC full (32 bit) */=0A>> - rc_cod=
e =3D RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |=0A>> - buf[2] << 8 =
| buf[3]);=0A>> - proto =3D RC_TYPE_NEC32;=0A>> - }=0A>> -=0A>> - rc_keyd=
own(d->rc_dev, proto, rc_code, 0);=0A>> + rc_keydown(d->rc_dev, RC_TYPE_N=
EC, rc_code, 0);=0A>> =0A>> ret =3D rtl28xxu_wr_reg(d, SYS_IRRC_SR, 1);=
=0A>> if (ret)=0A>> @@ -1673,7 +1658,7 @@ static int rtl2831u_get_rc_conf=
ig(struct dvb_usb_device *d,=0A>> struct dvb_usb_rc *rc)=0A>> {=0A>> rc->=
map_name =3D RC_MAP_EMPTY;=0A>> - rc->allowed_protos =3D RC_BIT_NEC | RC_=
BIT_NECX | RC_BIT_NEC32;=0A>> + rc->allowed_protos =3D RC_BIT_NEC;=0A>> r=
c->query =3D rtl2831u_rc_query;=0A>> rc->interval =3D 400;=0A>> =0A>> dif=
f --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dv=
b-usb/dib0700_core.c=0A>> index 08acdd32e412..3267bc7ea9c5 100644=0A>> --=
- a/drivers/media/usb/dvb-usb/dib0700_core.c=0A>> +++ b/drivers/media/usb=
/dvb-usb/dib0700_core.c=0A>> @@ -734,6 +734,7 @@ static void dib0700_rc_u=
rb_completion(struct urb *purb)=0A>> =0A>> switch (d->props.rc.core.proto=
col) {=0A>> case RC_BIT_NEC:=0A>> + protocol =3D RC_TYPE_NEC;=0A>> toggle=
 =3D 0;=0A>> =0A>> /* NEC protocol sends repeat code as 0 0 0 FF */=0A>> =
@@ -746,26 +747,10 @@ static void dib0700_rc_urb_completion(struct urb *p=
urb)=0A>> goto resubmit;=0A>> }=0A>> =0A>> - if ((poll_reply->nec.data ^ =
poll_reply->nec.not_data) !=3D 0xff) {=0A>> - deb_data("NEC32 protocol\n"=
);=0A>> - keycode =3D RC_SCANCODE_NEC32(poll_reply->nec.system << 24 |=0A=
>> - poll_reply->nec.not_system << 16 |=0A>> - poll_reply->nec.data << 8 =
|=0A>> - poll_reply->nec.not_data);=0A>> - protocol =3D RC_TYPE_NEC32;=0A=
>> - } else if ((poll_reply->nec.system ^ poll_reply->nec.not_system) !=
=3D 0xff) {=0A>> - deb_data("NEC extended protocol\n");=0A>> - keycode =
=3D RC_SCANCODE_NECX(poll_reply->nec.system << 8 |=0A>> - poll_reply->nec=
.not_system,=0A>> - poll_reply->nec.data);=0A>> -=0A>> - protocol =3D RC_=
TYPE_NECX;=0A>> - } else {=0A>> - deb_data("NEC normal protocol\n");=0A>>=
 - keycode =3D RC_SCANCODE_NEC(poll_reply->nec.system,=0A>> - poll_reply-=
>nec.data);=0A>> - protocol =3D RC_TYPE_NEC;=0A>> - }=0A>> + keycode =3D =
RC_SCANCODE_NEC32(poll_reply->nec.system << 24 |=0A>> + poll_reply->nec.n=
ot_system << 16 |=0A>> + poll_reply->nec.data << 8 |=0A>> + poll_reply->n=
ec.not_data);=0A>> =0A>> break;=0A>> default:=0A>> diff --git a/drivers/m=
edia/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c=0A>> ind=
ex fcbff7fb0c4e..ffe987f72590 100644=0A>> --- a/drivers/media/usb/dvb-usb=
/dtt200u.c=0A>> +++ b/drivers/media/usb/dvb-usb/dtt200u.c=0A>> @@ -89,7 +=
89,6 @@ static int dtt200u_pid_filter(struct dvb_usb_adapter *adap, int i=
ndex, u16 pid,=0A>> static int dtt200u_rc_query(struct dvb_usb_device *d)=
=0A>> {=0A>> struct dtt200u_state *st =3D d->priv;=0A>> - u32 scancode;=
=0A>> int ret;=0A>> =0A>> mutex_lock(&d->data_mutex);=0A>> @@ -100,23 +99=
,13 @@ static int dtt200u_rc_query(struct dvb_usb_device *d)=0A>> goto re=
t;=0A>> =0A>> if (st->data[0] =3D=3D 1) {=0A>> - enum rc_type proto =3D R=
C_TYPE_NEC;=0A>> -=0A>> - scancode =3D st->data[1];=0A>> - if ((u8) ~st->=
data[1] !=3D st->data[2]) {=0A>> - /* Extended NEC */=0A>> - scancode =3D=
 scancode << 8;=0A>> - scancode |=3D st->data[2];=0A>> - proto =3D RC_TYP=
E_NECX;=0A>> - }=0A>> - scancode =3D scancode << 8;=0A>> - scancode |=3D =
st->data[3];=0A>> -=0A>> - /* Check command checksum is ok */=0A>> - if (=
(u8) ~st->data[3] =3D=3D st->data[4])=0A>> - rc_keydown(d->rc_dev, proto,=
 scancode, 0);=0A>> - else=0A>> - rc_keyup(d->rc_dev);=0A>> + u32 scancod=
e;=0A>> +=0A>> + scancode =3D RC_SCANCODE_NEC32((st->data[1] << 24) |=0A>=
> + (st->data[2] << 16) |=0A>> + (st->data[3] << 8) |=0A>> + (st->data[4]=
 << 0));=0A>> + rc_keydown(d->rc_dev, RC_TYPE_NEC, scancode, 0);=0A>> } e=
lse if (st->data[0] =3D=3D 2) {=0A>> rc_repeat(d->rc_dev);=0A>> } else {=
=0A>> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/medi=
a/usb/em28xx/em28xx-input.c=0A>> index eba75736e654..93c3fca7849a 100644=
=0A>> --- a/drivers/media/usb/em28xx/em28xx-input.c=0A>> +++ b/drivers/me=
dia/usb/em28xx/em28xx-input.c=0A>> @@ -259,21 +259,11 @@ static int em287=
4_polling_getkey(struct em28xx_IR *ir,=0A>> break;=0A>> =0A>> case RC_BIT=
_NEC:=0A>> - poll_result->scancode =3D msg[1] << 8 | msg[2];=0A>> - if ((=
msg[3] ^ msg[4]) !=3D 0xff) { /* 32 bits NEC */=0A>> - poll_result->proto=
col =3D RC_TYPE_NEC32;=0A>> - poll_result->scancode =3D RC_SCANCODE_NEC32=
((msg[1] << 24) |=0A>> - (msg[2] << 16) |=0A>> - (msg[3] << 8) |=0A>> - (=
msg[4]));=0A>> - } else if ((msg[1] ^ msg[2]) !=3D 0xff) { /* 24 bits NEC=
 */=0A>> - poll_result->protocol =3D RC_TYPE_NECX;=0A>> - poll_result->sc=
ancode =3D RC_SCANCODE_NECX(msg[1] << 8 |=0A>> - msg[2], msg[3]);=0A>> - =
} else { /* Normal NEC */=0A>> - poll_result->protocol =3D RC_TYPE_NEC;=
=0A>> - poll_result->scancode =3D RC_SCANCODE_NEC(msg[1], msg[3]);=0A>> -=
 }=0A>> + poll_result->protocol =3D RC_TYPE_NEC;=0A>> + poll_result->scan=
code =3D RC_SCANCODE_NEC32((msg[1] << 24) |=0A>> + (msg[2] << 16) |=0A>> =
+ (msg[3] << 8) |=0A>> + (msg[4]));=0A>> break;=0A>> =0A>> case RC_BIT_RC=
6_0:=0A>> @@ -780,7 +770,7 @@ static int em28xx_ir_init(struct em28xx *de=
v)=0A>> case CHIP_ID_EM28178:=0A>> ir->get_key =3D em2874_polling_getkey;=
=0A>> rc->allowed_protocols =3D RC_BIT_RC5 | RC_BIT_NEC |=0A>> - RC_BIT_N=
ECX | RC_BIT_NEC32 | RC_BIT_RC6_0;=0A>> + RC_BIT_RC6_0;=0A>> break;=0A>> =
default:=0A>> err =3D -ENODEV;=0A>> diff --git a/include/media/rc-map.h b=
/include/media/rc-map.h=0A>> index 1a815a572fa1..e5d0559dc523 100644=0A>>=
 --- a/include/media/rc-map.h=0A>> +++ b/include/media/rc-map.h=0A>> @@ -=
24,8 +24,6 @@=0A>> * @RC_TYPE_SONY15: Sony 15 bit protocol=0A>> * @RC_TYP=
E_SONY20: Sony 20 bit protocol=0A>> * @RC_TYPE_NEC: NEC protocol=0A>> - *=
 @RC_TYPE_NECX: Extended NEC protocol=0A>> - * @RC_TYPE_NEC32: NEC 32 bit=
 protocol=0A>> * @RC_TYPE_SANYO: Sanyo protocol=0A>> * @RC_TYPE_MCIR2_KBD=
: RC6-ish MCE keyboard=0A>> * @RC_TYPE_MCIR2_MSE: RC6-ish MCE mouse=0A>> =
@@ -49,21 +47,20 @@ enum rc_type {=0A>> RC_TYPE_SONY15 =3D 7,=0A>> RC_TYP=
E_SONY20 =3D 8,=0A>> RC_TYPE_NEC =3D 9,=0A>> - RC_TYPE_NECX =3D 10,=0A>> =
- RC_TYPE_NEC32 =3D 11,=0A>> - RC_TYPE_SANYO =3D 12,=0A>> - RC_TYPE_MCIR2=
_KBD =3D 13,=0A>> - RC_TYPE_MCIR2_MSE =3D 14,=0A>> - RC_TYPE_RC6_0 =3D 15=
,=0A>> - RC_TYPE_RC6_6A_20 =3D 16,=0A>> - RC_TYPE_RC6_6A_24 =3D 17,=0A>> =
- RC_TYPE_RC6_6A_32 =3D 18,=0A>> - RC_TYPE_RC6_MCE =3D 19,=0A>> - RC_TYPE=
_SHARP =3D 20,=0A>> - RC_TYPE_XMP =3D 21,=0A>> - RC_TYPE_CEC =3D 22,=0A>>=
 + RC_TYPE_SANYO =3D 10,=0A>> + RC_TYPE_MCIR2_KBD =3D 11,=0A>> + RC_TYPE_=
MCIR2_MSE =3D 12,=0A>> + RC_TYPE_RC6_0 =3D 13,=0A>> + RC_TYPE_RC6_6A_20 =
=3D 14,=0A>> + RC_TYPE_RC6_6A_24 =3D 15,=0A>> + RC_TYPE_RC6_6A_32 =3D 16,=
=0A>> + RC_TYPE_RC6_MCE =3D 17,=0A>> + RC_TYPE_SHARP =3D 18,=0A>> + RC_TY=
PE_XMP =3D 19,=0A>> + RC_TYPE_CEC =3D 20,=0A>> };=0A>> =0A>> +#define rc_=
bitmap_to_type(x) (fls64(x) - 1)=0A>> #define RC_BIT_NONE 0ULL=0A>> #defi=
ne RC_BIT_UNKNOWN BIT_ULL(RC_TYPE_UNKNOWN)=0A>> #define RC_BIT_OTHER BIT_=
ULL(RC_TYPE_OTHER)=0A>> @@ -75,8 +72,6 @@ enum rc_type {=0A>> #define RC_=
BIT_SONY15 BIT_ULL(RC_TYPE_SONY15)=0A>> #define RC_BIT_SONY20 BIT_ULL(RC_=
TYPE_SONY20)=0A>> #define RC_BIT_NEC BIT_ULL(RC_TYPE_NEC)=0A>> -#define R=
C_BIT_NECX BIT_ULL(RC_TYPE_NECX)=0A>> -#define RC_BIT_NEC32 BIT_ULL(RC_TY=
PE_NEC32)=0A>> #define RC_BIT_SANYO BIT_ULL(RC_TYPE_SANYO)=0A>> #define R=
C_BIT_MCIR2_KBD BIT_ULL(RC_TYPE_MCIR2_KBD)=0A>> #define RC_BIT_MCIR2_MSE =
BIT_ULL(RC_TYPE_MCIR2_MSE)=0A>> @@ -93,7 +88,7 @@ enum rc_type {=0A>> RC_=
BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ | \=0A>> RC_BIT_JVC | \=0A>> RC_=
BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \=0A>> - RC_BIT_NEC | RC_BIT=
_NECX | RC_BIT_NEC32 | \=0A>> + RC_BIT_NEC | \=0A>> RC_BIT_SANYO | \=0A>>=
 RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE | \=0A>> RC_BIT_RC6_0 | RC_BIT_RC6_6=
A_20 | RC_BIT_RC6_6A_24 | \=0A>> @@ -104,7 +99,7 @@ enum rc_type {=0A>> (=
RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ | \=0A>> RC_BIT_JVC | \=0A>> =
RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \=0A>> - RC_BIT_NEC | RC_=
BIT_NECX | RC_BIT_NEC32 | \=0A>> + RC_BIT_NEC | \=0A>> RC_BIT_SANYO | RC_=
BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE | \=0A>> RC_BIT_RC6_0 | RC_BIT_RC6_6A_20=
 | RC_BIT_RC6_6A_24 | \=0A>> RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_S=
HARP | \=0A>> @@ -114,7 +109,7 @@ enum rc_type {=0A>> (RC_BIT_RC5 | RC_BI=
T_RC5X_20 | RC_BIT_RC5_SZ | \=0A>> RC_BIT_JVC | \=0A>> RC_BIT_SONY12 | RC=
_BIT_SONY15 | RC_BIT_SONY20 | \=0A>> - RC_BIT_NEC | RC_BIT_NECX | RC_BIT_=
NEC32 | \=0A>> + RC_BIT_NEC | \=0A>> RC_BIT_SANYO | RC_BIT_MCIR2_KBD | RC=
_BIT_MCIR2_MSE | \=0A>> RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_2=
4 | \=0A>> RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | \=0A>> @@ -122,13 +117,20 =
@@ enum rc_type {=0A>> =0A>> #define RC_SCANCODE_UNKNOWN(x) (x)=0A>> #def=
ine RC_SCANCODE_OTHER(x) (x)=0A>> -#define RC_SCANCODE_NEC(addr, cmd) (((=
addr) << 8) | (cmd))=0A>> -#define RC_SCANCODE_NECX(addr, cmd) (((addr) <=
< 8) | (cmd))=0A>> -#define RC_SCANCODE_NEC32(data) ((data) & 0xffffffff)=
=0A>> #define RC_SCANCODE_RC5(sys, cmd) (((sys) << 8) | (cmd))=0A>> #defi=
ne RC_SCANCODE_RC5_SZ(sys, cmd) (((sys) << 8) | (cmd))=0A>> #define RC_SC=
ANCODE_RC6_0(sys, cmd) (((sys) << 8) | (cmd))=0A>> #define RC_SCANCODE_RC=
6_6A(vendor, sys, cmd) (((vendor) << 16) | ((sys) << 8) | (cmd))=0A>> +#d=
efine RC_SCANCODE_NEC(addr, cmd) \=0A>> + ((((addr) & 0xff) << 24) | \=0A=
>> + ((~(addr) & 0xff) << 16) | \=0A>> + (((cmd) & 0xff) << 8 ) | \=0A>> =
+ ((~(cmd) & 0xff) << 0 ))=0A>> +#define RC_SCANCODE_NECX(addr, cmd) \=0A=
>> + ((((addr) & 0xffff) << 16) | \=0A>> + (((cmd) & 0x00ff) << 8) | \=0A=
>> + ((~(cmd) & 0x00ff) << 0))=0A>> +#define RC_SCANCODE_NEC32(data) ((da=
ta) & 0xffffffff)=0A>> =0A>> /**=0A>> * struct rc_map_table - represents =
a scancode/keycode pair
