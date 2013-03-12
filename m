Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:60891 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3CLCWz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 22:22:55 -0400
Received: by mail-ie0-f173.google.com with SMTP id 9so5721838iec.32
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2013 19:22:55 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 22:22:54 -0400
Message-ID: <CAMv0F5M9SSUwySz=ud3rc1FL1uAeacYyjHq1CGVGAMuvNK5rHg@mail.gmail.com>
Subject: MSI DigiVOX ATSC (0db0:8810). V4L-DVB build failing [Ubuntu 12.10]
From: Patrick Denney <patrickdenney2@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm attempting to build the latest drivers in hopes of getting the
following USB TV Tuner working:

Bus 001 Device 004: ID 0db0:8810 Micro Star International
Couldn't open device, some information will be missing
Device Descriptor:
 bLength                18
 bDescriptorType         1
 bcdUSB               2.00
 bDeviceClass            0 (Defined at Interface level)
 bDeviceSubClass         0
 bDeviceProtocol         0
 bMaxPacketSize0        64
 idVendor           0x0db0 Micro Star International
 idProduct          0x8810


I'm running ubuntu 12.10 with the 3.5.0-26-generic kernel.

I have cloned and ran build (without error) from the media_build
repository but am unable to perform a make install, I get the
following error (see below):

Any help would be much appreciated.

