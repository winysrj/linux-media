Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42J27Ew026350
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 15:02:07 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42J1eff031804
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 15:01:40 -0400
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@gmail.com>
In-Reply-To: <e686f5060805021035w1f804d9eifde9c7837737e618@mail.gmail.com>
References: <e686f5060805021035w1f804d9eifde9c7837737e618@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 14:56:41 -0400
Message-Id: <1209754601.3269.30.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, ivtv-users@ivtvdriver.org
Subject: Re: Trouble with drivers for CX18, CX23885, IVTV
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 2008-05-02 at 13:35 -0400, Brandon Jenkins wrote:
> Greetings,
> 
> When the CX18 merge to the V4L tree happened, I began pulling the
> source from the v4l mercurial. Everything compiles correctly, but upon
> reboot the only driver which loads for me is cx88 all others fail
> with:
> 
> [    8.554593] videobuf_dvb: disagrees about version of symbol
> videobuf_read_stop
> [    8.554596] videobuf_dvb: Unknown symbol videobuf_read_stop
> [    8.554615] videobuf_dvb: disagrees about version of symbol videobuf_waiton
> [    8.554616] videobuf_dvb: Unknown symbol videobuf_waiton
> [    8.554657] videobuf_dvb: Unknown symbol videobuf_queue_to_vmalloc
> [    8.554689] videobuf_dvb: disagrees about version of symbol
> videobuf_read_start
> [    8.554691] videobuf_dvb: Unknown symbol videobuf_read_start
> [    8.763114] cx18: disagrees about version of symbol video_unregister_device
> [    8.763117] cx18: Unknown symbol video_unregister_device
> [    8.763165] cx18: disagrees about version of symbol video_device_alloc
> [    8.763167] cx18: Unknown symbol video_device_alloc
> [    8.763190] cx18: disagrees about version of symbol video_register_device
> [    8.763191] cx18: Unknown symbol video_register_device
> [    8.763437] cx18: disagrees about version of symbol video_device_release
> [    8.763438] cx18: Unknown symbol video_device_release
> [    8.784514] cx23885: disagrees about version of symbol videobuf_streamoff
> [    8.784517] cx23885: Unknown symbol videobuf_streamoff
> [    8.784560] cx23885: disagrees about version of symbol videobuf_poll_stream
> [    8.784562] cx23885: Unknown symbol videobuf_poll_stream
> [    8.784603] cx23885: disagrees about version of symbol videobuf_read_stop
> [    8.784605] cx23885: Unknown symbol videobuf_read_stop
> [    8.784671] cx23885: disagrees about version of symbol videobuf_dma_free
> [    8.784672] cx23885: Unknown symbol videobuf_dma_free
> [    8.784710] cx23885: disagrees about version of symbol videobuf_reqbufs
> [    8.784712] cx23885: Unknown symbol videobuf_reqbufs
> [    8.784752] cx23885: disagrees about version of symbol videobuf_waiton
> [    8.784754] cx23885: Unknown symbol videobuf_waiton
> [    8.784776] cx23885: disagrees about version of symbol videobuf_dqbuf
> [    8.784778] cx23885: Unknown symbol videobuf_dqbuf
> [    8.784940] cx23885: disagrees about version of symbol btcx_riscmem_alloc
> [    8.784941] cx23885: Unknown symbol btcx_riscmem_alloc
> [    8.784977] cx23885: disagrees about version of symbol btcx_riscmem_free
> [    8.784978] cx23885: Unknown symbol btcx_riscmem_free
> [    8.784995] cx23885: disagrees about version of symbol videobuf_queue_sg_init
> [    8.784996] cx23885: Unknown symbol videobuf_queue_sg_init
> [    8.785018] cx23885: Unknown symbol videobuf_dvb_unregister
> [    8.785050] cx23885: disagrees about version of symbol videobuf_dma_unmap
> [    8.785051] cx23885: Unknown symbol videobuf_dma_unmap
> [    8.785068] cx23885: disagrees about version of symbol videobuf_read_stream
> [    8.785070] cx23885: Unknown symbol videobuf_read_stream
> [    8.785093] cx23885: Unknown symbol videobuf_dvb_register
> [    8.785118] cx23885: disagrees about version of symbol videobuf_querybuf
> [    8.785119] cx23885: Unknown symbol videobuf_querybuf
> [    8.785135] cx23885: disagrees about version of symbol
> video_unregister_device
> [    8.785136] cx23885: Unknown symbol video_unregister_device
> [    8.785153] cx23885: disagrees about version of symbol videobuf_qbuf
> [    8.785155] cx23885: Unknown symbol videobuf_qbuf
> [    8.785189] cx23885: disagrees about version of symbol video_device_alloc
> [    8.785190] cx23885: Unknown symbol video_device_alloc
> [    8.785207] cx23885: disagrees about version of symbol videobuf_read_one
> [    8.785209] cx23885: Unknown symbol videobuf_read_one
> [    8.785233] cx23885: disagrees about version of symbol video_register_device
> [    8.785234] cx23885: Unknown symbol video_register_device
> [    8.785344] cx23885: disagrees about version of symbol videobuf_iolock
> [    8.785346] cx23885: Unknown symbol videobuf_iolock
> [    8.785369] cx23885: disagrees about version of symbol videobuf_streamon
> [    8.785371] cx23885: Unknown symbol videobuf_streamon
> [    8.785390] cx23885: disagrees about version of symbol videobuf_queue_cancel
> [    8.785391] cx23885: Unknown symbol videobuf_queue_cancel
> [    8.785462] cx23885: disagrees about version of symbol video_device_release
> [    8.785464] cx23885: Unknown symbol video_device_release
> [    8.785480] cx23885: disagrees about version of symbol videobuf_mmap_mapper
> [    8.785481] cx23885: Unknown symbol videobuf_mmap_mapper
> [    8.785527] cx23885: disagrees about version of symbol videobuf_to_dma
> [    8.785528] cx23885: Unknown symbol videobuf_to_dma
> [    8.785544] cx23885: disagrees about version of symbol videobuf_mmap_free
> [    8.785546] cx23885: Unknown symbol videobuf_mmap_free
> [    8.306366] ivtv: disagrees about version of symbol video_unregister_device
> [    8.306368] ivtv: Unknown symbol video_unregister_device
> [    8.306404] ivtv: disagrees about version of symbol video_device_alloc
> [    8.306406] ivtv: Unknown symbol video_device_alloc
> [    8.306437] ivtv: disagrees about version of symbol video_register_device
> [    8.306438] ivtv: Unknown symbol video_register_device
> [    8.306652] ivtv: disagrees about version of symbol video_device_release
> [    8.306653] ivtv: Unknown symbol video_device_release
> [    8.871010] ivtv: disagrees about version of symbol video_unregister_device
> [    8.871013] ivtv: Unknown symbol video_unregister_device
> [    8.871049] ivtv: disagrees about version of symbol video_device_alloc
> [    8.871050] ivtv: Unknown symbol video_device_alloc
> [    8.871081] ivtv: disagrees about version of symbol video_register_device
> [    8.871083] ivtv: Unknown symbol video_register_device
> [    8.871295] ivtv: disagrees about version of symbol video_device_release
> [    8.871296] ivtv: Unknown symbol video_device_release
> 
> I use make menuconfig to narrow down the drivers which are built. I am
> currently working out of the http://linuxtv.org/hg/~stoth/merge/ tree
> for the dvb support of the HVR-1600, but this happens with the main
> v4l tree as well.

