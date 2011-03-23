Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab1CWI4v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 04:56:51 -0400
Message-ID: <4D89B5D0.1010202@redhat.com>
Date: Wed, 23 Mar 2011 05:56:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andrew Goff <goffa72@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Leadtek Winfast 1800H FM Tuner
References: <4D8550A3.5010604@aapt.net.au>	<4D85B871.3010201@iki.fi>	<4D8726C5.2090403@gmail.com>	<4D8737EB.9070006@aapt.net.au>	<4D878E84.2020801@redhat.com>	<4D87B927.9040200@aapt.net.au>	<4D87BEA1.7080601@redhat.com> <AANLkTikTf-M9U5VZBj+uZY9oFMCTtSufrHBsyn_DO9UR@mail.gmail.com>
In-Reply-To: <AANLkTikTf-M9U5VZBj+uZY9oFMCTtSufrHBsyn_DO9UR@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 22-03-2011 08:54, Andrew Goff escreveu:
> On Tue, Mar 22, 2011 at 8:09 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 21-03-2011 17:46, Andrew Goff escreveu:
>>> On Tue 22-Mar-2011 4:44 AM, Mauro Carvalho Chehab wrote:
>>>> Em 21-03-2011 08:35, Andrew Goff escreveu:
>>>>> On Mon 21-Mar-2011 9:21 PM, Mauro Carvalho Chehab wrote:
>>>>>> Em 20-03-2011 05:18, Antti Palosaari escreveu:
>>>>>>> On 03/20/2011 02:56 AM, Andrew Goff wrote:
>>>>>>>> Hi, I hope someone may be able to help me solve a problem or point me in
>>>>>>>> the right direction.
>>>>>>>>
>>>>>>>> I have been using a Leadtek Winfast DTV1800H card (﻿Xceive xc3028 tuner)
>>>>>>>> for a while now without any issues (DTV&  Radio have been working well),
>>>>>>>> I recently decided to get another tuner card, Leadtek Winfast DTV2000DS
>>>>>>>> (Tuner: NXP TDA18211, but detected as TDA18271 by V4L drivers, Chipset:
>>>>>>>> AF9015 + AF9013 ) and had to compile and install the V4L drivers to get
>>>>>>>> it working. Now DTV on both cards work well but there is a problem with
>>>>>>>> the radio tuner on the 1800H card.
>>>>>>>>
>>>>>>>> After installing the more recent V4L drivers the radio frequency is
>>>>>>>> 2.7MHz out, so if I want to listen to 104.9 I need to tune the radio to
>>>>>>>> 107.6. Now I could just change all my preset stations but I can not
>>>>>>>> listen to my preferred stations as I need to set the frequency above
>>>>>>>> 108MHz.
>>>>>>> I think there is something wrong with the FM tuner (xc3028?) or other chipset drivers used for DTV1800H. No relations to the af9015, af9013 or tda18271. tda18211 is same chip as tda18271 but only DVB-T included. If DTV1800H does not contain tda18211 or tda18271 problem cannot be either that.
>>>>>> Yes, the problem is likely at xc3028. It has to do frequency shift for some
>>>>>> DVB standards, and the shift is dependent on what firmware is loaded.
>>>>>>
>>>>>> So, you need to enable load tuner-xc2028 with debug=1, and provide us the
>>>>>> dmesg.
>>>>>>
>>>>>> Mauro.
>>>>>>
>>>>> Hi Mauro
>>>>>
>>>>> To do this do I just add the line
>>>>>
>>>>> options tuner-xc2028 debug=1
>>>>>
>>>>> to the /etc/modules file.
>>>>>
>>>>>  From my current dmesg file looks like the firmware is version 2.7.
>>>>>
>>>>> xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
>>>>
>>>> There are about 60 firmwares that are grouped inside xc3028-v27.fw. Please
>>>> post the complete dmesg. We also need to know what version of the driver
>>>> you were using when the driver used to work and what you're using when it
>>>> broke.
>>>>
>>>> Thanks
>>>> Mauro.
>>>>
>>>
>>> Mauro, please see dmesg attached, note I have not added debug=1 yet, do I still need to do this.
>>>
>>> To get the other card working I installed this driver version http://linuxtv.org/hg/v4l-dvb/rev/abd3aac6644e
>>
>> The mercurial tree is there just due to historic reasons. It has _obsolete_ stuff and nobody
>> is updating it. Please use, instead, the media_build.git (see linuxtv.org wiki).
>>
>> the dmesg with the debug=1 is required, otherwise, it won't produce any error about what's happening at
>> the xc3028 driver.
>>
>> Mauro.
>>
> 
> HI Mauro, now using media_build.git and followed the instructions from
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
> 
> have added options tuner-xc2028 debug=1 to the /etc/modules , please
> see attached dmesg
> 
> FM tuner has now completely stopped working.

