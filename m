Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41476 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2HPUlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 16:41:47 -0400
Received: by lbbgj3 with SMTP id gj3so1734271lbb.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 13:41:45 -0700 (PDT)
Message-ID: <502D5AFA.4040300@iki.fi>
Date: Thu, 16 Aug 2012 23:41:30 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb-usb-v2 change broke s2250-loader compilation
References: <201208161233.43618.hverkuil@xs4all.nl> <502CE527.2070006@iki.fi> <502CF98B.1060700@iki.fi> <201208161607.03380.hverkuil@xs4all.nl> <502D03B6.8030708@iki.fi> <502D24DF.8090503@redhat.com> <502D3C6F.6010507@iki.fi> <502D3D35.7020107@redhat.com> <502D408F.9080102@iki.fi> <502D52B9.7050401@redhat.com>
In-Reply-To: <502D52B9.7050401@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/2012 11:06 PM, Mauro Carvalho Chehab wrote:
> Em 16-08-2012 15:48, Antti Palosaari escreveu:
>> On 08/16/2012 09:34 PM, Mauro Carvalho Chehab wrote:
>>> Em 16-08-2012 15:31, Antti Palosaari escreveu:
>>>> On 08/16/2012 07:50 PM, Mauro Carvalho Chehab wrote:
>>>>> Em 16-08-2012 11:29, Antti Palosaari escreveu:
>>>>>> On 08/16/2012 05:07 PM, Hans Verkuil wrote:
>>>>>>> On Thu August 16 2012 15:45:47 Antti Palosaari wrote:
>>>>>>>> On 08/16/2012 03:18 PM, Antti Palosaari wrote:
>>>>>>>>> On 08/16/2012 01:33 PM, Hans Verkuil wrote:
>>>>>>>>>> Building the kernel with the Sensoray 2250/2251 staging go7007 driver
>>>>>>>>>> enabled
>>>>>>>>>> fails with this link error:
>>>>>>>>>>
>>>>>>>>>> ERROR: "usb_cypress_load_firmware"
>>>>>>>>>> [drivers/staging/media/go7007/s2250-loader.ko] undefined!
>>>>>>>>>>
>>>>>>>>>> As far as I can tell this is related to the dvb-usb-v2 changes.
>>>>>>>>>>
>>>>>>>>>> Can someone take a look at this?
>>>>>>>>>>
>>>>>>>>>> Thanks!
>>>>>>>>>>
>>>>>>>>>>         Hans
>>>>>>>>>
>>>>>>>>> Yes it is dvb usb v2 related. I wasn't even aware that someone took that
>>>>>>>>> module use in few days after it was added for the dvb-usb-v2.
>>>>>>>>>
>>>>>>>>> Maybe it is worth to make it even more common and move out of dvb-usb-v2...
>>>>>>>>>
>>>>>>>>> regards
>>>>>>>>> Antti
>>>>>>>>
>>>>>>>> And after looking it twice I cannot see the reason. I split that Cypress
>>>>>>>> firmware download to own module called dvb_usb_cypress_firmware which
>>>>>>>> offer routine usbv2_cypress_load_firmware(). Old DVB USB is left
>>>>>>>> untouched. I can confirm it fails to compile for s2250, but there is
>>>>>>>> still old dvb_usb_cxusb that is compiling without a error.
>>>>>>>>
>>>>>>>> Makefile paths seems to be correct also, no idea whats wrong....
>>>>>>>
>>>>>>> drivers/media/usb/Makefile uses := instead of += for the dvb-usb(-v2) directories,
>>>>>>> and that prevents dvb-usb from being build. I think that's the cause of the link
>>>>>>> error.
>>>>>>
>>>>>> For that I cannot say as I don't understand situation enough.
>>>>>>
>>>>>>> In addition I noticed that in usb/dvb-usb there is a dvb_usb_dvb.c and a
>>>>>>> dvb-usb-dvb.c file: there's a mixup with _ and -.
>>>>>>
>>>>>> These files seems to be my fault. Original patch series removes those,
>>>>>> but I was forced to rebase whole set and in that rebased set those are left unremoved.
>>>>>> Likely due to some rebase conflict. I will send new patch to remove those.
>>>>>
>>>>> If you remove the _, they'll conflict with dvb-usb at media-build.git.
>>>>>
>>>>> The better is to add a _v2 (or -v2) on all dvb-usb-v2 files
>>>>> (or to convert the remaining dvb-usb drivers to dvb-usb-v2).
>>>>
>>>> hmm, now I am quite out what you mean.
>>>>
>>>> This is from my first PULL-request:
>>>> http://git.linuxtv.org/anttip/media_tree.git/commit/c60c6d44111be2b2fd9ef9b716ea50bd87493893
>>>>
>>>> And this is same patch after large rebase:
>>>> http://git.linuxtv.org/anttip/media_tree.git/commit/ac97c6f722aafb5b562ef04062b543147399dff8
>>>>
>>>> Why removing those wrong files will cause conflict in media_build.git ?
>>>
>>> Because, at the media-build, all files are linked into the "/v4l" dir. If there are two different
>>> modules with the same name, one will override the other.
>>
>> But there should not be same names what I know.
>> Here is the list of DVB USB related files:
>>
>> DVB USB v1:
>> ***********
>> dvb-usb/dvb-usb-firmware.c
>> dvb-usb/dvb-usb.h
>> dvb-usb/dvb-usb-common.h
>> dvb-usb/dvb_usb_dvb.c *** not needed
>> dvb-usb/dvb-usb-dvb.c
>> dvb-usb/dvb-usb-i2c.c
>> dvb-usb/dvb-usb-init.c
>> dvb-usb/dvb_usb_remote.c *** not needed
>> dvb-usb/dvb-usb-remote.c
>> dvb-usb/dvb-usb-urb.c
>> dvb-usb/usb-urb.c
>> dvb-usb/dvb-usb.ko
>>
>> DVB USB v2:
>> ***********
>> dvb-usb-v2/cypress_firmware.c
>> dvb-usb-v2/cypress_firmware.h
>> dvb-usb-v2/dvb_usb.h
>> dvb-usb-v2/dvb_usb_common.h
>> dvb-usb-v2/dvb_usb_core.c
>> dvb-usb-v2/dvb_usb_urb.c
>> dvb-usb-v2/usb_urb.c
>> dvb-usb-v2/dvb_usb_cypress_firmware.ko
>> dvb-usb-v2/dvb_usbv2.ko
>
> Yes, but Hans got confused with dvb_usb/dvb-usb stuff.
> I said that renaming from one to the other would cause conflicts.
>
> -
>
> As discussed on IRC, this patch should likely fix it (untested, at media-build).

