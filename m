Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:37871 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752802Ab1LDBdm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Dec 2011 20:33:42 -0500
From: David Kuehling <dvdkhlng@gmx.de>
To: linux-media@vger.kernel.org
Subject: dvb_usb_vp7045 regression after upgrading from 2.6.39.4 to 3.1.1
Date: Sun, 04 Dec 2011 02:33:32 +0100
Message-ID: <871uslp1cj.fsf@snail.Pool>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi,

after upgrading from 2.6.39.4 to 3.1.1., my usb dvb-t receiver started
having tuning problems.  Tuning with 'tzap' now randomly fails, as does
'scan'.

Of course I cannot rule out that the hardware is starting to wear down,
or that there are problems on the transmission side, but these problems
started after upgrading my kernel, so I thought I'd ask here.

Googeling for any changes, I so far only found this commit that affects
the vp7045 driver:

http://patchwork.linuxtv.org/patch/258/ (committed as
f2685ef0fbc5fff0a8f1cdc204bf37ab0c9a04a7)

This is the output I get from 'tzap' when it fails:
  __
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/spock/.tzap/channels.conf'
tuning to 618000000 Hz
video pid 0x0221, audio pid 0x0222
status 00 | signal 5f00 | snr ffff | ber 00ffffff | unc 0000ffff |=20
status 1f | signal 0000 | snr ffff | ber 00ffffff | unc 0000ffff | FE_HAS_L=
OCK
status 1f | signal 0000 | snr ffff | ber 00ffffff | unc 0000ffff | FE_HAS_L=
OCK
[..]
  __

or sometimes I get this:
  __
[..]
status 00 | signal 3000 | snr a0a0 | ber 00000000 | unc 00000000 |=20
status 00 | signal 3000 | snr 0000 | ber 00000000 | unc 00000000 |=20
status 00 | signal e146 | snr a0a0 | ber 00000000 | unc 00000000 |=20
status 00 | signal f14a | snr 0000 | ber 00000000 | unc 00000000 |=20
status 00 | signal 2154 | snr a0a0 | ber 00000000 | unc 00000000 |=20
status 00 | signal c141 | snr 0000 | ber 00000000 | unc 00000000 |=20
status 00 | signal f14c | snr a0a0 | ber 00000000 | unc 00000000 |=20
status 00 | signal f133 | snr 0000 | ber 00000000 | unc 00000000 |=20
[..]
  __

This is the output I get from 'scan', when it fails:
  __
scanning /usr/local/share/dvb/dvb-t/de-Berlin
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 506000000 0 2 9 1 1 2 0
initial transponder 522000000 0 2 9 1 1 2 0
initial transponder 570000000 0 2 9 1 1 3 0
initial transponder 618000000 0 2 9 3 1 2 0
initial transponder 658000000 0 2 9 1 1 2 0
initial transponder 682000000 0 2 9 1 1 2 0
initial transponder 706000000 0 2 9 1 1 2 0
initial transponder 754000000 0 2 9 1 1 2 0
initial transponder 778000000 0 2 9 1 1 2 0
>>> tune to: 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_=
16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
ARNING: filter timeout pid 0x0010
>>> tune to: 522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_=
16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSI=
ON_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
[..]
  __=20=20
(same 3 messages about filter timeout repeating for all transponders)

This is the 3.1.1 kernel log when the receiver is plugged in:

  __
[  178.480000] usb 1-2: new high speed USB device number 4 using ehci_hcd
[  178.612000] usb 1-2: New USB device found, idVendor=3D13d3, idProduct=3D=
3205
[  178.612000] usb 1-2: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[  180.588000] IR NEC protocol handler initialized
[  180.624000] IR RC5(x) protocol handler initialized
[  180.680000] IR RC6 protocol handler initialized
[  180.724000] IR JVC protocol handler initialized
[  180.764000] IR Sony protocol handler initialized
[  180.828000] IR MCE Keyboard/mouse protocol handler initialized
[  180.884000] dvb-usb: found a 'Twinhan USB2.0 DVB-T receiver (TwinhanDTV =
Alpha/MagicBox II)' in cold state, will try to load a firmware
[  180.904000] lirc_dev: IR Remote Control driver registered, major 251=20
[  180.904000] IR LIRC bridge handler initialized
[  181.020000] dvb-usb: downloading firmware from file 'dvb-usb-vp7045-01.f=
w'
[  181.104000] usbcore: registered new interface driver dvb_usb_vp7045
[  181.104000] usb 1-2: USB disconnect, device number 4
[  181.104000] dvb-usb: generic DVB-USB module successfully deinitialized a=
nd disconnected.
[  182.860000] usb 1-2: new high speed USB device number 5 using ehci_hcd
[  182.992000] usb 1-2: New USB device found, idVendor=3D13d3, idProduct=3D=
3206
[  182.992000] usb 1-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[  182.992000] usb 1-2: Product: VP-7045
[  182.992000] usb 1-2: Manufacturer: TWINHAN
[  182.996000] dvb-usb: found a 'Twinhan USB2.0 DVB-T receiver (TwinhanDTV =
Alpha/MagicBox II)' in warm state.
[  183.152000] dvb-usb: will pass the complete MPEG2 transport stream to th=
e software demuxer.
[  183.152000] DVB: registering new adapter (Twinhan USB2.0 DVB-T receiver =
(TwinhanDTV Alpha/MagicBox II))
[  183.224000] dvb-usb: MAC address: 08:ca:00:00:00:ff
[  183.236000] DVB: registering adapter 0 frontend 0 (Twinhan VP7045/46 USB=
 DVB-T)...
[  183.236000] input: IR-receiver inside an USB DVB receiver as /devices/pc=
i0000:00/0000:00:0e.5/usb1/1-2/input/input2
[  183.236000] dvb-usb: schedule remote query interval to 400 msecs.
[  183.392000] dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/Mag=
icBox II) successfully initialized and connected.
  __

Any ideas?

cheers,

David
=2D-=20
GnuPG public key: http://dvdkhlng.users.sourceforge.net/dk.gpg
Fingerprint: B17A DC95 D293 657B 4205  D016 7DEF 5323 C174 7D40

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7aze0ACgkQfe9TI8F0fUDKygCgj2GddpBIzsadByRjGaaTYJpT
gv0An167y6aSA5P+4neayydvoYYTmlOT
=t0KP
-----END PGP SIGNATURE-----
--=-=-=--
