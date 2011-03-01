Return-path: <mchehab@pedra>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:37557 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848Ab1CAJR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 04:17:28 -0500
Message-ID: <4D6CB747.60306@cit-ec.uni-bielefeld.de>
Date: Tue, 01 Mar 2011 10:07:19 +0100
From: Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>
MIME-Version: 1.0
To: Paolo Santinelli <paolo.santinelli@unimore.it>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Kernel configuration for ov9655 on the PXA27x Quick Capture Interface
References: <AANLkTika03k=cppbejCHkuOT+Uq9ptVHZwYa80ubwLqT@mail.gmail.com>	<Pine.LNX.4.64.1102172029220.30692@axis700.grange>	<AANLkTi=9hTp-s0UGKMNrTJOL0pzhnsunWkA6UwpobJE5@mail.gmail.com>	<Pine.LNX.4.64.1102172111300.30692@axis700.grange> <AANLkTi=K3G=be3b3hH-dFetHoFeeiWsSZuK8+Vi6zq9V@mail.gmail.com>
In-Reply-To: <AANLkTi=K3G=be3b3hH-dFetHoFeeiWsSZuK8+Vi6zq9V@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Paolo,

Am 17.02.2011 22:13, schrieb Paolo Santinelli:
> Does exist an older kernel version that I can patch (
> https://patchwork.kernel.org/patch/16548/) in order to use the ov9655
> sensor ?
you can find updated patches in my openembedded overlay.
http://git.berlios.de/cgi-bin/gitweb.cgi?p=openrobotix;a=tree;f=recipes/linux

The ov9655 is part of my linux-bebot.patch.

Regards,
     Stefan

> Paolo
>
> 2011/2/17 Guennadi Liakhovetski<g.liakhovetski@gmx.de>:
>> (replaced the old mailing list address)
>>
>> On Thu, 17 Feb 2011, Paolo Santinelli wrote:
>>
>>> Hi Guennadi,
>>>
>>> thank you for the information.
>>>
>>> Can I use or adapt this patch:  https://patchwork.kernel.org/patch/16548/  ?
>> You'd have to port it to the current kernel, the patch is almost 2 years
>> old...
>>
>>> I Could  use the code from the patch  to direct control the sensor
>>> register configuration and use the  PXA27x Quick Capture Interface to
>>> capture data by mean "soc_camera" and "pxa_camera" driver modules. But
>>> now when I try to load the soc_camera module i get this error:
>>>
>>> insmod soc_camera.ko
>>> insmod: cannot insert 'soc_camera.ko': No such device
>>>
>>> Please, could you give mi some tips and indication
>> No, all the drivers: soc-camera core, camera host driver (pxa_camera) and
>> a camera sensor driver (ov9655) have to work together. And their mutual
>> work is configured at the platform level. Sorry, I don't think, I can
>> guide you in detail through a complete v4l2-subdev / soc-camera driver
>> architecture. You can try to have a look at one of the multiple examples,
>> e.g.,
>>
>> arch/arm/mach-pxa/ezx.c (see a780_camera)
>> drivers/media/video/mt9m111.c
>> drivers/media/video/pxa_camera.c
>>
>> Good luck
>> Guennadi
>>
>>> Thanks
>>>
>>> Paolo
>>>
>>> 2011/2/17 Guennadi Liakhovetski<g.liakhovetski@gmx.de>:
>>>> On Wed, 16 Feb 2011, Paolo Santinelli wrote:
>>>>
>>>>> Hi all,
>>>>>
>>>>> I have an embedded smart camera equipped with an XScal-PXA270
>>>>> processor running Linux 2.6.37 and the OV9655 Image sensor connected
>>>>> on the PXA27x Quick Capture Interface.
>>>>>
>>>>> Please, what kernel module I have to select in order to use the Image sensor ?
>>>> You need to write a new or adapt an existing driver for your ov9655
>>>> sensor, currently, there's no driver available to work with your pxa270.
>>>>
>>>> Thanks
>>>> Guennadi
>>>> ---
>>>> Guennadi Liakhovetski, Ph.D.
>>>> Freelance Open-Source Software Developer
>>>> http://www.open-technology.de/
>>>>
>>>
>>>
>>> --
>>> --------------------------------------------------
>>> Paolo Santinelli
>>> ImageLab Computer Vision and Pattern Recognition Lab
>>> Dipartimento di Ingegneria dell'Informazione
>>> Universita' di Modena e Reggio Emilia
>>> via Vignolese 905/B, 41125, Modena, Italy
>>>
>>> Cell. +39 3472953357,  Office +39 059 2056270, Fax +39 059 2056129
>>> email:<mailto:paolo.santinelli@unimore.it>  paolo.santinelli@unimore.it
>>> URL:<http://imagelab.ing.unimo.it/>  http://imagelab.ing.unimo.it
>>> --------------------------------------------------
>>>
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>>
>
>


-- 
Dipl.-Ing. Stefan Herbrechtsmeier

Universit‰t Bielefeld
AG Kognitronik&  Sensorik
Exzellenzcluster Cognitive Interaction Technology (CITEC)
Universit‰tsstraﬂe 21-23
D-33615 Bielefeld (Germany)

office : M6-117
phone  : +49 521-106-67370
fax    : +49 521-106-12348
mailto : sherbrec@cit-ec.uni-bielefeld.de
www    : http://www.ks.cit-ec.uni-bielefeld.de/

