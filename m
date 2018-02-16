Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:51201 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933559AbeBPKhi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 05:37:38 -0500
Received: from [192.168.178.26] ([46.91.232.19]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MBTQo-1etkOd1CnW-00AW8n for
 <linux-media@vger.kernel.org>; Fri, 16 Feb 2018 11:37:37 +0100
To: linux-media@vger.kernel.org
From: Aurelius Wendelken <foto-wendelken@web.de>
Subject: Trying to build V4L on an Orange Pi One Plus - Build failed - Help
 wanted
Message-ID: <34c125cf-0b6f-3ee1-6a6c-93a6a891caf7@web.de>
Date: Fri, 16 Feb 2018 11:37:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey guys,

I want to build V4L on an Orange Pi One Plus. Unfortunately I am running 
in an error while building on ARM64.
https://www.aliexpress.com/store/product/Orange-Pi-One-Plus-H6-1GB-Quad-core-64bit-development-board-Support-android7-0-mini-PC/1553371_32848891030.html.


BOARD IMAGE:
http://www.orangepi.org/downloadresources/orangepioneplus/2018-01-24/orangepioneplus6e6042bd7a15ee4b06ad1.html

ENVIROMENT:
Ubuntu_Server from vendor


BOARD KERNEL: (uname -a)
Linux OrangePi 3.10.65 #35 SMP PREEMPT Tue Jan 23 18:13:02 CST 2018 
aarch64 aarch64 aarch64 GNU/Linux


DVB STICK:
HMP-Combo DVB C/T2 Hybrid USB TUNER

lsusb
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 003: ID 0572:0320 Conexant Systems (Rockwell), Inc. 
DVBSky T330 DVB-T2/C tuner
Bus 002 Device 002: ID 04b4:6560 Cypress Semiconductor Corp. CY7C65640 
USB-2.0 "TetraHub"
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 006 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

dmesg
[    2.250891] usb 2-1.4: New USB device found, idVendor=0572, 
idProduct=0320
[    2.250895] usb 2-1.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    2.250899] usb 2-1.4: Product: DVB-T2/C USB-Stick
[    2.250902] usb 2-1.4: Manufacturer: Bestunar Inc
[    2.250906] usb 2-1.4: SerialNumber: 20140126


cat /etc/apt/sources.list from vendor
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial main restricted 
universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-updates main 
restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-backports main 
restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial-security main 
restricted universe multiverse
deb https://dl.bintray.com/tvheadend/deb xenial release-4.2


BUILD V4L:
./build
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
     LANGUAGE = (unset),
     LC_ALL = (unset),
     LC_CTYPE = "de_DE.UTF-8",
     LANG = "de_DE.UTF-8"
     are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
Checking if the needed tools for Ubuntu 16.04.3 LTS are available
Needed package dependencies are met.

************************************************************
* This script will download the latest tarball and build it*
* Assuming that your kernel is compatible with the latest  *
* drivers. If not, you'll need to add some extra backports,*
* ./backports/<kernel> directory.                          *
* It will also update this tree to be sure that all compat *
* bits are there, to avoid compilation failures            *
************************************************************
************************************************************
* All drivers and build system are under GPLv2 License     *
* Firmware files are under the license terms found at:     *
* http://www.linuxtv.org/downloads/firmware/               *
* Please abort in the next 5 secs if you don't agree with  *
* the license                                              *
************************************************************

Not aborted. It means that the licence was agreed. Proceeding...

****************************
Updating the building system
****************************
 From git://linuxtv.org/media_build
  * branch            master     -> FETCH_HEAD
