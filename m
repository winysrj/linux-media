Return-path: <linux-media-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:34650 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZEXJCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 05:02:33 -0400
Message-ID: <4A190BFA.6050007@bsc-bvba.be>
Date: Sun, 24 May 2009 10:57:30 +0200
From: Luc Brosens <dvb3@bsc-bvba.be>
Reply-To: dvb3@bsc-bvba.be
MIME-Version: 1.0
To: =?UTF-8?B?QlJVTkVUT04gQsOpcmFuZ2Vy?= <bruneton@gmail.com>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org,
	tarik.chougua@yahoo.fr
Subject: Re: [linux-dvb] Hauppauge WinTV-CI
References: <965444.24352.qm@web26902.mail.ukl.yahoo.com>	 <20090515231650.56d6c4f4@bk.ru> <4A164E9F.1070302@bsc-bvba.be> <18d12a680905220950w5ac161f4gd2c716b84bc71cf5@mail.gmail.com>
In-Reply-To: <18d12a680905220950w5ac161f4gd2c716b84bc71cf5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

BRUNETON Béranger wrote:
>> I have been struggling for ages with this device, trying get the firmware to load.
>>
>> The program I wrote to extract the firmware from the driver now outputs the Intel Hex format too, used by fxload.
>> No luck : the A3 part does not get loaded, not even using fxloads' A3-loader
>>
>> Details and downloads of code, logs etc at http://www.bsc-bvba.be/linux/dvb
>>
>> I could use some help, like :
>>>> traces of the firmware being loaded on XP/Vista (I am using USBspy myself), preferably using a hardware protocol analyser
>>>> recommendations for an affordable hardware USB2 protocol analyser (I'd try to compare the XP-log with the non-working Linux log)
>>>> suggestions on how to proceed ...
> 
> 
> Do you know why it doesn't support S2 channels ?
> Hardware or software limitation ?
> 
> 
> Regards
> 

I don't have much in the way of DVB-expertise, but here goes :
1) WinTV-CI doesn't participate in getting the signal, so changes in tuners/modulation standards/... etc shouldn't bother it
2) It is a USB2-device so should have the raw bandwidth to handle a HDTV stream
3) It uses the smartcard you'd use normally, so the actual decryption is done with the same hardware

so I'd venture it's a software limitation.

Luc
