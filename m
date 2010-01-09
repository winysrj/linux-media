Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.aster.pl ([212.76.33.56]:44155 "EHLO smtp2.aster.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753600Ab0AIMIj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2010 07:08:39 -0500
Message-ID: <4B4871C4.10401@aster.pl>
Date: Sat, 09 Jan 2010 13:08:36 +0100
From: Daro <ghost-rider@aster.pl>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: IR device at I2C address 0x7a
References: <4B324EF0.7090606@aster.pl>	<20100106153909.6bce3183@hyperion.delvare>	<4B44CF62.5060405@aster.pl>	<20100106194059.061636d3@hyperion.delvare>	<4B44E026.3060906@aster.pl> <20100106212140.11b02d0f@hyperion.delvare>
In-Reply-To: <20100106212140.11b02d0f@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 06.01.2010 21:21, Jean Delvare pisze:
> On Wed, 06 Jan 2010 20:10:30 +0100, Daro wrote:
>    
>> W dniu 06.01.2010 19:40, Jean Delvare pisze:
>>      
>>> On Wed, 06 Jan 2010 18:58:58 +0100, Daro wrote:
>>>
>>>        
>>>> It is not the error message itself that bothers me but the fact that IR
>>>> remote control device is not detected and I cannot use it (I checked it
>>>> on Windows and it's working). After finding this thread I thought it
>>>> could have had something to do with this error mesage.
>>>> Is there something that can be done to get my IR remote control working?
>>>>
>>>>          
>>> Did it ever work on Linux?
>>>        
>> I have no experience on that. I bought this card just few weeks ago and
>> tried it only on Karmic Koala.
>>      
> OK.
>
> You could try loading the saa7134 driver with option card=146 and see
> if it helps.
>
>    
It works!

[   15.477875] input: saa7134 IR (ASUSTeK P7131 Analo as 
/devices/pci0000:00/0000:00:1e.0/0000:05:00.0/input/input8

Thank you very much fo your help.

I have another question regarding this driver:

[   21.340316] saa7133[0]: dsp access error
[   21.340320] saa7133[0]: dsp access error

Do those messages imply something wrong? Can they have something do do 
with the fact I cannot get the sound out of tvtime application directly 
and have to use "arecord | aplay" workaround which causes undesirable delay?

