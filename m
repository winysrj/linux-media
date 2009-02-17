Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.219]:33216 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751019AbZBQLOS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 06:14:18 -0500
Message-ID: <499A9C09.8070004@epfl.ch>
Date: Tue, 17 Feb 2009 12:14:17 +0100
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: i.MX31 Camera Sensor Interface support
References: <Pine.LNX.4.64.0901240218400.8371@axis700.grange> <4995BA71.6090801@epfl.ch>
In-Reply-To: <4995BA71.6090801@epfl.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Valentin Longchamp wrote:
> Hi Guennadi,
> 
> Guennadi Liakhovetski wrote:
>> I uploaded my current patch-stack for the i.MX31 Camera Sensor Interface 
>> to http://gross-embedded.homelinux.org/~lyakh/i.MX31-20090124/ (to be 
>> submitted later, hopefully for 2.6.30). As stated in 0000-base-unknown, 
>> these patches shall be used on top of the 
>> git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git tree 
>> "upstream" branch.
>>
> 
> I have tested your patchset on our mx31moboard system. However, I would
> like some precisions on how things should be registered.
> 

I am now able to register a camera device on the soc_camera bus with
mx3_camera, I had not initialized well the bus_id for my platform
device. After struggling with a few minor hardware bugs, I am now able
to register a MT9T031 camera (actually we have a MT9T001 for testing,
but they are very similar).

So things seem to be working fine. I am testing it with the capture.c
example from v4linux. But the mt9t031 only supports bayer format atm (I
could try to work on it, but first I need to validate our hardware
design by grabbing real images), could someone point me to an easy way
of converting this bayer format to something readable (maybe a raw image
for gimp, that's what I am trying to do now) ?

By the way, Guennadi, if you want me to test something more extensively,
don't hesitate to ask me about it.

Thanks again for your patch.

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEA3485, Station 9, CH-1015 Lausanne
