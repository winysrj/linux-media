Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57223 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab1HXWuu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 18:50:50 -0400
Subject: Re: Bug#639161: linux-image-3.0.0-1-686-pae: Upgrade 2.6.39 ->
 3.0.0 breaks playback on DiBcom 7000PC
From: Ben Hutchings <ben@decadent.org.uk>
To: Patrick Boettcher <patrick.boettcher@dibcom.fr>
Cc: 639161@bugs.debian.org,
	"Soeren D. Schulze" <soeren.d.schulze@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Date: Wed, 24 Aug 2011 23:50:37 +0100
In-Reply-To: <4E552DE2.6000908@gmx.de>
References: <4E552DE2.6000908@gmx.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-4QpSPdqm2TbSe2KRBVJD"
Message-ID: <1314226243.27179.56.camel@deadeye>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-4QpSPdqm2TbSe2KRBVJD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Patrick,

Please could you take a look at the following bug report on Linux 3.0 as
packaged in Debian.

Ben.

On Wed, 2011-08-24 at 18:59 +0200, Soeren D. Schulze wrote:
> Package: linux-2.6
> Version: 3.0.0-1
> Severity: normal
>=20
> I usually use tzap/mplayer for TV playback.
>=20
> After the upgrade to Linux 3.0.0, tzap command line output still looks
> fine, but mplayer does not seem to receive any data (its cache does not
> fill up).
>=20
> syslog/dmesg output looks the same as in 2.6.39.  On the first try to
> tune, dmesg receives:
>=20
> dib0700: tx buffer length is larger than 4. Not supported.
> (for which I find various non-Debian bug reports)
>=20
> But that does not seem to be the issue, because the same message appears
> in 2.6.39, where everything is fine.
> So I do not really have an idea what the problem is, but I certainly
> know that it's a regression, because simply booting Linux 2.6.39 rather
> than 3.0.0 on the same system avoids the problem.
>=20
> -- Package-specific info:
> ** Version:
> Linux version 3.0.0-1-686-pae (Debian 3.0.0-1) (ben@decadent.org.uk)
> (gcc version 4.5.3 (Debian 4.5.3-3) ) #1 SMP Sun Jul 24 14:27:32 UTC 2011
>=20
> ** Command line:
> BOOT_IMAGE=3D/vmlinuz-3.0.0-1-686-pae
> root=3DUUID=3D3aa0a731-df46-486e-9c1e-258723e14f8f ro
>=20
> ** Not tainted
>=20
> ** Kernel log:
> [   11.031446] saa7134:   card=3D172 -> RoverMedia TV Link Pro FM
>        19d1:0138
> [   11.031580] saa7134:   card=3D173 -> Zolid Hybrid TV Tuner PCI
>        1131:2004
> [   11.031713] saa7134:   card=3D174 -> Asus Europa Hybrid OEM
>        1043:4847
> [   11.031847] saa7134:   card=3D175 -> Leadtek Winfast DTV1000S
>        107d:6655
> [   11.031982] saa7134:   card=3D176 -> Beholder BeholdTV 505 RDS
>        0000:5051
> [   11.032126] saa7134:   card=3D177 -> Hawell HW-404M7
>=20
> [   11.032217] saa7134:   card=3D178 -> Beholder BeholdTV H7
>        5ace:7190
> [   11.032351] saa7134:   card=3D179 -> Beholder BeholdTV A7
>        5ace:7090
> [   11.032485] saa7134:   card=3D180 -> Avermedia PCI M733A
>        1461:4155 1461:4255
> [   11.032656] saa7134:   card=3D181 -> TechoTrend TT-budget T-3000
>        13c2:2804
> [   11.032789] saa7134:   card=3D182 -> Kworld PCI SBTVD/ISDB-T Full-Seg
> Hybrid  17de:b136
> [   11.032923] saa7134:   card=3D183 -> Compro VideoMate Vista M1F
>        185b:c900
> [   11.033057] saa7134:   card=3D184 -> Encore ENLTV-FM 3
>        1a7f:2108
> [   11.033192] saa7134:   card=3D185 -> MagicPro ProHDTV Pro2
> DMB-TH/Hybrid      17de:d136
> [   11.033326] saa7134:   card=3D186 -> Beholder BeholdTV 501
>        5ace:5010
> [   11.033460] saa7134:   card=3D187 -> Beholder BeholdTV 503 FM
>        5ace:5030
> [   11.033596] saa7134[0]: subsystem: 1131:0000, board: UNKNOWN/GENERIC
> [card=3D0,autodetected]
> [   11.075242] IR NEC protocol handler initialized
> [   11.265597] saa7134[0]: board init: gpio is 10020
> [   11.368582] saa7134[0]: Huh, no eeprom present (err=3D-5)?
> [   11.381924] saa7134[0]: registered device video0 [v4l2]
> [   11.382055] saa7134[0]: registered device vbi0
> [   11.417515] IR RC5(x) protocol handler initialized
> [   11.607051] cfg80211: Calling CRDA to update world regulatory domain
> [   11.995773] IR RC6 protocol handler initialized
> [   12.191500] IR JVC protocol handler initialized
> [   12.263839] dib0700: loaded with support for 20 different device-types
> [   12.264209] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
> [   12.265499] dvb-usb: will pass the complete MPEG2 transport stream to
> the software demuxer.
> [   12.266158] DVB: registering new adapter (Hauppauge Nova-T Stick)
> [   12.517093] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
> [   12.609760] IR Sony protocol handler initialized
> [   12.790869] DiB0070: successfully identified
> [   12.907896] ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
> [   12.907988] VIA 82xx Audio 0000:00:11.5: PCI INT C -> Link[ALKC] ->
> GSI 22 (level, low) -> IRQ 22
> [   12.908316] VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
> [   12.932675] saa7134 ALSA driver for DMA sound loaded
> [   12.932807] saa7134[0]/alsa: saa7134[0] at 0xfdffc000 irq 16
> registered as card -1
> [   12.948789] lirc_dev: IR Remote Control driver registered, major 249
> [   12.952109] IR LIRC bridge handler initialized
> [   13.380033] Registered IR keymap rc-dib0700-rc5
> [   13.380514] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:10.4/usb1/1-1/1-1.3/rc/rc0/input6
> [   13.380749] rc0: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:10.4/usb1/1-1/1-1.3/rc/rc0
> [   13.382312] dvb-usb: schedule remote query interval to 50 msecs.
> [   13.382385] dvb-usb: Hauppauge Nova-T Stick successfully initialized
> and connected.
> [   13.382931] dib0700: rc submit urb failed
> [   13.382935]
> [   13.383099] usbcore: registered new interface driver dvb_usb_dib0700
> [   13.530512] ENS1371 0000:00:14.0: PCI INT A -> GSI 17 (level, low) ->
> IRQ 17
> [   14.848088] usb 1-1.1: ath9k_htc: Transferred FW: htc_9271.fw, size:
> 51272
> [   15.061785] ath9k_htc 1-1.1:1.0: ath9k_htc: HTC initialized with 33
> credits
> [   15.277766] ath9k_htc 1-1.1:1.0: ath9k_htc: FW Version: 1.3
> [   15.277836] ath: EEPROM regdomain: 0x809c
> [   15.277841] ath: EEPROM indicates we should expect a country code
> [   15.277848] ath: doing EEPROM country->regdmn map search
> [   15.277853] ath: country maps to regdmn code: 0x52
> [   15.277859] ath: Country alpha2 being used: CN
> [   15.277864] ath: Regpair used: 0x52
> [   15.585402] ieee80211 phy0: Atheros AR9271 Rev:1
> [   15.589401] Registered led device: ath9k_htc-phy0
> [   15.589415] usb 1-1.1: ath9k_htc: USB layer initialized
> [   15.590190] usbcore: registered new interface driver ath9k_htc
> [   18.808140] Adding 10787640k swap on /dev/sda4.  Priority:-1
> extents:1 across:10787640k
> [   19.502130] EXT3-fs (sda1): using internal journal
> [   22.357921] EXT3-fs: barriers not enabled
> [   22.358315] kjournald starting.  Commit interval 5 seconds
> [   22.358692] EXT3-fs (sda3): using internal journal
> [   22.358751] EXT3-fs (sda3): mounted filesystem with ordered data mode
> [   22.395040] EXT3-fs: barriers not enabled
> [   22.401833] kjournald starting.  Commit interval 5 seconds
> [   22.402651] EXT3-fs (sdb3): using internal journal
> [   22.402712] EXT3-fs (sdb3): mounted filesystem with ordered data mode
> [   25.514875] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   26.986709] wlan0: authenticate with 00:12:80:61:35:51 (try 1)
> [   26.997149] wlan0: authenticated
> [   26.997194] wlan0: associate with 00:12:80:61:35:51 (try 1)
> [   26.999084] wlan0: RX AssocResp from 00:12:80:61:35:51 (capab=3D0x421
> status=3D0 aid=3D242)
> [   26.999092] wlan0: associated
> [   27.003033] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   33.524144] via-velocity 0000:00:0e.0: BAR 0: set to [io
> 0xf800-0xf8ff] (PCI address [0xf800-0xf8ff])
> [   33.524235] via-velocity 0000:00:0e.0: BAR 1: set to [mem
> 0xfdffe000-0xfdffe0ff] (PCI address [0xfdffe000-0xfdffe0ff])
> [   33.538795] Velocity is AUTO mode
> [   36.714998] eth1: Link auto-negotiation speed 1000M bps full duplex
> [   37.286191] fuse init (API version 7.16)
> [   43.648030] eth1: no IPv6 routers present
> [   51.853616] tun: Universal TUN/TAP device driver, 1.6
> [   51.853684] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [   52.109378] lp: driver loaded but no devices found
> [   52.920446] ppdev: user-space parallel port driver
> [   54.753473] [drm] Initialized drm 1.1.0 20060810
> [   54.806037] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
> [   54.807929] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010)=
.
> [   54.807943] [drm] No driver support for vblank timestamp query.
> [   54.807953] [drm] Initialized via 2.11.1 20070202 for 0000:01:00.0 on
> minor 0
> [   54.887708] agpgart-via 0000:00:00.0: AGP 3.5 bridge
> [   54.887762] agpgart-via 0000:00:00.0: putting AGP V3 device into 8x mo=
de
> [   54.887870] pci 0000:01:00.0: putting AGP V3 device into 8x mode
> [   55.014046] saa7134[0]/irq[10,-61247]: r=3D0x20 s=3D0x00 PE
> [   55.014057] saa7134[0]/irq: looping -- clearing PE (parity error!)
> enable bit
> [   62.016040] tap0: no IPv6 routers present
>=20
> ** Model information
> not available
>=20
> ** Loaded modules:
> Module                  Size  Used by
> acpi_cpufreq           12865  0
> mperf                  12421  1 acpi_cpufreq
> cpufreq_userspace      12520  0
> cpufreq_stats          12758  0
> cpufreq_powersave      12422  0
> cpufreq_conservative    12987  0
> via                    34755  2
> drm                   129806  3 via
> parport_pc             22059  0
> ppdev                  12651  0
> lp                     12894  0
> parport                27241  3 parport_pc,ppdev,lp
> tun                    17889  2
> binfmt_misc            12880  1
> fuse                   56331  1
> arc4                   12418  2
> ath9k_htc              42912  0
> mac80211              165768  1 ath9k_htc
> rc_dib0700_rc5         12364  0
> ir_lirc_codec          12627  0
> lirc_dev               12803  1 ir_lirc_codec
> saa7134_alsa           17407  0
> snd_ens1371            18687  1
> snd_via82xx            22658  0
> gameport               13404  2 snd_ens1371,snd_via82xx
> snd_ac97_codec         84197  2 snd_ens1371,snd_via82xx
> ir_sony_decoder        12403  0
> ath9k_common           12610  1 ath9k_htc
> snd_mpu401_uart        13299  1 snd_via82xx
> ac97_bus               12462  1 snd_ac97_codec
> snd_seq_midi           12744  0
> snd_pcm_oss            36377  0
> snd_mixer_oss          17713  1 snd_pcm_oss
> dvb_usb_dib0700        68669  0
> snd_pcm                53315  5
> saa7134_alsa,snd_ens1371,snd_via82xx,snd_ac97_codec,snd_pcm_oss
> ir_jvc_decoder         12435  0
> ath9k_hw              250420  2 ath9k_htc,ath9k_common
> snd_rawmidi            22621  3 snd_ens1371,snd_mpu401_uart,snd_seq_midi
> ir_rc6_decoder         12426  0
> dib7000p               26533  2 dvb_usb_dib0700
> dib0090                21477  1 dvb_usb_dib0700
> dib7000m               17340  1 dvb_usb_dib0700
> dib0070                12767  2 dvb_usb_dib0700
> ath                    17181  2 ath9k_htc,ath9k_hw
> dvb_usb                17949  1 dvb_usb_dib0700
> dib8000                26215  1 dvb_usb_dib0700
> dvb_core               68157  3 dib7000p,dvb_usb,dib8000
> cfg80211              112970  3 ath9k_htc,mac80211,ath
> snd_seq_midi_event     13124  1 snd_seq_midi
> ir_rc5_decoder         12401  0
> rfkill                 18522  1 cfg80211
> dib3000mc              17436  1 dvb_usb_dib0700
> dibx000_common         13018  5
> dvb_usb_dib0700,dib7000p,dib7000m,dib8000,dib3000mc
> snd_seq                39539  2 snd_seq_midi,snd_seq_midi_event
> ir_nec_decoder         12435  0
> saa7134               133424  1 saa7134_alsa
> rc_core                17944  11
> rc_dib0700_rc5,ir_lirc_codec,ir_sony_decoder,dvb_usb_dib0700,ir_jvc_decod=
er,ir_rc6_decoder,dvb_usb,ir_rc5_decoder,ir_nec_decoder,saa7134
> videobuf_dma_sg        13047  2 saa7134_alsa,saa7134
> videobuf_core          17516  2 saa7134,videobuf_dma_sg
> v4l2_common            13054  1 saa7134
> snd_timer              22027  2 snd_pcm,snd_seq
> snd_seq_device         12985  3 snd_seq_midi,snd_rawmidi,snd_seq
> videodev               61530  2 saa7134,v4l2_common
> media                  13692  1 videodev
> tveeprom               16473  1 saa7134
> snd                    38562  14
> saa7134_alsa,snd_ens1371,snd_via82xx,snd_ac97_codec,snd_mpu401_uart,snd_p=
cm_oss,snd_mixer_oss,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
> evdev                  12995  11
> i2c_viapro             12451  0
> shpchp                 26759  0
> pci_hotplug            26736  1 shpchp
> i2c_core               19141  15
> drm,dvb_usb_dib0700,dib7000p,dib0090,dib7000m,dib0070,dvb_usb,dib8000,dib=
3000mc,dibx000_common,saa7134,v4l2_common,videodev,tveeprom,i2c_viapro
> soundcore              12992  1 snd
> snd_page_alloc         12899  2 snd_via82xx,snd_pcm
> pcspkr                 12515  0
> button                 12810  0
> processor              27382  2 acpi_cpufreq
> ext3                   99597  3
> jbd                    42027  1 ext3
> mbcache                12898  1 ext3
> usbhid                 31584  0
> hid                    60152  1 usbhid
> sg                     21564  0
> sr_mod                 17478  0
> cdrom                  34689  1 sr_mod
> sd_mod                 35493  6
> crc_t10dif             12332  1 sd_mod
> ata_generic            12439  0
> pata_via               12733  4
> sata_via               12760  0
> libata                133339  3 ata_generic,pata_via,sata_via
> uhci_hcd               22275  0
> ehci_hcd               35401  0
> scsi_mod              135178  4 sg,sr_mod,sd_mod,libata
> usbcore               104234  7
> ath9k_htc,dvb_usb_dib0700,dvb_usb,usbhid,uhci_hcd,ehci_hcd
> firewire_ohci          26764  0
> via_velocity           27240  0
> crc_ccitt              12331  1 via_velocity
> firewire_core          42778  1 firewire_ohci
> crc_itu_t              12331  1 firewire_core
> thermal                13138  0
> fan                    12594  0
> thermal_sys            17677  3 processor,thermal,fan
>=20
> ** Network interface configuration:
>=20
> -- System Information:
> Debian Release: wheezy/sid
>   APT prefers testing
>   APT policy: (501, 'testing')
> Architecture: i386 (i686)
>=20
> Kernel: Linux 3.0.0-1-686-pae (SMP w/1 CPU core)
> Locale: LANG=3Dde_DE.UTF-8, LC_CTYPE=3Dde_DE.UTF-8 (charmap=3DUTF-8)
> Shell: /bin/sh linked to /bin/bash
>=20
> Versions of packages linux-image-3.0.0-1-686-pae depends on:
> ii  debconf [debconf-2.0]         1.5.40     Debian configuration
> management sy
> ii  initramfs-tools [linux-initra 0.99       tools for generating an
> initramfs
> ii  linux-base                    3.3        Linux image base package
> ii  module-init-tools             3.16-1     tools for managing Linux
> kernel mo
>=20
> Versions of packages linux-image-3.0.0-1-686-pae recommends:
> ii  firmware-linux-free           3          Binary firmware for various
> driver
> ii  libc6-i686                    2.13-16    Embedded GNU C Library:
> Shared lib
>=20
> Versions of packages linux-image-3.0.0-1-686-pae suggests:
> ii  grub-pc                       1.99-11    GRand Unified Bootloader,
> version
> pn  linux-doc-3.0.0               <none>     (no description available)
>=20
> Versions of packages linux-image-3.0.0-1-686-pae is related to:
> pn  firmware-bnx2                 <none>     (no description available)
> pn  firmware-bnx2x                <none>     (no description available)
> pn  firmware-ipw2x00              <none>     (no description available)
> pn  firmware-ivtv                 <none>     (no description available)
> pn  firmware-iwlwifi              <none>     (no description available)
> pn  firmware-linux                <none>     (no description available)
> pn  firmware-linux-nonfree        <none>     (no description available)
> pn  firmware-qlogic               <none>     (no description available)
> pn  firmware-ralink               <none>     (no description available)
> pn  xen-hypervisor                <none>     (no description available)
>=20
> -- debconf information:
>   linux-image-3.0.0-1-686-pae/postinst/ignoring-ramdisk:
> * linux-image-3.0.0-1-686-pae/postinst/missing-firmware-3.0.0-1-686-pae:
>=20
> linux-image-3.0.0-1-686-pae/prerm/removing-running-kernel-3.0.0-1-686-pae=
:
> true
>=20
> linux-image-3.0.0-1-686-pae/postinst/depmod-error-initrd-3.0.0-1-686-pae:=
 false
>=20
>=20
>=20


--=-4QpSPdqm2TbSe2KRBVJD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATlWAPee/yOyVhhEJAQpeSg//T6HZQ6NyDWYit18sLwbmV96aLYq08UFr
lZR6alALWftIvosFmWfJ2kqPDUEfe8L+nM0P8Erc91DL8XBA8kUKyBzvRPLBLBci
1Ga6nhssxLZjCIRTl/yjKRgCtIEDwZPwjscFAntde9xuqCtxqz1oHpSNf9MYbarl
PiYDgRn2DwSSn6zey3gGxPQT2FxrtjmVsrdnuC5Lt7dVnIzbO0EJzlbWEXUIgunS
iBNZ6Bw7UIeZ3VP4LZTK2yeOlDS6+XvvBnhKfuyPUh7zLzsfMPuDyxpyHmfAz0ix
N9nJ1d1u9GQyOfVGkqWkRn1Wd+PY2kQJkbHviXsJccy3vk+i7kFIsOeeNqyJJTJl
amKuQuXP6WYP9qtjGFzZYOIzETQ/dUVDu/ht5YelzQxC8YUv7y93PINA5g/Q9oS7
RJCC2IGypbCiT6imlqrwmF+yg4zTawawDKZ6LO0oq3uB77yrym8cTV5lHuGImE3a
qP9EGmSu7e6jfx0QmeMXQg7G904XB4jhAbww8gMnGCi7mGOf/NdT4sAo/GqZoz4b
vajwzh8Kr/cdVHefPHDnMMm2RbmqnaOKzT9tbnNwANIA+csxlxHBMa2Tdd6OzpYf
lOZwnTK6KrGbWkdhHE3gWq+JRX+h3jnZjZCafLwVH+6beHu+ZRXKj492iw7Kgv6o
37ZRF8aV2bg=
=Yzzz
-----END PGP SIGNATURE-----

--=-4QpSPdqm2TbSe2KRBVJD--
