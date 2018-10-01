Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39820 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728960AbeJAQZ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 12:25:56 -0400
Subject: Re: [PATCH 2/5] v4l: controls: Add support for exponential bases,
 prefixes and units
To: Helmut Grohne <helmut.grohne@intenta.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "rajmohan.mani@intel.com" <rajmohan.mani@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "ricardo.ribalda@gmail.com" <ricardo.ribalda@gmail.com>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "ping-chung.chen@intel.com" <ping-chung.chen@intel.com>,
        "andy.yeh@intel.com" <andy.yeh@intel.com>,
        "jim.lai@intel.com" <jim.lai@intel.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "snawrocki@kernel.org" <snawrocki@kernel.org>
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
 <20180925101434.20327-3-sakari.ailus@linux.intel.com>
 <ed5a453b-41d3-6ab5-2bc2-8cab309ac749@xs4all.nl>
 <20181001092758.ionkxntgduvq2puv@laureti-dev>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <62eb24aa-2221-c156-16d3-3e4bd5d32841@xs4all.nl>
Date: Mon, 1 Oct 2018 11:48:53 +0200
MIME-Version: 1.0
In-Reply-To: <20181001092758.ionkxntgduvq2puv@laureti-dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/01/2018 11:27 AM, Helmut Grohne wrote:
> On Fri, Sep 28, 2018 at 04:00:17PM +0200, Hans Verkuil wrote:
>> On 09/25/2018 12:14 PM, Sakari Ailus wrote:
>>> +/* V4L2 control unit prefixes */
>>> +#define V4L2_CTRL_PREFIX_NANO		-9
>>> +#define V4L2_CTRL_PREFIX_MICRO		-6
>>> +#define V4L2_CTRL_PREFIX_MILLI		-3
>>> +#define V4L2_CTRL_PREFIX_1		0
>>
>> I would prefer PREFIX_NONE, since there is no prefix in this case.
>>
>> I assume this prefix is only valid if the unit is not UNDEFINED and not
>> NONE?
> 
> Why should it? The prefix is concerned with rescaling a value prior to
> presenting it to a user. Even a unitless quantity or a value of
> undefined unit can be reasonably scaled. Displaying a unit and scaling
> look like orthogonal concepts to me.

What's the point? If I have a unit-less control with values 1-1000, then
what would a prefix 'milli' tell me as a user? Why would 0.001-1 be better
compared to 1-1000?

Without a unit it is just an integer range and scaling is meaningless.

> 
>> Is 'base' also dependent on a valid unit? (it doesn't appear to be)
> 
> I'd argue it should not depend on a valid unit like the prefix.

I think I agree with that, although I am dubious about the value of the
base field as I commented on elsewhere.

Regards,

	Hans
