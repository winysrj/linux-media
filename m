Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab0AUUEs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 15:04:48 -0500
Message-ID: <4B58B357.2040309@infradead.org>
Date: Thu, 21 Jan 2010 18:04:39 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Brandon Philips <brandon@ifup.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <20100120210740.GJ4015@jenkins.home.ifup.org> <4B57B6E4.2070500@infradead.org> <201001210823.04739.hverkuil@xs4all.nl>
In-Reply-To: <201001210823.04739.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Thursday 21 January 2010 03:07:32 Mauro Carvalho Chehab wrote:
>> Brandon Philips wrote:

>>>> I've different experience in the projects with git I've used, as
>>>> long as there are some governance rules (like never ever push -f,
>>>> always do a rebase fix your stuff and then push, and if something
>>>> else got in in the window in between rebase again, etc.).
>>> If the group of people with commit access is small (3-4) it generally
>>> works well.
>> Yes. The more people touching at the same tree, the more troubles may happen.
>>
>> I don't object to allow a limited group of people accessing it, although
>> I suspect that, if we open to more than one, we will have more than 4 people
>> interested on it.
> 
> In practice the only people who regularly touch v4l2-apps are Hans de Goede
> (libv4l), you and myself (v4l2-ctl, v4l2-dbg, qv4l2). I can't remember anyone
> else contributing regularly to v4l2-apps.

It seems that you forgot me ;) After running the import proccess and have the
contributions isolated, it would be easy to double check if nobody else is missed.

Cheers,
Mauro

