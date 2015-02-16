Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:43054 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081AbbBPQJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 11:09:13 -0500
Message-ID: <54E21614.5010800@xs4all.nl>
Date: Mon, 16 Feb 2015 17:08:52 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Michael Hall <mhall119@gmail.com>,
	Steven Zakulec <spzakulec@gmail.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Can the patch adding support for the Tasco USB microscope be
 queued up?
References: <CAOraNAbMn227Doegfx-o=-edLCwaL3so-6019jHf+ydChuoiCQ@mail.gmail.com> <54E20D3E.9020308@gmail.com> <54E20F64.5060506@xs4all.nl> <54E2144C.7030206@gmail.com>
In-Reply-To: <54E2144C.7030206@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/16/2015 05:01 PM, Michael Hall wrote:
> My apologies, the other emails were sent to linux-uvc-devel, not
> linux-media.
> 
> Do you want an attached patch file, or simply a diff in the body of the
> email? I'm also not clear on what you mean by "correct Signed-off-by
> line", I have very little experience with git, I've mostly used bzr.

This is a good link with the relevant information:

http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches

Anyway, I checked where the original patch came from, and Laurent Pinchart
wrote it. Since he's kernel maintainer he knows all about well-formatted
patches and it's best if he just posts and merges his own patch :-)

Laurent, it's all yours!

Regards,

	Hans

> 
> Michael Hall
> mhall119@gmail.com
> 
> On 02/16/2015 10:40 AM, Hans Verkuil wrote:
>> On 02/16/2015 04:31 PM, Michael Hall wrote:
>>> This is now the 3rd or 4th email to this list requesting that this patch
>>> be merged in. If there is something wrong with the patch that needs
>>> fixing, please let me know and I will work on the fix. Otherwise I've
>>> lost interest in pushing to get it into upstream.
>>
>> I can't remember ever seeing a patch for that posted to the linux-media
>> mailinglist.
>>
>> The best way is just to post the patch to this mailinglist, check that it
>> appears in patchwork (https://patchwork.linuxtv.org/project/linux-media/list/),
>> make sure you keep the author and correct Signed-off-by line and it's
>> *guaranteed* that someone will look at it, and merge it or reply to it
>> if there are problems.
>>
>> Mails like 'please pick up a patch from some other git repo' are very
>> likely to be forgotten due to volume of other postings. Patchwork won't
>> pick them up and that's what we all rely on.
>>
>> So if either of you can just post this as a properly formatted patch,
>> then it will be taken care of.
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> Michael Hall
>>> mhall119@gmail.com
>>>
>>> On 02/16/2015 10:08 AM, Steven Zakulec wrote:
>>>> Hi, as an owner of a Tasco/Aveo USB microscope detected but not
>>>> working under Linux, I'd really like to see the patch adding this
>>>> variant added to the kernel.  I've copied the patch's author on the
>>>> email.
>>>> The people on the linux-uvc-devel list directed me over here.
>>>>
>>>> The patch here:
>>>> http://sourceforge.net/p/linux-uvc/mailman/message/32434617/ , itself
>>>> an update of an earlier patch:
>>>> http://sourceforge.net/p/linux-uvc/mailman/message/29835445/ works.
>>>> The patch does make the USB microscope work where it didn't work at all before.
>>>>
>>>> Thank you!
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>