Hmm... distro kernel with a non-standard place for module backports detected.
Please always prefer to use vanilla upstream kernel with V4L/DVB
I'll try to remove old/obsolete LUM files from
/lib/modules/3.5.0-26-generic//updates/dkms:
Installing kernel modules under
/lib/modules/3.5.0-26-generic/kernel/drivers/media/:
	/: media.ko
	usb/b2c2/: b2c2-flexcop-usb.ko
	pci/cx23885/: altera-ci.ko cx23885.ko
	usb/usbvision/: usbvision.ko
	usb/dvb-usb-v2/: mxl111sf-tuner.ko dvb_usb_cypress_firmware.ko dvb_usb_v2.ko
		dvb-usb-rtl28xxu.ko dvb-usb-af9015.ko dvb-usb-lmedm04.ko
		dvb-usb-au6610.ko dvb-usb-af9035.ko mxl111sf-demod.ko
		dvb-usb-ce6230.ko dvb-usb-mxl111sf.ko dvb-usb-az6007.ko
		dvb-usb-anysee.ko dvb-usb-it913x.ko dvb-usb-gl861.ko
		dvb-usb-ec168.ko
	pci/saa7134/: saa6752hs.ko saa7134-empress.ko saa7134-alsa.ko
		saa7134-dvb.ko saa7134.ko
	usb/ttusb-dec/: ttusbdecfe.ko ttusb_dec.ko
	i2c/cx25840/: cx25840.ko
	pci/cx18/: cx18.ko cx18-alsa.ko
	usb/au0828/: au0828.ko
	v4l2-core/: videobuf2-memops.ko videobuf-dvb.ko v4l2-int-device.ko
		videobuf-dma-contig.ko videodev.ko v4l2-common.ko
		videobuf-dma-sg.ko videobuf-vmalloc.ko tuner.ko
		v4l2-mem2mem.ko videobuf2-core.ko videobuf2-dma-sg.ko
		videobuf2-vmalloc.ko videobuf-core.ko
	usb/s2255/: s2255drv.ko
	usb/tm6000/: tm6000-alsa.ko tm6000-dvb.ko tm6000.ko
	dvb-core/: dvb-core.ko
	usb/gspca/m5602/: gspca_m5602.ko
	parport/: w9966.ko c-qcam.ko bw-qcam.ko
	usb/dvb-usb/: dvb-usb-dtv5100.ko dvb-usb-opera.ko dvb-usb-cxusb.ko
		dvb-usb-vp7045.ko dvb-usb-af9005-remote.ko dvb-usb-technisat-usb2.ko
		dvb-usb-ttusb2.ko dvb-usb-dib0700.ko dvb-usb-az6027.ko
		dvb-usb-a800.ko dvb-usb-gp8psk.ko dvb-usb-dibusb-common.ko
		dvb-usb-pctv452e.ko dvb-usb-digitv.ko dvb-usb.ko
		dvb-usb-dibusb-mc.ko dvb-usb-af9005.ko dvb-usb-nova-t-usb2.ko
		dvb-usb-friio.ko dvb-usb-dtt200u.ko dvb-usb-cinergyT2.ko
		dvb-usb-vp702x.ko dvb-usb-umt-010.ko dvb-usb-dibusb-mb.ko
		dvb-usb-dw2102.ko dvb-usb-m920x.ko
	usb/pwc/: pwc.ko
	firewire/: firedtv.ko
	radio/si470x/: radio-usb-si470x.ko
	pci/dm1105/: dm1105.ko
	usb/tlg2300/: poseidon.ko
	usb/gspca/stv06xx/: gspca_stv06xx.ko
	pci/cx25821/: cx25821-alsa.ko cx25821.ko
	platform/: vivi.ko via-camera.ko timblogiw.ko
		mem2mem_testdev.ko
	pci/pluto2/: pluto2.ko
	rc/: ati_remote.ko lirc_dev.ko redrat3.ko
		ir-sony-decoder.ko gpio-ir-recv.ko ene_ir.ko
		mceusb.ko rc-core.ko streamzap.ko
		ir-nec-decoder.ko ir-rc5-decoder.ko fintek-cir.ko
		ir-rc6-decoder.ko rc-loopback.ko ir-jvc-decoder.ko
		ttusbir.ko ir-sanyo-decoder.ko nuvoton-cir.ko
		ir-rc5-sz-decoder.ko iguanair.ko ir-mce_kbd-decoder.ko
		ir-lirc-codec.ko imon.ko ite-cir.ko
		winbond-cir.ko
	common/: btcx-risc.ko cx2341x.ko tveeprom.ko
	platform/soc_camera/: soc_camera.ko soc_mediabus.ko soc_camera_platform.ko
	usb/sn9c102/: sn9c102.ko
	usb/siano/: smsusb.ko
	radio/: radio-keene.ko dsbr100.ko si4713-i2c.ko
		shark2.ko radio-shark.ko tef6862.ko
		radio-wl1273.ko radio-ma901.ko radio-maxiradio.ko
		saa7706h.ko radio-tea5764.ko radio-si4713.ko
		radio-timb.ko radio-mr800.ko
	rc/keymaps/: rc-tevii-nec.ko rc-terratec-slim.ko rc-adstech-dvb-t-pci.ko
		rc-medion-x10-or2x.ko rc-pctv-sedna.ko rc-proteus-2309.ko
		rc-msi-tvanywhere.ko rc-asus-ps3-100.ko rc-avermedia-dvbt.ko
		rc-pixelview.ko rc-avermedia-rm-ks.ko rc-snapstream-firefly.ko
		rc-dm1105-nec.ko rc-encore-enltv-fm53.ko rc-digittrade.ko
		rc-imon-mce.ko rc-evga-indtube.ko rc-em-terratec.ko
		rc-hauppauge.ko rc-gadmei-rm008z.ko rc-avermedia-m733a-rm-k6.ko
		rc-alink-dtu-m.ko rc-dntv-live-dvb-t.ko rc-anysee.ko
		rc-kworld-plus-tv-analog.ko rc-behold.ko rc-norwood.ko
		rc-pinnacle-color.ko rc-cinergy-1400.ko rc-leadtek-y04g0051.ko
		rc-avertv-303.ko rc-msi-digivox-ii.ko rc-total-media-in-hand.ko
		rc-trekstor.ko rc-ati-x10.ko rc-it913x-v2.ko
		rc-cinergy.ko rc-tivo.ko rc-manli.ko
		rc-eztv.ko rc-lme2510.ko rc-kworld-315u.ko
		rc-twinhan1027.ko rc-avermedia-a16d.ko rc-medion-x10.ko
		rc-tt-1500.ko rc-videomate-tv-pvr.ko rc-apac-viewcomp.ko
		rc-terratec-cinergy-xs.ko rc-nebula.ko rc-msi-tvanywhere-plus.ko
		rc-npgtech.ko rc-msi-digivox-iii.ko rc-ati-tv-wonder-hd-600.ko
		rc-videomate-m1f.ko rc-pinnacle-pctv-hd.ko rc-iodata-bctv7e.ko
		rc-pixelview-002t.ko rc-avermedia.ko rc-budget-ci-old.ko
		rc-imon-pad.ko rc-digitalnow-tinytwin.ko rc-nec-terratec-cinergy-xs.ko
		rc-winfast-usbii-deluxe.ko rc-flydvb.ko rc-videomate-s350.ko
		rc-pv951.ko rc-kworld-pc150u.ko rc-pixelview-mk12.ko
		rc-it913x-v1.ko rc-winfast.ko rc-lirc.ko
		rc-encore-enltv2.ko rc-pixelview-new.ko rc-purpletv.ko
		rc-fusionhdtv-mce.ko rc-technisat-usb2.ko rc-pinnacle-grey.ko
		rc-dib0700-rc5.ko rc-gotview7135.ko rc-kaiomy.ko
		rc-powercolor-real-angel.ko rc-terratec-slim-2.ko rc-avermedia-m135a.ko
		rc-azurewave-ad-tu700.ko rc-medion-x10-digitainer.ko rc-encore-enltv.ko
		rc-flyvideo.ko rc-tbs-nec.ko rc-dib0700-nec.ko
		rc-behold-columbus.ko rc-streamzap.ko rc-avermedia-cardbus.ko
		rc-real-audio-220-32-keys.ko rc-genius-tvgo-a11mce.ko
