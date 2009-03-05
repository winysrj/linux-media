Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:13458 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbZCEAKc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 19:10:32 -0500
MIME-Version: 1.0
In-Reply-To: <49AEA071.9020900@maxwell.research.nokia.com>
References: <19F8576C6E063C45BE387C64729E73940427BCA193@dbde02.ent.ti.com>
	 <49AEA071.9020900@maxwell.research.nokia.com>
Date: Thu, 5 Mar 2009 09:10:30 +0900
Message-ID: <5e9665e10903041610q31385162ib39a4bc41296bdbc@mail.gmail.com>
Subject: Re: [RFC 0/9] OMAP3 ISP and camera drivers
From: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I'm also facing same issue with Hiremath.

Here you are my kernel stack dump.

Cheers,

Nate

[    6.465606] [<c019e194>] (dev_driver_string+0x0/0x44) from
[<c01cc5e0>] (omap34xxcam_device_register+0x110/0x2f8)
[    6.475952] [<c01cc4d0>] (omap34xxcam_device_register+0x0/0x2f8)
from [<c01b91a0>] (__v4l2_int_device_try_attach_all+0xb0/0x108)
[    6.487609]  r7:00000000 r6:c03e4fcc r5:cfbbf834 r4:c03e4f94
[    6.493347] [<c01b90f0>]
(__v4l2_int_device_try_attach_all+0x0/0x108) from [<c01b9258>]
(v4l2_int_device_register+0x60/0x7c)
[    6.504638]  r7:c03e4eec r6:cf9e5020 r5:c03e4f94 r4:c03e03f8
[    6.510375] [<c01b91f8>] (v4l2_int_device_register+0x0/0x7c) from
[<c00182e4>] (ce131f_probe+0x88/0xa8)
[    6.519836]  r5:00000000 r4:cf9e5000
[    6.523437] [<c001825c>] (ce131f_probe+0x0/0xa8) from [<c01cefa4>]
(i2c_device_probe+0x78/0x90)
[    6.532226]  r5:cf9e5000 r4:c001825c
[    6.535827] [<c01cef2c>] (i2c_device_probe+0x0/0x90) from
[<c01a1634>] (driver_probe_device+0xd4/0x180)
[    6.545318]  r7:c03e4eec r6:c03e4eec r5:cf9e50a8 r4:cf9e5020
[    6.551025] [<c01a1560>] (driver_probe_device+0x0/0x180) from
[<c01a1748>] (__driver_attach+0x68/0x8c)
[    6.560394]  r7:c03e4eec r6:c03e4eec r5:cf9e50a8 r4:cf9e5020
[    6.566131] [<c01a16e0>] (__driver_attach+0x0/0x8c) from
[<c01a0a8c>] (bus_for_each_dev+0x4c/0x84)
[    6.575164]  r7:c03e4eec r6:c01a16e0 r5:cf821cc8 r4:00000000
[    6.580871] [<c01a0a40>] (bus_for_each_dev+0x0/0x84) from
[<c01a1478>] (driver_attach+0x20/0x28)
[    6.589721]  r7:cfb121a0 r6:c0018224 r5:c03e4eec r4:00000000
[    6.595458] [<c01a1458>] (driver_attach+0x0/0x28) from [<c01a1054>]
(bus_add_driver+0xa8/0x214)
[    6.604217] [<c01a0fac>] (bus_add_driver+0x0/0x214) from
[<c01a196c>] (driver_register+0x98/0x120)
[    6.613250]  r8:00000000 r7:c03ef760 r6:c0018224 r5:c03e4eec r4:c03e4ec0
[    6.620025] [<c01a18d4>] (driver_register+0x0/0x120) from
[<c01cfffc>] (i2c_register_driver+0x98/0xfc)
[    6.629425] [<c01cff64>] (i2c_register_driver+0x0/0xfc) from
[<c001823c>] (ce131f_isp_init+0x18/0x38)
[    6.638702]  r7:c03ef760 r6:c0018224 r5:c0022d78 r4:c0023128
[    6.644439] [<c0018224>] (ce131f_isp_init+0x0/0x38) from
[<c002a2d0>] (do_one_initcall+0x78/0x1d8)
[    6.653472]  r5:c0022d78 r4:c0023128
[    6.657073] [<c002a258>] (do_one_initcall+0x0/0x1d8) from
[<c0008720>] (kernel_init+0x74/0xe0)
[    6.665740]  r8:00000000 r7:00000000 r6:00000000 r5:c0022d78 r4:c0023128
[    6.672515] [<c00086ac>] (kernel_init+0x0/0xe0) from [<c005c234>]
(do_exit+0x0/0x684)
[    6.680419]  r5:00000000 r4:00000000
[    6.684020] Code: c036e993 e1a0c00d e92dd800 e24cb004 (e5903098)
[    6.690246] ---[ end trace cc13b15a4191e849 ]---
[    6.694915] Kernel panic - not syncing: Attempted to kill init!

On Thu, Mar 5, 2009 at 12:38 AM, Sakari Ailus
<sakari.ailus@maxwell.research.nokia.com> wrote:
> Hiremath, Vaibhav wrote:
>>
>> [Hiremath, Vaibhav] Sakari, Let me ask you basic question, have you
>> tested/verified these patch-sets?
>
> For the ISP and camera drivers, yes. That's actually the only thing that's
> contained in the patchset.
>
>> The reason I am asking this question is, for me it was not working. I
>> had to debug this and found that -
>>
>> - Changes missing in devices.c file, so isp_probe function will not
>> be called at all, keeping omap3isp = NULL. You will end up into
>> kernel crash in omap34xxcam_device_register.
>
> Anyway a crash shouldn't happen here. Could I see the kernel oops if there
> was such?
>
>> - The patches from Hiroshi DOYU doesn't build as is, you need to add
>> one include line #include <linux/hardirq.h> in iovmmu.c (I am using
>> the patches submitted on 16th Jan 2009)
>
> Just pull the iommu branch, the Hiroshi's original patches are missing some
> hacks that you need to use them now. I'd expect Hiroshi to update the
> patchset when he comes back.
>
>> I have attached "git diff" output here with this mail for reference.
>
> Please pull also the "base" branch.
>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
>



-- 
========================================================
DongSoo(Nathaniel), Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
