Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc3-s2.bay0.hotmail.com ([65.54.246.202]:30655 "EHLO
	bay0-omc3-s2.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbZBQFs1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 00:48:27 -0500
Message-ID: <BAY102-W227ECD869066F0AAFAC94DCFB40@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: <devin.heitmueller@gmail.com>
CC: <linux-media@vger.kernel.org>
Subject: =?windows-1256?Q?RE:_HVR-1500_tuner_seems_to_be_recognized=2C_but_wont_tu?=
 =?windows-1256?Q?rn_on.=FE?=
Date: Mon, 16 Feb 2009 23:48:26 -0600
In-Reply-To: <412bdbff0902162114v4764e320y7f17664d166c6b43@mail.gmail.com>
References: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
	 <412bdbff0902131309i169884bambd1ddb8adf9f90e5@mail.gmail.com>
 	 <BAY102-W3919BC0C2532C366EEDB1FCFB90@phx.gbl>
 	 <BAY102-W279D1B5B2A645C46C9099CCFB40@phx.gbl>
 <412bdbff0902162114v4764e320y7f17664d166c6b43@mail.gmail.com>
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Unplugging the card makes the computer freeze.  I tried putting the line about tuner-xc2038 in /etc/modules, but that didn't make a difference.  Would it help to reinstall i2c and how do I go about doing so?

Thanks,

Tom
----------------------------------------
> Date: Tue, 17 Feb 2009 00:14:56 -0500
> Subject: Re: HVR-1500 tuner seems to be recognized, but wont turn on.þ
> From: devin.heitmueller@gmail.com
> To: nickotym@hotmail.com
> CC: linux-media@vger.kernel.org
>
> 2009/2/17 Thomas Nicolai :
>>
>> Here is the pertinent part of the dmesg I got tonight:
>>
>> dmesg
>>
>> 407.155095] firmware: requesting xc3028-v27.fw
>> [ 407.248329] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
>> [ 407.447731] xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
>> [ 407.970376] xc2028 1-0061: i2c output error: rc = -5 (should be 4)
>> [ 407.970385] xc2028 1-0061: -5 returned from send
>> [ 407.970390] xc2028 1-0061: Error -22 while loading base firmware
>> [ 408.222453] xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
>> [ 408.744786] xc2028 1-0061: i2c output error: rc = -5 (should be 4)
>> [ 408.744791] xc2028 1-0061: -5 returned from send
>> [ 408.744793] xc2028 1-0061: Error -22 while loading base firmware
>> [ 409.945750] xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
>> [ 411.102083] xc2028 1-0061: Loading firmware for type=D2633 DTV6 ATSC (10030), id 0000000000000000.
>>
>>
>> ----------------------------------------
>>> From: nickotym@hotmail.com
>>> To: devin.heitmueller@gmail.com
>>> CC: linux-media@vger.kernel.org
>>> Subject: RE: HVR-1500 tuner seems to be recognized, but wont turn on.þ
>>> Date: Sat, 14 Feb 2009 12:05:09 -0600
>>>
>>>
>>>
>>>
>>>
>>>> That looks really suspicious. Perhaps the xc3028 tuner is being put
>>>> to sleep and not being woken up properly.
>>>>
>>>> Could you please post the full dmesg output showing the initialization
>>>> of the device?
>>>>
>>>> Devin
>>>
>>>
>>> I turned kubuntu on, shut off the backend for mythtv and then did a scan using dvbscan.
>>>
>>> Here is the full dmesg output, sorry it is long I wanted to include it all in case i missed anything.:
>>>
>>>
>>> dmesg
>>>
>>
>>
>> _________________________________________________________________
>> Windows Live™: Keep your life in sync.
>> http://windowslive.com/howitworks?ocid=TXT_TAGLM_WL_t1_allup_howitworks_022009
>>
>
> Sorry for not getting back to you sooner.
>
> I don't claim to know much about this card, but there was a relatively
> recent change where the tuner gets put to sleep, which might explain
> why you are having i2c communication failures.
>
> Try the following:
>
> 
> make unload
> modprobe tuner-xc2028 no_poweroff=1 debug=1
> 
> 
>
> If that doesn't work, send the dmesg output.
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

_________________________________________________________________
Windows Live™: E-mail. Chat. Share. Get more ways to connect. 
http://windowslive.com/explore?ocid=TXT_TAGLM_WL_t2_allup_explore_022009
