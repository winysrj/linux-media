Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:35984 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbcL2PKr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Dec 2016 10:10:47 -0500
Received: by mail-yw0-f174.google.com with SMTP id a10so208531489ywa.3
        for <linux-media@vger.kernel.org>; Thu, 29 Dec 2016 07:10:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <20161019213026.GU9460@valkosipuli.retiisi.org.uk> <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Thu, 29 Dec 2016 16:10:26 +0100
Message-ID: <CAH-u=83snOXVS1iSk1=xhkq7-iDUJXutnR_jhyN+qpGxE_zejQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am so sorry... This mail wasn't send to the mailing list as this
****** gmail switched back to HTML...

2016-12-29 16:08 GMT+01:00 Jean-Michel Hautbois
<jean-michel.hautbois@veo-labs.com>:
> Hi Philipp and al.,
>
>
> 2016-10-19 23:30 GMT+02:00 Sakari Ailus <sakari.ailus@iki.fi>:
>>
>> On Fri, Oct 14, 2016 at 07:34:20PM +0200, Philipp Zabel wrote:
>> > Hi,
>> >
>> > the second round removes the prepare_stream callback and instead lets
>> > the
>> > intermediate subdevices propagate s_stream calls to their sources rather
>> > than individually calling s_stream on each subdevice from the bridge
>> > driver.
>> > This is similar to how drm bridges recursively call into their next
>> > neighbor.
>> > It makes it easier to do bringup ordering on a per-link level, as long
>> > as the
>> > source preparation can be done at s_power, and the sink can just
>> > prepare, call
>> > s_stream on its source, and then enable itself inside s_stream.
>> > Obviously this
>> > would only work in a generic fashion if all asynchronous subdevices with
>> > both
>> > inputs and outputs would propagate s_stream to their source subdevices.
>
>
> What is the status of this work ? I saw Steve's patches before yours, so
> both are implementing pretty much the same functionnality but differently.
> Which one will be finally merged ?
> I wanted to upgrade my kernel, in order to give it a try on a board with
> adv7604 and adv7611 devices.
> Is there a git tree somewhere integrating it too ?
>
> Thanks,
> JM
>
>
