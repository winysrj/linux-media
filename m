Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53777 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZIKHS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 03:18:26 -0400
Received: by bwz19 with SMTP id 19so595277bwz.37
        for <linux-media@vger.kernel.org>; Fri, 11 Sep 2009 00:18:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909110056.26512.liplianin@me.by>
References: <3c031ccc0909101330p47b355e1vc95938ccbf99df90@mail.gmail.com>
	 <200909110056.26512.liplianin@me.by>
Date: Fri, 11 Sep 2009 09:18:27 +0200
Message-ID: <3c031ccc0909110018v3accf93cx3002fcf34ace0ce@mail.gmail.com>
Subject: Re: TeVii S650 DVB-S2 USB und s2-liplianin drivers
From: crow <crow@linux.org.ba>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 10, 2009 at 11:56 PM, Igor M. Liplianin <liplianin@me.by> wrote:
> On 10 сентября 2009, linux-media@vger.kernel.org wrote:
>> Hi,
>> I tried today s2-liplianin drivers with tevii s650 and vdr cant lock
>> any channels with this error msg:
>>
>> <---snip---->
>> <6>stv0900_search: <7><6>Search Fail
>> stv0900_read_status: <7>DEMOD LOCK FAIL
>> stv0900_read_status: <7>DEMOD LOCK FAIL
>> <6>stb0900_set_property(..)
>> <6>stv0900_set_tone: On
>> <---snip--->
>>
>> Then i found from old installation compiled drivers from rev12458 and
>> installed it and everything work fine
>> (s2-liplianin-hg-12458-1-i686.pkg.tar.gz).
>>
>> I am on archlinux x86 with 2.6.30.5-1 kernel
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Hi
> I have s650 and tested it already. It works just fine.
> Send you the firmware. Put it in /lib/firmware
> Brief:
> hg clone http://mercurial.intuxication.org/hg/s2-liplianin/
> cd  s2-liplianin
> make release
> make
> sudo make install
>
> BR
> --
> Igor M. Liplianin
> Microsoft Windows Free Zone - Linux used for all Computing Tasks
>

Hi,thnx for your replay.
I already have had that firmware but i overwrited the old one (same
size) just to be shure, i pulled again source and compiled but the
problem is still there, this is from dmesg:

<---snip---->

dvb-usb: found a 'TeVii S650 USB2.0' in cold state, will try to load a firmware
usb 2-1: firmware: requesting dvb-usb-dw2104.fw
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
dvb-usb: downloading firmware from file 'dvb-usb-dw2104.fw'
dw2102: start downloading DW210X firmware
dvb-usb: found a 'TeVii S650 USB2.0' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (TeVii S650 USB2.0)
dvb-usb: MAC address: 00:00:00:00:00:00
<6>stv0900_init_internal
<6>stv0900_init_internal: Create New Internal Structure!
<6>stv0900_st_dvbs2_single
<6>stv0900_set_ts_parallel_serial
<6>stv0900_set_mclk: Mclk set to 135000000, Quartz = 8000000
<6>stv0900_get_mclk_freq: Calculated Mclk = 484000000
<6>stv0900_get_mclk_freq: Calculated Mclk = 484000000
stv0900_attach: Attaching STV0900 demodulator(0)
STV6110 attached on addr=60!
dw2102: Attached STV0900!

DVB: registering adapter 0 frontend 0 (STV0900 frontend)...
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:06.1/usb2/2-1/input/input7
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: TeVii S650 USB2.0 successfully initialized and connected.
usbcore: registered new interface driver dw2102
<6>stv0900_init
stv0900_read_status: <7>DEMOD LOCK FAIL
stv0900_read_status: <7>DEMOD LOCK FAIL
stv0900_read_status: <7>DEMOD LOCK FAIL
stv0900_read_status: <7>DEMOD LOCK FAIL
stv0900_read_status: <7>DEMOD LOCK FAIL
<6>stv0900_search: <7><6>Search Fail
stv0900_read_status: <7>DEMOD LOCK FAIL
<6>stv0900_search: <7><6>Search Fail
stv0900_read_status: <7>DEMOD LOCK FAIL
stv0900_read_status: <7>DEMOD LOCK FAIL
<6>stb0900_set_property(..)
<6>stv0900_set_tone: On
<---snip---->

Durning compiling i sow some warnings:
<---snip--->
 CC [M]  /home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/tevii_pwr.o
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/tevii_pwr.c:
In function 'tevii_dvbs2_set_voltage':
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/tevii_pwr.c:335:
warning: 'QuestionBuffer' may be used uninitialized in this function

  CC [M]  /home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/et61x251_core.o
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/et61x251_core.c:
In function 'et61x251_ioctl_v4l2':
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/et61x251_core.c:2491:
warning: the frame size of 1208 bytes is larger than 1024 bytes

 CC [M]  /home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/zc0301_core.o
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/zc0301_core.c:
In function 'zc0301_ioctl_v4l2':
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/zc0301_core.c:1892:
warning: the frame size of 1208 bytes is larger than 1024 bytes

 CC [M]  /home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dib3000mc.o
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dib3000mc.c:
In function 'dib3000mc_i2c_enumeration':
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dib3000mc.c:863:
warning: the frame size of 1052 bytes is larger than 1024 bytes

  CC [M]  /home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dib7000p.o
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dib7000p.c:
In function 'dib7000p_i2c_enumeration':
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dib7000p.c:1341:
warning: the frame size of 1100 bytes is larger than 1024 bytes

 CC [M]  /home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/mb86a16.o
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/mb86a16.c:1885:
warning: initialization from incompatible pointer type
  CC [M]  /home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/cu1216.o
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/cu1216.c:395:
warning: 'cu1216_read_quality' defined but not used

/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dvb-bt8xx.c:
In function 'cx24108_tuner_set_params':
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dvb-bt8xx.c:221:
warning: array subscript is above array bounds
  CC [M]  /home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dst.o
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dst.c:1774:
warning: initialization from incompatible pointer type
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dst.c:1800:
warning: initialization from incompatible pointer type
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dst.c:1829:
warning: initialization from incompatible pointer type
/home/crow/archvdr/trunk/archvdr/s2-liplianin-hg/src/s2-liplianin-build/v4l/dst.c:1852:
warning: initialization from incompatible pointer type

<---snip--->

Rest was fine.

The compiled packages for archlinux with rev12458
(s2-liplianin-hg-12458-1-i686.pkg.tar.gz) wich is compiled on (i
think) kernel26 (2.6.29.4-1),  is working...

Info:
Linux vdrbox 2.6.30-ARCH #1 SMP PREEMPT Mon Aug 17 18:04:53 CEST 2009
i686 Intel(R) Celeron(R) CPU 430 @ 1.80GHz GenuineIntel NU/Linux
[2009-09-09 23:16] installed kernel26-firmware (2.6.30-1)
[2009-09-09 23:17] installed kernel26 (2.6.30.5-1)
[2009-09-10 17:16] upgraded kernel-headers (2.6.30.5-1 -> 2.6.30.5-1)
