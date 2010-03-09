Return-path: <linux-media-owner@vger.kernel.org>
Received: from nat-9.jups.junix.cz ([86.49.49.73]:46500 "EHLO
	lim-has.no-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752490Ab0CIIQ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 03:16:27 -0500
Message-ID: <4B960276.9030302@brdo.cz>
Date: Tue, 09 Mar 2010 09:10:30 +0100
From: LiM <lim@brdo.cz>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: thomas.schorpp@gmail.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: Help with RTL2832U DVB-T dongle (LeadTek WinFast DTV Dongle Mini)
References: <6934ea941003052353n4258600cs78dba8487d203564@mail.gmail.com> <4B93537F.30407@hoogenraad.net> <4B93D751.1020008@gmail.com> <4B956830.6070508@hoogenraad.net>
In-Reply-To: <4B956830.6070508@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

for information...i have the same dongle (LeadTek WinFast DTV Dongle
Mini - Bus 001 Device 003: ID 0413:6a03 Leadtek Research, Inc. )
and after compiled RTL2832U + change VID+PID in rtl2832u.h (i changed
USB_VID_GTEK + USB_PID_GTEK_WARM to leadtek`s 0413:6a03)
is tuner working!  (me-tv + kaffeine)

[54444.033094] usb 1-2: new high speed USB device using ehci_hcd and
address 3
[54444.174858] usb 1-2: configuration #1 chosen from 1 choice
[54444.287045] dvb-usb: found a 'RT DTV 2832U' in warm state.
[54444.287056] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[54444.288707] DVB: registering new adapter (RT DTV 2832U)
[54444.289274] DVB: registering adapter 0 frontend 0 (Realtek RTL2832
DVB-T)...
[54444.289324] dvb-usb: RT DTV 2832U successfully initialized and connected.
[54444.289360] usbcore: registered new interface driver dvb_usb_rtl2832u


compilation is the same as instruction for msi digivox mini II v3.0

--cut ----
Installation of Realtek rtl2832u-based DVB-T-USB-Sticks:

sudo apt-get install unrar build-essential mercurial
mkdir digivox; cd digivox
hg clone http://linuxtv.org/hg/v4l-dvb <http://linuxtv.org/hg/v4l-dvb>
wget
http://media.ubuntuusers.de/forum/attachments/2103272/090730_RTL2832U_LINUX_Ver1.1.rar
<http://media.ubuntuusers.de/forum/attachments/2103272/090730_RTL2832U_LINUX_Ver1.1.rar>
unrar x -ep 090730_RTL2832U_LINUX_Ver1.1.rar
./v4l-dvb/linux/drivers/media/dvb/dvb-usb
cd v4l-dvb
for i in `find . -name *.pl`; do chmod +x $i ; done
gedit ./linux/drivers/media/dvb/dvb-usb/Makefile

(Insertion nearly to the end of file
<https://bugs.launchpad.net/me-tv/+bug/478439/file>:)
dvb-usb-rtl2832u-objs = demod_rtl2832.o dvbt_demod_base.o
dvbt_nim_base.o foundation.o math_mpi.o nim_rtl2832_mxl5007t.o
nim_rtl2832_fc2580.o nim_rtl2832_mt2266.o rtl2832u.o rtl2832u_fe.o
rtl2832u_io.o tuner_mxl5007t.o tuner_fc2580.o tuner_mt2266.o
tuner_tua9001.o nim_rtl2832_tua9001.o
obj-$(CONFIG_DVB_USB_RTL2832U) += dvb-usb-rtl2832u.o

gedit ./linux/drivers/media/dvb/dvb-usb/Kconfig

(Insertion to the end of file
<https://bugs.launchpad.net/me-tv/+bug/478439/file>:)
config DVB_USB_RTL2832U
        tristate "Realtek RTL2832U DVB-T USB2.0 support"
        depends on DVB_USB
        help
          Realtek RTL2832U DVB-T driver

gedit ./linux/drivers/media/dvb/dvb-usb/rtl2832u.c

(1. Remove // of line 12:)
//DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);

(2. replace line 61-63 by:)
        if ( ( 0==
dvb_usb_device_init(intf,&rtl2832u_1st_properties,THIS_MODULE,NULL,adapter_nr)
)||
                ( 0==
dvb_usb_device_init(intf,&rtl2832u_2nd_properties,THIS_MODULE,NULL,adapter_nr)
) ||
                ( 0==
dvb_usb_device_init(intf,&rtl2832u_3th_properties,THIS_MODULE,NULL,adapter_nr)
))

gedit ./linux/drivers/media/dvb/dvb-usb/tuner_tua9001.c

(search for 19.2 AND 20.48 and replace it by 19_2 AND 20_48:)
#elif defined(CRYSTAL_19.2_MHZ) /* Frequency 19.2 MHz */
#elif defined(CRYSTAL_19_2_MHZ) /* Frequency 19.2 MHz */
#elif defined(CRYSTAL_20.48_MHZ) /* Frequency 20,48 MHz */
#elif defined(CRYSTAL_20_48_MHZ) /* Frequency 20,48 MHz */

make

STRG^C after some secs.

gedit ./v4l/.config

(replace FIREDTV=m by FIREDTV=n:)
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV=n

make clean
make
sudo make install

--cut ----

Jan Hoogenraad napsal(a):
> Mauro:
>
> Can you remove the VERY OLD branch:
> http://linuxtv.org/hg/~mchehab/rtl2831/rev/d116540ebaab
> It is giving some confusion here.
>
> Thomas & Jan:
>
> I've got the RTL2831 code (mind the last digit) vetted off by LeadTek.
> For the rtl2832, I haven't had contact with them.
>
> Certainly, Jan could try any of the three archives.
> I know Antti has thoughts on the rtl2832, I'm sure he knows more.
>
> thomas schorpp wrote:
>> Jan Hoogenraad wrote:
>>> Antti has been working on drivers for the RTL283x.
>>>
>>> http://linuxtv.org/hg/~anttip/rtl2831u
>>> or
>>> http://linuxtv.org/hg/~anttip/qt1010/
>>
>> ~jhoogenraad/rtl2831-r2     rtl2831-r2 development repository: *known
>> working version*     Jan Hoogenraad
>>
>> Should Jan Slaninka try it?
>>>
>>> If you have more information on the RTL2832, I'd be happy to add it at:
>>> http://www.linuxtv.org/wiki/index.php/Rtl2831_devices
>>
>> Nothing on the Realtek website yet.
>>
>>>
>>>
>>> Jan Slaninka wrote:
>>>> Hi,
>>>>
>>>> I'd like to ask for a support with getting LeadTek WindFast DTV Dongle
>>>> mini running on Linux. So far I was able to fetch latest v4l-dvb from
>>>> HG, and successfully compiled module dvb_usb_rtl2832u found in
>>
>>>> 090730_RTL2832U_LINUX_Ver1.1.rar  
>>
>> Can be considered as GPL code then according to
>>
>> http://linuxtv.org/hg/~mchehab/rtl2831/rev/d116540ebaab
>>
>> Patch to make RTL2831U DVB-T USB2.0 DEVICE work, based on RealTek
>> version 080314
>>
>> ~mchehab/rtl2831     rtl2831 development repository with *RealTek GPL
>> code* for rtl2831     Mauro Carvalho Chehab     24 months ago
>>
>> ?
>>
>> y
>> tom
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>

