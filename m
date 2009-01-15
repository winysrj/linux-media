Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4837 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbZAOOBb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 09:01:31 -0500
Message-ID: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
Date: Thu, 15 Jan 2009 15:01:28 +0100 (CET)
Subject: Re: KWorld ATSC 115 all static
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Cc: "CityK" <cityk@rogers.com>,
	"hermann pitton" <hermann-pitton@arcor.de>,
	"V4L" <video4linux-list@redhat.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Josh Borke" <joshborke@gmail.com>,
	"David Lonie" <loniedavid@gmail.com>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hans Verkuil wrote:
>> On Thursday 15 January 2009 06:01:28 CityK wrote:
>>
>>> Hans Verkuil wrote:
>>>
>>>> OK, I couldn't help myself and went ahead and tested it. It seems
>>>> fine, so please test my tree:
>>>>
>>>> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-saa7134
>>>>
>>>> Let me know if it works.
>>>>
>>> Hi Hans,
>>>
>>> It didn't work.  No analog reception on either RF input.  (as Mauro
>>> noted, DVB is unaffected; it still works).
>>>
>>> dmesg output looks right:
>>>
>>> tuner-simple 1-0061: creating new instance
>>> tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual
>>> in)
>>>
>>> I tried backing out of the modules and then reloading them, but no
>>> change.  (including after fresh build or after rebooting)
>>>
>>
>> Can you give the full dmesg output? Also, is your board suppossed to
>> have a tda9887 as well?
>>
>
> Hans' changes are not enough to fix the ATSC115 issue.

Ah, OK.

> I believe that if you can confirm that the same problem exists, but the
> previous workaround continues to work even after Hans' changes, then I
> believe that confirms that Hans' changes Do the Right Thing (tm).
>
> ATSC115 is broken not because the tuner type assignment has been removed
> from attach_inform.
>
> This is actually a huge problem across all analog drivers now, since we
> are no longer able to remove the "tuner" module and modprobe it again --
> the second modprobe will not allow for an attach, as there will be no
> way for the module to be recognized without having the glue code needed
> inside attach_inform...

Huh? Why would you want to rmmod and modprobe tuner? Anyway, drivers that
use v4l2_subdev (like my converted saa7134) will increase the tuner module
usecount, preventing it from being rmmod'ed.

Regards,

      Hans

> ...unless somebody has a suggestion?
>
> Anyway, if the previous workaround works after Hans' changes, then I
> think his changes should be merged -- even though it doesnt fix ATSC115,
> it is indeed a step into the right direction.
>
> If the ATSC115 hack-fix patch doesn't apply anymore, please let me know
> -- I'll respin it.
>
> Regards,
>
> Mike Krufky
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

