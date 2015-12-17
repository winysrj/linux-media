Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:58516 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbbLQNw0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 08:52:26 -0500
Subject: Re: Automatic device driver back-porting with media_build
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <5672A6F0.6070003@free.fr> <20151217105543.13599560@recife.lan>
From: Mason <slash.tmp@free.fr>
Message-ID: <5672BE15.9070006@free.fr>
Date: Thu, 17 Dec 2015 14:52:21 +0100
MIME-Version: 1.0
In-Reply-To: <20151217105543.13599560@recife.lan>
Content-Type: multipart/mixed;
 boundary="------------040103020401070906080105"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040103020401070906080105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Mauro,

On 17/12/2015 13:55, Mauro Carvalho Chehab wrote:

> Mason wrote:
> 
>> I have a TechnoTrend TT-TVStick CT2-4400v2 USB tuner, as described here:
>> http://linuxtv.org/wiki/index.php/TechnoTrend_TT-TVStick_CT2-4400
>>
>> According to the article, the device is supported since kernel 3.19
>> and indeed, if I use a 4.1 kernel, I can pick CONFIG_DVB_USB_DVBSKY
>> and everything seems to work.
>>
>> Unfortunately (for me), I've been asked to make this driver work on
>> an ancient 3.4 kernel.
>>
>> The linuxtv article mentions:
>>
>> "Drivers are included in kernel 3.17 (for version 1) and 3.19 (for version 2).
>> They can be built with media_build for older kernels."
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> This seems to imply that I can use the media_build framework to
>> automatically (??) back-port a 3.19 driver to a 3.4 kernel?
> 
> "automatically" is a complex word ;)

If I get it working, I think you can even say "auto-magically" ;-)

>> This sounds too good to be true...
>> How far back can I go?
> 
> The goal is to allow compilation since 2.6.32, but please notice that
> not all drivers will go that far. Basically, when the backport seems too
> complex, we just remove the driver from the list of drivers that are
> compiled for a given legacy version.
> 
> Se the file v4l/versions.txt to double-check if the drivers you need
> have such restrictions. I suspect that, in the specific case of
> DVB_USB_DVBSKY, it should compile.

That is great news.

> That doesn't mean that it was tested there. We don't test those
> backports to check against regressions. We only work, at best
> effort basis, to make them to build. So, use it with your own
> risk. If you find any problems, feel free to send us patches
> fixing it.

My first problem is that compilation fails on the first file ;-)
See attached log.

My steps are:

cd media_build/linux
make tar DIR=/tmp/sandbox/media_tree
make untar
cd ..
make release DIR=/tmp/sandbox/custom-linux-3.4
make

I will investigate and report back.

Regards.


--------------040103020401070906080105
Content-Type: text/x-log;
 name="build.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="build.log"

/tmp/sandbox$ cd media_build/linux
/tmp/sandbox/media_build/linux$ make tar DIR=3D/tmp/sandbox/media_tree
rm -f /tmp/sandbox/media_build/linux/linux-media.tar.bz2
tar cf /tmp/sandbox/media_build/linux/linux-media.tar -C /tmp/sandbox/med=
ia_tree sound/pci/bt87x.c mm/frame_vector.c include/linux/mmc/sdio_ids.h =
include/sound/aci.h include/uapi/linux/usb/video.h include/linux/via-core=
=2Eh include/linux/ti_wilink_st.h include/linux/dma-buf.h include/linux/f=
ence.h include/linux/of_graph.h include/linux/kconfig.h include/linux/hdm=
i.h include/linux/compiler-gcc.h include/linux/dma/xilinx_dma.h include/t=
race/events/v4l2.h include/trace/events/vb2.h include/linux/pci_ids.h inc=
lude/misc/altera.h include/uapi/linux/lirc.h include/uapi/linux/videodev2=
=2Eh include/uapi/linux/meye.h include/uapi/linux/ivtv.h include/uapi/lin=
ux/ivtvfb.h include/uapi/linux/media.h include/uapi/linux/media-bus-forma=
t.h include/uapi/linux/v4l2-dv-timings.h include/uapi/linux/v4l2-controls=
=2Eh include/uapi/linux/uvcvideo.h include/uapi/linux/vsp1.h include/uapi=
/linux/xilinx-v4l2-controls.h include/uapi/linux/smiapp.h include/uapi/li=
nux/v4l2-subdev.h include/uapi/linux/v4l2-common.h include/uapi/linux/v4l=
2-mediabus.h include/linux/fixp-arith.h firmware/av7110/bootcode.bin.ihex=
 firmware/av7110/Boot.S firmware/cpia2/stv0672_vp4.bin.ihex firmware/ihex=
