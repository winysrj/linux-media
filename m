Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41700 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbbCaBhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 21:37:48 -0400
Date: Tue, 31 Mar 2015 03:37:20 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, pali.rohar@gmail.com,
	tony@atomide.com
Subject: Re: [PATCH 1/1] omap3isp: Don't pass uninitialised arguments to
 of_graph_get_next_endpoint()
Message-ID: <20150331013719.GA1096@earth>
References: <20150330174123.GA2658@earth>
 <1427757208-1938-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <1427757208-1938-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 31, 2015 at 02:13:28AM +0300, Sakari Ailus wrote:
> isp_of_parse_nodes() passed an uninitialised prev argument to
> of_graph_get_next_endpoint(). This is bad, fix it by assigning NULL to it=
 in
> the initialisation.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Reported-by: Sebastian Reichel <sre@kernel.org>
> ---
>  drivers/media/platform/omap3isp/isp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platfo=
rm/omap3isp/isp.c
> index ff8f633..ff51c4f 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2338,7 +2338,7 @@ static int isp_of_parse_node(struct device *dev, st=
ruct device_node *node,
>  static int isp_of_parse_nodes(struct device *dev,
>  			      struct v4l2_async_notifier *notifier)
>  {
> -	struct device_node *node;
> +	struct device_node *node =3D NULL;
> =20
>  	notifier->subdevs =3D devm_kcalloc(
>  		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);

Acked-By: Sebastian Reichel <sre@kernel.org>

Note, that this actually triggered the following stacktrace for me,
so you may want to add a Fixes: <commitid> and the stacktrace to the
commit message if its not merged with the original commit (relevant
for people doing git bisect).

[    1.587951] pgd =3D c0004000
[    1.590820] [fffffe17] *pgd=3D8fef6821, *pte=3D00000000, *ppte=3D00000000
[    1.597503] Internal error: Oops: 17 [#1] SMP ARM
[    1.602478] Modules linked in:
[    1.605743] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.0.0-rc1-00019-g2=
58ac6a-dirty #293
[    1.614379] Hardware name: Nokia RX-51 board
[    1.618896] task: ce0aab80 ti: ce0ac000 task.ti: ce0ac000
[    1.624603] PC is at of_get_parent+0x18/0x34
[    1.629150] LR is at _raw_spin_lock_irqsave+0x48/0x54
[    1.634490] pc : [<c05c6034>]    lr : [<c07d5e20>]    psr: 60000193
[    1.634490] sp : ce0addc8  ip : c0c0b5a0  fp : c0b91b90
[    1.646636] r10: c0b2e598  r9 : ce3804d0  r8 : 00000000
[    1.652160] r7 : fffffdfb  r6 : cfc84c44  r5 : fffffdfb  r4 : fffffdfb
[    1.659057] r3 : 60000193  r2 : 00000000  r1 : 95d695d5  r0 : a0000113
[    1.665954] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segmen=
t kernel
[    1.673767] Control: 10c5387d  Table: 80004019  DAC: 00000015
[    1.679870] Process swapper/0 (pid: 1, stack limit =3D 0xce0ac218)
[    1.686218] Stack: (0xce0addc8 to 0xce0ae000)
[    1.690826] ddc0:                   ce380010 c05c662c ce545810 c041d9e0 =
ce380010 ce1f4010
[    1.699462] dde0: ce1f4000 c056b024 c07d4254 ce0aab80 00000001 c142199c =
c0a547f0 c0085dcc
[    1.708129] de00: c0bfeee8 60000113 c0bfef0c c07d4254 00000002 00000000 =
ce546c90 ce1f6270
[    1.716766] de20: ce1f6270 c01bced0 ce1f6270 c0a547f0 ce1f6270 ce546d50 =
00000000 00000001
[    1.725433] de40: ce1f6270 c0a547f0 ce546c90 c1457f98 ce1f4010 c0c304d4 =
fffffdfb 00000000
[    1.734069] de60: 00000000 c0b2e598 c0b91b90 c041c6c8 c041c684 c1457f98 =
ce1f4010 00000000
[    1.742736] de80: c0c304d4 c041ade4 00000000 ce1f4010 c0c304d4 ce1f4044 =
c0c18730 00000000
[    1.751373] dea0: c0b91b98 c041aff4 00000000 c0c304d4 c041af60 c041936c =
ce0d7ca4 ce1f7e90
[    1.760040] dec0: c0c304d4 ce526740 00000000 c041a608 c09f8b88 c0c304d4 =
c0bb3eb0 c0c304d4
[    1.768676] dee0: c0bb3eb0 ce5458c0 c0b71550 c041b74c 00000000 c0bb3eb0 =
c0bb3eb0 c0008b64
[    1.777343] df00: cfeff246 cfeff241 c082416c c0aed820 00000100 c0aede00 =
00000000 0000005e
[    1.785980] df20: cfeff241 ce0adf38 00000072 00000000 cfeff292 c005b040 =
c0a6bfb8 cfeff294
[    1.794647] df40: 00000006 00000006 00000000 c0ba7c74 c0ba7fa8 00000006 =
c0c61700 00000114
[    1.803283] df60: c0c61700 c0b2e598 c0b91b90 c0b2eea0 00000006 00000006 =
c0b2e598 ffffffff
[    1.811920] df80: fffbfdff 00000000 c07ca054 00000000 00000000 00000000 =
00000000 00000000
[    1.820587] dfa0: 00000000 c07ca05c 00000000 c000e8f0 00000000 00000000 =
00000000 00000000
[    1.829223] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    1.837890] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 =
ffffffff ffffffff
[    1.846557] [<c05c6034>] (of_get_parent) from [<c05c662c>] (of_graph_get=
_next_endpoint+0x24/0x118)
[    1.856018] [<c05c662c>] (of_graph_get_next_endpoint) from [<c056b024>] =
(isp_probe+0x118/0xf58)
[    1.865234] [<c056b024>] (isp_probe) from [<c041c6c8>] (platform_drv_pro=
be+0x44/0xa4)
[    1.873535] [<c041c6c8>] (platform_drv_probe) from [<c041ade4>] (driver_=
probe_device+0x104/0x23c)
[    1.882934] [<c041ade4>] (driver_probe_device) from [<c041aff4>] (__driv=
er_attach+0x94/0x98)
[    1.891876] [<c041aff4>] (__driver_attach) from [<c041936c>] (bus_for_ea=
ch_dev+0x6c/0xa0)
[    1.900512] [<c041936c>] (bus_for_each_dev) from [<c041a608>] (bus_add_d=
river+0x144/0x1f0)
[    1.909271] [<c041a608>] (bus_add_driver) from [<c041b74c>] (driver_regi=
ster+0x78/0xf8)
[    1.917755] [<c041b74c>] (driver_register) from [<c0008b64>] (do_one_ini=
tcall+0x80/0x1dc)
[    1.926391] [<c0008b64>] (do_one_initcall) from [<c0b2eea0>] (kernel_ini=
t_freeable+0x204/0x2d0)
[    1.935607] [<c0b2eea0>] (kernel_init_freeable) from [<c07ca05c>] (kerne=
l_init+0x8/0xec)
[    1.944183] [<c07ca05c>] (kernel_init) from [<c000e8f0>] (ret_from_fork+=
0x14/0x24)
[    1.952209] Code: e1a04000 0a000005 e59f0018 eb083f68 (e594401c)=20
[    1.958709] ---[ end trace 5d64830d502ea2d7 ]---
[    1.965698] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x0000000b
[    1.965698]=20
[    1.975402] ---[ end Kernel panic - not syncing: Attempted to kill init!=
 exitcode=3D0x0000000b
[    1.975402]=20

-- Sebastian

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVGfpJAAoJENju1/PIO/qasfsP/A5/+CgnGo2VrrPF0WfoV9CX
2wPlwCQkC8ZFh9Zn7ECelLBa8FXn8+bGD1+7+GpCEM1CWcGIe/eARawA2J3Bs7We
X20qMWkK+8xFSIe0AiUu1KN0B9owQuFmgnIe6vUvQEIDzcHPMzIUbIi5SU2Bxjpx
qo+OA8pmFWDVQ1XzgkzBzpVP9otls0kkpNR2oi0yVQiJVWeMdP73QNaYPR1Y9q/s
InpCe5h6zFfHM++pQlCPFpSMpe72vHEK+hf971xdzmGQN3Od2+WVTXekVEiEDuYg
Gz1YzU5cyLZPpNft3GUzrAeUEa4HzOUs3iYCxIonbV2ONHLKJaaoZLm4y9JCiGwE
EtC7jYQhVMNMfuMHXcaTVB1LNjxu6A7kdxgpNdGX8ZjKnH/0VA64OtyIKp2sLOC6
Wb+hXQDEVBLC07/Kv6W3QBcRyrEtkiRCmN8DGGkodr6Hj6Jxr87IU4BXM/aN+f91
J6b2k5r22j9g0WbAJrs8k+cBI+xfGh4BCYtvPu6DrK+Rj+GxyyrK9wIVOWD/uBtd
a3QQHHIMKOY+rtslp8qIyzDP+6i+XrNUaiyFQ3RpapN/9MJUJft+PqwMCSfutfCe
txiN5fWLCVDPunOjVif7S4oubFioq7r9vrO8n28TF1rkJ2C7i705gOOcR/PfLu2L
RSb3GH3NlkSpur0qEpf0
=KTEb
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
