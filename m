Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:16713 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab0BWH4M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 02:56:12 -0500
Message-ID: <4B838A00.5060103@maxwell.research.nokia.com>
Date: Tue, 23 Feb 2010 09:55:44 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	david.cohen@nokia.com
Subject: Re: [PATCH 6/6] V4L: Events: Add documentation
References: <4B82A7FB.50505@maxwell.research.nokia.com> <201002230020.27454.hverkuil@xs4all.nl> <4B8312E2.4000201@maxwell.research.nokia.com> <201002230819.24988.hverkuil@xs4all.nl>
In-Reply-To: <201002230819.24988.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Tuesday 23 February 2010 00:27:30 Sakari Ailus wrote:
>> Hans Verkuil wrote:
>>> On Monday 22 February 2010 23:47:49 Sakari Ailus wrote:
>>>> Will be "There are standard and private events. New standard events must
>>>> use the smallest available event type. The drivers must allocate their
>>>> events starting from base (V4L2_EVENT_PRIVATE_START + n * 1024) + 1." in
>>>> the next one.
>>>
>>> Ah, OK. But why '+ 1'? I don't really see a reason for that to be honest.
>>> Am I missing something?
>>
>> Many V4L2 control classes do that. No other reason really. :-) Can be
>> removed on my behalf.
> 
> Then this can be removed. There are reasons for doing that with controls, but
> those reasons do not apply to events (mostly to do with the CTRL_NEXT flag).

Good point.

Would we want to enumerate events in future perhaps? If so, it might
still be a good idea to keep this for now. What do you think?

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