2fw.c firmware/vicam/firmware.H16 firmware/ttusb-budget/dspbootcode.bin.i=
hex
git --git-dir /tmp/sandbox/media_tree/.git log --pretty=3Doneline -n3 |se=
d -r 's,([\x22]),,g; s,([\x25\x5c]),\1\1,g' >git_log
perl -e 'while (<>) { $a=3D$1 if (m/^\s*VERSION\s*=3D\s*(\d+)/); $b=3D$1 =
if (m/^\s*PATCHLEVEL\s*=3D\s*(\d+)/); $c=3D$1 if (m/^\s*SUBLEVEL\s*=3D\s*=
(\d+)/); } printf "#define V4L2_VERSION %d\n", ((($a) << 16) + (($b) << 8=
) + ($c))' /tmp/sandbox/media_tree/Makefile > kernel_version.h
tar rvf /tmp/sandbox/media_build/linux/linux-media.tar git_log kernel_ver=
sion.h
git_log
kernel_version.h
for i in drivers/media/ drivers/staging/media/ drivers/misc/altera-stapl/=
 include/media/ include/dt-bindings/media/ include/linux/platform_data/me=
dia/ include/uapi/linux/dvb/; do \
		if [ "`echo $i|grep Documentation`" =3D "" ]; then \
			dir=3D"`(cd /tmp/sandbox/media_tree; find $i -type f -name '*.[ch]')`"=
; \
			dir=3D"$dir `(cd /tmp/sandbox/media_tree; find $i -type f -name Makefi=
le)`"; \
			dir=3D"$dir `(cd /tmp/sandbox/media_tree; find $i -type f -name Kconfi=
g)`"; \
			tar rvf /tmp/sandbox/media_build/linux/linux-media.tar -C /tmp/sandbox=
/media_tree $dir; \
		else \
			tar rvf /tmp/sandbox/media_build/linux/linux-media.tar -C /tmp/sandbox=
/media_tree $i; \
		fi; done; bzip2 /tmp/sandbox/media_build/linux/linux-media.tar
[snip list of 2247 files]
/tmp/sandbox/media_build/linux$ make untar
tar xfj linux-media.tar.bz2
rm -f .patches_applied .linked_dir .git_log.md5
/tmp/sandbox/media_build/linux$ cd ..
/tmp/sandbox/media_build$ make release DIR=3D/tmp/sandbox/custom-linux-3.=
4
make -C /tmp/sandbox/media_build/v4l release
make[1]: Entering directory `/tmp/sandbox/media_build/v4l'
Searching in /tmp/sandbox/custom-linux-3.4/Makefile for kernel version.
Forcing compiling to version 3.4.3913
make[1]: Leaving directory `/tmp/sandbox/media_build/v4l'
/tmp/sandbox/media_build$ make
make -C /tmp/sandbox/media_build/v4l=20
make[1]: Entering directory `/tmp/sandbox/media_build/v4l'
scripts/make_makefile.pl
Updating/Creating .config
make[2]: Entering directory `/tmp/sandbox/media_build/linux'
Applying patches for kernel 3.4.3913
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
patch -s -f -N -p1 -i ../backports/debug.patch
patch -s -f -N -p1 -i ../backports/drx39xxj.patch
patch -s -f -N -p1 -i ../backports/v4.1_pat_enabled.patch
patch -s -f -N -p1 -i ../backports/v4.0_dma_buf_export.patch
patch -s -f -N -p1 -i ../backports/v4.0_drop_trace.patch
patch -s -f -N -p1 -i ../backports/v4.0_fwnode.patch
patch -s -f -N -p1 -i ../backports/v3.19_get_user_pages_locked.patch
Patched drivers/media/dvb-core/dvbdev.c
Patched drivers/media/v4l2-core/v4l2-dev.c
Patched drivers/media/rc/rc-main.c
make[2]: Leaving directory `/tmp/sandbox/media_build/linux'
Preparing to compile for kernel version 3.4.3913
WARNING: This is the V4L/DVB backport tree, with experimental drivers
	 backported to run on legacy kernels from the development tree at:
		http://git.linuxtv.org/media-tree.git.
	 It is generally safe to use it for testing a new driver or
	 feature, but its usage on production environments is risky.
	 Don't use it in production. You've been warned.
