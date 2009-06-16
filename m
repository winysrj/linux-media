Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:58923 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbZFPRXQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 13:23:16 -0400
Message-ID: <4A37D529.8010905@cam.ac.uk>
Date: Tue, 16 Jun 2009 17:23:53 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Darius Augulis <augulis.darius@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc-camera: ov7670 merged multiple drivers and moved
 over to v4l2-subdev
References: <4A365918.40801@cam.ac.uk> <Pine.LNX.4.64.0906161552420.4880@axis700.grange> <4A37AFF0.9090004@cam.ac.uk> <4A37BBB4.1070301@gmail.com>
In-Reply-To: <4A37BBB4.1070301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Darius Augulis wrote:
> On 06/16/2009 05:45 PM, Jonathan Cameron wrote:
>> Guennadi Liakhovetski wrote:
>>> On Mon, 15 Jun 2009, Jonathan Cameron wrote:
>>>
>>>> From: Jonathan Cameron <jic23@cam.ac.uk>
>>>>
>>>> OV7670 soc-camera driver. Merge of drivers from Jonathan Corbet,
>>>> Darius Augulis and Jonathan Cameron 
>>> Could you please, describe in more detail how you merged them? 
>> Mostly by combining the various register sets and then adding pretty much
>> all the functionality in each of them, testing pretty much everything.
>>
>> Note that a lot of what was in those drivers (usually labeled as
>> untested)
>> simply doesn't work and is based on 'magic' register sets provided by
>> omnivision.
>>
>>> However, I am not sure this is the best way to go. I think, a better
>>> approach would be to take a driver currently in the mainline, perhaps,
>>> the most feature-complete one if there are several of them there, 
>> That is more or less what I've done (it's based on Jonathan Corbet's
>> driver).
>> Darius' driver and mine have never been in mainline. Darius' was a
>> complete
>> rewrite based on doc's he has under NDA. Mine was based on Jonathan
>> Corbet's one with a few bits leveraged from a working tinyos driver
>> for the
>> platform I'm using (principally because Omnivision are ignoring both
>> myself
>> and the board supplier). 
> 
> It's very difficult to write 'normal' driver for it.
> Omnivision does not provide useful documentation,
> only long constant arrays with few strange comments.
> Beside documentation is poor, there are lot of errors in register
> description.
> Many things are mistery, not documented and seems Omnivision does not
> have such documentation.
> I thing this sensor isn't perfect for embedded projects. It's 'designed'
> for webcams, where reliability and quality are not needed.
> With ov7720 similar situation...
Agreed.  Though random discussions with others suggest lots of these
chips turn up in things like pedestrian avoidance systems in cars
and similar.  (not generally running linux and tend to have fairly
fixed settings I guess).

Jonathan