rc-total-media-in-hand-02.ko
		rc-rc6-mce.ko rc-dntv-live-dvbt-pro.ko rc-asus-pc39.ko
	pci/ngene/: ngene.ko
	pci/ttpci/: dvb-ttpci.ko budget-patch.ko ttpci-eeprom.ko
		budget-av.ko budget.ko budget-core.ko
		budget-ci.ko
	common/saa7146/: saa7146_vv.ko saa7146.ko
	pci/ivtv/: ivtvfb.ko ivtv-alsa.ko ivtv.ko
	usb/em28xx/: em28xx-dvb.ko em28xx-alsa.ko em28xx.ko
		em28xx-rc.ko
	pci/mantis/: mantis_core.ko mantis.ko hopper.ko
	pci/saa7164/: saa7164.ko
	pci/bt8xx/: bttv.ko dst_ca.ko dvb-bt8xx.ko
		bt878.ko dst.ko
	usb/pvrusb2/: pvrusb2.ko
	usb/stkwebcam/: stkwebcam.ko
	dvb-frontends/: nxt6000.ko dib7000m.ko m88rs2000.ko
		dib0090.ko s5h1411.ko drxd.ko
		dib9000.ko tda665x.ko dib8000.ko
		tda10071.ko nxt200x.ko stv0367.ko
		s921.ko lnbp22.ko rtl2830.ko
		s5h1409.ko atbm8830.ko cxd2820r.ko
		lg2160.ko dib3000mb.ko ec100.ko
		lgs8gl5.ko dib3000mc.ko a8293.ko
		stv0900.ko sp8870.ko tda8083.ko
		stv0297.ko tda10086.ko zl10353.ko
		mb86a16.ko lgs8gxx.ko au8522_common.ko
		stv0299.ko af9033.ko dvb-pll.ko
		cx22702.ko tda8261.ko hd29l2.ko
		tua6100.ko bcm3510.ko it913x-fe.ko
		or51211.ko stb0899.ko cx24113.ko
		tda826x.ko mb86a20s.ko af9013.ko
		drxk.ko ix2505v.ko si21xx.ko
		s5h1420.ko stv090x.ko stv0288.ko
		mt352.ko zl10039.ko isl6405.ko
		sp887x.ko dibx000_common.ko isl6421.ko
		mt312.ko or51132.ko rtl2832.ko
		tda1004x.ko tda18271c2dd.ko stv6110.ko
		itd1000.ko stv6110x.ko zl10036.ko
		lgdt3305.ko ts2020.ko dib7000p.ko
		l64781.ko ves1x93.ko stb6100.ko
		ves1820.ko dib0070.ko cx22700.ko
		cx24110.ko au8522_dig.ko dvb_dummy_fe.ko
		lgdt330x.ko cx24123.ko lnbp21.ko
		stb6000.ko isl6423.ko tda10023.ko
		cx24116.ko tda10021.ko au8522_decoder.ko
		tda10048.ko ds3000.ko s5h1432.ko
	tuners/: mt2063.ko xc4000.ko fc0012.ko
		e4000.ko fc0013.ko fc0011.ko
		tuner-xc2028.ko tda18218.ko mt2060.ko
		tda9887.ko tua9001.ko mt2131.ko
		mc44s803.ko qt1010.ko max2165.ko
		mt20xx.ko tda827x.ko tda18271.ko
		tda18212.ko xc5000.ko mxl5007t.ko
		tea5761.ko tuner-types.ko fc2580.ko
		tda8290.ko tuner-simple.ko mt2266.ko
		tea5767.ko mxl5005s.ko
	usb/stk1160/: stk1160.ko
	pci/zoran/: videocodec.ko zr36050.ko zr36016.ko
		zr36060.ko zr36067.ko
	pci/saa7146/: hexium_gemini.ko hexium_orion.ko mxb.ko
	usb/ttusb-budget/: dvb-ttusb-budget.ko
	i2c/soc_camera/: ov772x.ko ov9740.ko ov9640.ko
		tw9910.ko imx074.ko mt9v022.ko
		rj54n1cb0c.ko ov5642.ko mt9m001.ko
		mt9m111.ko mt9t031.ko ov2640.ko
		mt9t112.ko ov6650.ko
	usb/zr364xx/: zr364xx.ko
	mmc/siano/: smssdio.ko
	common/siano/: smsdvb.ko smsmdtv.ko
	pci/ddbridge/: ddbridge.ko
	usb/uvc/: uvcvideo.ko
	../linux/drivers/misc/altera-stapl/: altera-stapl.ko
	i2c/: adp1653.ko s5k6aa.ko vpx3220.ko
		ad9389b.ko adv7175.ko bt856.ko
		cs53l32a.ko adv7604.ko adv7343.ko
		upd64083.ko saa7115.ko saa7110.ko
		noon010pc30.ko saa6588.ko ths7303.ko
		tda9840.ko saa7191.ko ak881x.ko
		tvp7002.ko wm8775.ko adv7180.ko
		saa7185.ko mt9p031.ko tvp5150.ko
		s5k4ecgx.ko ov9650.ko vp27smpx.ko
		adv7170.ko smiapp-pll.ko ks0127.ko
		ov7670.ko aptina-pll.ko tvaudio.ko
		saa7127.ko tea6420.ko bt866.ko
		mt9v011.ko m52790.ko msp3400.ko
		tvp514x.ko as3645a.ko tcm825x.ko
		wm8739.ko mt9v032.ko sr030pc30.ko
		tda7432.ko cs5345.ko saa717x.ko
		vs6624.ko ir-kbd-i2c.ko upd64031a.ko
		mt9m032.ko tea6415c.ko tlv320aic23b.ko
		adv7393.ko bt819.ko mt9t001.ko
		adv7183.ko
	usb/cpia2/: cpia2.ko
	usb/cx231xx/: cx231xx.ko cx231xx-dvb.ko cx231xx-alsa.ko
	usb/gspca/gl860/: gspca_gl860.ko
	pci/b2c2/: b2c2-flexcop-pci.ko
	usb/hdpvr/: hdpvr.ko
	pci/pt1/: earth-pt1.ko
	common/b2c2/: b2c2-flexcop.ko
	pci/meye/: meye.ko
	pci/cx88/: cx8802.ko cx8800.ko cx88-blackbird.ko
		cx88-alsa.ko cx88xx.ko cx88-vp3054-i2c.ko
		cx88-dvb.ko
	usb/gspca/: gspca_xirlink_cit.ko gspca_stk014.ko gspca_spca501.ko
		gspca_spca500.ko gspca_mars.ko gspca_spca1528.ko
		gspca_stv0680.ko gspca_sunplus.ko gspca_vc032x.ko
		gspca_benq.ko gspca_spca505.ko gspca_sn9c20x.ko
		gspca_zc3xx.ko gspca_vicam.ko gspca_sq930x.ko
		gspca_topro.ko gspca_sq905c.ko gspca_sonixb.ko
		gspca_jl2005bcd.ko gspca_etoms.ko gspca_pac7302.ko
		gspca_pac207.ko gspca_konica.ko gspca_ov534_9.ko
		gspca_spca508.ko gspca_nw80x.ko gspca_sq905.ko
		gspca_t613.ko gspca_sn9c2028.ko gspca_spca561.ko
		gspca_ov534.ko gspca_tv8532.ko gspca_jeilinj.ko
		gspca_spca506.ko gspca_se401.ko gspca_sonixj.ko
		gspca_main.ko gspca_cpia1.ko gspca_mr97310a.ko
		gspca_conex.ko gspca_kinect.ko gspca_pac7311.ko
		gspca_ov519.ko gspca_finepix.ko
