Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47949 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109AbZLJUrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 15:47:12 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: =?iso-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>,
	HoP <jpetrous@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 10 Dec 2009 14:46:53 -0600
Subject: RE: Latest stack that can be merged on top of linux-next tree
Message-ID: <A69FA2915331DC488A831521EAE36FE40155C80C7B@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40155C809AB@dlee06.ent.ti.com>
 <846899810912101139g6e8a36f7j78fa650e6629ad1b@mail.gmail.com>
 <4B2156AA.80309@emlix.com>
In-Reply-To: <4B2156AA.80309@emlix.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the email.

Any idea how i2c drivers can work with this?

Currently in my board, I have adapter id = 1 for main i2c bus. So when this mux driver is built into the kernel, I guess I can access it using a different adapter id, right? If so, what is the adapter id?

How do I use this with MT9T031 driver? Any idea to share?

Thanks

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Daniel Glöckner [mailto:dg@emlix.com]
>Sent: Thursday, December 10, 2009 3:15 PM
>To: HoP
>Cc: Karicheri, Muralidharan; linux-media@vger.kernel.org
>Subject: Re: Latest stack that can be merged on top of linux-next tree
>
>Hi,
>
>On 12/10/2009 08:39 PM, HoP wrote:
>> 2009/12/10 Karicheri, Muralidharan <m-karicheri2@ti.com>:
>>> BTW, Is there a driver for the PCA9543 i2c switch that is part of
>MT9T031
>>> headboard?
>>>
>>
>> I would like to know answer also :)
>>
>> I had to add support for pca9542 (what is 2 port switch) for our project.
>> After some googling I found some patches for similar kernel I was
>> working on (2.6.22). You can find original patches for example there:
>> http://www.mail-archive.com/i2c@lm-sensors.org/msg00315.html
>>
>> FYI, the driver pca954x.c seems to be driver for full family of i2c
>> muxes/switches. Such code works fine for me.
>>
>> The only thing I didn't find was why the code was never merged.
>
>the driver that has the greatest chance of being accepted has been
>discussed
>on the linux-i2c list a few days ago:
>
>http://thread.gmane.org/gmane.linux.drivers.i2c/4856
>
>The patchset they are talking about is this one:
>
>http://thread.gmane.org/gmane.linux.drivers.i2c/2998
>
>With these patches the bus segments beyond the i2c multiplexer will be
>registered as separate i2c busses. Access to a device on those busses
>will then automatically reconfigure the multiplexer.
>
>
>Last time we tried to enable only one channel of the pca9543 on the mt9d131
>board it had an effect on the brightness. Unfortunately we don't have the
>schematics of the head board. Can anyone explain what was going on there?
>
>  Daniel
>
>--
>Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
>Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
>Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
>Geschäftsführer: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055
>
>emlix - your embedded linux partner
