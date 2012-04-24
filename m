Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51885 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab2DXCpI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 22:45:08 -0400
Received: by pbbro12 with SMTP id ro12so373967pbb.19
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 19:45:07 -0700 (PDT)
Date: Tue, 24 Apr 2012 10:45:25 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Antti Palosaari" <crope@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>,
	"Konstantin Dimitrov" <kosio.dimitrov@gmail.com>
References: <1327228731.2540.3.camel@tvbox>,
 <4F2185A1.2000402@redhat.com>,
 <201204152353103757288@gmail.com>,
 <201204201601166255937@gmail.com>,
 <4F9130BB.8060107@iki.fi>,
 <201204211045557968605@gmail.com>,
 <4F958640.9010404@iki.fi>,
 <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>
Subject: Re: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
Message-ID: <201204241044551105025@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012-04-24 09:50:33 nibble.max@gmail.com
>Em 23-04-2012 19:51, Konstantin Dimitrov escreveu:
>> Antti, i already commented about ds3103 drivers months ago:
> 
>> also, why Montage tuner code should be spitted from the demodulator
>> code? is there any evidence that any Montage tuner (ts2020 or ts2022)
>> can work with 3rd party demodulator different than ds3000 or ds3103?
>
>This has nothing to do with Montage devices, but with the way we write
>those drivers in Kernel.
>
>There are _several_ examples where the driver for a single silicon were
>turned into more than one driver. The biggest examples are the SoC chips,
>that are transformed into a large series of drivers.
>
>Another example is the cx88 driver: due to technical reasons, it was splitted 
>into 4 drivers, one for each different PCI ID exported by it. 
>
>The cx2341x driver is also an interesting example: while it used to be for a
>separate chip, the cx2341x functions are now part of IP blocks on newer 
>Conexant chipsets. Those single chips require two drivers to work (cx2341x
>and the associated media PCI bridge driver).
>
>Looking into tuners, there are the tda18271 family of devices, with are
>supported by several drivers: tda827x, tda8290 and tda18271-fe, depending
>on how the actual device is mounted. Eventually, the actual tuner may
>also have a tda9887 inside it.
>
>So, there's nothing wrong on splitting it on separate drivers. In a matter of
>fact, we strongly prefer to have tuners separate from demods. Having them
>together can only be justified technically, if there are really strong reasons
>why they should be at the same driver.
>
>I probably missed this at my review for ds3000 (that's why it ended by being
>merged), but, on the review I did on it (accidentally due to m88ds3103 patchset
>review), it is clear that the tuner has actually a different I2C address (0x60)
>than the demod, and it is indeed a separate device. Sorry for slipping into it.
>
>Anyway, now that this is noticed, tuner and demod drivers should be split,
>especially since there are some patches floating around to add support for ds3103.
>
>As I said before, the right thing to do is:
>
>	1) split ds3000 from ts2020 at the existing driver;
>	2) add support for the newer chips (ds3103/ts2022) to the ds3000 and ds3103
>	   drivers.
>	3) test if the patches adding support for the newer chips didn't break the
>	   support for existing hardware.
>
>My proposal is that tasks (1) and (3) should be handled by you. As Max wants to
>add support for some devices based on ds3103/ts2022, IMO, he can do the patches
>for (2) in a way that they would be acceptable by you, as the driver maintainer
>for ds3000/ts2020, testing with their devices.
>
>Regards,
>Mauro

Montage M88ds3103 is not only working with its own tuners. 
It works with silicon tuner including AV2011, AV2026 and CAN tuner including sharp6306, sharp7803 and sharp7903 etc.
How to add these supports in the single file? It is really headache. 
So I think that spliting the tuner and demod file is only right way.

First I read the source code of DS3000 and show respects to ds3000 work in linux.
But find that it can not read back the tuner register correctly, and not set the right tuner bandwidth filter,etc.
I fix all those bugs and also update ds3000 firmware to the latest one.
The big one is that I start to add m88ds3103 demodulator and m88ts2022 tuner support. It is not just the work as simple as adding some constant. there are much difference as you can see much "switch and if" to apply the especial code for new tuner and demodulator.

But Konstantin tell me that I have no right to put the copyright in the file, even say many bad words to my works.
As I know that Konstantin works for the competitor company, I donot care the fight of his company and dvbsky.
Dvbsky develops its hardware by their own, and write windows driver. some of their technical guys have more than ten years in PC tuner design experience from old analog one based on bt878 chip. ohh, this story is out of this topic, sorry.

As many requirements to run into linux, I become the candidate to do it. 
It is public and open project, everybody can contribute to it. Is it right?
I think it is unfair and is abnormal for open source project. 
even start to read the GNU document carefully to check if the original author deny your work in the wrong way, what can i do?
So I decide to rewrite the code from scratch, and find almost ds3000 code copy from the reference code except the driver framework. 
It is obvious that the code is old one, montage update its ds3000 code after Konstantin' works. So I update to the new one.
I have no hardware of Konstantin's works and patch the original ds3000 because more complex works.
That is why I decide to write the new m88ds3103 file and put copyright of Montage and Konstantin as well to show repects to both.

BR,
Max

