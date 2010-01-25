Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab0AYQEA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 11:04:00 -0500
Message-ID: <4B5DC0CA.3070005@redhat.com>
Date: Mon, 25 Jan 2010 17:03:22 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Brandon Philips <brandon@ifup.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <20100120210740.GJ4015@jenkins.home.ifup.org> <4B57B6E4.2070500@infradead.org> <201001210823.04739.hverkuil@xs4all.nl> <4B5B31A3.9060903@redhat.com> <4B5B976B.1080309@infradead.org>
In-Reply-To: <4B5B976B.1080309@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/24/2010 01:42 AM, Mauro Carvalho Chehab wrote:
> Hans de Goede wrote:
>> Hi,
>>
>> On 01/21/2010 08:23 AM, Hans Verkuil wrote:
>>>>
>>
>> <snip>
>>
>>>> Yes, but, as we have also non-c code, some rules there don't apply.
>>>> For example the rationale for not using // comments don't apply to c++,
>>>> since it is there since the first definition.
>>>
>>> Most apps are already in 'kernel' style. The main exception being libv4l.
>
> Well... they are "close" to kernel style, but if you run checkpatch over
> all files there, I'm sure you'll see lots of violations.
>
>>
>> Ack,
>>
>> which in hind sight may not have been the best choice (I have no personal
>> coding style, I'm used to adjusting my style to what ever the project
>> I'm working on uses).
>>
>> Still I would like to keep libv4l as an exception,
>
> If we're adopting one CodingStyle, this should be done for everything, otherwise
> it makes no sense to standardize.
>

Ok that makes sense. But as said this need to be done in one big bang commit then.

Regards,

Hans
