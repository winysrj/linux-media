Return-path: <linux-media-owner@vger.kernel.org>
Received: from spectre.t3rror.net ([188.40.142.143]:38614 "EHLO
	mail.t3rror.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756441Ab0GHTm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 15:42:58 -0400
From: Boris Cuber <me@boris64.net>
Reply-To: me@boris64.net
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 15826] New: WARNING: at fs/proc/generic.c:317 __xlate_proc_name+0xbd/0xe0()
Date: Thu, 8 Jul 2010 21:34:06 +0200
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, linux-media@vger.kernel.org,
	bugzilla.kernel.org@boris64.net
References: <bug-15826-10286@https.bugzilla.kernel.org/> <20100426151933.87e82353.akpm@linux-foundation.org>
In-Reply-To: <20100426151933.87e82353.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4499796.mnaS7HNkd7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007082134.07321.me@boris64.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart4499796.mnaS7HNkd7
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Still present in kernel-2.6.34.1.
The dvb card itself has been installed to another computer,
different os (archlinux instead of gentoo), warning is still there.

[dmesg]...
b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded=20
successfully
flexcop-pci: will use the HW PID filter.
flexcop-pci: card revision 2
b2c2_flexcop_pci 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
=2D-----------[ cut here ]------------
WARNING: at fs/proc/generic.c:317 __xlate_proc_name+0xb3/0xc0()
Hardware name: System Name
name 'Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver'
Modules linked in: b2c2_flexcop_pci(+) i2c_viapro snd(+) soundcore=20
b2c2_flexcop dvb_core cx24123 cx24113 via_ircc uhci_hcd s5h1420 button ther=
mal=20
processor irda crc_ccitt ehci_hcd usbcore via_agp firewire_ohci firewire_co=
re=20
crc_itu_t shpchp pci_hotplug evdev psmouse via_rhine mii emu10k1_gp gamepor=
t=20
sg serio_raw pcspkr rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sr_mo=
d=20
cdrom sd_mod pata_via ata_generic pata_acpi floppy libata scsi_mod radeon t=
tm=20
drm_kms_helper drm agpgart i2c_algo_bit i2c_core
Pid: 1187, comm: modprobe Not tainted 2.6.34-ARCH #1
Call Trace:
 [<c104317d>] warn_slowpath_common+0x6d/0xa0
 [<c113b553>] ? __xlate_proc_name+0xb3/0xc0
 [<c113b553>] ? __xlate_proc_name+0xb3/0xc0
 [<c10431f6>] warn_slowpath_fmt+0x26/0x30
 [<c113b553>] __xlate_proc_name+0xb3/0xc0
 [<c113b5b9>] __proc_create+0x59/0x100
 [<c113bed3>] proc_mkdir_mode+0x23/0x50
 [<c113bf0f>] proc_mkdir+0xf/0x20
 [<c10986ab>] register_handler_proc+0xeb/0x110
 [<c1096a3f>] __setup_irq+0x19f/0x2f0
 [<c10e950c>] ? kmem_cache_alloc_notrace+0x7c/0xb0
 [<f8ce7140>] ? flexcop_pci_isr+0x0/0x140 [b2c2_flexcop_pci]
 [<c1096c6e>] request_threaded_irq+0xde/0x1c0
 [<c1027516>] ? ioremap_nocache+0x16/0x20
 [<f8ce73e0>] flexcop_pci_probe+0x160/0x2b0 [b2c2_flexcop_pci]
 [<c119ad56>] pci_device_probe+0x56/0x80
 [<c1215a27>] driver_probe_device+0x77/0x180
 [<c1215ba9>] __driver_attach+0x79/0x80
 [<c1214c83>] bus_for_each_dev+0x43/0x70
 [<c1215779>] driver_attach+0x19/0x20
 [<c1215b30>] ? __driver_attach+0x0/0x80
 [<c121533d>] bus_add_driver+0xbd/0x2d0
 [<c119aca0>] ? pci_device_remove+0x0/0x40
 [<c1215da5>] driver_register+0x65/0x110
 [<c119af80>] __pci_register_driver+0x40/0xb0
 [<f8cf4017>] flexcop_pci_module_init+0x17/0x19 [b2c2_flexcop_pci]
 [<c100120d>] do_one_initcall+0x2d/0x190
 [<f8cf4000>] ? flexcop_pci_module_init+0x0/0x19 [b2c2_flexcop_pci]
 [<c1078fed>] sys_init_module+0xad/0x210
 [<c10d8ec9>] ? sys_mmap_pgoff+0x89/0x110
 [<c100379f>] sysenter_do_call+0x12/0x28
