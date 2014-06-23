Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3360 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaFWIWi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 04:22:38 -0400
Message-ID: <53A7E3BA.1080100@xs4all.nl>
Date: Mon, 23 Jun 2014 10:22:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Time for v4l-utils 1.2 release?
References: <53A49A11.2010502@googlemail.com> <53A4B097.3050802@xs4all.nl> <20140620192946.39765ec3.m.chehab@samsung.com> <53A5213D.7010202@xs4all.nl> <20140621075348.50b8a47d.m.chehab@samsung.com>
In-Reply-To: <20140621075348.50b8a47d.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/21/2014 12:53 PM, Mauro Carvalho Chehab wrote:
> Em Sat, 21 Jun 2014 08:07:57 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 06/21/2014 12:29 AM, Mauro Carvalho Chehab wrote:
>>> Em Sat, 21 Jun 2014 00:07:19 +0200
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> On 06/20/2014 10:31 PM, Gregor Jasny wrote:
>>>>> Hello,
>>>>>
>>>>> It's been 11 months since the 1.0.0 release. What do you think about
>>>>> releasing HEAD? Do you have any pending commits?
>>>>
>>>> I've got two patches from Laurent pending that ensure that the 'installed
>>>> kernel headers' are used. I plan on processing those on Monday. After that
>>>> I think it's OK to do a release.
>>>>
>>>> Mauro, did you look at my email where I suggest to remove three apps from
>>>> contrib? If you agree with that, then I can do that Monday as well.
>>>
>>> Well, I don't remember about such email, nor I was able to find on a quick
>>> look.
>>
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg76120.html
>>
>> Marked with ATTN as well!
> 
> Well, from my side, feel free to drop those 3 utilities. If you drop v4lgrab,
> you'll need to check the DocBook Makefile scripts, as it used to have some
> automation to include it at the media DocBook. 
> 
> I think that this was removed in the past, but it doesn't hurt to
> double-check.
> 
>>>
>>> What apps are you planning to remove?
>>>
>>> Btw, I think it could be a good idea to be able to install some of those
>>> stuff under contrib to a separate package. I had to do a quick hack
>>> in order to install v4l2grab on a Tizen package, in order to be able to
>>> test a card there (as was needing to do some tests via CLI).
>>
>> What does v4l2grab offer that v4l2-ctl doesn't? I would be much more inclined
>> to remove v4l2grab.
> 
> I never used v4l2-ctl for streaming (didn't even know/remember) that it was
> capable of doing that ;) 

It was added about a year ago or something like that.

> Looking at --help-streaming, though, one thing that it is not clear there
> is what's the format of the output, when --stream-to= is used. 

Completely raw output.

> Btw, I think that one big miss on v4l2-ctl is the lack of a man page witch
> would have an EXAMPLES section explaining things like that.

Absolutely. With a bit of luck I might have time for that fairly soon.

> One of the advantages of v4l2grab is that it takes per-frame snapshots, instead
> of writing a stream file. Those snapshots help to identify, for example, if
> there are interlacing issues on a frame, or if some frames have some other
> problems.

You can dump just a single frame as well with v4l2-ctl (--stream-count=1).

> Also, v4l2grab is a good example of how to use libv4l, and it is enclosed
> at DocBook (not sure if we're using automation to allow including
> the latest version of it):
> 	http://linuxtv.org/downloads/v4l-dvb-apis/v4l2grab-example.html

Isn't capture.c.xml much more useful as example code? I have to admit, I
didn't know v4l2grab.c was used as an example.

> 
> So, I don't think we should remove it.

No problem.

Regards,

	Hans

