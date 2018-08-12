Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37292 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbeHLXbx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Aug 2018 19:31:53 -0400
Subject: Re: [ANN] edid-decode maintenance info
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hansverk@cisco.com>, xorg-devel@lists.x.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4f89ae25-4ae6-3530-a8f9-171dd39dceb0@cisco.com>
 <85fdad02-5b68-1e62-cc59-d4dd6a33759b@oracle.com>
 <af4b80cc-1966-b346-a9fd-66db45b0c102@xs4all.nl>
From: Alan Coopersmith <alan.coopersmith@oracle.com>
Message-ID: <cc3bbc46-fca1-a969-a276-3a8d0f7f4745@oracle.com>
Date: Sun, 12 Aug 2018 13:52:33 -0700
MIME-Version: 1.0
In-Reply-To: <af4b80cc-1966-b346-a9fd-66db45b0c102@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/22/18 01:12 AM, Hans Verkuil wrote:
> On 06/22/2018 01:36 AM, Alan Coopersmith wrote:
>> On 06/21/18 01:59 AM, Hans Verkuil wrote:
>>> Hi all,
>>>
>>> As Adam already announced earlier this week I'm taking over maintenance of
>>> the edid-decode utility.
>>>
>>> Since I am already maintaining other utilities on git.linuxtv.org I decided
>>> to move the edid-decode git repo to linuxtv.org as well. It is now available
>>> here: https://git.linuxtv.org/edid-decode.git/
>>>
>>> Patches, bug reports, etc. should be mailed to linux-media@vger.kernel.org
>>> (see https://linuxtv.org/lists.php). Please make sure the subject line
>>> contains 'edid-decode'.
>>>
>>> One thing I would like to tackle in the very near future is to add support for
>>> the new HDMI 2.1b EDID additions.
>>>
>>> I also know that some patches for edid-decode were posted to xorg-devel that
>>> were never applied. I will try to find them, but to be safe it is best to
>>> repost them to linux-media.
>>
>> Thanks - there's also a handful of open bug reports against edid-decode in
>> our bugzilla as well, some of which have patches attached:
>>
>> https://bugs.freedesktop.org/buglist.cgi?component=App%2Fedid-decode
>>
> 
> Thank you for this information. I looked through all the bug reports and
> 100607, 100340 and 93366 were already fixed before I took over maintenance.
> 
> I just fixed 89348 and 93777 in my git repo, so those can be marked as
> resolved.

Since no one else has, I marked all of these resolved now with links to your
repo for the fixes.

> The edid-decode component should probably be removed from the freedesktop
> bugzilla.

I don't know how to do that without deleting the bugs, so I'm hoping Adam
or Daniel can do that, much as they've been doing for the stuff migrating
to gitlab.


-- 
	-Alan Coopersmith-               alan.coopersmith@oracle.com
	 Oracle Solaris Engineering - https://blogs.oracle.com/alanc