Already up-to-date.
make: Entering directory '/root/git/media_build/linux'
wget http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5 
-O linux-media.tar.bz2.md5.tmp
--2018-02-15 12:08:02-- 
http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5
Resolving linuxtv.org (linuxtv.org)... 130.149.80.248
Connecting to linuxtv.org (linuxtv.org)|130.149.80.248|:80... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: 
https://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5 
[following]
--2018-02-15 12:08:02-- 
https://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5
Connecting to linuxtv.org (linuxtv.org)|130.149.80.248|:443... connected.
WARNING: cannot verify linuxtv.org's certificate, issued by 'CN=Let\'s 
Encrypt Authority X3,O=Let\'s Encrypt,C=US':
   Unable to locally verify the issuer's authority.
HTTP request sent, awaiting response... 200 OK
Length: 105 [application/x-bzip2]
Saving to: 'linux-media.tar.bz2.md5.tmp'

linux-media.tar.bz2.md5.tmp 
100%[======================================================================================================>] 
105  --.-KB/s    in 0s

2018-02-15 12:08:02 (1.40 MB/s) - 'linux-media.tar.bz2.md5.tmp' saved 
[105/105]

make: Leaving directory '/root/git/media_build/linux'
make: Entering directory '/root/git/media_build/linux'
tar xfj linux-media.tar.bz2
rm -f .patches_applied .linked_dir .git_log.md5
make: Leaving directory '/root/git/media_build/linux'
**********************************************************
* Downloading firmwares from linuxtv.org.                *
**********************************************************
as102_data1_st.hex
as102_data2_st.hex
cmmb_vega_12mhz.inp
cmmb_venice_12mhz.inp
dvb-fe-bcm3510-01.fw
dvb-fe-drxj-mc-1.0.8.fw
dvb-fe-drxj-mc-vsb-1.0.8.fw
dvb-fe-drxj-mc-vsb-qam-1.0.8.fw
dvb-fe-or51132-qam.fw
dvb-fe-or51132-vsb.fw
dvb-fe-or51211.fw
dvb-fe-xc4000-1.4.1.fw
dvb-fe-xc5000-1.6.114.fw
dvb-fe-xc5000c-4.1.30.7.fw
dvb-firmwares.tar.bz2
dvb-ttpci-01.fw-261a
dvb-ttpci-01.fw-261b
dvb-ttpci-01.fw-261c
dvb-ttpci-01.fw-261d
dvb-ttpci-01.fw-261f
dvb-ttpci-01.fw-2622
dvb-usb-avertv-a800-02.fw
dvb-usb-bluebird-01.fw
dvb-usb-dib0700-1.20.fw
dvb-usb-dibusb-5.0.0.11.fw
dvb-usb-dibusb-6.0.0.8.fw
dvb-usb-dtt200u-01.fw
dvb-usb-it9135-01.fw
dvb-usb-it9135-02.fw
dvb-usb-terratec-h5-drxk.fw
dvb-usb-terratec-h7-az6007.fw
dvb-usb-terratec-h7-drxk.fw
dvb-usb-umt-010-02.fw
dvb-usb-vp702x-01.fw
dvb-usb-vp7045-01.fw
dvb-usb-wt220u-01.fw
dvb-usb-wt220u-02.fw
dvb_nova_12mhz.inp
dvb_nova_12mhz_b0.inp
isdbt_nova_12mhz.inp
isdbt_nova_12mhz_b0.inp
isdbt_rio.inp
sms1xxx-hcw-55xxx-dvbt-02.fw
sms1xxx-hcw-55xxx-isdbt-02.fw
sms1xxx-nova-a-dvbt-01.fw
sms1xxx-nova-b-dvbt-01.fw
sms1xxx-stellar-dvbt-01.fw
tdmb_nova_12mhz.inp
v4l-cx231xx-avcore-01.fw
v4l-cx23418-apu.fw
v4l-cx23418-cpu.fw
v4l-cx23418-dig.fw
v4l-cx23885-avcore-01.fw
v4l-cx23885-enc-broken.fw
v4l-cx25840.fw
******************
* Start building *
******************
make -C /root/git/media_build/v4l allyesconfig
make[1]: Entering directory '/root/git/media_build/v4l'
make[2]: Entering directory '/root/git/media_build/linux'
Applying patches for kernel 3.10.65
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
patch -s -f -N -p1 -i ../backports/debug.patch
patch -s -f -N -p1 -i ../backports/drx39xxj.patch
patch -s -f -N -p1 -i ../backports/v4.14_compiler_h.patch
patch -s -f -N -p1 -i ../backports/v4.14_saa7146_timer_cast.patch
patch -s -f -N -p1 -i ../backports/v4.14_module_param_call.patch
patch -s -f -N -p1 -i 
../backports/v4.12_revert_solo6x10_copykerneluser.patch
patch -s -f -N -p1 -i ../backports/v4.10_sched_signal.patch
patch -s -f -N -p1 -i ../backports/v4.10_fault_page.patch
patch -s -f -N -p1 -i ../backports/v4.10_refcount.patch
patch -s -f -N -p1 -i ../backports/v4.9_mm_address.patch
patch -s -f -N -p1 -i ../backports/v4.9_dvb_net_max_mtu.patch
patch -s -f -N -p1 -i ../backports/v4.9_ktime_cleanups.patch
patch -s -f -N -p1 -i ../backports/v4.9_uvcvideo_ktime_conversion.patch
patch -s -f -N -p1 -i ../backports/v4.8_user_pages_flag.patch
patch -s -f -N -p1 -i ../backports/v4.7_dma_attrs.patch
patch -s -f -N -p1 -i ../backports/v4.7_pci_alloc_irq_vectors.patch
patch -s -f -N -p1 -i ../backports/v4.6_i2c_mux.patch
patch -s -f -N -p1 -i ../backports/v4.5_gpiochip_data_pointer.patch
patch -s -f -N -p1 -i ../backports/v4.5_get_user_pages.patch
patch -s -f -N -p1 -i ../backports/v4.5_uvc_super_plus.patch
patch -s -f -N -p1 -i ../backports/v4.4_gpio_chip_parent.patch
patch -s -f -N -p1 -i ../backports/v4.3_add_autorepeat_handling.patch
patch -s -f -N -p1 -i ../backports/v4.2_atomic64.patch
patch -s -f -N -p1 -i ../backports/v4.2_frame_vector.patch
patch -s -f -N -p1 -i ../backports/v4.1_pat_enabled.patch
patch -s -f -N -p1 -i ../backports/v4.1_drop_fwnode.patch
patch -s -f -N -p1 -i ../backports/v4.0_dma_buf_export.patch
patch -s -f -N -p1 -i ../backports/v4.0_drop_trace.patch
patch -s -f -N -p1 -i ../backports/v4.0_fwnode.patch
patch -s -f -N -p1 -i ../backports/v3.19_get_user_pages_unlocked.patch
patch -s -f -N -p1 -i ../backports/v3.19_get_user_pages_locked.patch
patch -s -f -N -p1 -i ../backports/v3.18_drop_property_h.patch
patch -s -f -N -p1 -i ../backports/v3.18_ktime_get_real_seconds.patch
patch -s -f -N -p1 -i ../backports/v3.17_fix_clamp.patch
patch -s -f -N -p1 -i ../backports/v3.16_netdev.patch
patch -s -f -N -p1 -i ../backports/v3.16_wait_on_bit.patch
patch -s -f -N -p1 -i ../backports/v3.16_void_gpiochip_remove.patch
patch -s -f -N -p1 -i ../backports/v3.13_ddbridge_pcimsi.patch
patch -s -f -N -p1 -i ../backports/v3.12_kfifo_in.patch
2 out of 3 hunks FAILED
Makefile:130: recipe for target 'apply_patches' failed
make[2]: *** [apply_patches] Error 1
make[2]: Leaving directory '/root/git/media_build/linux'
Makefile:374: recipe for target 'allyesconfig' failed
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory '/root/git/media_build/v4l'
Makefile:26: recipe for target 'allyesconfig' failed
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 525



Any help is appreciated,

Regards
Aurelius
