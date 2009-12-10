Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:55483 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbZLJPSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 10:18:22 -0500
Received: by fxm5 with SMTP id 5so9030857fxm.28
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 07:18:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0912100250x349930d6ybcd22cf7cab6237f@mail.gmail.com>
References: <ad6681df0912090617k768b7f22p9abfb462ff32026f@mail.gmail.com>
	<829197380912090826w3821ce97i3df653a2d7c83f0f@mail.gmail.com>
	<ad6681df0912090911w13a1c2e1q2a4e59cec2c4e000@mail.gmail.com>
	<829197380912090916q61d45ddbraf89852dc524dcf3@mail.gmail.com>
	<ad6681df0912090949k2bbdd926tc6b14ab690e9bb26@mail.gmail.com>
	<829197380912090951u38928896ne85d1202d22eba8a@mail.gmail.com>
	<829197380912090952g3ade79dbg9bbba03dcb18a4a7@mail.gmail.com>
	<ad6681df0912091021j63de38f1t17e5beaa935931d1@mail.gmail.com>
	<829197380912091053o7cad8737o8acf76a3d6abe8fd@mail.gmail.com>
	<ad6681df0912100250x349930d6ybcd22cf7cab6237f@mail.gmail.com>
From: Valerio Bontempi <valerio.bontempi@gmail.com>
Date: Thu, 10 Dec 2009 16:18:07 +0100
Message-ID: <ad6681df0912100718k4bb57e49k82fb1696cf8d4add@mail.gmail.com>
Subject: Re: v4l-dvb from source on 2.6.31.5 opensuse kernel - not working
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/12/10 Valerio Bontempi <valerio.bontempi@gmail.com>:
> 2009/12/9 Devin Heitmueller <dheitmueller@kernellabs.com>:
>> On Wed, Dec 9, 2009 at 1:21 PM, Valerio Bontempi
>>> I don't know how it is happened, because I followed the normal way to
>>> compile v4l-dvb, so it seems a very strange behaviour...
>>>
>>> however, how can I solve, cleaning out all the in-kernel modules and
>>> all the modules I need to remove?
>>
>> Well, the problem wasn't that you compiled v4l-dvb.  It's that you had
>> these third party em28xx modules installed (which rely on v4l-dvb).
>> And a recompile of v4l-dvb breaks compatibility for those third party
>> modules.
>>
>> Without knowing how you installed the third party em28xx stuff, I
>> cannot really advise you on the best way to remove them.  If it were
>> me, I would probably just move all of those files to some temporary
>> directory and reboot (which would allow me to restore them if I
>> screwed something up).  However, I wouldn't want to be held
>> responsible for a user screwing up his machine.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com
>>
>
>
> Hi,
>
> I managed to clean installed modules (an opensuse unofficial
> repository provides em28xx-new kernel module so I needed to uninstall
> it) and then I compiled and installed again my modified version of
> v4l-dvb
> Now em28xx is loaded correctly, but dvb tuner is not initialized
> Below the part of dmesg related to the error
>
> [    8.061407] em28xx: New device TerraTec Electronic GmbH Cinergy T
> USB XS @ 480 Mbps (0ccd:0043, interface 0, class 0)
> [    8.061509] em28xx #0: chip ID is em2870
> [    8.172499] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 43 00 c0 12
> 5c 00 9e 24 6a 34
> [    8.172512] em28xx #0: i2c eeprom 10: 00 00 06 57 02 0c 00 00 00 00
> 00 00 00 00 00 00
> [    8.172574] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 01 00 00 00
> 00 00 5b 00 00 00
> [    8.172587] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
> 00 00 00 00 00 00
> [    8.172598] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    8.172609] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    8.172621] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
> 34 03 54 00 65 00
> [    8.172632] em28xx #0: i2c eeprom 70: 72 00 72 00 61 00 54 00 65 00
> 63 00 20 00 45 00
> [    8.172643] em28xx #0: i2c eeprom 80: 6c 00 65 00 63 00 74 00 72 00
> 6f 00 6e 00 69 00
> [    8.172655] em28xx #0: i2c eeprom 90: 63 00 20 00 47 00 6d 00 62 00
> 48 00 00 00 24 03
> [    8.172666] em28xx #0: i2c eeprom a0: 43 00 69 00 6e 00 65 00 72 00
> 67 00 79 00 20 00
> [    8.172678] em28xx #0: i2c eeprom b0: 54 00 20 00 55 00 53 00 42 00
> 20 00 58 00 53 00
> [    8.172689] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    8.172700] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    8.172712] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    8.172723] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    8.172736] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xbfdf1b96
> [    8.172738] em28xx #0: EEPROM info:
> [    8.172740] em28xx #0:       No audio on board.
> [    8.172742] em28xx #0:       500mA max power
> [    8.172744] em28xx #0:       Table at 0x06, strings=0x249e, 0x346a, 0x0000
> [    8.173347] em28xx #0: Identified as Terratec Cinergy T XS (card=43)
> [    8.173350] em28xx #0:
> [    8.173351]
> [    8.173454] em28xx #0: The support for this board weren't valid yet.
> [    8.173504] em28xx #0: Please send a report of having this working
> [    8.173553] em28xx #0: not to V4L mailing list (and/or to other addresses)
> [    8.173555]
> [    8.474416] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80000f828c2]
> [    8.528409] ieee1394: Host added: ID:BUS[1-00:1023]  GUID[00023c01510ec213]
> [    8.947399] tuner 2-0061: chip found @ 0xc2 (em28xx #0)
> [    8.969375] xc2028 2-0061: creating new instance
> [    8.969381] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> [    8.969391] usb 1-4: firmware: requesting xc3028-v27.fw
> [    9.035956] xc2028 2-0061: Loading 80 firmware images from
> xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> [    9.068266] xc2028 2-0061: Loading firmware for type=BASE (1), id
> 0000000000000000.
> [   10.456270] xc2028 2-0061: Loading firmware for type=(0), id
> 000000000000b700.
> [   10.482264] SCODE (20000000), id 000000000000b700:
> [   10.482272] xc2028 2-0061: Loading SCODE for type=MONO SCODE
> HAS_IF_4320 (60008000), id 0000000000008000.
> [   10.604270] em28xx #0: v4l2 driver version 0.1.2
> [   10.609181] em28xx #0: V4L2 video device registered as /dev/video1
> [   10.610313] usbcore: registered new interface driver em28xx
> [   10.610318] em28xx driver loaded
> [   10.689974] zl10353_read_register: readreg error (reg=127, ret==-19)
> [   10.707974] mt352_read_register: readreg error (reg=127, ret==-19)
> [   10.708071] em28xx #0: /2: dvb frontend not attached. Can't attach xc3028
> [   10.708153] Em28xx: Initialized (Em28xx dvb Extension) extension
>
> The same driver source code works fine on ubuntu 9.10, so I can't
> uderstand where could be the problem.
>
> Valerio
>

Analyzing ubuntu 9.10 dmesg I found that zl10353_read_register should not fail
Moreover opensuse 11.2 and ubuntu 9.10 have the same kernel release,
2.6.31, so it should work fine...
I tried with last v4l-dvb release (unmodified) but modprobe em28xx fails

#modprobe em28xx
FATAL: Error inserting em28xx
(/lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx.ko):
Unknown symbol in module, or unknown parameter (see dmesg)


And from dmesg

[ 4028.719330] Linux video capture interface: v2.00
[ 4028.738588] em28xx: disagrees about version of symbol videobuf_streamoff
[ 4028.738608] em28xx: Unknown symbol videobuf_streamoff
[ 4028.738824] em28xx: disagrees about version of symbol videobuf_poll_stream
[ 4028.738833] em28xx: Unknown symbol videobuf_poll_stream
[ 4028.739027] em28xx: disagrees about version of symbol v4l2_i2c_new_subdev_cfg
[ 4028.739036] em28xx: Unknown symbol v4l2_i2c_new_subdev_cfg
[ 4028.739436] em28xx: disagrees about version of symbol
ir_codes_evga_indtube_table
[ 4028.739447] em28xx: Unknown symbol ir_codes_evga_indtube_table
[ 4028.739549] em28xx: disagrees about version of symbol videobuf_reqbufs
[ 4028.739558] em28xx: Unknown symbol videobuf_reqbufs
[ 4028.739719] em28xx: disagrees about version of symbol
ir_codes_gadmei_rm008z_table
[ 4028.739729] em28xx: Unknown symbol ir_codes_gadmei_rm008z_table
[ 4028.739843] em28xx: disagrees about version of symbol videobuf_queue_is_busy
[ 4028.739852] em28xx: Unknown symbol videobuf_queue_is_busy
[ 4028.739954] em28xx: disagrees about version of symbol videobuf_dqbuf
[ 4028.739962] em28xx: Unknown symbol videobuf_dqbuf
[ 4028.740108] em28xx: disagrees about version of symbol videobuf_to_vmalloc
[ 4028.740117] em28xx: Unknown symbol videobuf_to_vmalloc
[ 4028.740215] em28xx: disagrees about version of symbol v4l2_i2c_subdev_addr
[ 4028.740224] em28xx: Unknown symbol v4l2_i2c_subdev_addr
[ 4028.740336] em28xx: disagrees about version of symbol
ir_codes_pinnacle_grey_table
[ 4028.740360] em28xx: Unknown symbol ir_codes_pinnacle_grey_table
[ 4028.740463] em28xx: disagrees about version of symbol
ir_codes_hauppauge_new_table
[ 4028.740473] em28xx: Unknown symbol ir_codes_hauppauge_new_table
[ 4028.740574] em28xx: disagrees about version of symbol videobuf_vmalloc_free
[ 4028.740583] em28xx: Unknown symbol videobuf_vmalloc_free
[ 4028.740871] em28xx: disagrees about version of symbol video_devdata
[ 4028.740879] em28xx: Unknown symbol video_devdata
[ 4028.741400] em28xx: disagrees about version of symbol videobuf_stop
[ 4028.741408] em28xx: Unknown symbol videobuf_stop
[ 4028.741544] em28xx: disagrees about version of symbol ir_codes_kaiomy_table
[ 4028.741553] em28xx: Unknown symbol ir_codes_kaiomy_table
[ 4028.741657] em28xx: disagrees about version of symbol videobuf_read_stream
[ 4028.741665] em28xx: Unknown symbol videobuf_read_stream
[ 4028.741898] em28xx: disagrees about version of symbol videobuf_querybuf
[ 4028.741906] em28xx: Unknown symbol videobuf_querybuf
[ 4028.742006] em28xx: disagrees about version of symbol ir_input_init
[ 4028.742014] em28xx: Unknown symbol ir_input_init
[ 4028.742194] em28xx: disagrees about version of symbol video_unregister_device
[ 4028.742203] em28xx: Unknown symbol video_unregister_device
[ 4028.742308] em28xx: disagrees about version of symbol videobuf_qbuf
[ 4028.742317] em28xx: Unknown symbol videobuf_qbuf
[ 4028.742513] em28xx: disagrees about version of symbol
ir_codes_terratec_cinergy_xs_table
[ 4028.742523] em28xx: Unknown symbol ir_codes_terratec_cinergy_xs_table
[ 4028.742621] em28xx: disagrees about version of symbol video_device_alloc
[ 4028.742630] em28xx: Unknown symbol video_device_alloc
[ 4028.742729] em28xx: disagrees about version of symbol
ir_codes_ati_tv_wonder_hd_600_table
[ 4028.742740] em28xx: Unknown symbol ir_codes_ati_tv_wonder_hd_600_table
[ 4028.742839] em28xx: disagrees about version of symbol v4l2_device_disconnect
[ 4028.742848] em28xx: Unknown symbol v4l2_device_disconnect
[ 4028.742973] em28xx: disagrees about version of symbol video_register_device
[ 4028.742982] em28xx: Unknown symbol video_register_device
[ 4028.743133] em28xx: disagrees about version of symbol v4l2_device_register
[ 4028.743142] em28xx: Unknown symbol v4l2_device_register
[ 4028.743242] em28xx: disagrees about version of symbol ir_input_nokey
[ 4028.743257] em28xx: Unknown symbol ir_input_nokey
[ 4028.743609] em28xx: disagrees about version of symbol videobuf_iolock
[ 4028.743618] em28xx: Unknown symbol videobuf_iolock
[ 4028.743752] em28xx: disagrees about version of symbol videobuf_streamon
[ 4028.743761] em28xx: Unknown symbol videobuf_streamon
[ 4028.743863] em28xx: disagrees about version of symbol
ir_codes_em_terratec_table
[ 4028.743872] em28xx: Unknown symbol ir_codes_em_terratec_table
[ 4028.744213] em28xx: Unknown symbol ir_input_free
[ 4028.744409] em28xx: disagrees about version of symbol
videobuf_queue_vmalloc_init
[ 4028.744483] em28xx: Unknown symbol videobuf_queue_vmalloc_init
[ 4028.744582] em28xx: disagrees about version of symbol v4l2_device_unregister
[ 4028.744591] em28xx: Unknown symbol v4l2_device_unregister
[ 4028.744884] em28xx: disagrees about version of symbol video_device_release
[ 4028.744893] em28xx: Unknown symbol video_device_release
[ 4028.745083] em28xx: disagrees about version of symbol videobuf_mmap_mapper
[ 4028.745092] em28xx: Unknown symbol videobuf_mmap_mapper
[ 4028.745191] em28xx: disagrees about version of symbol ir_input_keydown
[ 4028.745200] em28xx: Unknown symbol ir_input_keydown
[ 4028.745312] em28xx: disagrees about version of symbol videobuf_cgmbuf
[ 4028.745321] em28xx: Unknown symbol videobuf_cgmbuf
[ 4028.745443] em28xx: Unknown symbol ir_codes_rc5_hauppauge_new_table
[ 4028.745759] em28xx: disagrees about version of symbol
ir_codes_pinnacle_pctv_hd_table
[ 4028.745768] em28xx: Unknown symbol ir_codes_pinnacle_pctv_hd_table
[ 4028.745868] em28xx: disagrees about version of symbol videobuf_mmap_free
[ 4028.745876] em28xx: Unknown symbol videobuf_mmap_free
