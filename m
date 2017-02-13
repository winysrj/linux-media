Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51986 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751818AbdBMPn3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 10:43:29 -0500
Subject: Re: [PATCH 00/11] media: rcar-vin: fix OPS and format/pad index
 issues
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
 <35612ce2-57b1-3059-60c8-18806e3f066a@xs4all.nl> <1812889.6lH78FPids@avalon>
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <199172bf-6144-4593-04ee-874cd76961a0@xs4all.nl>
Date: Mon, 13 Feb 2017 16:43:24 +0100
MIME-Version: 1.0
In-Reply-To: <1812889.6lH78FPids@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2017 04:31 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 13 Feb 2017 15:19:13 Hans Verkuil wrote:
>> Hi Niklas,
>>
>> One general remark: in many commit logs you mistype 'subdeivce'. Can you
>> fix that for the v2?
>>
>> On 01/31/2017 04:40 PM, Niklas Söderlund wrote:
>>> Hi,
>>>
>>> This series address issues with the R-Car Gen2 VIN driver. The most
>>> serious issue is the OPS when unbind and rebinding the i2c driver for
>>> the video source subdevice which have popped up as a blocker for other
>>> work.
>>>
>>> This series is broken out of my much larger R-Car Gen3 enablement series
>>> '[PATCHv2 00/32] rcar-vin: Add Gen3 with media controller support'. I
>>> plan to remove that series form patchwork and focus on these fixes first
>>> as they are blocking other development. Once the blocking issues are
>>> removed I will rebase and repost the larger Gen3 series.
>>>
>>> Patch 1-4 fix simple problems found while testing
>>>
>>>     1-2 Fix format problems when the format is (re)set.
>>>     3   Fix media pad errors
>>>     4   Fix standard enumeration problem
>>>
>>> Patch 5 adds a wrapper function to retrieve the active video source
>>> subdevice. This is strictly not needed on Gen2 which only have one
>>> possible video source per VIN instance (This will change on Gen3). But
>>> patch 6-8,11 which fixes real issues on Gen2 make use of this wrapper, as
>>> not risk breaking things by removing this wrapper in this series and
>>> then readding it in a later Gen3 series I have chosen to keep the patch.
>>> Please let me know if I should drop it and rewrite patch 6-11 (if
>>> possible I would like to avoid that).
>>>
>>> Patch 6-8 deals with video source subdevice pad index handling by moving
>>> the information from struct rvin_dev to struct rvin_graph_entity and
>>> moving the pad index probing to the struct v4l2_async_notifier complete
>>> callback. This is needed to allow the bind/unbind fix in patch 10-11.
>>>
>>> Patch 9 use the pad information when calling enum_mbus_code.
>>>
>>> Patch 10-11 fix a OPS when unbinding/binding the video source subdevice.
>>
>> This will not help: you can unbind a subdev at any time, including when
>> it is in use.
>>
>> But why do you need this at all? You can also set suppress_bind_attrs in
>> the adv7180 driver to prevent the bind/unbind files from appearing.
>>
>> It really makes no sense for subdevs. In fact, all subdevs should set this
>> flag since in the current implementation this is completely impossible to
>> implement safely.
>>
>> I suggest you drop the patches relating to this and instead set the suppress
>> flag.
> 
> The adv7180 is connected to an I2C controller that can be unbound. Setting the 
> suppress_bind_attrs flag in the driver thus won't prevent the device from 
> being unbound. suppress_bind_attrs is not a good solution for I2C drivers.

Then just drop these patches, since those don't solve anything either. Without
some of the things we discussed during the refcounting meeting (i.e. a locking
scheme before calling into subdev ops) anything you do will at best just give
you an illusion that you're safe.

Regards,

	Hans
