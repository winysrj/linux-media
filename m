Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40057 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935107Ab2JYOBC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 10:01:02 -0400
Message-ID: <5089461A.9050307@ti.com>
Date: Thu, 25 Oct 2012 17:00:58 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Taneja, Archit" <archit@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] omap_vout: Set DSS overlay_info only if paddr is non
 zero
References: <1331110876-11895-1-git-send-email-archit@ti.com>  <1729342.AddG4HPA3i@avalon> <79CD15C6BA57404B839C016229A409A83180E941@DBDE01.ent.ti.com>
In-Reply-To: <79CD15C6BA57404B839C016229A409A83180E941@DBDE01.ent.ti.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigCF96AA033133308E1FEFF6E5"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigCF96AA033133308E1FEFF6E5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-03-09 10:03, Hiremath, Vaibhav wrote:
> On Fri, Mar 09, 2012 at 05:17:41, Laurent Pinchart wrote:
>> Hi Archit,
>>
>> On Wednesday 07 March 2012 14:31:16 Archit Taneja wrote:
>>> The omap_vout driver tries to set the DSS overlay_info using
>>> set_overlay_info() when the physical address for the overlay is still=
 not
>>> configured. This happens in omap_vout_probe() and vidioc_s_fmt_vid_ou=
t().
>>>
>>> The calls to omapvid_init(which internally calls set_overlay_info()) =
are
>>> removed from these functions. They don't need to be called as the
>>> omap_vout_device struct anyway maintains the overlay related changes =
made.
>>> Also, remove the explicit call to set_overlay_info() in vidioc_stream=
on(),
>>> this was used to set the paddr, this isn't needed as omapvid_init() d=
oes
>>> the same thing later.
>>>
>>> These changes are required as the DSS2 driver since 3.3 kernel doesn'=
t let
>>> you set the overlay info with paddr as 0.
>>>
>>> Signed-off-by: Archit Taneja <archit@ti.com>
>>
>> Thanks for the patch. This seems to fix memory corruption that would r=
esult
>> in sysfs-related crashes such as
>>
>> [   31.279541] ------------[ cut here ]------------
>> [   31.284423] WARNING: at fs/sysfs/file.c:343 sysfs_open_file+0x70/0x=
1f8()
>> [   31.291503] missing sysfs attribute operations for kobject: (null)
>> [   31.298004] Modules linked in: mt9p031 aptina_pll omap3_isp
>> [   31.303924] [<c0018260>] (unwind_backtrace+0x0/0xec) from [<c003448=
8>] (warn_slowpath_common+0x4c/0x64)
>> [   31.313812] [<c0034488>] (warn_slowpath_common+0x4c/0x64) from [<c0=
034520>] (warn_slowpath_fmt+0x2c/0x3c)
>> [   31.323913] [<c0034520>] (warn_slowpath_fmt+0x2c/0x3c) from [<c0121=
9bc>] (sysfs_open_file+0x70/0x1f8)
>> [   31.333618] [<c01219bc>] (sysfs_open_file+0x70/0x1f8) from [<c00ccc=
94>] (__dentry_open+0x1f8/0x30c)
>> [   31.343139] [<c00ccc94>] (__dentry_open+0x1f8/0x30c) from [<c00cce5=
8>] (nameidata_to_filp+0x50/0x5c)
>> [   31.352752] [<c00cce58>] (nameidata_to_filp+0x50/0x5c) from [<c00db=
4c0>] (do_last+0x55c/0x6a0)
>> [   31.361999] [<c00db4c0>] (do_last+0x55c/0x6a0) from [<c00db6bc>] (p=
ath_openat+0xb8/0x37c)
>> [   31.370605] [<c00db6bc>] (path_openat+0xb8/0x37c) from [<c00dba60>]=
 (do_filp_open+0x30/0x7c)
>> [   31.379486] [<c00dba60>] (do_filp_open+0x30/0x7c) from [<c00cc904>]=
 (do_sys_open+0xd8/0x170)
>> [   31.388366] [<c00cc904>] (do_sys_open+0xd8/0x170) from [<c0012760>]=
 (ret_fast_syscall+0x0/0x3c)
>> [   31.397552] ---[ end trace 13639ab74f345d7e ]---
>>
>> Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>
>=20
> Thanks Laurent for testing this patch.
>=20
>=20
>> Please push it to v3.3 :-)
>>
>=20
> Will send a pull request today itself.

Vaibhav, I don't see this crash fix in 3.3, 3.4, 3.5, 3.6 nor in 3.7-rc.
Are you still maintaining the omap v4l2 driver? Can you finally push
this fix?

 Tomi



--------------enigCF96AA033133308E1FEFF6E5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQiUYaAAoJEPo9qoy8lh71mxAP/AtVXUmmvZ/N4uQkuonH0Tio
FnxnW2DKlDyHXmIMMdVGuAtI1yIly8asj7a0krcHkA719EA+CILJtDPvUKf0R0x/
p2+qFjbwOOuRmEcpB5dY/9AJi/gsjJqwdY01BVuHszEB8yYlELm2tYAzjo3UerjA
TEPiQ+rOd++xt1an8ONpYoZ4NGj981b0IcEY7pNAHZf2Up0SFkZ9aZkIPv7BnD/3
/SS5637QvYqA+/6Uh3spxQQKqcWBMEd6Fuqcy/ffotNGfrHCGU3DL4gplug932ae
5UoplYnnzxTmMkfb4c0NEeYVIlgLq8619bN/QNBfn5JqfcIxuXEAVR4v7QoHgs9i
O5hbHvvvAX+tv2nijj5ROJ1Az8/jDb0JR1V0MCOK5La/uhTmBopC95iR1CvakkBK
TLcgIVTFOazXtXYAXZ+Xmkodde96dLlMehzpek7widiEWAClnc3bnsx6MhGU9uGd
2Vm92IzxmdVOA5EFU29mNCwZm6RHZ+m/ZTkF1yYX+5+pJ2e6V/C2viNQ22iPdfXr
MMbKNBP4FFuOgOPbEbUCauAW3HQVN2Tw9HZdrkwqZujm2a8wKYjkaZ/K6JK0CKxn
QjXiW5TQHMuFRMvbYqN0V8Rx7K5UZcohgIotAxy6p3yl7NeuvbXDI68IVWNEsUhU
5xm9GXmSzIID2Sx9+87m
=vXW9
-----END PGP SIGNATURE-----

--------------enigCF96AA033133308E1FEFF6E5--
