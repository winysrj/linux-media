Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38878 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2HMTQD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 15:16:03 -0400
Received: by bkwj10 with SMTP id j10so1457114bkw.19
        for <linux-media@vger.kernel.org>; Mon, 13 Aug 2012 12:16:01 -0700 (PDT)
Message-ID: <5029526E.7020605@gmail.com>
Date: Mon, 13 Aug 2012 21:15:58 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
References: <201208131427.56961.hverkuil@xs4all.nl> <5028FD7E.1010402@redhat.com>
In-Reply-To: <5028FD7E.1010402@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On 08/13/2012 03:13 PM, Hans de Goede wrote:
>> 2) If a driver supports only formats with more than one plane, should
>> V4L2_CAP_VIDEO_CAPTURE still be defined?
> 
> No

Agreed.

>> And if a driver also supports
>> single-plane formats in addition to >1 plane formats, should
>> V4L2_CAP_VIDEO_CAPTURE be compulsary?
> 
> Yes, so that non multi-plane aware apps keep working.

There is the multi-planar API and there are multi-planar formats. Single- 
and multi-planar formats can be handled with the multi-planar API. So if 
a driver supports single- and multi-planar formats by means on multi-planar
APIs, there shouldn't be a need for signalling V4L2_CAP_VIDEO_CAPTURE, 
which normally indicates single-planar API. The driver may choose to not 
support it, in order to handle single-planar formats. Thus, in my opinion 
making V4L2_CAP_VIDEO_CAPTURE compulsory wouldn't make sense. Unless the 
driver supports both types of ioctls (_mplane and regular versions), we 
shouldn't flag V4L2_CAP_VIDEO_CAPTURE. 

Regards,
Sylwester
