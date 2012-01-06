Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:21659 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933119Ab2AFKIF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 05:08:05 -0500
Message-ID: <4F06C7FC.3090704@maxwell.research.nokia.com>
Date: Fri, 06 Jan 2012 12:07:56 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 02/17] v4l: Document integer menu controls
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-2-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201051655.25660.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201051655.25660.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Tuesday 20 December 2011 21:27:54 Sakari Ailus wrote:
>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  Documentation/DocBook/media/v4l/compat.xml         |   10 +++++
>>  Documentation/DocBook/media/v4l/v4l2.xml           |    7 ++++
>>  .../DocBook/media/v4l/vidioc-queryctrl.xml         |   39
>> +++++++++++++++++++- 3 files changed, 54 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/compat.xml
>> b/Documentation/DocBook/media/v4l/compat.xml index b68698f..569efd1 100644
>> --- a/Documentation/DocBook/media/v4l/compat.xml
>> +++ b/Documentation/DocBook/media/v4l/compat.xml
>> @@ -2379,6 +2379,16 @@ that used it. It was originally scheduled for
>> removal in 2.6.35. </orderedlist>
>>      </section>
>>
>> +    <section>
>> +      <title>V4L2 in Linux 3.3</title>
> 
> Seems it will be for 3.4 :-) Same for Documentation/DocBook/media/v4l/v4l2.xml

Right. I'll make the change for now but I don't of course mind if we get
this to 3.3 already. However, if we want a driver using this go in at
the same time, the smia++ driver for almost certain is not going to be
3.3 since it depends on a large set of other patches.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
