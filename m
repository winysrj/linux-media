Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41832 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755498AbdABOqF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 09:46:05 -0500
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <20161019213026.GU9460@valkosipuli.retiisi.org.uk>
 <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
 <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de>
 <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
 <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com>
 <CAH-u=83LDyfcErrxaDNN2+w7ZK56v9cJkvBL864ofxiBWrmBSg@mail.gmail.com>
Cc: Marek Vasut <marex@denx.de>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3b8ed13c-a23e-dc2b-0e31-1288ea3f562a@xs4all.nl>
Date: Mon, 2 Jan 2017 15:45:58 +0100
MIME-Version: 1.0
In-Reply-To: <CAH-u=83LDyfcErrxaDNN2+w7ZK56v9cJkvBL864ofxiBWrmBSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/02/17 14:51, Jean-Michel Hautbois wrote:
> Hi,
>
> 2016-12-30 21:26 GMT+01:00 Steve Longerbeam <steve_longerbeam@mentor.com>:
>>
>>
>> On 12/30/2016 11:06 AM, Marek Vasut wrote:
>>>
>>> On 12/29/2016 09:51 PM, Robert Schwebel wrote:
>>>>
>>>> Hi Jean-Michel,
>>>
>>> Hi,
>>>
>>>> On Thu, Dec 29, 2016 at 04:08:33PM +0100, Jean-Michel Hautbois wrote:
>>>>>
>>>>> What is the status of this work?
>>>>
>>>> Philipp's patches have been reworked with the review feedback from the
>>>> last round and a new version will be posted when he is back from
>>>> holidays.
>>>
>>> IMO Philipp's patches are better integrated and well structured, so I'd
>>> rather like to see his work in at some point.
>>
>>
>> Granted I am biased, but I will state my case. "Better integrated" - my
>> patches
>> are also well integrated with the media core infrastructure. Philipp's
>> patches
>> in fact require modification to media core, whereas mine require none.
>> Some changes are needed of course (more subdev type definitions for
>> one).
>>
>> As for "well structured", I don't really understand what is meant by that,
>> but my driver is also well structured.
>>
>> Philipp's driver only supports unconverted image capture from the SMFC. In
>> addition
>> to that, mine allows for all the hardware links supported by the IPU,
>> including routing
>> frames from the CSI directly to the Image converter for scaling up to
>> 4096x4096,
>> colorspace conversion, rotation, and motion compensated de-interlace. Yes
>> all these
>> conversion can be carried out post-capture via a mem2mem device, but
>> conversion
>> directly from CSI capture has advantages, including minimized CPU
>> utilization and
>> lower AXI bus traffic. In any case, Freescale added these hardware paths,
>> and my
>> driver supports them.
>
> I had a deeper look to both drivers, and I must say the features of
> Steve's one are really interesting.
> I don't think any of those has been tested with digital inputs (I have
> ADV76xx chips on my board, which I hope will be available one day for
> those interested) and so, I can test and help adding some of the
> missing parts.
> And for at least a week or two, I have all of my time for it, so it
> would be of great help to know which one has the bigger chance to be
> integrated... :)

Steve's series is definitely preferred from my point of view. The feature
set is clearly superior to Philipp's driver.

I plan on reviewing Steve's series soonish but a quick scan didn't see anything
suspicious. The code looks clean, and I am leaning towards getting this in sooner
rather than later, so if you have the time to work on this, then go for it!

Steve, I have a SabreLite and a ov5642 sensor, so I should be able to test
that driver.

There is also an ov5642 sensor driver in drivers/media/i2/soc_camera/ov5642.c.
But nobody AFAIK is using it, so I would be inclined to take your code and
remove the soc_camera driver.

Regards,

	Hans
