Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:59477 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932837AbeDXIbl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 04:31:41 -0400
Subject: Re: [PATCH v2] [media] uvcvideo: Refactor teardown of uvc on USB
 disconnect
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Li Li <aawlbt@gmail.com>, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <CAJXMgdov1mLojsRTU5ea4Whf9i-g8fwCX97fueH6dHt8qmC_1Q@mail.gmail.com>
 <c9813acf-ee0e-4dc8-6902-965504ac0707@xs4all.nl>
 <f36b9180-9c5b-9482-ebe0-c7cc48a721f6@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9bf089ff-802a-6644-68ef-cd9e21242ac4@xs4all.nl>
Date: Tue, 24 Apr 2018 10:31:31 +0200
MIME-Version: 1.0
In-Reply-To: <f36b9180-9c5b-9482-ebe0-c7cc48a721f6@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/24/18 10:28, Kieran Bingham wrote:
> Hi Hans,
> 
> On 23/04/18 20:12, Hans Verkuil wrote:
>> Laurent, Kieran,
>>
>> Can one of you look at this?
>>
>> https://patchwork.linuxtv.org/patch/40941/
> 
> Looking through it now. Looks good so far - I'll try it against my Async UVC
> work as well! It looks like there won't be conflicts though.
> 
> I now have a filter on my mailinglists so that I will see UVC related patches
> posted to linux-media more prominently, but that's fairly recent. Perhaps I
> should add myself to the MAINTAINERS file for UVC so I get CC'd on relevant
> patches too.
> 
>> BTW, there are a *lot* of old patches delegated to you, Laurent. If neither
>> you or Kieran have time to look at them, then please undelegate them and I
>> can take a bunch of them. I see quite a few simple bug fixes (e.g.
>> https://patchwork.linuxtv.org/patch/42935/) that really should be merged.
> 
> Is there anyway I can filter patchwork to see patches delegated to Laurent
> (without signing in as Laurent that is :D )

Click on the 'Delegate' column and it will sort all the patches by delegate.

I also see a lot of patches that should be superseded, it really needs spring
cleaning :-)

Regards,

	Hans

> 
> Regards
> 
> Kieran
> 
> 
>> Regards,
>>
>> 	Hans
>>
>> On 04/23/2018 07:59 PM, Li Li wrote:
>>> https://www.spinics.net/lists/linux-media/msg115062.html
>>>
>>> Thanks for Daniel to fix this old issue. I might overlooked it but I
>>> didn't find it in the latest upstream kernel.
>>>
>>> Are we going to merge this missing patch? Thanks!
>>>
>>> Best,
>>> Li
>>>
>>
> 
