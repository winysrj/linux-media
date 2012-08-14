Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab2HNIMq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 04:12:46 -0400
Message-ID: <502A08B7.2090704@redhat.com>
Date: Tue, 14 Aug 2012 10:13:43 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
References: <201208131427.56961.hverkuil@xs4all.nl> <5028FD7E.1010402@redhat.com> <5029526E.7020605@gmail.com>
In-Reply-To: <5029526E.7020605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/13/2012 09:15 PM, Sylwester Nawrocki wrote:
<snip>

>>> And if a driver also supports
>>> single-plane formats in addition to >1 plane formats, should
>>> V4L2_CAP_VIDEO_CAPTURE be compulsary?
>>
>> Yes, so that non multi-plane aware apps keep working.
>
> There is the multi-planar API and there are multi-planar formats. Single-
> and multi-planar formats can be handled with the multi-planar API. So if
> a driver supports single- and multi-planar formats by means on multi-planar
> APIs, there shouldn't be a need for signalling V4L2_CAP_VIDEO_CAPTURE,
> which normally indicates single-planar API. The driver may choose to not
> support it, in order to handle single-planar formats. Thus, in my opinion
> making V4L2_CAP_VIDEO_CAPTURE compulsory wouldn't make sense. Unless the
> driver supports both types of ioctls (_mplane and regular versions), we
> shouldn't flag V4L2_CAP_VIDEO_CAPTURE.
>

Ok.

Regards,

Hans
