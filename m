Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:46294 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbdLGXXZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 18:23:25 -0500
Subject: Re: [PATCH 0/9] media: imx: Add better OF graph support
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
 <c20882c4-8a61-c2b1-6664-171f9bfbcaa6@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <8feaf7ed-17f1-18bb-fa1f-2532fda8f829@gmail.com>
Date: Thu, 7 Dec 2017 15:23:20 -0800
MIME-Version: 1.0
In-Reply-To: <c20882c4-8a61-c2b1-6664-171f9bfbcaa6@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 12/04/2017 05:44 AM, Hans Verkuil wrote:
> Hi Steve,
>
> On 10/28/2017 10:36 PM, Steve Longerbeam wrote:
>> This is a set of patches that improve support for more complex OF
>> graphs. Currently the imx-media driver only supports a single device
>> with a single port connected directly to either the CSI muxes or the
>> MIPI CSI-2 receiver input ports. There can't be a multi-port device in
>> between. This patch set removes those limitations.
>>
>> For an example taken from automotive, a camera sensor or decoder could
>> be literally a remote device accessible over a FPD-III link, via TI
>> DS90Ux9xx deserializer/serializer pairs. This patch set would support
>> such OF graphs.
>>
>> There are still some assumptions and restrictions, regarding the equivalence
>> of device-tree ports, port parents, and endpoints to media pads, entities,
>> and links that have been enumerated in the TODO file.
> Before I merge this patch series I wanted to know if Sakari's async work
> that has now been merged (see https://www.spinics.net/lists/linux-media/msg124082.html)
> affects this patch series.
>
> It still applies cleanly, but I wondered if the subnotifier improvements
> would simplify this driver.

Indeed it does, it negates the need to recursively walk the OF graph to 
discover
and register the fwnodes with the async notifier, as imx-media is 
currently doing.

Of course it does require adding some code to the sub-devices, to call
v4l2_async_notifier_parse_fwnode_endpoints_by_port() to register remote
fwnodes attached to the sub-device's ports, and then
v4l2_async_subdev_notifier_register() to register a sub-notifier.


>
> Of course, any such simplification can also be done after this series has
> been applied, but I don't know what your thoughts are on this.

I do prefer the sub-notifier approach to discovering fwnodes, so yes I would
like to switch to this.

Since it is a distinct change (using sub-notifiers instead of recursive 
graph
walk), I would prefer to get this series applied first, and then switch to
sub-notifiers as distinct patches afterwards.

Let me submit a v2 of this series first however. There are some minor 
changes I
would like to make so that the up-coming sub-notifier patches are cleaner.

Steve

>
>> This patch set supersedes the following patches submitted earlier:
>>
>> "[PATCH v2] media: staging/imx: do not return error in link_notify for unknown sources"
>> "[PATCH RFC] media: staging/imx: fix complete handler"
>>
>> Tested by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> on SabreLite with the OV5640
>>
>> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
>> on Nitrogen6X with the TC358743.
>>
>> Tested-by: Russell King <rmk+kernel@armlinux.org.uk>
>> with the IMX219
>>
>>
>> Steve Longerbeam (9):
>>    media: staging/imx: get CSI bus type from nearest upstream entity
>>    media: staging/imx: remove static media link arrays
>>    media: staging/imx: of: allow for recursing downstream
>>    media: staging/imx: remove devname string from imx_media_subdev
>>    media: staging/imx: pass fwnode handle to find/add async subdev
>>    media: staging/imx: remove static subdev arrays
>>    media: staging/imx: convert static vdev lists to list_head
>>    media: staging/imx: reorder function prototypes
>>    media: staging/imx: update TODO
>>
>>   drivers/staging/media/imx/TODO                    |  63 +++-
>>   drivers/staging/media/imx/imx-ic-prp.c            |   4 +-
>>   drivers/staging/media/imx/imx-media-capture.c     |   2 +
>>   drivers/staging/media/imx/imx-media-csi.c         | 187 +++++-----
>>   drivers/staging/media/imx/imx-media-dev.c         | 400 ++++++++++------------
>>   drivers/staging/media/imx/imx-media-internal-sd.c | 253 +++++++-------
>>   drivers/staging/media/imx/imx-media-of.c          | 278 ++++++++-------
>>   drivers/staging/media/imx/imx-media-utils.c       | 122 +++----
>>   drivers/staging/media/imx/imx-media.h             | 187 ++++------
>>   9 files changed, 722 insertions(+), 774 deletions(-)
>>