/sbin/depmod -a 3.5.0-26-generic
make -C firmware install
make[2]: Entering directory `/home/patrick/media_build/v4l/firmware'
Installing firmwares at /lib/firmware: vicam/firmware.fw
dabusb/firmware.fw cp: cannot stat `dabusb/firmware.fw': No such file
or directory
dabusb/bitstream.bin cp: cannot stat `dabusb/bitstream.bin': No such
file or directory
ttusb-budget/dspbootcode.bin cpia2/stv0672_vp4.bin av7110/bootcode.bin
dvb-fe-bcm3510-01.fw dvb-fe-or51132-qam.fw dvb-fe-or51132-vsb.fw
dvb-fe-or51211.fw dvb-fe-xc5000-1.6.114.fw dvb-ttpci-01.fw-261a
dvb-ttpci-01.fw-261b dvb-ttpci-01.fw-261c dvb-ttpci-01.fw-261d
dvb-ttpci-01.fw-261f dvb-ttpci-01.fw-2622 dvb-usb-avertv-a800-02.fw
dvb-usb-bluebird-01.fw dvb-usb-dib0700-1.20.fw
dvb-usb-dibusb-5.0.0.11.fw dvb-usb-dibusb-6.0.0.8.fw
dvb-usb-dtt200u-01.fw dvb-usb-terratec-h5-drxk.fw
dvb-usb-terratec-h7-az6007.fw dvb-usb-terratec-h7-drxk.fw
dvb-usb-umt-010-02.fw dvb-usb-vp702x-01.fw dvb-usb-vp7045-01.fw
dvb-usb-wt220u-01.fw dvb-usb-wt220u-02.fw v4l-cx231xx-avcore-01.fw
v4l-cx23418-apu.fw v4l-cx23418-cpu.fw v4l-cx23418-dig.fw
v4l-cx23885-avcore-01.fw v4l-cx23885-enc.fw v4l-cx25840.fw

Regards,
Patrick
