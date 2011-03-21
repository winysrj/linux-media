Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab1CUVJ5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 17:09:57 -0400
Message-ID: <4D87BEA1.7080601@redhat.com>
Date: Mon, 21 Mar 2011 18:09:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: goffa72@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: Leadtek Winfast 1800H FM Tuner
References: <4D8550A3.5010604@aapt.net.au> <4D85B871.3010201@iki.fi> <4D8726C5.2090403@gmail.com> <4D8737EB.9070006@aapt.net.au> <4D878E84.2020801@redhat.com> <4D87B927.9040200@aapt.net.au>
In-Reply-To: <4D87B927.9040200@aapt.net.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-03-2011 17:46, Andrew Goff escreveu:
> On Tue 22-Mar-2011 4:44 AM, Mauro Carvalho Chehab wrote:
>> Em 21-03-2011 08:35, Andrew Goff escreveu:
>>> On Mon 21-Mar-2011 9:21 PM, Mauro Carvalho Chehab wrote:
>>>> Em 20-03-2011 05:18, Antti Palosaari escreveu:
>>>>> On 03/20/2011 02:56 AM, Andrew Goff wrote:
>>>>>> Hi, I hope someone may be able to help me solve a problem or point me in
>>>>>> the right direction.
>>>>>>
>>>>>> I have been using a Leadtek Winfast DTV1800H card (﻿Xceive xc3028 tuner)
>>>>>> for a while now without any issues (DTV&  Radio have been working well),
>>>>>> I recently decided to get another tuner card, Leadtek Winfast DTV2000DS
>>>>>> (Tuner: NXP TDA18211, but detected as TDA18271 by V4L drivers, Chipset:
>>>>>> AF9015 + AF9013 ) and had to compile and install the V4L drivers to get
>>>>>> it working. Now DTV on both cards work well but there is a problem with
>>>>>> the radio tuner on the 1800H card.
>>>>>>
>>>>>> After installing the more recent V4L drivers the radio frequency is
>>>>>> 2.7MHz out, so if I want to listen to 104.9 I need to tune the radio to
>>>>>> 107.6. Now I could just change all my preset stations but I can not
>>>>>> listen to my preferred stations as I need to set the frequency above
>>>>>> 108MHz.
>>>>> I think there is something wrong with the FM tuner (xc3028?) or other chipset drivers used for DTV1800H. No relations to the af9015, af9013 or tda18271. tda18211 is same chip as tda18271 but only DVB-T included. If DTV1800H does not contain tda18211 or tda18271 problem cannot be either that.
>>>> Yes, the problem is likely at xc3028. It has to do frequency shift for some
>>>> DVB standards, and the shift is dependent on what firmware is loaded.
>>>>
>>>> So, you need to enable load tuner-xc2028 with debug=1, and provide us the
>>>> dmesg.
>>>>
>>>> Mauro.
>>>>
>>> Hi Mauro
>>>
>>> To do this do I just add the line
>>>
>>> options tuner-xc2028 debug=1
>>>
>>> to the /etc/modules file.
>>>
>>>  From my current dmesg file looks like the firmware is version 2.7.
>>>
>>> xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
>>
>> There are about 60 firmwares that are grouped inside xc3028-v27.fw. Please
>> post the complete dmesg. We also need to know what version of the driver
>> you were using when the driver used to work and what you're using when it
>> broke.
>>
>> Thanks
>> Mauro.
>>
> 
> Mauro, please see dmesg attached, note I have not added debug=1 yet, do I still need to do this.
> 
> To get the other card working I installed this driver version http://linuxtv.org/hg/v4l-dvb/rev/abd3aac6644e

The mercurial tree is there just due to historic reasons. It has _obsolete_ stuff and nobody
is updating it. Please use, instead, the media_build.git (see linuxtv.org wiki).

the dmesg with the debug=1 is required, otherwise, it won't produce any error about what's happening at
the xc3028 driver.

Mauro.
