Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr820131.outbound.protection.outlook.com ([40.107.82.131]:45600
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730860AbeKTJci (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 04:32:38 -0500
From: Ken Sloat <KSloat@aampglobal.com>
To: "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "wenyou.yang@microchip.com" <wenyou.yang@microchip.com>
Subject: MICROCHIP ISC DRIVER Bug: Possible NULL struct pointer dereference
 case
Date: Mon, 19 Nov 2018 23:06:31 +0000
Message-ID: <BL0PR07MB41151F40A163E75C8F73E1D6ADD80@BL0PR07MB4115.namprd07.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have discovered a bug in the Atmel/Microchip ISC driver while developing =
a i2c v4l2 sub-device driver. This bug did not previously occur for me on a=
n older version of the driver (more details below), but I have confirmed th=
is bug on a platform based on the SAMA5D2 running a newer kernel v4.20 from=
 the media tree. I am running the Atmel ISC drivers as built-in and the mod=
ule I am developing as an LKM (though the problem will still occur if built=
-in as well). Specifically I get a kernel oops when my driver is loaded and=
 the ISC driver attempts to initialize my sub-device.

The bug summary  is as follows:
There is a case where a NULL pointer dereference can possibly occur in rega=
rds to isc->raw_fmt

Details:
isc->raw_fmt is NULL by default. It is referenced in functions such as isc_=
try_fmt()

i.e.
if (sensor_is_preferred(isc_fmt))
	mbus_code =3D isc_fmt->mbus_code;
else
	mbus_code =3D isc->raw_fmt->mbus_code;


and is only set in one place as far as I can see:
isc_formats_init()

if (fmt->flags & FMT_FLAG_RAW_FORMAT)
	isc->raw_fmt =3D fmt;

These statements and the others are missing checks or handling for a possib=
le NULL pointer, so if they are hit this will cause a kernel oops. Accordin=
g to git bisect, in my current use case, this does not occur until the foll=
owing commit:

commit f103ea11cd037943b511fa71c852ff14cc6de8ee
Author: Wenyou Yang <wenyou.yang@microchip.com>
Date:   Tue Oct 10 04:46:40 2017 +0200

    media: atmel-isc: Rework the format list
   =20
    To improve the readability of code, split the format array into two,
    one for the format description, other for the register configuration.
    Meanwhile, add the flag member to indicate the format can be achieved
    from the sensor or be produced by the controller, and rename members
    related to the register configuration.
   =20
    Also add more formats support: GREY, ARGB444, ARGB555 and ARGB32.
   =20
    Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>


Specifically, this is caused by the introduction of new format flag stateme=
nts which possibly prevent isc-raw_fmt from being set:

        while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
               NULL, &mbus_code)) {
                mbus_code.index++;
+
                fmt =3D find_format_by_code(mbus_code.code, &i);
-               if (!fmt)
+               if ((!fmt) || (!(fmt->flags & FMT_FLAG_FROM_SENSOR)))
                        continue;
=20
                fmt->sd_support =3D true;
=20
-               if (i <=3D RAW_FMT_IND_END) {
-                       for (j =3D ISC_FMT_IND_START; j <=3D ISC_FMT_IND_EN=
D; j++)
-                               isc_formats[j].isc_support =3D true;
-
+               if (fmt->flags & FMT_FLAG_RAW_FORMAT)
                        isc->raw_fmt =3D fmt;
-               }
        }

I am happy to provide any more details as needed as well as submit a patch =
if I can understand a correct fix. A log of my kernel oops message follows:

