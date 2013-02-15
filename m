Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37082 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab3BOPs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 10:48:58 -0500
Received: by mail-wi0-f179.google.com with SMTP id ez12so1334596wid.6
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 07:48:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51165A8E.10805@gmail.com>
References: <50F05C09.3010104@iki.fi> <CAHsu+b8UAh5VD_V4Ub6g7z_5LC=NH1zuY77Yv5nBefnrEwUHMw@mail.gmail.com>
 <510A78D8.7030602@iki.fi> <CAHsu+b-TdcBaM_JzsON40k+4sifL27xM-AV8M6bdMt9L3ZCpeA@mail.gmail.com>
 <510ABD7F.6030200@iki.fi> <51165A8E.10805@gmail.com>
From: pierigno <pierigno@gmail.com>
Date: Fri, 15 Feb 2013 16:48:16 +0100
Message-ID: <CAN7fRVuO3JRRd+Wmt-2=35t1EL6EJithNWg3mfCkSPJ8Vg9p7w@mail.gmail.com>
Subject: Re: af9035 test needed!
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Andre Heider <a.heider@gmail.com>,
	Jose Alberto Reguero <jareguero@telefonica.net>,
	gennarone@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've tested my AverMedia Twinstar (A825) against the latest antti's
git repository, branch it9135_tuner. The following patches make the
stick works in dual mode with all the currenty available firmware,that
is:

dvb-usb-af9035-02.fw_0184ba128bee3befe2fc49f144a8dbab_12.5.13.0_6.8.13.bin
dvb-usb-af9035-02.fw_085e676dc50addf538b6cb18f4ca233a_12.13.15.0_6.20.15.bin
dvb-usb-af9035-02.fw_14ae2b81bac90ff5c6b490c225265267_12.13.15.0_6.20.15.bin
dvb-usb-af9035-02.fw_3735d499d945a6bb873a7f3ad5c701fa_12.13.15.0_6.20.15.bin
dvb-usb-af9035-02.fw_7cdc1e3aba54f3a9ad052dc6a29603fd_11.10.10.0_5.33.10.bin
dvb-usb-af9035-02.fw_f71efe295151ba76cac2280680b69f3f_11.5.9.0_5.17.9.bin


general output of dmesg:
[112271.422441] usb 2-1.2.4: new high-speed USB device number 18 using ehci_hcd
[112271.503855] usb 2-1.2.4: New USB device found, idVendor=07ca, idProduct=0825
[112271.503867] usb 2-1.2.4: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[112271.503873] usb 2-1.2.4: Product: A825
[112271.503879] usb 2-1.2.4: Manufacturer: AVerMedia TECHNOLOGIES, Inc.
[112271.503884] usb 2-1.2.4: SerialNumber: 3018704000300
[112271.506973] usb 2-1.2.4: af9035_identify_state: prechip_version=00
chip_version=03 chip_type=3802
[112271.507348] usb 2-1.2.4: dvb_usb_v2: found a 'AVerMedia Twinstar
(A825)' in cold state
[112271.507491] usb 2-1.2.4: dvb_usb_v2: downloading firmware from
file 'dvb-usb-af9035-02.fw'
[112274.148675] usb 2-1.2.4: dvb_usb_af9035: firmware version=12.5.13.0
[112274.148714] usb 2-1.2.4: dvb_usb_v2: found a 'AVerMedia Twinstar
(A825)' in warm state
[112274.152673] usb 2-1.2.4: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[112274.152723] DVB: registering new adapter (AVerMedia Twinstar (A825))
[112274.154013] 909: i2c i2c-7: af9033_attach:
[112274.154864] i2c i2c-7: af9033: firmware version: LINK=12.5.13.0
OFDM=6.8.13.0
[112274.154876] usb 2-1.2.4: DVB: registering adapter 0 frontend 0
(Afatech AF9033 (DVB-T))...
[112274.490178] mxl5007t 7-0060: creating new instance
[112274.490888] mxl5007t_get_chip_id: unknown rev (3f)
[112274.490894] mxl5007t_get_chip_id: MxL5007T detected @ 7-0060
[112274.490906] usb 2-1.2.4: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[112274.490955] DVB: registering new adapter (AVerMedia Twinstar (A825))
[112274.491655] 909: i2c i2c-7: af9033_attach:
[112274.503395] i2c i2c-7: af9033: firmware version: LINK=12.5.13.0
OFDM=6.8.13.0
[112274.503415] usb 2-1.2.4: DVB: registering adapter 1 frontend 0
(Afatech AF9033 (DVB-T))...
[112274.503631] mxl5007t 7-00e0: creating new instance
[112274.509382] mxl5007t_get_chip_id: unknown rev (3f)
[112274.509394] mxl5007t_get_chip_id: MxL5007T detected @ 7-00e0
[112274.520989] usb 2-1.2.4: dvb_usb_v2: 'AVerMedia Twinstar (A825)'
successfully initialized and connected


The two adapters works quite reliably, adapters can perform scanning
independently and at the same time, and all channels get recocgnized
by both of them.

However, there are some sporadic image glitches while watching a
channel on adapter 0 and at the same time performing a scanning on
adapater 1. After the scan, though, glitches do not appear anymore. On
the other hand, there are no image glithces at all watching a channel
on adapter 1 and performing at the same time a scan on adapter0.



diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
b/drivers/media/usb/dvb-usb-v2/af9035.c
index a1e953a..c051083 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -628,6 +628,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		if (ret < 0)
 			goto err;

+		state->af9033_config[1].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 		state->af9033_config[1].i2c_addr = tmp;
 		dev_dbg(&d->udev->dev, "%s: 2nd demod I2C addr=%02x\n",
 				__func__, tmp);
@@ -673,6 +674,8 @@ static int af9035_read_config(struct dvb_usb_device *d)
 			switch (tmp) {
 			case AF9033_TUNER_FC0012:
 				break;
+			case AF9033_TUNER_MXL5007T:
+				break;
 			default:
 				state->dual_mode = false;
 				dev_info(&d->udev->dev,
