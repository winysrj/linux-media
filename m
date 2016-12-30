Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:58643 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754096AbcL3U1E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Dec 2016 15:27:04 -0500
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
To: Marek Vasut <marex@denx.de>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <20161019213026.GU9460@valkosipuli.retiisi.org.uk>
 <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
 <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de>
 <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com>
Date: Fri, 30 Dec 2016 12:26:55 -0800
MIME-Version: 1.0
In-Reply-To: <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/30/2016 11:06 AM, Marek Vasut wrote:
> On 12/29/2016 09:51 PM, Robert Schwebel wrote:
>> Hi Jean-Michel,
> Hi,
>
>> On Thu, Dec 29, 2016 at 04:08:33PM +0100, Jean-Michel Hautbois wrote:
>>> What is the status of this work?
>> Philipp's patches have been reworked with the review feedback from the
>> last round and a new version will be posted when he is back from
>> holidays.
> IMO Philipp's patches are better integrated and well structured, so I'd
> rather like to see his work in at some point.

Granted I am biased, but I will state my case. "Better integrated" - my 
patches
are also well integrated with the media core infrastructure. Philipp's 
patches
in fact require modification to media core, whereas mine require none.
Some changes are needed of course (more subdev type definitions for
one).

As for "well structured", I don't really understand what is meant by that,
but my driver is also well structured.

Philipp's driver only supports unconverted image capture from the SMFC. 
In addition
to that, mine allows for all the hardware links supported by the IPU, 
including routing
frames from the CSI directly to the Image converter for scaling up to 
4096x4096,
colorspace conversion, rotation, and motion compensated de-interlace. 
Yes all these
conversion can be carried out post-capture via a mem2mem device, but 
conversion
directly from CSI capture has advantages, including minimized CPU 
utilization and
lower AXI bus traffic. In any case, Freescale added these hardware 
paths, and my
driver supports them.

I leave it up to the maintainers.

Steve


