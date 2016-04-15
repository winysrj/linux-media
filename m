Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:36258 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753794AbcDOIiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 04:38:15 -0400
Subject: Re: [PATCH] Add GS1662 driver (a SPI video serializer)
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
	Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
References: <56FE9B7F.7060206@nexvision.fr> <56FEA192.9020303@nexvision.fr>
 <CAH-u=83J0kJzaV5Mqz7Zt76JgfVz6M_v_nhzPEeqwcRCRKm8VQ@mail.gmail.com>
 <57022D5A.5080704@nexvision.fr>
 <CAH-u=82LeD9TWrHpntjOmV9g-6rBLuboGy6RUsasSWBBtpyQJw@mail.gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5710A872.6050509@xs4all.nl>
Date: Fri, 15 Apr 2016 10:38:10 +0200
MIME-Version: 1.0
In-Reply-To: <CAH-u=82LeD9TWrHpntjOmV9g-6rBLuboGy6RUsasSWBBtpyQJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/04/2016 02:35 PM, Jean-Michel Hautbois wrote:
>>> Next, you should add a complete description to your commit. Just
>>> having an object and a signed-off-by line is not enough.
>> Oh, I'm sorry, I don't have any idea to explicit more details. I will
>> find something for that.
> 
> Just get the description from the datasheet as a start ;-).
> 
>>> You also have to use the scripts/checkpatch.pl script to verify that
>>> everything is ok with it.
>> I have executed this script before to send it. And it noticed nothing about that.
>>
>>> Last thing, I can't see anything related to V4L2 in your patch. It is
>>> just used to initialize the chip and the spi bus, that's all.
>>> Adding a subdev is a start, and some operations if it can do something
>>> else than just serializing.
>>
>> Maybe I'm in the wrong list for that in fact. I didn't know this list was about V4L2 and related topics.
>> This driver is only to configure the component to manage the video stream in electronic card, it is not to capture video stream via V4L.
>>
>> I should improve my driver to be configurable by userspace. But maybe I should submit my future patch in another ML.
> 
> Well, I am not really sure about that. I added Hans in cc as he may
> have a better view.
> From my point of view, it can be a V4L2 subdev, even a simple one, as
> you can configure outputs, etc.

I think the media subsystem is definitely the right place for this.

I would use the cs3308.c driver as a starting point. This is also a minimal driver
(and you can remove the code under CONFIG_VIDEO_ADV_DEBUG for your driver), but it
uses v4l2_subdev and that makes it ready to be extended in the future, which you
will likely need to do eventually.

Regards,

	Hans
