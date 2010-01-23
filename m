Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab0AWUtI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 15:49:08 -0500
Message-ID: <4B5B31A3.9060903@redhat.com>
Date: Sat, 23 Jan 2010 18:28:03 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Brandon Philips <brandon@ifup.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <20100120210740.GJ4015@jenkins.home.ifup.org> <4B57B6E4.2070500@infradead.org> <201001210823.04739.hverkuil@xs4all.nl>
In-Reply-To: <201001210823.04739.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/21/2010 08:23 AM, Hans Verkuil wrote:
>>

<snip>

>> Yes, but, as we have also non-c code, some rules there don't apply.
>> For example the rationale for not using // comments don't apply to c++,
>> since it is there since the first definition.
>
> Most apps are already in 'kernel' style. The main exception being libv4l.
>

Ack,

which in hind sight may not have been the best choice (I have no personal
coding style, I'm used to adjusting my style to what ever the project
I'm working on uses).

Still I would like to keep libv4l as an exception, re-indenting it is
not going to do it any good (I did my best to keep lines within 80
chars, but moving to tabs as indent will ruin this, and there are quite
a few nasty nested if cases in there).

<snip>

Regards,

Hans