V4L2_FLASH_LED_CLASS: Requires at least kernel 4.2.0
VIDEOBUF2_DMA_CONTIG: Requires at least kernel 3.6.0
IR_HIX5HD2: Requires at least kernel 3.10.0
IR_IMG: Requires at least kernel 3.9.0
RC_ST: Requires at least kernel 3.15.0
DVB_USB_RTL28XXU: Requires at least kernel 3.7.0
VIDEO_FB_IVTV: Requires at least kernel 3.11.0
DVB_PT3: Requires at least kernel 3.11.0
DVB_NETUP_UNIDVB: Requires at least kernel 3.7.0
VIDEO_RCAR_VIN: Requires at least kernel 3.9.0
VIDEO_XILINX: Requires at least kernel 3.17.0
VIDEO_CODA: Requires at least kernel 3.5.0
VIDEO_SH_VEU: Requires at least kernel 3.9.0
VIDEO_RENESAS_VSP1: Requires at least kernel 3.9.0
RADIO_SI4713: Requires at least kernel 3.13.0
I2C_SI4713: Requires at least kernel 3.17.0
VIDEO_ADV7183: Requires at least kernel 3.5.0
VIDEO_ADV7604: Requires at least kernel 3.17.0
VIDEO_TC358743: Requires at least kernel 3.17.0
VIDEO_OV2659: Requires at least kernel 3.5.0
VIDEO_OV9650: Requires at least kernel 3.5.0
VIDEO_VS6624: Requires at least kernel 3.5.0
VIDEO_MT9P031: Requires at least kernel 3.17.0
VIDEO_MT9T001: Requires at least kernel 3.5.0
VIDEO_MT9V032: Requires at least kernel 3.19.0
VIDEO_NOON010PC30: Requires at least kernel 3.5.0
VIDEO_M5MOLS: Requires at least kernel 3.6.0
VIDEO_S5K6AA: Requires at least kernel 3.5.0
VIDEO_S5K6A3: Requires at least kernel 3.5.0
VIDEO_S5K5BAF: Requires at least kernel 3.5.0
VIDEO_SMIAPP: Requires at least kernel 4.0.0
VIDEO_S5C73M3: Requires at least kernel 3.6.0
VIDEO_ADP1653: Requires at least kernel 3.17.0
SOC_CAMERA_OV2640: Requires at least kernel 3.17.0
MEDIA_TUNER_E4000: Requires at least kernel 3.5.0
DVB_M88DS3103: Requires at least kernel 3.8.0
DVB_TS2020: Requires at least kernel 3.8.0
DVB_RTL2830: Requires at least kernel 3.8.0
DVB_RTL2832: Requires at least kernel 3.8.0
Created default (all yes) .config file
=2E/scripts/make_myconfig.pl
make[1]: Leaving directory `/tmp/sandbox/media_build/v4l'
make[1]: Entering directory `/tmp/sandbox/media_build/v4l'
scripts/make_makefile.pl
make[1]: Leaving directory `/tmp/sandbox/media_build/v4l'
make[1]: Entering directory `/tmp/sandbox/media_build/v4l'
perl scripts/make_config_compat.pl /tmp/sandbox/custom-linux-3.4 ./.mycon=
fig ./config-compat.h
creating symbolic links...
make -C firmware prep
make[2]: Entering directory `/tmp/sandbox/media_build/v4l/firmware'
make[2]: Leaving directory `/tmp/sandbox/media_build/v4l/firmware'
make -C firmware
make[2]: Entering directory `/tmp/sandbox/media_build/v4l/firmware'
  CC  ihex2fw
Generating vicam/firmware.fw
Generating ttusb-budget/dspbootcode.bin
Generating cpia2/stv0672_vp4.bin
Generating av7110/bootcode.bin
make[2]: Leaving directory `/tmp/sandbox/media_build/v4l/firmware'
Kernel build directory is /tmp/sandbox/custom-linux-3.4
make -C ../linux apply_patches
make[2]: Entering directory `/tmp/sandbox/media_build/linux'
Patches for 3.4.3913 already applied.
make[2]: Leaving directory `/tmp/sandbox/media_build/linux'
make -C /tmp/sandbox/custom-linux-3.4 SUBDIRS=3D/tmp/sandbox/media_build/=
v4l  modules
make[2]: Entering directory `/tmp/sandbox/custom-linux-3.4'
  CC [M]  /tmp/sandbox/media_build/v4l/aptina-pll.o
In file included from <command-line>:0:0:
/tmp/sandbox/media_build/v4l/compat.h:1568:0: warning: "writel_relaxed" r=
edefined
 #define writel_relaxed writel
 ^
In file included from include/linux/scatterlist.h:10:0,
                 from /tmp/sandbox/media_build/v4l/compat.h:1255,
                 from <command-line>:0:
/tmp/sandbox/custom-linux-3.4/arch/arm/include/asm/io.h:235:0: note: this=
 is the location of the previous definition
 #define writel_relaxed(v,c) ((void)__raw_writel((__force u32) \
 ^
In file included from <command-line>:0:0:
/tmp/sandbox/media_build/v4l/compat.h: In function 'kvfree':
/tmp/sandbox/media_build/v4l/compat.h:1631:3: error: implicit declaration=
 of function 'vfree' [-Werror=3Dimplicit-function-declaration]
   vfree(addr);
   ^
cc1: some warnings being treated as errors
make[3]: *** [/tmp/sandbox/media_build/v4l/aptina-pll.o] Error 1
make[2]: *** [_module_/tmp/sandbox/media_build/v4l] Error 2
make[2]: Leaving directory `/tmp/sandbox/custom-linux-3.4'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/tmp/sandbox/media_build/v4l'
make: *** [all] Error 2

--------------040103020401070906080105--