Hmmm. The symbol resolution for loading ivtv and cx18 complains about
symbols that all seem to be defined in videodev.ko:

$ cd /lib/modules
$ find . -name "videodev.ko" -exec nm -g --defined-only {} \; -print


The gripe message comes from linux/kernel/module.c when checking symbol
versions.  The functions to resolve symbols and check versions want the
CRC values that are stored in here:

$ cd /lib/modules
$ find . \( -name ivtv.ko -o -name cx18.ko \) \
-exec objdump -s -j __versions {} \; -print

to match the ones stored in here:

$ find . -name videodev.ko -exec objdump -s \
-j __kcrctab \
-j __kcrctab_gpl \
-j __kcrctab_gpl_future \
-j __kcrctab_unused \
-j __kcrctab_unused_gpl \
{} \; -print 

I apparently don't have CONFIG_MODVERSIONS set, so I can't point you to
exactly where the matching CRC values should be.


The symbol resolution and version checking code in module.c appears to
look for any symbols compiled into the kernel first, and then for
symbols in modules though.  So it would be helpful to know if the
symbols in question are compiled into the kernel or not.

On my system:

$ grep video_unregister_device /proc/kallsyms
ffffffff881f8585 u video_unregister_device      [ivtv]
ffffffff881f8585 u video_unregister_device      [cx18]
ffffffff881fd920 r __ksymtab_video_unregister_device    [videodev]
ffffffff881fda00 r __kstrtab_video_unregister_device    [videodev]
ffffffff881f8585 T video_unregister_device      [videodev]

