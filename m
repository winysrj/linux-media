Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:52535 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbZLJUO3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 15:14:29 -0500
Message-ID: <4B2156AA.80309@emlix.com>
Date: Thu, 10 Dec 2009 21:14:34 +0100
From: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Latest stack that can be merged on top of linux-next tree
References: <A69FA2915331DC488A831521EAE36FE40155C809AB@dlee06.ent.ti.com> <846899810912101139g6e8a36f7j78fa650e6629ad1b@mail.gmail.com>
In-Reply-To: <846899810912101139g6e8a36f7j78fa650e6629ad1b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/10/2009 08:39 PM, HoP wrote:
> 2009/12/10 Karicheri, Muralidharan <m-karicheri2@ti.com>:
>> BTW, Is there a driver for the PCA9543 i2c switch that is part of MT9T031
>> headboard?
>>
> 
> I would like to know answer also :)
> 
> I had to add support for pca9542 (what is 2 port switch) for our project.
> After some googling I found some patches for similar kernel I was
> working on (2.6.22). You can find original patches for example there:
> http://www.mail-archive.com/i2c@lm-sensors.org/msg00315.html
> 
> FYI, the driver pca954x.c seems to be driver for full family of i2c
> muxes/switches. Such code works fine for me.
> 
> The only thing I didn't find was why the code was never merged.

the driver that has the greatest chance of being accepted has been discussed
on the linux-i2c list a few days ago:

http://thread.gmane.org/gmane.linux.drivers.i2c/4856

The patchset they are talking about is this one:

http://thread.gmane.org/gmane.linux.drivers.i2c/2998

With these patches the bus segments beyond the i2c multiplexer will be
registered as separate i2c busses. Access to a device on those busses
will then automatically reconfigure the multiplexer.


Last time we tried to enable only one channel of the pca9543 on the mt9d131
board it had an effect on the brightness. Unfortunately we don't have the
schematics of the head board. Can anyone explain what was going on there?

  Daniel

-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführer: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - your embedded linux partner
