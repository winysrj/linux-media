Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63213 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbaJUKLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 06:11:43 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDS008CQHS28QA0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 Oct 2014 11:14:26 +0100 (BST)
Message-id: <54463158.1050300@samsung.com>
Date: Tue, 21 Oct 2014 12:11:36 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v2 1/4] Add a media device configuration file parser.
References: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
 <1413557682-20535-2-git-send-email-j.anaszewski@samsung.com>
 <20141020214415.GE15257@valkosipuli.retiisi.org.uk>
 <5446086C.5030705@samsung.com>
 <20141021092623.GF15257@valkosipuli.retiisi.org.uk>
In-reply-to: <20141021092623.GF15257@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 10/21/2014 11:26 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Tue, Oct 21, 2014 at 09:17:00AM +0200, Jacek Anaszewski wrote:
> ...
>>>> + * The V4L2 control group format:
>>>> + *
>>>> + * v4l2-controls {
>>>> + * <TAB><control1_name>: <entity_name><LF>
>>>> + * <TAB><control2_name>: <entity_name><LF>
>>>> + * ...
>>>> + * <TAB><controlN_name>: <entity_name><LF>
>>>> + * }
>>>
>>> I didn't know you were working on this.
>>
>> Actually I did the main part of work around 1,5 year ago as a part
>> of familiarizing myself with V4L2 media controller API.
>
> :-D
>
> I think it's about time we get things like this to libv4l.

Definitely :)

>>>
>>> I have a small library which does essentially the same. The implementation
>>> is incomplete, that's why I hadn't posted it to the list. We could perhaps
>>> discuss this a little bit tomorrow. When would you be available, in case you
>>> are?
>>
>> I will be available around 8 hours from now on.
>
> I couldn't see you on #v4l, would an hour from now (13:30 Finnish time) be
> ok for you?

What about 14:00 Finnish time?

>>> What would you think of using a little bit more condensed format for this,
>>> similar to that of libmediactl?
>>>
>>
>> Could you spot a place where the format is defined?
>
> At the moment there's none, but I thought of a similar format used by
> libmediactl.

OK, to be discussed.

Best Regards,
Jacek Anaszewski