=2D--[ end trace d65de7b15fba8e1f ]---
DVB: registering new adapter (FlexCop Digital TV device)
b2c2-flexcop: MAC address =3D 00:d0:d7:0f:30:58
CX24123: cx24123_i2c_readreg: reg=3D0x0 (error=3D-121)
CX24123: wrong demod revision: 87
usb 2-2: new low speed USB device using uhci_hcd and address 3
b2c2-flexcop: found 'ST STV0299 DVB-S' .
DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S rev 2.6' at the 'PC=
I'=20
bus controlled by a 'FlexCopIIb' complete
=2E..
[dmesg]


Am Dienstag, 27. April 2010 schrieb Andrew Morton:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
>=20
> On Wed, 21 Apr 2010 12:21:18 GMT
>=20
> bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D15826
> >=20
> >            Summary: WARNING: at fs/proc/generic.c:317
> >           =20
> >                     __xlate_proc_name+0xbd/0xe0()
> >           =20
> >            Product: v4l-dvb
> >            Version: unspecified
> >    =20
> >     Kernel Version: 2.6.34-rc5
> >    =20
> >           Platform: All
> >        =20
> >         OS/Version: Linux
> >        =20
> >               Tree: Mainline
> >            =20
> >             Status: NEW
> >          =20
> >           Severity: normal
> >           Priority: P1
> >         =20
> >          Component: dvb-core
> >        =20
> >         AssignedTo: v4l-dvb_dvb-core@kernel-bugs.osdl.org
> >         ReportedBy: bugzilla.kernel.org@boris64.net
> >         Regression: No
> >=20
> > Created an attachment (id=3D26077)
> >=20
> >  --> (https://bugzilla.kernel.org/attachment.cgi?id=3D26077)
> >=20
> > full dmesg
> >=20
> > I keep getting this warning on boot. It seems to
> > happen when the dvb driver for my "technisat skystar2"
> > card is loaded (correct me if i'm wrong).
> >=20
> > If you need more infos or debug stuff inside
> > my kernel config, please tell me what i need to include.
> >=20
> > Thank you in advance.
> >=20
> > ----------------------------------------
> > ...
> > [    0.739420] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiv=
er
> > chip loaded successfully
> > [    0.739435] flexcop-pci: will use the HW PID filter.
> > [    0.739438] flexcop-pci: card revision 2
> > [    0.739442] b2c2_flexcop_pci 0000:04:01.0: PCI INT A -> GSI 17 (leve=
l,
> > low) -> IRQ 17
> > [    0.739459] ------------[ cut here ]------------
> > [    0.739463] WARNING: at fs/proc/generic.c:317
> > __xlate_proc_name+0xbd/0xe0()
>=20
> Alexey, this sucks.  A developer goes to the warning site:
>=20
> static int __xlate_proc_name(const char *name, struct proc_dir_entry **re=
t,
> 			     const char **residual)
> {
> 	const char     		*cp =3D name, *next;
> 	struct proc_dir_entry	*de;
> 	int			len;
>=20
> 	de =3D *ret;
> 	if (!de)
> 		de =3D &proc_root;
>=20
> 	while (1) {
> 		next =3D strchr(cp, '/');
> 		if (!next)
> 			break;
>=20
> 		len =3D next - cp;
> 		for (de =3D de->subdir; de ; de =3D de->next) {
> 			if (proc_match(len, cp, de))
> 				break;
> 		}
> 		if (!de) {
> 			WARN(1, "name '%s'\n", name);
> 			return -ENOENT;
> 		}
> 		cp +=3D len + 1;
> 	}
> 	*residual =3D cp;
> 	*ret =3D de;
> 	return 0;
> }
>=20
> and there's no hint whatsoever to tell him what the warning means, nor
> how to fix it.
>=20
> Please send a patch adding a nice comment to __xlate_proc_name().  Then
> perhaps the DVB guys have a chance of fixing this bug.
>=20
> Thanks.
>=20
> > [    0.739465] Hardware name: P5K
> > [    0.739466] name 'Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI
> > Driver' [    0.739467] Modules linked in:
> > [    0.739470] Pid: 1, comm: swapper Not tainted
> > 2.6.34-rc5-v2k11+-dbg-dirty #118
> > [    0.739471] Call Trace:
> > [    0.739476]  [<ffffffff8103e386>] warn_slowpath_common+0x76/0xb0
> > [    0.739478]  [<ffffffff8103e41c>] warn_slowpath_fmt+0x3c/0x40
> > [    0.739481]  [<ffffffff8110b4ad>] __xlate_proc_name+0xbd/0xe0
> > [    0.739483]  [<ffffffff8110b540>] __proc_create+0x70/0x140
> > [    0.739486]  [<ffffffff8110bf49>] proc_mkdir_mode+0x29/0x60
> > [    0.739488]  [<ffffffff8110bf91>] proc_mkdir+0x11/0x20
> > [    0.739491]  [<ffffffff8107b39b>] register_handler_proc+0x11b/0x140
> > [    0.739494]  [<ffffffff810791f9>] __setup_irq+0x1f9/0x390
> > [    0.739497]  [<ffffffff813ca790>] ? flexcop_pci_isr+0x0/0x3e0
> > [    0.739500]  [<ffffffff810794bc>] request_threaded_irq+0x12c/0x210
> > [    0.739502]  [<ffffffff813cad20>] flexcop_pci_probe+0x1b0/0x350
> > [    0.739505]  [<ffffffff811e4ee5>] pci_device_probe+0x75/0xa0
> > [    0.739509]  [<ffffffff8130522a>] ? driver_sysfs_add+0x5a/0x90
> > [    0.739511]  [<ffffffff813054f3>] driver_probe_device+0x93/0x1a0
> > [    0.739514]  [<ffffffff8130569b>] __driver_attach+0x9b/0xa0
> > [    0.739517]  [<ffffffff81305600>] ? __driver_attach+0x0/0xa0
> > [    0.739519]  [<ffffffff8130460e>] bus_for_each_dev+0x5e/0x90
> > [    0.739522]  [<ffffffff813051c9>] driver_attach+0x19/0x20
> > [    0.739524]  [<ffffffff81304d62>] bus_add_driver+0xb2/0x260
> > [    0.739527]  [<ffffffff8130590f>] driver_register+0x6f/0x130
> > [    0.739529]  [<ffffffff811e5171>] __pci_register_driver+0x51/0xd0
> > [    0.739533]  [<ffffffff818f49a9>] ? flexcop_pci_module_init+0x0/0x1b
> > [    0.739535]  [<ffffffff818f49c2>] flexcop_pci_module_init+0x19/0x1b
> > [    0.739538]  [<ffffffff810002d9>] do_one_initcall+0x39/0x1a0
> > [    0.739540]  [<ffffffff818d1cc4>] kernel_init+0x14d/0x1d7
> > [    0.739543]  [<ffffffff81003194>] kernel_thread_helper+0x4/0x10
> > [    0.739546]  [<ffffffff818d1b77>] ? kernel_init+0x0/0x1d7
> > [    0.739548]  [<ffffffff81003190>] ? kernel_thread_helper+0x0/0x10
> > [    0.739553] ---[ end trace 4e6b2faee55cb1bf ]---
> > [    0.744389] DVB: registering new adapter (FlexCop Digital TV device)
> > [    0.746102] b2c2-flexcop: MAC address =3D 00:d0:d7:0f:30:58
> > [    0.946350] b2c2-flexcop: found 'ST STV0299 DVB-S' .
> > [    0.946353] DVB: registering adapter 0 frontend 0 (ST STV0299
> > DVB-S)... [    0.946422] b2c2-flexcop: initialization of 'Sky2PC/SkyStar
> > 2 DVB-S rev 2.6' at the 'PCI' bus controlled by a 'FlexCopIIb' complete


=2D-=20
http://boris64.net 20xx ;)

--nextPart4499796.mnaS7HNkd7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iQIcBAABAgAGBQJMNigvAAoJEONrv02ePEYNik8P/jEOOAP3hCzw01YCwwZNqRPO
AI4wJF00ZvfHV8GRF2iJ/5BALJkzXYb/HUpdF76yLUcoF8n1iiSrX8GhsAJk7jnR
qtl82xu2L+JFdEsP20itcvvWADDGYObxoqMYIynb02P6wBdpXmV7o3Uc59VnmhTj
pnNI4gAzDCs1lakq2zjKx/+S9/3CdAEdjIkIJJZc/o11VgORK9hwLRJpwr2JicwU
dCs8a5V4jJDvvbSGOwdbjnMw7kIR9sASzOq9aMbIS5LRVw+/D7SNnq/7Z4OyvBz1
MSzbmePfi7SliNfUuLTkMuecXfURxhKN2b8YQr0YfoepRBiplYo7kjmHihk+XlrS
mBR97EwDKd+beCBzL6C4kLcCLUE3lWk8oyU3aYXQ+2dxN6nMKgpcxdxXrMHZIiC8
D80WkmS2NCjnbJk4AeXb+Pst9xxTZILFnF9ymZJaZ5F1n9WjVO+oS1GbUirRay5z
LeK65Vv/pAVmWfwrnut/+N/QObvGPdgLbCzEuT5etBQoPuiCYvRMS1P5lQyZ8R41
uKSBtFegh0qMRjkn4GvfXlkulq7cuz4k17EJ09Kg6fmFMlCu3r47n8z2zda4WCzI
pSIfoWsBOBsEBZT8F37PK7FONYFA1lguREDJSOxnyN8HFcQOPpT4Kk7mGgh1aPUW
BevHuBGruHujLoHgbRzn
=DdCh
-----END PGP SIGNATURE-----

--nextPart4499796.mnaS7HNkd7--
