Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:32985 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZCPOjz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 10:39:55 -0400
Message-ID: <49BE64B1.3050606@cam.ac.uk>
Date: Mon, 16 Mar 2009 14:39:45 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	corbet@lwn.net
Subject: Re: RFC: ov7670 soc-camera driver
References: <49BD3669.1070409@cam.ac.uk> <Pine.LNX.4.64.0903151948180.11969@axis700.grange> <200903152005.36265.hverkuil@xs4all.nl> <Pine.LNX.4.64.0903152112470.11969@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0903152112470.11969@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Sun, 15 Mar 2009, Hans Verkuil wrote:
> 
>> On Sunday 15 March 2009 19:50:39 Guennadi Liakhovetski wrote:
>>> On Sun, 15 Mar 2009, Jonathan Cameron wrote:
>>>> From: Jonathan Cameron <jic23@cam.ac.uk>
>>>>
>>>> OV7670 driver for soc-camera interfaces.
>>> Much appreciated, thanks!
>>>
>>>> ---
>>>> There is already an ov7670 driver in tree, but it is very interface
>>>> specific (olpc) and hence not much use for the crossbow IMB400 board
>>>> which is plugged into an imote 2 pxa271 main board.
> 
> [snip]
> 
>>>> Clearly this driver shares considerable portions of code with
>>>> Jonathan Corbet's driver (in tree). It would be complex to combine
>>>> the two drivers, but perhaps people feel this would be worthwhile?
>>> Now, there we go... Hans, time for v4l2-device?...
>>>
>>> This means, I will look through the driver, but we should really think
>>> properly whether to pull it in now, or "just" convert the OLPC driver and
>>> soc-camera to v4l2-device and thus enable re-use.
>> I have already converted ov7670 to v4l2_subdev here:
>>
>> http://linuxtv.org/hg/~hverkuil/v4l-dvb-cafe2/
>>
>> I'm waiting for test feedback (Hi Corbet!) before I'll merge it.
>>
>> This situation is exactly why we need one single API for subdevices like 
>> this. As soon as soc-camera is converted to v4l2-device it will just all 
>> fall neatly into place.
>>
>> I don't think it is a good idea to merge a second ov7670 driver as that's 
>> exactly what we are trying to avoid. Migrating soc-camera to the 
>> v4l2-device/v4l2-subdev framework is the right approach. Otherwise this 
>> issue will just crop up time and again.
>>
>> Although not good news for Jonathan, since his work will be delayed. 
>> Jonathan, to get an idea what all of this is about you should read the 
>> v4l2-framework.txt document in the master v4l-dvb repository 
>> (linuxtv.org/hg/v4l-dvb). It will give you the background information on 
>> the v4l2_subdev structure and associated API that we are migrating towards. 
>> And soc-camera happens to a framework that hasn't been converted yet.
> 
> Well, I don't think Jonathan's work will be quite in vain - it will 
> probably help having both drivers (soc-camera and v4l2-device) during the 
> porting for comparison and feature exchange. But I agree, that it wouldn't 
> be a right thing to merge this driver in the mainline now.
That's fair enough.  I'm having to maintain a couple of other drivers
out of tree under similar circumstances so one more doesn't make much difference.
Hardest bit of this driver was dealing with some board specific i2c quirks
anyway which I'd have had to do even if their was a suitable driver in tree.

For reference, any changes I make in the meantime will end up in 
http://git.kernel.org/?p=linux/kernel/git/jic23/imote2.git
> 
> I am willing and planning to do (at least a part of) this conversion, the 
> only problem is that I don't have much free (as in beer:-)) time for it, 
Know that feeling, or I'd offer to help ;)  Happy to do some testing but
probably can't contribute any coding time.  Too much in the todo list right
now.

I'm not entirely clear how the subdev stuff will actually help, but I guess
that'll be come clear as the code progresses.
> and so far I don't see anyone outside queuing to finance this work:-) In 
> any case, looks like I'll have to pump up its priority and start working 
> on it asap. I only have to review the next version of PXA DMA conversion 
> patches, and then I'll declare a feature-freeze and just plunge into it. 
> Once started it will be finished some time:-)
Sounds, good.

Please keep me informed of progress (I'm not going to be that active
a reader of linux-media ;)

Thanks for the quick responses.

Jonathan
