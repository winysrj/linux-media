Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:47672 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbeIZHP4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 03:15:56 -0400
Subject: Re: [PATCH v6 02/17] media: v4l2: async: Allow searching for asd of
 any type
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
 <1531175957-1973-3-git-send-email-steve_longerbeam@mentor.com>
 <20180924140604.23e2b56f@coco.lan>
 <a8ea673c-a519-81e8-35b1-9d4a224dcbf5@mentor.com>
 <20180925192045.59c83e3d@coco.lan>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <36fd43b2-695d-b990-bec2-c4d88ccb8e88@mentor.com>
Date: Tue, 25 Sep 2018 18:05:36 -0700
MIME-Version: 1.0
In-Reply-To: <20180925192045.59c83e3d@coco.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/25/2018 03:20 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 25 Sep 2018 14:04:21 -0700
> Steve Longerbeam <steve_longerbeam@mentor.com> escreveu:
>
>>>   
>>>> @@ -392,12 +406,11 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>>>>    		case V4L2_ASYNC_MATCH_CUSTOM:
>>>>    		case V4L2_ASYNC_MATCH_DEVNAME:
>>>>    		case V4L2_ASYNC_MATCH_I2C:
>>>> -			break;
>>>>    		case V4L2_ASYNC_MATCH_FWNODE:
>>>> -			if (v4l2_async_notifier_fwnode_has_async_subdev(
>>>> -				    notifier, asd->match.fwnode, i)) {
>>>> +			if (v4l2_async_notifier_has_async_subdev(
>>>> +				    notifier, asd, i)) {
>>>>    				dev_err(dev,
>>>> -					"fwnode has already been registered or in notifier's subdev list\n");
>>>> +					"asd has already been registered or in notifier's subdev list\n");
>>> Please, never use "asd" on messages printed to the user. While someone
>>> may understand it while reading the source code, for a poor use,
>>> "asd" is just a random sequence of 3 characters.
>> I will change the message to read:
>>
>> "subdev descriptor already listed in this or other notifiers".
> Perfect!

But the error message is removed in the subsequent patch
"[PATCH 03/17] media: v4l2: async: Add v4l2_async_notifier_add_subdev".

I could bring it back as a dev_dbg() in v4l2_async_notifier_asd_valid(), but
this shouldn't be a dev_err() anymore since it is up to the media platform
to decide whether an already existing subdev descriptor is an error.

Steve
