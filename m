Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:41057 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZFQJZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 05:25:51 -0400
Message-ID: <4A38B6C5.3020108@cam.ac.uk>
Date: Wed, 17 Jun 2009 09:26:29 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Darius <augulis.darius@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] soc-camera: ov7670 merged multiple drivers and moved
 over to v4l2-subdev
References: <4A365918.40801@cam.ac.uk> <Pine.LNX.4.64.0906161552420.4880@axis700.grange> <4A37AFF0.9090004@cam.ac.uk> <200906170844.42512.hverkuil@xs4all.nl>
In-Reply-To: <200906170844.42512.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Tuesday 16 June 2009 16:45:04 Jonathan Cameron wrote:
>> Guennadi Liakhovetski wrote:
>>> On Mon, 15 Jun 2009, Jonathan Cameron wrote:
>>>> From: Jonathan Cameron <jic23@cam.ac.uk>
>>>>
>>>> OV7670 soc-camera driver. Merge of drivers from Jonathan Corbet,
>>>> Darius Augulis and Jonathan Cameron
>>> Could you please, describe in more detail how you merged them?
>> Mostly by combining the various register sets and then adding pretty much
>> all the functionality in each of them, testing pretty much everything.
>>
>> Note that a lot of what was in those drivers (usually labeled as
>> untested) simply doesn't work and is based on 'magic' register sets
>> provided by omnivision.
>>
>>> However, I am not sure this is the best way to go. I think, a better
>>> approach would be to take a driver currently in the mainline, perhaps,
>>> the most feature-complete one if there are several of them there,
>> That is more or less what I've done (it's based on Jonathan Corbet's
>> driver). Darius' driver and mine have never been in mainline. Darius' was
>> a complete rewrite based on doc's he has under NDA.  Mine was based on
>> Jonathan Corbet's one with a few bits leveraged from a working tinyos
>> driver for the platform I'm using (principally because Omnivision are
>> ignoring both myself and the board supplier).
>>
>>> convert
>>> it and its user(s) to v4l2-subdev, extend it with any features missing
>>> in it and present in other drivers, then switch users of all other
>>> ov7670 drivers over to this one,
>> That's the problem. The only mainlined driver is specifically for an OLPC
>> machine.  The driver is tied to specific i2c device and doesn't use
>> anything anywhere near soc-camera or v4l2-subdev.
> 
> Yes, it does. ov7670.c was converted to v4l2-subdev in 2.6.30.
Ah! thanks for the heads up on that.
Some how I missed that entirely.
> 
>> While it would be nice to get a single driver working
>> for this hardware as well as more conventional soc-camera devices, it
>> isn't going to happen without a lot of input from someone with an olpc. 
>> The chip is interfaced through a Marvell 88alp101 'cafe' chip which does
>> a whole host of random things alongside being video processor and taking
>> a quick look at that would be written in a completely different fashion
>> if it were done now (mfd with subdevices etc, v4l2-sudev)
>>
>> So basically in the ideal world it would happen exactly as you've
>> suggested, but I doubt it'll happen any time soon and in the meantime
>> there is no in kernel support for those of us using the chip on other
>> platforms.
>>
>> *looks hopefully in the direction of Jonathan Corbet and other olpc
>> owners*
> 
> I have an olpc, but I still haven't had the time to setup a proper test 
> environment on it. However, I managed to clear my backlog of reviews in the 
> past few days so hopefully I can find some time this weekend to set it up.
Cool.
> 
>>> and finally make it work with soc-camera. This
>>> way you get a series of smaller and reviewable patches, instead of a
>>> completely new driver, that reproduces a lot of existing code but has
>>> to be reviewed anew. How does this sound?
>> Would be fine if the original driver (or anything terribly close to it)
>> were useable on a platform I actually have without more or less being
>> rewritten.
>>
>> I can back track the driver to be as close to that as possible and still
>> functional, but I'm not entirely sure it will make the code any easier to
>> review and you'll loose a lot the functionality lifted from Darius' as
>> my original drivers.
>>
>> The original posting I made was as close as you can reasonably get to
>> Jonathan's original driver.
>>
>> http://patchwork.kernel.org/patch/12192/
>>
>> At the time it wasn't really reviewed (beyond a few comments)
>> as you were just commencing the soc-camera conversion and it made
>> sense to wait for after that.
>>
>> I'm not really sure how we should proceed with this. I'm particularly
>> loath to touch the olpc driver unless we have a reasonable number of
>> people willing to test.
> 
> The current ov7670.c driver in the 2.6.30 tree (and the v4l-dvb repository) 
> is already v4l2_subdev based and should be reusable in other platforms, 
> including soc-camera once that has also been converted to use v4l2_subdev.
Excellent, I'll look at moving the functionality patches based on this driver
and Darius' on to that then.  Sorry for repeating some of your work, I somehow
completely forgot your original email saying this was on it's way!

Jonathan
