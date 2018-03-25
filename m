Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:54374 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753281AbeCYQRf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 12:17:35 -0400
Subject: Re: [RFC v2 00/10] Preparing the request API
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: acourbot@chromium.org
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
 <bc453725-e35d-77d4-c92f-27c37e9b3b5d@xs4all.nl>
Message-ID: <2c969629-d69c-49b6-4cfc-a00e8157b070@xs4all.nl>
Date: Sun, 25 Mar 2018 18:17:30 +0200
MIME-Version: 1.0
In-Reply-To: <bc453725-e35d-77d4-c92f-27c37e9b3b5d@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/25/2018 05:12 PM, Hans Verkuil wrote:
> Hi all,
> 
> On 03/23/2018 10:17 PM, Sakari Ailus wrote:
>> Hi folks,
>>
>> This preliminary RFC patchset prepares for the request API. What's new
>> here is support for binding arbitrary configuration or resources to
>> requests.
>>
>> There are a few new concepts here:
>>
>> Class --- a type of configuration or resource a driver (or e.g. the V4L2
>> framework) can attach to a resource. E.g. a video buffer queue would be a
>> class.
>>
>> Object --- an instance of the class. This may be either configuration (in
>> which case the setting will stay until changed, e.g. V4L2 format on a
>> video node) or a resource (such as a video buffer).
>>
>> Reference --- a reference to an object. If a configuration is not changed
>> in a request, instead of allocating a new object, a reference to an
>> existing object is used. This saves time and memory.
>>
>> I expect Laurent to comment on aligning the concept names between the
>> request API and DRM. As far as I understand, the respective DRM names for
>> "class" and "object" used in this set would be "object" and "state".
>>
>> The drivers will need to interact with the requests in three ways:
>>
>> - Allocate new configurations or resources. Drivers are free to store
>>   their own data into request objects as well. These callbacks are
>>   specific to classes.
>>
>> - Validate and queue callbacks. These callbacks are used to try requests
>>   (validate only) as well as queue them (validate and queue). These
>>   callbacks are media device wide, at least for now.
>>
>> The lifetime of the objects related to requests is based on refcounting
>> both requests and request objects. This fits well for existing use cases
>> whether or not based on refcounting; what still needs most of the
>> attention is likely that the number of gets and puts matches once the
>> object is no longer needed.
>>
>> Configuration can be bound to the request the usual way (V4L2 IOCTLs with
>> the request_fd field set to the request). Once queued, request completion
>> is signalled through polling the request file handle (POLLPRI).
>>
>> I'm posting this as an RFC because it's not complete yet. The code
>> compiles but no testing has been done yet.
> 
> Thank you for this patch series. There are some good ideas here, but it is
> quite far from being useful with Alexandre's RFCv4 series.
> 
> So this weekend I worked on a merger of this work and the RFCv4 Request API
> patch series, taking what I think are the best bits of both.
> 
> It is available here:
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv6

I reorganized/cleaned up the patch series. So look here instead:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv7

It's easier to follow.

Regards,

	Hans
