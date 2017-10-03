Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34175 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdJCSso (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 14:48:44 -0400
Received: by mail-pg0-f68.google.com with SMTP id u27so10614724pgn.1
        for <linux-media@vger.kernel.org>; Tue, 03 Oct 2017 11:48:44 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH RFC] media: staging/imx: fix complete handler
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
References: <E1dy2zX-0003NB-5J@rmk-PC.armlinux.org.uk>
 <9fccea49-c708-325f-bbce-269eecc6f350@gmail.com>
 <20171001233604.GF20805@n2100.armlinux.org.uk>
 <eef28fbb-5145-e934-3c6c-ba777813c34c@gmail.com>
 <20171003090604.GI20805@n2100.armlinux.org.uk>
Message-ID: <83ab4c95-4184-6bfe-3802-0bb51d5ff039@gmail.com>
Date: Tue, 3 Oct 2017 11:48:41 -0700
MIME-Version: 1.0
In-Reply-To: <20171003090604.GI20805@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/03/2017 02:06 AM, Russell King - ARM Linux wrote:
> On Mon, Oct 02, 2017 at 05:59:30PM -0700, Steve Longerbeam wrote:
>> On 10/01/2017 04:36 PM, Russell King - ARM Linux wrote:
>>> On Sun, Oct 01, 2017 at 01:16:53PM -0700, Steve Longerbeam wrote:
>>>> Right, imx_media_add_vdev_to_pa() has followed a link to an
>>>> entity that imx is not aware of.
>>>>
>>>> The only effect of this patch (besides allowing the driver to load
>>>> with smiapp cameras), is that no controls from the unknown entity
>>>> will be inherited to the capture device nodes. That's not a big deal
>>>> since the controls presumably can still be accessed from the subdev
>>>> node.
>>> smiapp is just one example I used to illustrate the problem.  The imx
>>> media implementation must not claim subdevs exclusively for itself if
>>> it's going to be useful, it has to cater for subdevs existing for
>>> other hardware attached to it.
>>>
>>> As you know, the camera that interests me is my IMX219 camera, and it's
>>> regressed with your driver because of your insistence that you have sole
>>> ownership over subdevs in the imx media stack
>> If by "sole ownership", you mean expecting async registration of subdevs
>> and setting up the media graph between them, imx-media will only do that
>> if those devices and the connections between them are described in the
>> device tree. If they are not, i.e. the subdevs and media pads and links are
>> created internally by the driver, then imx-media doesn't interfere with
>> that.
> By "sole ownership" I mean that _at the moment_ imx-media believes
> that it has sole right to make use of all subdevs with the exception
> of one external subdev, and expects every subdev to have an imx media
> subdev structure associated with it.
> That's clearly true, because as soon as a multi-subdev device is
> attempted to be connected to imx-media, imx-media falls apart because
> it's unable to find its private imx media subdev structure for the
> additional subdevs.

If imx-media finds a subdev in the device tree that is ultimately linked
to an IPU CSI port, then it needs to maintain information about that
subdev so that imx-media can field an async registration from it and setup
media links to/from it. That info is contained in struct imx_media_subdev.

Besides async registration and media link setup, I've done an audit on
the other ways struct imx_media_subdev is used.

One other usage is to locate a CSI entity in PRP entity, but CSI 
entities _must_
be known to imx-media, so no problem there.

Another usage is to locate the originating source entity (the sensor) in 
CSI entity,
to retrieve media bus config. But there will be an originating device in 
the OF
graph, and imx-media necessarily needs to know about that one.

Finally, besides the regression in imx_media_add_vdev_to_pad(), there is one
other problem usage of imx_media_find_subdev_by_sd() which I will post a 
patch
for. See below [1].


>>>   - I'm having to carry more
>>> and more hacks to workaround things that end up broken.  The imx-media
>>> stack needs to start playing better with the needs of others, which it
>>> can only do by allowing subdevs to be used by others.
>> Well, for example imx-media will chain s_stream until reaches your
>> IMX219 driver. It's then up to your driver to pass s_stream to the
>> subdevs that it owns.
> Of course it is.  It's your responsibility to pass appropriate stuff
> down the chain as far as you know how to, which is basically up to
> the first external subdev facing imx-media.  What happens beyond there
> is up to the external drivers.
>
>>>    One way to
>>> achieve that change that results in something that works is the patch
>>> that I've posted - and tested.
>>   Can you change the error message to be more descriptive, something
>> like "any controls for unknown subdev %s will not be inherited\n" and maybe
>> convert to a warn. After that I will ack it.
> No, that's plainly untrue as I said below:
>
>>> It also results in all controls (which are spread over the IMX219's two
>>> subdevs) to be visible via the v4l2 video interface - I have all the
>>> controls attached to the pixel array subdev as well as the controls
>>> attached to the scaling subdev.
> Given that I said this, and I can prove that it does happen, I've no
> idea why your reply seemed to totally ignore this paragraph.
> So I refuse to add a warning message that is incorrect.

Oops, sorry you are right. I reviewed the control inheritance code
and I've forgotten some details.

imx_media_inherit_controls() will start adding control handlers starting
from the source entity from a link_notify. As long as that source entity
is known to imx-media, imx_media_inherit_controls() moves upstream
without the need for a struct imx_media_subdev. If the source entity is
_not_ known, link_notify will fail before attempting to inherit controls 
[1].

So never mind my erroneously suggested error message, in fact I wouldn't
mind if you removed the error message altogether, or convert to debug.

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>


[1] This is a bug, if imx_media_link_notify() gets a source subdev not know
to imx-media, it should return 0, not an error code. The link_notify op 
is only
used to inherit controls, and the controls for the unknown subdev will get
inherited later anyway, starting from a subdev that is known to imx-media.
I will post a patch to fix.


Steve