I can confirm after that patch at least dvb-usb and dvb-usb-v2 are build 
again.

Tested-by: Antti Palosaari <crope@iki.fi>

>
>
>
> [media] Fix some Makefile rules
>
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> On a few places, := were using instead of +=, causing drivers to
> not compile.
>
> While here, standardize the usage of += on all cases where multiple
> lines are needed, and for obj-y/obj-m targets, and := when just one
> line is needed, on <module>-obj rules.
>
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> Identified-by: Antti Polosaari <crope@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/media/common/b2c2/Makefile b/drivers/media/common/b2c2/Makefile
> index 48a4c90..24993a5 100644
> --- a/drivers/media/common/b2c2/Makefile
> +++ b/drivers/media/common/b2c2/Makefile
> @@ -1,5 +1,6 @@
> -b2c2-flexcop-objs = flexcop.o flexcop-fe-tuner.o flexcop-i2c.o \
> -	flexcop-sram.o flexcop-eeprom.o flexcop-misc.o flexcop-hw-filter.o
> +b2c2-flexcop-objs += flexcop.o flexcop-fe-tuner.o flexcop-i2c.o
> +b2c2-flexcop-objs += flexcop-sram.o flexcop-eeprom.o flexcop-misc.o
> +b2c2-flexcop-objs += flexcop-hw-filter.o
>   obj-$(CONFIG_DVB_B2C2_FLEXCOP) += b2c2-flexcop.o
>
>   ccflags-y += -Idrivers/media/dvb-core/
> diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
> index 208bc49..7eb73bb 100644
> --- a/drivers/media/dvb-frontends/Makefile
> +++ b/drivers/media/dvb-frontends/Makefile
> @@ -5,10 +5,10 @@
>   ccflags-y += -I$(srctree)/drivers/media/dvb-core/
>   ccflags-y += -I$(srctree)/drivers/media/tuners/
>
> -stb0899-objs = stb0899_drv.o stb0899_algo.o
> -stv0900-objs = stv0900_core.o stv0900_sw.o
> -drxd-objs = drxd_firm.o drxd_hard.o
> -cxd2820r-objs = cxd2820r_core.o cxd2820r_c.o cxd2820r_t.o cxd2820r_t2.o
> +stb0899-objs := stb0899_drv.o stb0899_algo.o
> +stv0900-objs := stv0900_core.o stv0900_sw.o
> +drxd-objs := drxd_firm.o drxd_hard.o
> +cxd2820r-objs := cxd2820r_core.o cxd2820r_c.o cxd2820r_t.o cxd2820r_t2.o
>   drxk-objs := drxk_hard.o
>
>   obj-$(CONFIG_DVB_PLL) += dvb-pll.o
> diff --git a/drivers/media/firewire/Makefile b/drivers/media/firewire/Makefile
> index f314813..2394813 100644
> --- a/drivers/media/firewire/Makefile
> +++ b/drivers/media/firewire/Makefile
> @@ -1,6 +1,6 @@
>   obj-$(CONFIG_DVB_FIREDTV) += firedtv.o
>
> -firedtv-y := firedtv-avc.o firedtv-ci.o firedtv-dvb.o firedtv-fe.o firedtv-fw.o
> +firedtv-y += firedtv-avc.o firedtv-ci.o firedtv-dvb.o firedtv-fe.o firedtv-fw.o
>   firedtv-$(CONFIG_DVB_FIREDTV_INPUT)    += firedtv-rc.o
>
>   ccflags-y += -Idrivers/media/dvb-core
> diff --git a/drivers/media/mmc/Makefile b/drivers/media/mmc/Makefile
> index dacd3cb..31e297a 100644
> --- a/drivers/media/mmc/Makefile
> +++ b/drivers/media/mmc/Makefile
> @@ -1 +1 @@
> -obj-y := siano/
> +obj-y += siano/
> diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
> index c8dc6c7..35cc578 100644
> --- a/drivers/media/pci/Makefile
> +++ b/drivers/media/pci/Makefile
> @@ -2,7 +2,7 @@
>   # Makefile for the kernel multimedia device drivers.
>   #
>
> -obj-y        :=	ttpci/		\
> +obj-y        +=	ttpci/		\
>   		b2c2/		\
>   		pluto2/		\
>   		dm1105/		\
> diff --git a/drivers/media/pci/cx25821/Makefile b/drivers/media/pci/cx25821/Makefile
> index c038941..5bf3ea4 100644
> --- a/drivers/media/pci/cx25821/Makefile
> +++ b/drivers/media/pci/cx25821/Makefile
> @@ -7,7 +7,7 @@ cx25821-y   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
>   obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
>   obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
>
> -ccflags-y := -Idrivers/media/i2c
> +ccflags-y += -Idrivers/media/i2c
>   ccflags-y += -Idrivers/media/tuners
>   ccflags-y += -Idrivers/media/dvb-core
>   ccflags-y += -Idrivers/media/dvb-frontends
> diff --git a/drivers/media/pci/saa7134/Makefile b/drivers/media/pci/saa7134/Makefile
> index 9e510c1..3537548 100644
> --- a/drivers/media/pci/saa7134/Makefile
> +++ b/drivers/media/pci/saa7134/Makefile
> @@ -1,5 +1,5 @@
>
> -saa7134-y :=	saa7134-cards.o saa7134-core.o saa7134-i2c.o
> +saa7134-y +=	saa7134-cards.o saa7134-core.o saa7134-i2c.o
>   saa7134-y +=	saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o
>   saa7134-y +=	saa7134-video.o
>   saa7134-$(CONFIG_VIDEO_SAA7134_RC) += saa7134-input.o
> diff --git a/drivers/media/platform/omap/Makefile b/drivers/media/platform/omap/Makefile
> index fc410b4..d80df41 100644
> --- a/drivers/media/platform/omap/Makefile
> +++ b/drivers/media/platform/omap/Makefile
> @@ -3,6 +3,6 @@
>   #
>
>   # OMAP2/3 Display driver
> -omap-vout-y := omap_vout.o omap_voutlib.o
> +omap-vout-y += omap_vout.o omap_voutlib.o
>   omap-vout-$(CONFIG_VIDEO_OMAP2_VOUT_VRFB) += omap_vout_vrfb.o
>   obj-$(CONFIG_VIDEO_OMAP2_VOUT) += omap-vout.o
> diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
> index 63e37bb..7f51d7e 100644
> --- a/drivers/media/usb/Makefile
> +++ b/drivers/media/usb/Makefile
> @@ -3,8 +3,8 @@
>   #
>
>   # DVB USB-only drivers
> -obj-y := ttusb-dec/ ttusb-budget/ dvb-usb/ dvb-usb-v2/ siano/ b2c2/
> -obj-y := zr364xx/ stkwebcam/ s2255/
> +obj-y += ttusb-dec/ ttusb-budget/ dvb-usb/ dvb-usb-v2/ siano/ b2c2/
> +obj-y += zr364xx/ stkwebcam/ s2255/
>
>   obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
>   obj-$(CONFIG_USB_GSPCA)         += gspca/
> diff --git a/drivers/media/usb/b2c2/Makefile b/drivers/media/usb/b2c2/Makefile
> index ace9d76..2778c19 100644
> --- a/drivers/media/usb/b2c2/Makefile
> +++ b/drivers/media/usb/b2c2/Makefile
> @@ -1,4 +1,4 @@
> -b2c2-flexcop-usb-objs = flexcop-usb.o
> +b2c2-flexcop-usb-objs := flexcop-usb.o
>   obj-$(CONFIG_DVB_B2C2_FLEXCOP_USB) += b2c2-flexcop-usb.o
>
>   ccflags-y += -Idrivers/media/dvb-core/
> diff --git a/drivers/media/usb/dvb-usb-v2/Makefile b/drivers/media/usb/dvb-usb-v2/Makefile
> index 6256843..58027fd 100644
> --- a/drivers/media/usb/dvb-usb-v2/Makefile
> +++ b/drivers/media/usb/dvb-usb-v2/Makefile
> @@ -1,45 +1,46 @@
> -dvb_usbv2-objs = dvb_usb_core.o dvb_usb_urb.o usb_urb.o
> +dvb_usbv2-objs := dvb_usb_core.o dvb_usb_urb.o usb_urb.o
>   obj-$(CONFIG_DVB_USB_V2) += dvb_usbv2.o
>
> -dvb_usb_cypress_firmware-objs = cypress_firmware.o
> +dvb_usb_cypress_firmware-objs := cypress_firmware.o
>   obj-$(CONFIG_DVB_USB_CYPRESS_FIRMWARE) += dvb_usb_cypress_firmware.o
>
> -dvb-usb-af9015-objs = af9015.o
> +dvb-usb-af9015-objs := af9015.o
>   obj-$(CONFIG_DVB_USB_AF9015) += dvb-usb-af9015.o
>
> -dvb-usb-af9035-objs = af9035.o
> +dvb-usb-af9035-objs := af9035.o
>   obj-$(CONFIG_DVB_USB_AF9035) += dvb-usb-af9035.o
>
> -dvb-usb-anysee-objs = anysee.o
> +dvb-usb-anysee-objs := anysee.o
>   obj-$(CONFIG_DVB_USB_ANYSEE) += dvb-usb-anysee.o
>
> -dvb-usb-au6610-objs = au6610.o
> +dvb-usb-au6610-objs := au6610.o
>   obj-$(CONFIG_DVB_USB_AU6610) += dvb-usb-au6610.o
>
> -dvb-usb-az6007-objs = az6007.o
> +dvb-usb-az6007-objs := az6007.o
>   obj-$(CONFIG_DVB_USB_AZ6007) += dvb-usb-az6007.o
>
> -dvb-usb-ce6230-objs = ce6230.o
> +dvb-usb-ce6230-objs := ce6230.o
>   obj-$(CONFIG_DVB_USB_CE6230) += dvb-usb-ce6230.o
>
> -dvb-usb-ec168-objs = ec168.o
> +dvb-usb-ec168-objs := ec168.o
>   obj-$(CONFIG_DVB_USB_EC168) += dvb-usb-ec168.o
>
> -dvb-usb-it913x-objs = it913x.o
> +dvb-usb-it913x-objs := it913x.o
>   obj-$(CONFIG_DVB_USB_IT913X) += dvb-usb-it913x.o
>
> -dvb-usb-lmedm04-objs = lmedm04.o
> +dvb-usb-lmedm04-objs := lmedm04.o
>   obj-$(CONFIG_DVB_USB_LME2510) += dvb-usb-lmedm04.o
>
> -dvb-usb-gl861-objs = gl861.o
> +dvb-usb-gl861-objs := gl861.o
>   obj-$(CONFIG_DVB_USB_GL861) += dvb-usb-gl861.o
>
> -dvb-usb-mxl111sf-objs = mxl111sf.o mxl111sf-phy.o mxl111sf-i2c.o mxl111sf-gpio.o
> +dvb-usb-mxl111sf-objs += mxl111sf.o mxl111sf-phy.o mxl111sf-i2c.o
> +dvb-usb-mxl111sf-objs += mxl111sf-gpio.o
>   obj-$(CONFIG_DVB_USB_MXL111SF) += dvb-usb-mxl111sf.o
>   obj-$(CONFIG_DVB_USB_MXL111SF) += mxl111sf-demod.o
>   obj-$(CONFIG_DVB_USB_MXL111SF) += mxl111sf-tuner.o
>
> -dvb-usb-rtl28xxu-objs = rtl28xxu.o
> +dvb-usb-rtl28xxu-objs := rtl28xxu.o
>   obj-$(CONFIG_DVB_USB_RTL28XXU) += dvb-usb-rtl28xxu.o
>
>   ccflags-y += -I$(srctree)/drivers/media/dvb-core
> diff --git a/drivers/media/usb/dvb-usb/Makefile b/drivers/media/usb/dvb-usb/Makefile
> index d3ab1e7..acdd1ef 100644
> --- a/drivers/media/usb/dvb-usb/Makefile
> +++ b/drivers/media/usb/dvb-usb/Makefile
> @@ -1,78 +1,79 @@
> -dvb-usb-objs = dvb-usb-firmware.o dvb-usb-init.o dvb-usb-urb.o dvb-usb-i2c.o dvb-usb-dvb.o dvb-usb-remote.o usb-urb.o
> +dvb-usb-objs += dvb-usb-firmware.o dvb-usb-init.o dvb-usb-urb.o dvb-usb-i2c.o
> +dvb-usb-objs += dvb-usb-dvb.o dvb-usb-remote.o usb-urb.o
>   obj-$(CONFIG_DVB_USB) += dvb-usb.o
>
> -dvb-usb-vp7045-objs = vp7045.o vp7045-fe.o
> +dvb-usb-vp7045-objs := vp7045.o vp7045-fe.o
>   obj-$(CONFIG_DVB_USB_VP7045) += dvb-usb-vp7045.o
>
> -dvb-usb-vp702x-objs = vp702x.o vp702x-fe.o
> +dvb-usb-vp702x-objs := vp702x.o vp702x-fe.o
>   obj-$(CONFIG_DVB_USB_VP702X) += dvb-usb-vp702x.o
>
> -dvb-usb-gp8psk-objs = gp8psk.o gp8psk-fe.o
> +dvb-usb-gp8psk-objs := gp8psk.o gp8psk-fe.o
>   obj-$(CONFIG_DVB_USB_GP8PSK) += dvb-usb-gp8psk.o
>
> -dvb-usb-dtt200u-objs = dtt200u.o dtt200u-fe.o
> +dvb-usb-dtt200u-objs := dtt200u.o dtt200u-fe.o
>   obj-$(CONFIG_DVB_USB_DTT200U) += dvb-usb-dtt200u.o
>
> -dvb-usb-dibusb-common-objs = dibusb-common.o
> +dvb-usb-dibusb-common-objs := dibusb-common.o
>
> -dvb-usb-a800-objs = a800.o
> +dvb-usb-a800-objs := a800.o
>   obj-$(CONFIG_DVB_USB_A800) += dvb-usb-dibusb-common.o dvb-usb-a800.o
>
> -dvb-usb-dibusb-mb-objs = dibusb-mb.o
> +dvb-usb-dibusb-mb-objs := dibusb-mb.o
>   obj-$(CONFIG_DVB_USB_DIBUSB_MB) += dvb-usb-dibusb-common.o dvb-usb-dibusb-mb.o
>
> -dvb-usb-dibusb-mc-objs = dibusb-mc.o
> +dvb-usb-dibusb-mc-objs := dibusb-mc.o
>   obj-$(CONFIG_DVB_USB_DIBUSB_MC) += dvb-usb-dibusb-common.o dvb-usb-dibusb-mc.o
>
> -dvb-usb-nova-t-usb2-objs = nova-t-usb2.o
> +dvb-usb-nova-t-usb2-objs := nova-t-usb2.o
>   obj-$(CONFIG_DVB_USB_NOVA_T_USB2) += dvb-usb-dibusb-common.o dvb-usb-nova-t-usb2.o
>
> -dvb-usb-umt-010-objs = umt-010.o
> +dvb-usb-umt-010-objs := umt-010.o
>   obj-$(CONFIG_DVB_USB_UMT_010) += dvb-usb-dibusb-common.o dvb-usb-umt-010.o
>
> -dvb-usb-m920x-objs = m920x.o
> +dvb-usb-m920x-objs := m920x.o
>   obj-$(CONFIG_DVB_USB_M920X) += dvb-usb-m920x.o
>
> -dvb-usb-digitv-objs = digitv.o
> +dvb-usb-digitv-objs := digitv.o
>   obj-$(CONFIG_DVB_USB_DIGITV) += dvb-usb-digitv.o
>
> -dvb-usb-cxusb-objs = cxusb.o
> +dvb-usb-cxusb-objs := cxusb.o
>   obj-$(CONFIG_DVB_USB_CXUSB) += dvb-usb-cxusb.o
>
> -dvb-usb-ttusb2-objs = ttusb2.o
> +dvb-usb-ttusb2-objs := ttusb2.o
>   obj-$(CONFIG_DVB_USB_TTUSB2) += dvb-usb-ttusb2.o
>
> -dvb-usb-dib0700-objs = dib0700_core.o dib0700_devices.o
> +dvb-usb-dib0700-objs := dib0700_core.o dib0700_devices.o
>   obj-$(CONFIG_DVB_USB_DIB0700) += dvb-usb-dib0700.o
>
> -dvb-usb-opera-objs = opera1.o
> +dvb-usb-opera-objs := opera1.o
>   obj-$(CONFIG_DVB_USB_OPERA1) += dvb-usb-opera.o
>
> -dvb-usb-af9005-objs = af9005.o af9005-fe.o
> +dvb-usb-af9005-objs := af9005.o af9005-fe.o
>   obj-$(CONFIG_DVB_USB_AF9005) += dvb-usb-af9005.o
>
> -dvb-usb-af9005-remote-objs = af9005-remote.o
> +dvb-usb-af9005-remote-objs := af9005-remote.o
>   obj-$(CONFIG_DVB_USB_AF9005_REMOTE) += dvb-usb-af9005-remote.o
>
> -dvb-usb-pctv452e-objs = pctv452e.o
> +dvb-usb-pctv452e-objs := pctv452e.o
>   obj-$(CONFIG_DVB_USB_PCTV452E) += dvb-usb-pctv452e.o
>
> -dvb-usb-dw2102-objs = dw2102.o
> +dvb-usb-dw2102-objs := dw2102.o
>   obj-$(CONFIG_DVB_USB_DW2102) += dvb-usb-dw2102.o
>
> -dvb-usb-dtv5100-objs = dtv5100.o
> +dvb-usb-dtv5100-objs := dtv5100.o
>   obj-$(CONFIG_DVB_USB_DTV5100) += dvb-usb-dtv5100.o
>
> -dvb-usb-cinergyT2-objs = cinergyT2-core.o cinergyT2-fe.o
> +dvb-usb-cinergyT2-objs := cinergyT2-core.o cinergyT2-fe.o
>   obj-$(CONFIG_DVB_USB_CINERGY_T2) += dvb-usb-cinergyT2.o
>
> -dvb-usb-friio-objs = friio.o friio-fe.o
> +dvb-usb-friio-objs := friio.o friio-fe.o
>   obj-$(CONFIG_DVB_USB_FRIIO) += dvb-usb-friio.o
>
> -dvb-usb-az6027-objs = az6027.o
> +dvb-usb-az6027-objs := az6027.o
>   obj-$(CONFIG_DVB_USB_AZ6027) += dvb-usb-az6027.o
>
> -dvb-usb-technisat-usb2-objs = technisat-usb2.o
> +dvb-usb-technisat-usb2-objs := technisat-usb2.o
>   obj-$(CONFIG_DVB_USB_TECHNISAT_USB2) += dvb-usb-technisat-usb2.o
>
>   ccflags-y += -I$(srctree)/drivers/media/dvb-core
> diff --git a/drivers/media/usb/em28xx/Makefile b/drivers/media/usb/em28xx/Makefile
> index 6c5f338..634fb92 100644
> --- a/drivers/media/usb/em28xx/Makefile
> +++ b/drivers/media/usb/em28xx/Makefile
> @@ -1,4 +1,4 @@
> -em28xx-y :=	em28xx-video.o em28xx-i2c.o em28xx-cards.o
> +em28xx-y +=	em28xx-video.o em28xx-i2c.o em28xx-cards.o
>   em28xx-y +=	em28xx-core.o  em28xx-vbi.o
>
>   em28xx-alsa-objs := em28xx-audio.o
> diff --git a/drivers/media/usb/pwc/Makefile b/drivers/media/usb/pwc/Makefile
> index f5c8ec2..d7fdbcb 100644
> --- a/drivers/media/usb/pwc/Makefile
> +++ b/drivers/media/usb/pwc/Makefile
> @@ -1,4 +1,4 @@
> -pwc-objs	:= pwc-if.o pwc-misc.o pwc-ctrl.o pwc-v4l.o pwc-uncompress.o
> +pwc-objs	+= pwc-if.o pwc-misc.o pwc-ctrl.o pwc-v4l.o pwc-uncompress.o
>   pwc-objs	+= pwc-dec1.o pwc-dec23.o pwc-kiara.o pwc-timon.o
>
>   obj-$(CONFIG_USB_PWC) += pwc.o
> diff --git a/drivers/media/usb/tm6000/Makefile b/drivers/media/usb/tm6000/Makefile
> index 6fa1f10..f264493 100644
> --- a/drivers/media/usb/tm6000/Makefile
> +++ b/drivers/media/usb/tm6000/Makefile
> @@ -9,7 +9,7 @@ obj-$(CONFIG_VIDEO_TM6000) += tm6000.o
>   obj-$(CONFIG_VIDEO_TM6000_ALSA) += tm6000-alsa.o
>   obj-$(CONFIG_VIDEO_TM6000_DVB) += tm6000-dvb.o
>
> -ccflags-y := -Idrivers/media/i2c
> +ccflags-y += -Idrivers/media/i2c
>   ccflags-y += -Idrivers/media/tuners
>   ccflags-y += -Idrivers/media/dvb-core
>   ccflags-y += -Idrivers/media/dvb-frontends
>


-- 
http://palosaari.fi/
