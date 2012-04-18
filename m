Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49426 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab2DRSff (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 14:35:35 -0400
Message-ID: <4F8F0975.10605@iki.fi>
Date: Wed, 18 Apr 2012 21:35:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: RTL28XX driver
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com> <4F804CDC.3030306@gmail.com> <CAKZ=SG_=7U2QShzq+2HE8SVZvyRpG3rNTsDzwUaso=CG8tXOsg@mail.gmail.com> <4F85D787.2050403@iki.fi> <4F85F89A.80107@schinagl.nl> <4F85FE63.1030700@iki.fi> <4F86C66A.4010404@schinagl.nl> <CAKZ=SG8gHbnRGFrajp2=Op7x52UcMT_5CFM5wzgajKCXkggFtA@mail.gmail.com> <4F86CE09.3080601@schinagl.nl> <CAKZ=SG95OA3pOvxM6eypsNaBvzX1wfjPR4tucc8725bnhE3FEg@mail.gmail.com> <4F86D4B8.8060005@iki.fi> <CAKZ=SG8G8w1J_AF-bOCn2n8gcEogGPQ1rmp45wCtmwFgOUPifA@mail.gmail.com> <4F8EFD7B.2020901@iki.fi> <CAKZ=SG8=z6c4-n8wkMK1YmTzWs9rN9JrbM907+K+X0k4ampSJA@mail.gmail.com>
In-Reply-To: <CAKZ=SG8=z6c4-n8wkMK1YmTzWs9rN9JrbM907+K+X0k4ampSJA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The method should be selected based of knowledge if GPIO used for 
controlling FC0012 tuner OR controlling some other part (LNA, anatenna 
switch, etc.) So you have to identify meaning first. Look inside FC0012 
driver to see if there is some mention about that GPIO.

UNLESS we cannot identify meaning of GPIO, fe_ioctl_overrid must be used 
(inside rtl28xxu driver). All unknown "hacks" must reside DVB-USB-driver 
(in that case dvb_usb_rtl28xxu) leaving demodulator and tuner drivers clean.

regards
Antti


On 18.04.2012 21:20, Thomas Mair wrote:
> I don't know what it really is either but the comments are the following.
>
> if (frequency>  300000000)
> {
> 				
> 	printk("  %s : Tuner :FC0012 V-band (GPIO6 high)\n", __FUNCTION__);		
> }
> else
> {
> 	printk("  %s : Tuner :FC0012 U-band (GPIO6 low)\n", __FUNCTION__);	
> }
>
> I looked into both mechanisms but can't really decide which one would
> be the best one for this. What is the correct ioctl constant to listen
> for or do I define an own constant? And how is the ioctl command
> issued within the demod driver?
>
> Thomas
>
> 2012/4/18 Antti Palosaari<crope@iki.fi>:
>> On 18.04.2012 20:18, Thomas Mair wrote:
>>>
>>> I have been working on the driver over the past days and been making
>>> some progress. Right now I am stuck with a small problem that I have
>>> no idea how to deal with.
>>>
>>> It seems that the fc0012 tuner supports V-Band and U-Band. To switch
>>> between those modes a GPIO output value needs to be changed. In the
>>> original Realtek driver this is done at the beginning of the
>>> set_parameters callback. Is there a different callback that can be
>>> used for this or is it ok to write a RTL2832u register from the
>>> demodulator code?
>>
>>
>> Aah, I suspect it is antenna switch or LNA GPIO. You don't say what is
>> meaning of that GPIO...
>> If it is FC0012 input, which I think it is not, then you should use FE
>> callback (named as callback too) with  DVB_FRONTEND_COMPONENT_TUNER param.
>> But I suspect it is not issue.
>>
>> So lets introduce another solution. It is fe_ioctl_override. Use it.
>>
>> You will find good examples both cases using following GIT greps
>> git grep fe_ioctl_override drivers/media
>> git grep FRONTEND_COMPONENT
>>
>> Antti
>> --
>> http://palosaari.fi/


-- 
http://palosaari.fi/