Weird:

[   36.654409] xc2028 1-0061: creating new instance
[   36.654414] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   36.654419] xc2028 1-0061: destroying instance
[   36.654489] xc2028 1-0061: creating new instance
[   36.654491] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   36.654494] cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
[   36.745247] cx88_audio 0000:01:06.1: firmware: requesting xc3028-v27.fw
[   36.817868] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   36.817993] cx88[0]: Calling XC2028/3028 callback
[   36.966811] xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[   36.966815] cx88[0]: Calling XC2028/3028 callback

xc2028 driver didn't try to load a standard-specific firmware... 

I would expect at least two load firmware lines there... one for NTSC, and another one for one of
the radio-specific firmwares, when you tried to run radio on it.

Please also load tuner with debug=1. Let's see what happens when you change a frequency on your
radio program.

AH! Very important! V4L1 API got removed, so, you need to be sure that your radio program is
using V4L2 API. I had to fix xawtv3 "radio" program for it to work properly using V4L2 API.
So, xawtv 3.95 is broken. If you're using xawtv 3.100, radio application is working fine.

We had also a report that gnome-radio upstream is broken. While it does support both API's,
it seems that it fails if V4L1 is not available. There's a patch fixing it on Fedora. Not
sure if other distros applied the patch, but, on a quick look, the Fedora patch didn't reach
upstream:
	http://git.gnome.org/browse/gnomeradio/

Hmm...

[   37.381526] ir_lirc_codec: Unknown symbol lirc_dev_fop_poll
[   37.381724] ir_lirc_codec: Unknown symbol lirc_dev_fop_open
[   37.381807] ir_lirc_codec: disagrees about version of symbol lirc_get_pdata
[   37.381809] ir_lirc_codec: Unknown symbol lirc_get_pdata
[   37.381900] ir_lirc_codec: Unknown symbol lirc_dev_fop_close
[   37.381999] ir_lirc_codec: Unknown symbol lirc_dev_fop_read
[   37.382068] ir_lirc_codec: disagrees about version of symbol lirc_register_driver
[   37.382070] ir_lirc_codec: Unknown symbol lirc_register_driver
[   37.382256] ir_lirc_codec: Unknown symbol lirc_dev_fop_ioctl

You have a mix of old and new drivers on your install. The results are unpredictable
when you're mixing drivers. Please be sure that the Kernel you're running doesn't
have any trace of the ancient drivers. Maybe some parts of RC/V4L/DVB were compiled
built in, or your distro is not putting the media stuff at the right place.

The standard place to add media Kernel drivers are at:
	/lib/modules/`uname -r`/kernel/drivers/media/

Sometimes, they might also be find at:
	/lib/modules/`uname -r`/kernel/extra (or /lib/modules/`uname -r`/extra  )

Ubuntu (Debian?) have a different opinion about that, and they have
a directory on some other random place with some drivers. It used to be at:
	/lib/modules/`uname -r`/ubuntu/media 

The new_build install target tries to remove the ancient drivers from the above
directories, but if the distro you're using are storing them into some other
random place, make install won't be able to cleanup everything.

Could you please fix the above issues and test again?

Cheers,
Mauro


