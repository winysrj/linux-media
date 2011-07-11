Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:50070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997Ab1GKO3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 10:29:49 -0400
Message-ID: <4E1B0928.6080300@redhat.com>
Date: Mon, 11 Jul 2011 16:31:04 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: New ctrl framework also enumerates classes
References: <4E115C4E.804@redhat.com> <201107040830.58788.hverkuil@xs4all.nl>
In-Reply-To: <201107040830.58788.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi,

On 07/04/2011 08:30 AM, Hans Verkuil wrote:
> On Monday, July 04, 2011 08:23:10 Hans de Goede wrote:
>> Hi All,
>>
>> One last thing before I really leave on vacation which just popped
>> in my mind as something which I had not mentioned yet.
>>
>> The new ctrl framework also enumerates classes when enumerating
>> ctrls with the next flag. I wonder if this is intentional?
>
> It's absolutely intentional. It's needed to produce the headers of the
> tabs in e.g. qv4l2. It's been part of the spec for several years now.
>
>> IOW if this is a feature or a bug?
>>
>> Either way this confuses various userspace apps, gtk-v4l prints
>> warnings about an unknown control type,
>
> It should just skip such types.
>
>> and v4l2ucp gets a very
>> messed up UI because of this change. Thus unless there are
>> really strong reasons to do this, I suggest we skip classes
>> when enumerating controls.
>
> Those apps should be fixed. If apps see an unknown type, then they should
> always just skip such controls (and later add support for it, of course).

Ok, I will fix those apps (for gtk-v4l I'm involved upstream, for v4l2ucp
I'll fix it for Fedora and submit a patch upstream).

Regards,

Hans
