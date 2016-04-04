Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:34549 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbcDDMgH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2016 08:36:07 -0400
Received: by mail-vk0-f49.google.com with SMTP id e185so177202077vkb.1
        for <linux-media@vger.kernel.org>; Mon, 04 Apr 2016 05:36:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57022D5A.5080704@nexvision.fr>
References: <56FE9B7F.7060206@nexvision.fr> <56FEA192.9020303@nexvision.fr>
 <CAH-u=83J0kJzaV5Mqz7Zt76JgfVz6M_v_nhzPEeqwcRCRKm8VQ@mail.gmail.com> <57022D5A.5080704@nexvision.fr>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Mon, 4 Apr 2016 14:35:45 +0200
Message-ID: <CAH-u=82LeD9TWrHpntjOmV9g-6rBLuboGy6RUsasSWBBtpyQJw@mail.gmail.com>
Subject: Re: [PATCH] Add GS1662 driver (a SPI video serializer)
To: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Next, you should add a complete description to your commit. Just
>> having an object and a signed-off-by line is not enough.
> Oh, I'm sorry, I don't have any idea to explicit more details. I will
> find something for that.

Just get the description from the datasheet as a start ;-).

>> You also have to use the scripts/checkpatch.pl script to verify that
>> everything is ok with it.
> I have executed this script before to send it. And it noticed nothing about that.
>
>> Last thing, I can't see anything related to V4L2 in your patch. It is
>> just used to initialize the chip and the spi bus, that's all.
>> Adding a subdev is a start, and some operations if it can do something
>> else than just serializing.
>
> Maybe I'm in the wrong list for that in fact. I didn't know this list was about V4L2 and related topics.
> This driver is only to configure the component to manage the video stream in electronic card, it is not to capture video stream via V4L.
>
> I should improve my driver to be configurable by userspace. But maybe I should submit my future patch in another ML.

Well, I am not really sure about that. I added Hans in cc as he may
have a better view.
>From my point of view, it can be a V4L2 subdev, even a simple one, as
you can configure outputs, etc.

JM
