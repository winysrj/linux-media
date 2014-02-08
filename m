Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.pb.cz ([109.72.0.114]:42466 "EHLO smtp4.pb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaBHOnp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Feb 2014 09:43:45 -0500
Message-ID: <52F6429E.6070704@mizera.cz>
Date: Sat, 08 Feb 2014 15:43:42 +0100
From: kapetr@mizera.cz
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: video from USB DVB-T get  damaged after some time
References: <52F50E0B.1060507@mizera.cz> <52F56971.8060104@iki.fi>
In-Reply-To: <52F56971.8060104@iki.fi>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

unfortunately I do not understand development, patching, compiling things.
I have try it but I need more help.

I have done:

git clone --depth=1 git://linuxtv.org/media_build.git
cd media_build
./build

it downloads and builds all. At begin of compiling I had stop it.
Then I did manual change of
./media_build/linux/drivers/media/usb/dvb-usb-v2/af9035.c

------------------- old part:
         { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
                 &af9035_props, "TerraTec Cinergy T Stick (rev. 2)", 
NULL) },
         /* IT9135 devices */
#if 0
         { DVB_USB_DEVICE(0x048d, 0x9135,
                 &af9035_props, "IT9135 reference design", NULL) },
         { DVB_USB_DEVICE(0x048d, 0x9006,
                 &af9035_props, "IT9135 reference design", NULL) },
#endif
         /* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
         { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
                 &af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 
2)", NULL) },
----------------------------- new:
	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
		&af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
	/* IT9135 devices */

	{ DVB_USB_DEVICE(0x048d, 0x9135,
		&af9035_props, "IT9135 reference design", NULL) },

	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
--------------------------------------------


But now I do not know how to "restart" build process.

I have try:

cd /tmp/media_build/linux
make

It had compiled *. and *.ko files.

Then I have copy the new
dvb-usb-af9035.ko to kernel modules dir

And the result is:

# modprobe -r dvb_usb_it913x
# modprobe -v dvb-usb-af9035
insmod 
/lib/modules/3.2.0-58-generic/kernel/drivers/media/dvb-core/dvb-core.ko
insmod 
/lib/modules/3.2.0-58-generic/kernel/drivers/media/usb/dvb-usb-v2/dvb_usb_v2.ko 

insmod 
/lib/modules/3.2.0-58-generic/kernel/drivers/media/usb/dvb-usb-v2/dvb-usb-af9035.ko 

FATAL: Error inserting dvb_usb_af9035 
(/lib/modules/3.2.0-58-generic/kernel/drivers/media/usb/dvb-usb-v2/dvb-usb-af9035.ko): 
Invalid argument


--- syslog:
Feb  8 15:31:13 zly-hugo kernel: [ 5910.833525] WARNING: You are using 
an experimental version of the media stack.
Feb  8 15:31:13 zly-hugo kernel: [ 5910.833526] 	As the driver is 
backported to an older kernel, it doesn't offer
Feb  8 15:31:13 zly-hugo kernel: [ 5910.833527] 	enough quality for its 
usage in production.
Feb  8 15:31:13 zly-hugo kernel: [ 5910.833528] 	Use it with care.
Feb  8 15:31:13 zly-hugo kernel: [ 5910.833528] Latest git patches 
(needed if you report a bug to linux-media@vger.kernel.org):
Feb  8 15:31:13 zly-hugo kernel: [ 5910.833529] 
587d1b06e07b4a079453c74ba9edf17d21931049 [media] rc-core: reuse device 
numbers
Feb  8 15:31:13 zly-hugo kernel: [ 5910.833530] 
c3aed262186841bf01feb9603885671ea567ebd9 [media] em28xx-cards: properly 
initialize the device bitmap
Feb  8 15:31:13 zly-hugo kernel: [ 5910.833531] 
f52e9828d5f3001f11981d852dc9cbd3c8c5debe [media] Staging: media: Fix 
line length exceeding 80 characters in as102_drv.c
Feb  8 15:31:13 zly-hugo kernel: [ 5910.843728] dvb_usb_af9035: 
disagrees about version of symbol rc_keydown
Feb  8 15:31:13 zly-hugo kernel: [ 5910.843732] dvb_usb_af9035: Unknown 
symbol rc_keydown (err -22)
Feb  8 15:31:13 zly-hugo kernel: [ 5910.843738] dvb_usb_af9035: 
disagrees about version of symbol dvb_usbv2_generic_rw_locked
Feb  8 15:31:13 zly-hugo kernel: [ 5910.843740] dvb_usb_af9035: Unknown 
symbol dvb_usbv2_generic_rw_locked (err -22)
------------------------

What do I wrong ?
How to do it correct ?

- probably I should add patch file to
./media_build/backports

But I need the correct patch file with correct name of it ?
And what about modification of ./media_build/backports/backports.txt ?

Sorry that all is over my knowledge.

And it is not possible somehow to add new_id without patching ?
echo 048d 9135 > /sys/bus/usb/drivers/dvb_usb_af9035/new_id
bash: /sys/bus/usb/drivers/dvb_usb_af9035/new_id: Adresáø nebo soubor 
neexistuje

the file do not exist.

Why ? At my wifi dongle it has work.

Thanks for helping.

--kapetr






Dne 8.2.2014 00:17, Antti Palosaari napsal(a):
> Moikka
>
> On 07.02.2014 18:47, kapetr@mizera.cz wrote:
>> Hello,
>>
>> I have this:
>> http://linuxtv.org/wiki/index.php/ITE_IT9135
>>
>> with dvb-usb-it9135-02.fw (chip version 2) on U12.04 64b with compiled
>> newest drivers from:
>> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers.
>>
>>
>>
>>
>> The problem is - after some time I receive a program (e.g. in Kaffeine,
>> me-tv, vlc, ...) the program get more and more damaged and finely get
>> lost at all.
>>
>> I happens quicker (+- after 10-20 minutes) on channels with lower
>> signal. On stronger signals it happens after +- 30-100 minutes.
>>
>> The USB stick stays cool.
>>
>> I can switch to another frequency and back and it works again OK - for
>> only the "same" while.
>>
>> Could that problem be in (or solvable by) FW/drivers or is it
>> !absolutely certain! "only" HW problem ?
>>
>> In attachment is output from tzap - you can see the time point where the
>> video TS gets damaged.
>>
>> Any suggestion ?
>>
>>
>> Thanks  --kapetr
>>
>
> Could you test AF9035 driver? It support also IT9135 (difference between
> AF9035 is integrated RF tuner, AF9035 is older and needs external tuner
> whilst IT9135 contains tuner in same chip).
>
> Here is example patch how to add USB ID to af9035 driver:
> https://patchwork.linuxtv.org/patch/21611/
>
> regards
> Antti
>
