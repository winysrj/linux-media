Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2517 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbaCLNmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 09:42:04 -0400
Message-ID: <5320641A.7090507@xs4all.nl>
Date: Wed, 12 Mar 2014 14:41:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 14/35] v4l2-ctrls: prepare for matrix support.
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl> <1392631070-41868-15-git-send-email-hverkuil@xs4all.nl> <20140312074221.73ee30b1@samsung.com> <53205155.7030003@xs4all.nl> <20140312100041.513e0a0e@samsung.com>
In-Reply-To: <20140312100041.513e0a0e@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/12/2014 02:00 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 12 Mar 2014 13:21:41 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 03/12/14 11:42, Mauro Carvalho Chehab wrote:
>>> Em Mon, 17 Feb 2014 10:57:29 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> Add core support for matrices.
>>>
>>> Again, this patch has negative values for array index.
>>>
>>> I'll stop analyzing here, as it is hard to keep the mind in a
>>> sane state seeing those crazy things ;)
>>
>> Rather than getting bogged down in these details can you please give
>> your opinion on the public API aspects. There is no point for me to
>> spend time on this and then get it NACKed because you don't like the
>> API itself and want something completely different.
>>
>> Internal things I can change, but I'm not going to spend a second on
>> that unless I know the concept stands. Otherwise it is wasted time.
> 
> Ok, what patches after 16/35 contains the API bits?

Core control functionality: 4, 5, 19-22.

Adding support for the motion detection matrices: 24, 25, 27, 28.

Adding support for the motion detection event: 29, 30.

Sorry for sounding so irritated in my email: today is one of those
frustrating days where nothing works out the way you want it and
where I should have stayed in bed in the morning, and that spilled
over in my mail.

Regards,

	Hans

> 
> The changes I saw so far seem ok, with the adjustments I pointed.
> 
>> This is something we need to improve on with regards to our
>> processes: when it comes to API enhancements you really need to be
>> involved earlier or it's going to be a huge waste of everyones time
>> it is gets NACked. Not to mention demotivating and frustrating for
>> all concerned.
> 
> As I commented before: those complex API changes should ideally
> be discussed during our mini-summits, as it allows us to better
> understand the hole proposal and the taken approach.
> 