Unable to handle kernel NULL pointer dereference at virtual address 0000000=
4
pgd =3D a9560d56
[00000004] *pgd=3D232d7831, *pte=3D00000000, *ppte=3D00000000
Internal error: Oops: 17 [#1] ARM
Modules linked in: tw9990(FO+)
CPU: 0 PID: 519 Comm: insmod Tainted: GF          O      4.20.0-rc1-00084-g=
d1a71a33591d-dirty #2
Hardware name: Atmel SAMA5
PC is at isc_try_fmt+0x20c/0x22c
LR is at isc_try_fmt+0x38/0x22c
pc : [<c0526748>]    lr : [<c0526574>]    psr: 200e0013
sp : c29a3a68  ip : 00000008  fp : c0d0f3b8
r10: c0c03008  r9 : 00000000  r8 : 00000000
r7 : c0d0f010  r6 : c0c03008  r5 : c29a3b38  r4 : c0c2ce88
r3 : 00000280  r2 : 00000000  r1 : 000001e0  r0 : c29a3abc
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c53c7d  Table: 22864059  DAC: 00000051
Process insmod (pid: 519, stack limit =3D 0x5f911b4f)
Stack: (0xc29a3a68 to 0xc29a4000)
3a60:                   00000000 c0c0a8e0 c0c03008 c29a1c1c c29a3ad4 c07590=
c4
3a80: 0c000000 00000000 400e0013 83edcaea c0c03008 c29a2000 c0c0fb80 c0c030=
08
3aa0: c0c0fb60 ffffb5af c0c0fb80 c29a3ad4 c29a3ac4 c07594a0 400e0013 000000=
00
3ac0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
3ae0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
3b00: 00000000 00000000 00000000 00000000 00000000 83edcaea c0c03008 c0d0f0=
10
3b20: 00000008 00000001 c0d0f010 c0d0fe74 c0c03008 c05268f4 00000001 000002=
80
3b40: 000001e0 32315559 00000001 00000000 00000000 00000000 00000000 000000=
00
3b60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
3b80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
3ba0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
3bc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
3be0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
3c00: 00000000 83edcaea c0c2cf08 c0d0f060 00000008 c0527fe0 00000051 c0d4e0=
40
3c20: 00000035 00000001 c29a3c24 83edcaea c0d4e040 00000000 00000002 c0d0f0=
b8
3c40: 00000035 00000000 00000001 00002008 00000001 00000000 00000000 000000=
00
3c60: 00000000 00000000 00000000 00000000 00000000 83edcaea c225aa14 c225aa=
14
3c80: c0c2cb18 c0d06118 c225aac0 00000000 00000009 00000000 c0c03008 c051bb=
40
3ca0: bf001094 c0d53400 c225aa10 c225aa14 00000005 bf00036c 00000088 c0d4e1=
fc
3cc0: c0d53420 bf000174 bf00201c c0d53400 00000000 c04fd490 c0c63f08 c0d534=
20
3ce0: 00000000 c0c63f0c bf00201c c041d778 c0d53420 bf00201c c0d53454 c0c030=
08
3d00: 00000000 c4cf6000 bf002200 c041dab0 00000000 c056ac08 c0d53400 c0d534=
20
3d20: bf00201c c0d53454 c0c03008 00000000 c4cf6000 bf002200 c0c03008 c041dc=
94
3d40: 00000000 bf00201c c041dbb8 c041bb64 00000000 c3b4adcc c0d519b0 83edca=
ea
3d60: c0c2be90 bf00201c c2998b80 c0c2be90 00000000 c041cc24 bf0012b8 bf0022=
00
3d80: bf00201c bf00201c c0c03008 ffffe000 bf0003a8 c041e5b4 bf002000 c0c030=
08
3da0: ffffe000 c04fdd80 c0c41940 c0c03008 ffffe000 bf0003cc c0c41940 c01025=
d8
3dc0: c307ce40 00000000 00000001 00000000 00000001 83edcaea 00000000 c3b3d5=
40
3de0: c307ce40 83edcaea a00b0013 a00b0013 c307ce40 006000c0 c3b4cc00 c4cf8f=
ff
3e00: ffe00000 fffff000 00000000 83edcaea bf002200 00000001 c29963c0 c27e8f=
00
3e20: c29963e4 bf002200 c0c03008 c016de28 00000001 c29963e4 c4cf6000 c29a3f=
40
3e40: 00000001 c29963c0 00000001 c016cff8 bf00220c 00007fff bf002200 c016a4=
70
3e60: bf002248 c0c03008 bf0022e8 c09d5d90 bf002368 c0801e70 c0969e44 c0969e=
50
3e80: c0969ea8 c0c03008 00000000 00000000 00000000 ffffe000 bf000000 00001d=
30
3ea0: 00000000 00000000 00000000 00000000 00000000 00000000 6e72656b 00006c=
65
3ec0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
3ee0: 00000000 00000000 00000000 00000000 00000000 83edcaea 7fffffff c0c030=
08
3f00: 00000003 00000003 00028df0 c0101204 c29a2000 0000017b 00000000 c016d7=
44
3f20: 7fffffff 00000000 00000003 00000001 bebd7bdc c4cf6000 00001d30 000000=
00
3f40: c4cf662a c4cf6a00 c4cf6000 00001d30 c4cf7948 c4cf7864 c4cf7188 000030=
00
3f60: 000032f0 00000000 00000000 00000000 0000096c 00000017 00000018 000000=
0e
3f80: 00000000 00000009 00000000 83edcaea 00000000 0003c150 00000003 00026a=
b4
3fa0: 0000017b c0101000 0003c150 00000003 00000003 00028df0 00000003 000000=
00
3fc0: 0003c150 00000003 00026ab4 0000017b 00000000 00000003 b6fbcfa4 000000=
00
3fe0: bebd7be0 bebd7bd0 0001fe10 b6ef2130 60060010 00000003 00000000 000000=
00
[<c0526748>] (isc_try_fmt) from [<c05268f4>] (isc_set_default_fmt+0x6c/0xb4=
)
[<c05268f4>] (isc_set_default_fmt) from [<c0527fe0>] (isc_async_complete+0x=
260/0x53c)
[<c0527fe0>] (isc_async_complete) from [<c051bb40>] (v4l2_async_register_su=
bdev+0x1a4/0x1b8)
[<c051bb40>] (v4l2_async_register_subdev) from [<bf00036c>] (tw9990_probe+0=
x1f8/0x234 [tw9990])
[<bf00036c>] (tw9990_probe [tw9990]) from [<c04fd490>] (i2c_device_probe+0x=
1dc/0x248)
[<c04fd490>] (i2c_device_probe) from [<c041d778>] (really_probe+0xf8/0x2cc)
[<c041d778>] (really_probe) from [<c041dab0>] (driver_probe_device+0x60/0x1=
68)
[<c041dab0>] (driver_probe_device) from [<c041dc94>] (__driver_attach+0xdc/=
0xe0)
[<c041dc94>] (__driver_attach) from [<c041bb64>] (bus_for_each_dev+0x68/0xb=
4)
[<c041bb64>] (bus_for_each_dev) from [<c041cc24>] (bus_add_driver+0x100/0x2=
0c)
[<c041cc24>] (bus_add_driver) from [<c041e5b4>] (driver_register+0x78/0x10c=
)
[<c041e5b4>] (driver_register) from [<c04fdd80>] (i2c_register_driver+0x3c/=
0x7c)
[<c04fdd80>] (i2c_register_driver) from [<bf0003cc>] (tw9990_init+0x24/0x2c=
 [tw9990])
[<bf0003cc>] (tw9990_init [tw9990]) from [<c01025d8>] (do_one_initcall+0x54=
/0x194)
[<c01025d8>] (do_one_initcall) from [<c016de28>] (do_init_module+0x60/0x1d8=
)
[<c016de28>] (do_init_module) from [<c016cff8>] (load_module+0x1de8/0x22e4)
[<c016cff8>] (load_module) from [<c016d744>] (sys_finit_module+0xc8/0xd8)
[<c016d744>] (sys_finit_module) from [<c0101000>] (ret_fast_syscall+0x0/0x5=
4)
Exception stack(0xc29a3fa8 to 0xc29a3ff0)
3fa0:                   0003c150 00000003 00000003 00028df0 00000003 000000=
00
3fc0: 0003c150 00000003 00026ab4 0000017b 00000000 00000003 b6fbcfa4 000000=
00
3fe0: bebd7be0 bebd7bd0 0001fe10 b6ef2130
Code: e5d4200e e3520000 0affffbe e59725c0 (e592a004)
---[ end trace fdc3db2f91ac07c6 ]---

Thanks,
Ken Sloat
