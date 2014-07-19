Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-control.hrz.tu-darmstadt.de ([130.83.156.249]:46011 "EHLO
	lnx503.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758166AbaGSKan (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jul 2014 06:30:43 -0400
Date: Sat, 19 Jul 2014 12:30:26 +0200
From: Johannes Werner <johannes.werner@physik.tu-darmstadt.de>
To: Roberto Alcantara <roberto@eletronica.org>
Cc: linux-media@vger.kernel.org
Subject: Re: Siano Rio problems (idVendor=187f, idProduct=0600)
Message-ID: <20140719123026.5d5b4c9d@aeneas>
In-Reply-To: <27ABA78A-FCBA-4DA3-B001-55026BE467DF@eletronica.org>
References: <20140716141410.53d5fa5d@geo053104.klientdrift.uib.no>
	<27ABA78A-FCBA-4DA3-B001-55026BE467DF@eletronica.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/nsbwjZbQoLgmh2U6rIoLqqN"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/nsbwjZbQoLgmh2U6rIoLqqN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Roberto,

thanks for the reply (I guess I should have replied to the list only
as you are _probably_ subscribed?) I relly appreciate your input!

I guess you are on the right track, indeed I am trying to convince the
card (the usb stick) to do DVB-T Europe. The firmware name I am using
is hardcoded in the sms modules, see attached file "report2.txt", lines
21 and 22. The firmware seems to be at least a correct one for the
chip, loading works (line 38), probably I need to set the correct
device mode when loading the modules (line 43?) I tried to include the
mode in a modprobe.d/siano.conf file as in the smscoreapi.h, where it
has
enum SMS_DEVICE_MODE {
        DEVICE_MODE_NONE =3D -1,
        DEVICE_MODE_DVBT =3D 0,
 ...
 ...
which indeed leads to w_scan telling me:
Info: using DVB adapter auto detection.
	/dev/dvb/adapter0/frontend0 -> TERRESTRIAL "Siano Mobile
	Digital MDTV Receiver": good :-)

I now need to find the aerial and see if it works... and if it does
maybe write up a solution somewhere.
(What is also weird is that the firmware is included nowhere, but
referred to in the kernel modules)

Best,
Johannes

On Fri, 18 Jul 2014 21:27:56 -0300
Roberto Alcantara <roberto@eletronica.org> wrote:

> Johannes,
>=20
> For now Mauro Chehab is the maintainer for Siano tuners. Guys from Siano =
stops to send patch a long time ago.
>=20
> I=E2=80=99m using SMS2270 (Siano RIO) with ISDB-T. But your log shows "DV=
B-T Europe=E2=80=9D.
>=20
> Are you trying to tune ISDB-T Terrestrial stations as your firmware file =
name suggest?
>=20
> Try to enable debug inserting these options inside some file in /etc/modp=
robe.d/
>=20
> 	options smsusb debug=3D3
> 	options smsmdtv debug=3D3=20
>=20
> and be sure your firmware is loaded.
>=20
> regards,
>  - Roberto
>=20
>=20
> Em 16/07/2014, =C3=A0(s) 09:14, Johannes Werner <johannes.werner@physik.t=
u-darmstadt.de> escreveu:
>=20
> > Dear all,
> >=20
> > I hope this is the right place to ask for help / clarification
> > (linuxtv.org/ suggests it). I saw that Siano does indeed contribute to
> > the media drivers in the kernel (so I hope somebody relevant is reading
> > this). I have some questions about the Siano Rio chip that I could not
> > answer by asking google...
> >=20
> > First of all, the chip seems to be supported by the kernel (modules
> > load), but the firmware isdbt_rio.inp is not distributed by Ubuntu. I
> > could find a package at
> > http://repo.huayra.conectarigualdad.gob.ar/huayra/pool/non-free/f/firmw=
are-siano-rio/
> > and this contains a file with this name. This is the only place I could
> > find it on the interwebs.
> > Anyway, below is the actual problem (assuming the firmware mentioned
> > above is correct). I hope to get some hints on what I could try. I am
> > not afraid of building kernels, but haven't done so in a while...
> > Should I write a bug report? (where)?
> >=20
> > Thanks in advance,
> > Jo
> >=20
> >=20
> > Description:
> > Changes to the siano driver between 3.11 and 3.13 removed TERRESTRIAL
> > support for Siano Rio chipset from the driver.
> >=20
> >=20
> > Report:
> >=20
> > On my Netbook (Ubuntu 14.04, kernel 3.13) inserting the USB stick
> > results in
> >=20
> > -- dmesg output --
> > [] usb 1-1: new high-speed USB device number 5 using ehci-pci
> > [] usb 1-1: New USB device found, idVendor=3D187f,idProduct=3D0600=20
> > [] usb 1-1: New USB device strings: Mfr=3D1,Product=3D2, SerialNumber=
=3D0
> > [] usb 1-1: Product: MDTV Receiver
> > [] usb 1-1: Manufacturer: MDTV Receiver
> > [] DVB: registering new adapter (Siano Rio Digital Receiver)
> > [] usb 1-1: DVB: registering adapter 0 frontend 0 (Siano Mobile Digital
> > MDTV Receiver)...
> > -- end dmesg --
> >=20
> > and the modules being loaded.
> >=20
> > -- lsmod output
> > smsdvb                 18071  0=20
> > dvb_core              101206  1 smsdvb
> > smsusb                 17531  0=20
> > smsmdtv                48244  2 smsdvb,smsusb
> > rc_core                26724  1 smsmdtv
> > -- end lsmod --
> >=20
> > This looks promising. When trying to scan for station using w_scan
> > however:
> >=20
> > -- w_scan output --
> > w_scan version 20130331 (compiled for DVB API 5.10)
> > guessing country 'DE', use -c <country> to override
> > using settings for GERMANY
> > DVB aerial
> > DVB-T Europe
> > scan type TERRESTRIAL, channellist 4
> > output format vdr-2.0
> > output charset 'UTF-8', use -C <charset> to override
> > Info: using DVB adapter auto detection.
> > 	/dev/dvb/adapter0/frontend0 -> "Siano Mobile Digital MDTV
> > Receiver" doesnt support TERRESTRIAL -> SEARCH NEXT ONE. main:3228:
> > FATAL: ***** NO USEABLE TERRESTRIAL CARD FOUND. ***** Please check
> > wether dvb driver is loaded and verify that no dvb application (i.e.
> > vdr) is running.
> > -- end w_scan --
> >=20
> > even though this is a DVB-T receiver stick. Trying it on another machine
> > (where I cannot install the firmware) using Ubuntu 12.04.4, kernel 3.11
> > w_scan does indeed scan (but cannot find a signal because the firmware
> > is not loaded), see below. REMARK: even when not loading a firmware the
> > behaviour above (TERRESTRIAL not supported) persists.
> >=20
> > -- wscan output on other machine --
> > w_scan version 20111203 (compiled for DVB API 5.4)
> > WARNING: could not guess your country. Falling back to 'DE'
> > guessing country 'DE', use -c <country> to override
> > using settings for GERMANY
> > DVB aerial
> > DVB-T Europe
> > frontend_type DVB-T, channellist 4
> > output format vdr-1.6
> > WARNING: could not guess your codepage. Falling back to 'UTF-8'
> > output charset 'UTF-8', use -C <charset> to override
> > Info: using DVB adapter auto detection.
> > 	/dev/dvb/adapter0/frontend0 -> DVB-T "Siano Mobile Digital MDTV
> > Receiver": good :-) Using DVB-T frontend
> > (adapter /dev/dvb/adapter0/frontend0) -_-_-_-_ Getting frontend
> > capabilities-_-_-_-_ Using DVB API 5.a
> > frontend 'Siano Mobile Digital MDTV Receiver' supports
> > INVERSION_AUTO
> > QAM_AUTO
> > TRANSMISSION_MODE_AUTO
> > GUARD_INTERVAL_AUTO
> > HIERARCHY_AUTO
> > FEC_AUTO
> > FREQ (44.25MHz ... 867.25MHz)
> > [...]
> > -- end truncated wscan output --
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" =
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--MP_/nsbwjZbQoLgmh2U6rIoLqqN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=report2.txt

[28847.924304] usb 1-1: new high-speed USB device number 6 using ehci-pci
[28848.057603] usb 1-1: New USB device found, idVendor=187f, idProduct=0600
[28848.057625] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[28848.057641] usb 1-1: Product: MDTV Receiver
[28848.057655] usb 1-1: Manufacturer: MDTV Receiver
[28848.123124] smsusb_probe: board id=18, interface number 0
[28848.123135] smsusb_probe: smsusb_probe 0
[28848.123143] smsusb_probe: endpoint 0 81 02 512
[28848.124454] smsusb_probe: endpoint 1 02 02 512
[28848.126339] smsusb_init_device: in_ep = 81, out_ep = 02
[28848.126620] smscore_register_device: allocated 50 buffers
[28848.126637] smscore_register_device: device f074aa00 created
[28848.126646] smsusb_init_device: smsusb_start_streaming(...).
[28848.126686] smscore_set_device_mode: set device mode to 6
[28848.126699] smsusb_sendrequest: sending MSG_SMS_GET_VERSION_EX_REQ(668) size: 8
[28848.126900] smsusb_onresponse: received MSG_SMS_GET_VERSION_EX_RES(669) size: 100
[28848.126910] smscore_onresponse: Firmware id 255 prots 0x0 ver 8.1
[28848.126940] smscore_get_fw_filename: trying to get fw name from sms_boards board_id 18 mode 6
---
[28848.126948] smscore_get_fw_filename: cannot find fw name in sms_boards, getting from lookup table mode 6 type 7
[28848.126954] smscore_load_firmware_from_file: Firmware name: isdbt_rio.inp
---
[28848.127184] smscore_load_firmware_from_file: read fw isdbt_rio.inp, buffer size=0x15ed4
[28848.127249] smscore_load_firmware_family2: loading FW to addr 0x40260 size 89800
[28848.127330] smsusb_sendrequest: sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
[28848.127522] smsusb_onresponse: received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
 --- 742 more lines with that, I cut that --- 
[28848.235804] smsusb_sendrequest: sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 64
[28848.236033] smsusb_onresponse: received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
[28848.236110] smscore_load_firmware_family2: sending MSG_SMS_DATA_VALIDITY_REQ expecting 0xef779751
[28848.236133] smsusb_sendrequest: sending MSG_SMS_DATA_VALIDITY_REQ(662) size: 20
[28848.238289] smsusb_onresponse: received MSG_SMS_DATA_VALIDITY_RES(663) size: 12
[28848.238303] smscore_onresponse: MSG_SMS_DATA_VALIDITY_RES, checksum = 0xef779751
[28848.238351] smscore_load_firmware_family2: sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ
[28848.238374] smsusb_sendrequest: sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ(664) size: 28
[28848.238644] smsusb_onresponse: received MSG_SMS_SWDOWNLOAD_TRIGGER_RES(665) size: 12
[28848.640119] smscore_load_firmware_family2: rc=0
[28848.640166] smscore_set_device_mode: firmware download success
[28848.640180] smsusb_sendrequest: sending MSG_SMS_INIT_DEVICE_REQ(578) size: 12
[28848.640399] smsusb_onresponse: received MSG_SMS_INIT_DEVICE_RES(579) size: 12
[28848.640436] smsusb_sendrequest: sending MSG_SMS_INIT_DEVICE_REQ(578) size: 12
[28848.640649] smsusb_onresponse: received MSG_SMS_INIT_DEVICE_RES(579) size: 12
[28848.640680] smscore_set_device_mode: Success setting device mode.
[28848.640690] smscore_init_ir: IR port has not been detected
[28848.640698] smscore_start_device: device f074aa00 started, rc 0
[28848.640706] smsusb_init_device: device 0xec1e2000 created
[28848.640714] smsusb_probe: Device initialized with return code 0
[28848.661246] DVB: registering new adapter (Siano Rio Digital Receiver)
[28848.664771] usb 1-1: DVB: registering adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...
[28848.664921] smscore_register_client: eacc0800 693 1
[28848.667670] usbcore: registered new interface driver smsusb


--MP_/nsbwjZbQoLgmh2U6rIoLqqN--
