Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3095 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027AbaFUGIg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jun 2014 02:08:36 -0400
Message-ID: <53A5213D.7010202@xs4all.nl>
Date: Sat, 21 Jun 2014 08:07:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Time for v4l-utils 1.2 release?
References: <53A49A11.2010502@googlemail.com> <53A4B097.3050802@xs4all.nl> <20140620192946.39765ec3.m.chehab@samsung.com>
In-Reply-To: <20140620192946.39765ec3.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/21/2014 12:29 AM, Mauro Carvalho Chehab wrote:
> Em Sat, 21 Jun 2014 00:07:19 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 06/20/2014 10:31 PM, Gregor Jasny wrote:
>>> Hello,
>>>
>>> It's been 11 months since the 1.0.0 release. What do you think about
>>> releasing HEAD? Do you have any pending commits?
>>
>> I've got two patches from Laurent pending that ensure that the 'installed
>> kernel headers' are used. I plan on processing those on Monday. After that
>> I think it's OK to do a release.
>>
>> Mauro, did you look at my email where I suggest to remove three apps from
>> contrib? If you agree with that, then I can do that Monday as well.
> 
> Well, I don't remember about such email, nor I was able to find on a quick
> look.

https://www.mail-archive.com/linux-media@vger.kernel.org/msg76120.html

Marked with ATTN as well!

> 
> What apps are you planning to remove?
> 
> Btw, I think it could be a good idea to be able to install some of those
> stuff under contrib to a separate package. I had to do a quick hack
> in order to install v4l2grab on a Tizen package, in order to be able to
> test a card there (as was needing to do some tests via CLI).

What does v4l2grab offer that v4l2-ctl doesn't? I would be much more inclined
to remove v4l2grab.

Regards,

	Hans

