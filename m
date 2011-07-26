Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab1GZOgj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 10:36:39 -0400
Message-ID: <4E2ED15B.6070601@redhat.com>
Date: Tue, 26 Jul 2011 16:38:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hansverk@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some comments on the new autocluster patches
References: <4E0DE283.2030107@redhat.com> <201107261126.22285.hverkuil@xs4all.nl> <4E2EC67E.6010300@redhat.com> <201107261619.47827.hverkuil@xs4all.nl>
In-Reply-To: <201107261619.47827.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/26/2011 04:19 PM, Hans Verkuil wrote:
> On Tuesday, July 26, 2011 15:51:58 Hans de Goede wrote:
>

<snip>

>>> An open question is whether writing to an inactive and volatile control should return
>>> an error or not.
>>
>> I would prefer an error return.
>
> I am worried about backwards compatibility, though. Right now inactive controls
> can be written safely. Suddenly you add the volatile flag and doing the same thing
> causes an error.
>
> Also, a program that saves control values will have to skip any control that:
>
> 1) Is read or write only
> 2) Is inactive and volatile
>
> The first is obvious, but the second not so much.
>
> Another reason for not returning an error is that it makes v4l2-ctrls.c more complex: if
> autogain is on and I call VIDIOC_S_EXT_CTRLS to set autogain to off and gain to a new
> manual value, then it is quite difficult to detect that in this case setting gain is OK
> (since autogain is turned off at the same time).
>
> The more I think about it, the more I think this should just be allowed. The value
> disappears into a black hole, but at least it won't break any apps.

Ok disappear into a black hole it is :)

Regards,

Hans
