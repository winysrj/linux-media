Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:41846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab1F1K17 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 06:27:59 -0400
Message-ID: <4E09ACAC.90805@redhat.com>
Date: Tue, 28 Jun 2011 07:27:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 PATCH 11/18] v4l2-ctrls: add v4l2_fh pointer to the set
 control functions.
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl> <5efc95cbe00dda4ee88523f173a3998257120bdd.1307458245.git.hans.verkuil@cisco.com> <4E08F407.1090809@redhat.com> <201106280822.57297.hverkuil@xs4all.nl>
In-Reply-To: <201106280822.57297.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-06-2011 03:22, Hans Verkuil escreveu:
> On Monday, June 27, 2011 23:20:07 Mauro Carvalho Chehab wrote:
>> Em 07-06-2011 12:05, Hans Verkuil escreveu:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> When an application changes a control you want to generate an event.
>>> However, you want to avoid sending such an event back to the application
>>> (file handle) that caused the change.
>>
>> Why? 
>>
>> I can see two usecases for an event-triggered control change:
>> 	1) when two applications are used, and one changed a value that could
>> affect the other;
>> 	2) as a way to implement async changes.
>>
>> However, it seems, from your comments, that you're covering only case (1).
>>
>> There are several reasons why we need to support case (2):
>>
>> Some controls may be associated to a servo mechanism (like zoom, optical
>> focus, etc), or may require some time to happen (like charging a flash device).
>> So, it makes sense to have events back to the application that caused the change.
>>
>> Kernel should not assume that the application that requested a change on a control
>> doesn't want to receive the notification back when the event actually happened.
>> This way, both cases will be covered.
>>
>> Yet, I failed to see where, in the code, such restriction were imposed.
> 
> Async changes are triggered by the driver, not an application. Any changes
> made by the driver will be sent to all applications.
> 
> That said, I think I should add a flag like V4L2_EVENT_SUB_FL_NO_FEEDBACK
> to explicitly let applications decide.

Agreed. it makes the code more generic.
> 
> That's easy enough.
> 
> Regards,
> 
> 	Hans

