Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:42725 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750716AbeC2JQr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 05:16:47 -0400
Subject: Re: [RFCv9 PATCH 03/29] media-request: allocate media requests
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
 <20180328135030.7116-4-hverkuil@xs4all.nl>
 <20180329084543.qjlwg3brtfsv27pf@paasikivi.fi.intel.com>
 <f21d00cf-6b7a-ac8f-4deb-fd25c55e5747@xs4all.nl>
 <20180329090149.xcck4om3hgn4f6yg@paasikivi.fi.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <24ff3e13-7ad6-4086-2738-1adb43599fa4@xs4all.nl>
Date: Thu, 29 Mar 2018 11:16:45 +0200
MIME-Version: 1.0
In-Reply-To: <20180329090149.xcck4om3hgn4f6yg@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/03/18 11:01, Sakari Ailus wrote:
> On Thu, Mar 29, 2018 at 10:57:44AM +0200, Hans Verkuil wrote:
>> On 29/03/18 10:45, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> On Wed, Mar 28, 2018 at 03:50:04PM +0200, Hans Verkuil wrote:
>>> ...
>>>> @@ -88,6 +96,8 @@ struct media_device_ops {
>>>>   * @disable_source: Disable Source Handler function pointer
>>>>   *
>>>>   * @ops:	Operation handler callbacks
>>>> + * @req_lock:	Serialise access to requests
>>>> + * @req_queue_mutex: Serialise validating and queueing requests
>>>
>>> s/validating and//
>>>
>>> As there's no more a separate validation step. Then,
>>
>> Well, you validate before queuing. It's not a separate step, but
>> part of the queue operation. See patch 23 where this is implemented
>> in the vb2_request_helper function.
> 
> Works for me. I think we'll need the validate op sooner or later anyway.
> 


There is one. Request objects have prepare, unprepare and queue ops.

The request req_queue op will prepare all objects, and only queue if the
prepare (aka validate) step succeeds for all objects. If not, then the
objects that were prepared will be rolled back with the unprepare op
and req_queue returns an error.

Note that the object ops are not documented at the moment, it's one of
my TODOs.

Regards,

	Hans