Shows that the symbol "video_unregister_device" is defined as
text/executable ("T") and provided by the module [videodev] and that the
modules [ivtv] and [cx18] have references to the symbol but don't define
it ("u").

If "video_unregister_device" is built into the kernel you won't see the
[videodev] module name by it.


-Andy

> Running kernel 2.6.25 built from kernel.org on Ubuntu 8.04 server 64-bit.
> 
> Regards,
> 
> Brandon
> 
> v4l .config --
> 
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: KERNELVERSION
> # Fri May  2 06:42:56 2008
> #
> CONFIG_INPUT=y
> CONFIG_USB=m
> # CONFIG_PARPORT is not set
> # CONFIG_SPARC64 is not set
> CONFIG_FW_LOADER=y
> # CONFIG_of is not set
> # CONFIG_PLAT_M32700UT is not set
> CONFIG_NET=y
> CONFIG_FB_CFB_COPYAREA=m
> # CONFIG_GENERIC_GPIO is not set
> # CONFIG_SOUND_PRIME is not set
> # CONFIG_SND_AC97_CODEC is not set
> # CONFIG_PXA27x is not set
> # CONFIG_dependencies is not set
> # CONFIG_SGI_IP22 is not set
> CONFIG_I2C=m
> CONFIG_FB_CFB_IMAGEBLIT=m
> # CONFIG_GPIO_PCA953X is not set
> CONFIG_STANDALONE=y
> # CONFIG_SND_MPU401_UART is not set
> # CONFIG_SND is not set
> CONFIG_MODULES=y
> # CONFIG_BROKEN is not set
> # CONFIG_SND_OPL3_LIB is not set
> CONFIG_HAS_IOMEM=y
> # CONFIG_PPC_PMAC is not set
> CONFIG_PROC_FS=y
> # CONFIG_SPARC32 is not set
> CONFIG_I2C_ALGOBIT=m
> # CONFIG_DVB_FE_CUSTOMIZE is not set
> CONFIG_HAS_DMA=y
> CONFIG_INET=y
> # CONFIG_SOUND_OSS is not set
> CONFIG_CRC32=y
> CONFIG_FB=y
> CONFIG_SYSFS=y
> # CONFIG_ISA is not set
> CONFIG_PCI=y
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_SND_PCM is not set
> # CONFIG_PARPORT_1284 is not set
> CONFIG_EXPERIMENTAL=y
> # CONFIG_M32R is not set
> # CONFIG_I2C_ALGO_SGI is not set
> CONFIG_FB_CFB_FILLRECT=m
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_VIDEO_KERNEL_VERSION is not set
> 
> #
> # Multimedia devices
> #
> 
> #
> # Multimedia core support
> #
> CONFIG_VIDEO_DEV=m
> CONFIG_VIDEO_V4L2_COMMON=m
> CONFIG_VIDEO_ALLOW_V4L1=y
> CONFIG_VIDEO_V4L1_COMPAT=y
> CONFIG_DVB_CORE=m
> CONFIG_VIDEO_MEDIA=m
> 
> #
> # Multimedia drivers
> #
> CONFIG_MEDIA_ATTACH=y
> CONFIG_MEDIA_TUNER=m
> CONFIG_MEDIA_TUNER_CUSTOMIZE=y
> CONFIG_MEDIA_TUNER_SIMPLE=m
> CONFIG_MEDIA_TUNER_TDA8290=m
> CONFIG_MEDIA_TUNER_TDA827X=m
> CONFIG_MEDIA_TUNER_TDA18271=m
> CONFIG_MEDIA_TUNER_TDA9887=m
> CONFIG_MEDIA_TUNER_TEA5761=m
> CONFIG_MEDIA_TUNER_TEA5767=m
> CONFIG_MEDIA_TUNER_MT20XX=m
> CONFIG_MEDIA_TUNER_MT2060=m
> CONFIG_MEDIA_TUNER_MT2266=m
> CONFIG_MEDIA_TUNER_MT2131=m
> CONFIG_MEDIA_TUNER_QT1010=m
> CONFIG_MEDIA_TUNER_XC2028=m
> CONFIG_MEDIA_TUNER_XC5000=m
> CONFIG_MEDIA_TUNER_MXL5005S=m
> CONFIG_VIDEO_V4L2=m
> CONFIG_VIDEO_V4L1=m
> CONFIG_VIDEOBUF_GEN=m
> CONFIG_VIDEOBUF_DMA_SG=m
> CONFIG_VIDEOBUF_DVB=m
> CONFIG_VIDEO_BTCX=m
> CONFIG_VIDEO_IR_I2C=m
> CONFIG_VIDEO_IR=m
> CONFIG_VIDEO_TVEEPROM=m
> CONFIG_VIDEO_CAPTURE_DRIVERS=y
> CONFIG_VIDEO_ADV_DEBUG=y
> # CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set
> 
> #
> # Encoders/decoders and other helper chips
> #
> 
> #
> # Audio decoders
> #
> CONFIG_VIDEO_TVAUDIO=m
> # CONFIG_VIDEO_TDA7432 is not set
> # CONFIG_VIDEO_TDA9840 is not set
> # CONFIG_VIDEO_TDA9875 is not set
> # CONFIG_VIDEO_TEA6415C is not set
> # CONFIG_VIDEO_TEA6420 is not set
> CONFIG_VIDEO_MSP3400=m
> CONFIG_VIDEO_CS5345=m
> CONFIG_VIDEO_CS53L32A=m
> CONFIG_VIDEO_M52790=m
> CONFIG_VIDEO_TLV320AIC23B=m
> CONFIG_VIDEO_WM8775=m
> CONFIG_VIDEO_WM8739=m
> CONFIG_VIDEO_VP27SMPX=m
> 
> #
> # Video decoders
> #
> # CONFIG_VIDEO_BT819 is not set
> # CONFIG_VIDEO_BT856 is not set
> # CONFIG_VIDEO_BT866 is not set
> # CONFIG_VIDEO_KS0127 is not set
> # CONFIG_VIDEO_OV7670 is not set
> # CONFIG_VIDEO_TCM825X is not set
> # CONFIG_VIDEO_SAA7110 is not set
> # CONFIG_VIDEO_SAA7111 is not set
> # CONFIG_VIDEO_SAA7114 is not set
> CONFIG_VIDEO_SAA711X=m
> CONFIG_VIDEO_SAA717X=m
> # CONFIG_VIDEO_SAA7191 is not set
> # CONFIG_VIDEO_TVP5150 is not set
> # CONFIG_VIDEO_VPX3220 is not set
> 
> #
> # Video and audio decoders
> #
> CONFIG_VIDEO_CX25840=m
> 
> #
> # MPEG video encoders
> #
> CONFIG_VIDEO_CX2341X=m
> 
> #
> # Video encoders
> #
> CONFIG_VIDEO_SAA7127=m
> # CONFIG_VIDEO_SAA7185 is not set
> # CONFIG_VIDEO_ADV7170 is not set
> # CONFIG_VIDEO_ADV7175 is not set
> 
> #
> # Video improvement chips
> #
> CONFIG_VIDEO_UPD64031A=m
> CONFIG_VIDEO_UPD64083=m
> # CONFIG_VIDEO_VIVI is not set
> # CONFIG_VIDEO_BT848 is not set
> # CONFIG_VIDEO_CPIA is not set
> # CONFIG_VIDEO_CPIA2 is not set
> # CONFIG_VIDEO_SAA5246A is not set
> # CONFIG_VIDEO_SAA5249 is not set
> # CONFIG_TUNER_3036 is not set
> # CONFIG_VIDEO_STRADIS is not set
> # CONFIG_VIDEO_ZORAN is not set
> # CONFIG_VIDEO_SAA7134 is not set
> # CONFIG_VIDEO_MXB is not set
> # CONFIG_VIDEO_DPC is not set
> # CONFIG_VIDEO_HEXIUM_ORION is not set
> # CONFIG_VIDEO_HEXIUM_GEMINI is not set
> CONFIG_VIDEO_CX88=m
> # CONFIG_VIDEO_CX88_BLACKBIRD is not set
> CONFIG_VIDEO_CX88_DVB=m
> # CONFIG_VIDEO_CX88_VP3054 is not set
> CONFIG_VIDEO_CX23885=m
> # CONFIG_VIDEO_AU0828 is not set
> CONFIG_VIDEO_IVTV=m
> # CONFIG_VIDEO_FB_IVTV is not set
> CONFIG_VIDEO_CX18=m
> # CONFIG_VIDEO_CAFE_CCIC is not set
> CONFIG_V4L_USB_DRIVERS=y
> # CONFIG_VIDEO_PVRUSB2 is not set
> # CONFIG_VIDEO_EM28XX is not set
> # CONFIG_VIDEO_USBVISION is not set
> # CONFIG_USB_VICAM is not set
> # CONFIG_USB_IBMCAM is not set
> # CONFIG_USB_KONICAWC is not set
> # CONFIG_USB_QUICKCAM_MESSENGER is not set
> # CONFIG_USB_ET61X251 is not set
> # CONFIG_VIDEO_OVCAMCHIP is not set
> # CONFIG_USB_W9968CF is not set
> # CONFIG_USB_OV511 is not set
> # CONFIG_USB_SE401 is not set
> # CONFIG_USB_SN9C102 is not set
> # CONFIG_USB_STV680 is not set
> # CONFIG_USB_ZC0301 is not set
> # CONFIG_USB_PWC is not set
> # CONFIG_USB_ZR364XX is not set
> # CONFIG_USB_STKWEBCAM is not set
> # CONFIG_SOC_CAMERA is not set
> # CONFIG_RADIO_ADAPTERS is not set
> CONFIG_DVB_CAPTURE_DRIVERS=y
> 
> #
> # Supported SAA7146 based PCI Adapters
> #
> # CONFIG_TTPCI_EEPROM is not set
> # CONFIG_DVB_AV7110 is not set
> # CONFIG_DVB_BUDGET_CORE is not set
> 
> #
> # Supported USB Adapters
> #
> # CONFIG_DVB_USB is not set
> # CONFIG_DVB_TTUSB_BUDGET is not set
> # CONFIG_DVB_TTUSB_DEC is not set
> # CONFIG_DVB_CINERGYT2 is not set
> 
> #
> # Supported FlexCopII (B2C2) Adapters
> #
> # CONFIG_DVB_B2C2_FLEXCOP is not set
> 
> #
> # Supported BT878 Adapters
> #
> 
> #
> # Supported Pluto2 Adapters
> #
> # CONFIG_DVB_PLUTO2 is not set
> 
> #
> # Supported DVB Frontends
> #
> 
> #
> # Customise DVB Frontends
> #
> # CONFIG_DVB_FE_CUSTOMISE is not set
> 
> #
> # DVB-S (satellite) frontends
> #
> # CONFIG_DVB_CX24110 is not set
> CONFIG_DVB_CX24123=m
> # CONFIG_DVB_MT312 is not set
> # CONFIG_DVB_S5H1420 is not set
> # CONFIG_DVB_STV0299 is not set
> # CONFIG_DVB_TDA8083 is not set
> # CONFIG_DVB_TDA10086 is not set
> # CONFIG_DVB_VES1X93 is not set
> # CONFIG_DVB_TUNER_ITD1000 is not set
> # CONFIG_DVB_TDA826X is not set
> # CONFIG_DVB_TUA6100 is not set
> 
> #
> # DVB-T (terrestrial) frontends
> #
> # CONFIG_DVB_SP8870 is not set
> # CONFIG_DVB_SP887X is not set
> # CONFIG_DVB_CX22700 is not set
> CONFIG_DVB_CX22702=m
> # CONFIG_DVB_DRX397XD is not set
> # CONFIG_DVB_L64781 is not set
> # CONFIG_DVB_TDA1004X is not set
> # CONFIG_DVB_NXT6000 is not set
> CONFIG_DVB_MT352=m
> CONFIG_DVB_ZL10353=m
> # CONFIG_DVB_DIB3000MB is not set
> # CONFIG_DVB_DIB3000MC is not set
> # CONFIG_DVB_DIB7000M is not set
> CONFIG_DVB_DIB7000P=m
> CONFIG_DVB_TDA10048=m
> 
> #
> # DVB-C (cable) frontends
> #
> # CONFIG_DVB_VES1820 is not set
> # CONFIG_DVB_TDA10021 is not set
> # CONFIG_DVB_TDA10023 is not set
> # CONFIG_DVB_STV0297 is not set
> 
> #
> # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
> #
> CONFIG_DVB_NXT200X=m
> # CONFIG_DVB_OR51211 is not set
> CONFIG_DVB_OR51132=m
> # CONFIG_DVB_BCM3510 is not set
> CONFIG_DVB_LGDT330X=m
> CONFIG_DVB_S5H1409=m
> # CONFIG_DVB_AU8522 is not set
> CONFIG_DVB_S5H1411=m
> 
> #
> # Digital terrestrial only tuners/PLL
> #
> CONFIG_DVB_PLL=m
> # CONFIG_DVB_TUNER_DIB0070 is not set
> 
> #
> # SEC control devices for DVB-S
> #
> # CONFIG_DVB_LNBP21 is not set
> # CONFIG_DVB_ISL6405 is not set
> CONFIG_DVB_ISL6421=m
> # CONFIG_DAB is not set
> 
> #
> # Audio devices for multimedia
> #
> 
> #
> # ALSA sound
> #
> 
> #
> # OSS sound
> #
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
