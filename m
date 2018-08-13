Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:45299 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728406AbeHMKku (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 06:40:50 -0400
Subject: Re: [ANN] edid-decode maintenance info
To: Daniel Stone <daniel@fooishbar.org>,
        Alan Coopersmith <alan.coopersmith@oracle.com>
Cc: hansverk@cisco.com, xorg-devel <xorg-devel@lists.x.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
References: <4f89ae25-4ae6-3530-a8f9-171dd39dceb0@cisco.com>
 <85fdad02-5b68-1e62-cc59-d4dd6a33759b@oracle.com>
 <af4b80cc-1966-b346-a9fd-66db45b0c102@xs4all.nl>
 <cc3bbc46-fca1-a969-a276-3a8d0f7f4745@oracle.com>
 <CAPj87rPu5uaXZj-Rtj11H_gfpxxn284mr_mt=StiK6GqyjK-4g@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a24d0d3f-2f75-cdfb-150b-d43b0db6484c@xs4all.nl>
Date: Mon, 13 Aug 2018 09:59:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAPj87rPu5uaXZj-Rtj11H_gfpxxn284mr_mt=StiK6GqyjK-4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/08/18 08:13, Daniel Stone wrote:
> Hi,
> 
> On Sun, 12 Aug 2018 at 21:53, Alan Coopersmith
> <alan.coopersmith@oracle.com> wrote:
>> On 06/22/18 01:12 AM, Hans Verkuil wrote:
>>> Thank you for this information. I looked through all the bug reports and
>>> 100607, 100340 and 93366 were already fixed before I took over maintenance.
>>>
>>> I just fixed 89348 and 93777 in my git repo, so those can be marked as
>>> resolved.
>>
>> Since no one else has, I marked all of these resolved now with links to your
>> repo for the fixes.
>>
>>> The edid-decode component should probably be removed from the freedesktop
>>> bugzilla.
>>
>> I don't know how to do that without deleting the bugs, so I'm hoping Adam
>> or Daniel can do that, much as they've been doing for the stuff migrating
>> to gitlab.
> 
> edid-decode is already marked as inactive; the old bugs aren't deleted
> and it's possible to search by component, but you can't file new bugs
> against it.

Much appreciated for taking care of this!

Regards,

	Hans
