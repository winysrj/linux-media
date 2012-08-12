Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab2HLRP6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 13:15:58 -0400
Message-ID: <5027E4CB.4030902@redhat.com>
Date: Sun, 12 Aug 2012 14:15:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ilyes Gouta <ilyes.gouta@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Patchwork notifications for '[RESEND,media] v4l2: define V4L2_PIX_FMT_NV16M
 and V4L2_PIX_FMT_NV24M pixel formats'
References: <CAL4m05X11YPqzA+4+V_Uo4BUJ2RdyX2L95FEKcocT-Xdbj0UyQ@mail.gmail.com>
In-Reply-To: <CAL4m05X11YPqzA+4+V_Uo4BUJ2RdyX2L95FEKcocT-Xdbj0UyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-08-2012 08:55, Ilyes Gouta escreveu:
> Hi,
> 
> On Sun, Aug 12, 2012 at 2:58 AM, Patchwork <patchwork@linuxtv.org> wrote:
>> Hello,
>>
>> The following patches (submitted by you) have been updated in patchwork:
>>
>>  * [RESEND,media] v4l2: define V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV24M pixel formats
>>      - http://patchwork.linuxtv.org/patch/13555/
>>     was: New
>>     now: Superseded
>>
>>  * [RESEND,media] v4l2: define V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV24M pixel formats
>>      - http://patchwork.linuxtv.org/patch/13556/
>>     was: New
>>     now: Changes Requested
> 
> Patchwork has moved my V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV24M
> definitions  patch (http://patchwork.linuxtv.org/patch/13556) from New
> to Changes Requested, but I couldn't look-up what changes need to be
> made.
> 
> Where can I find such feedback?
> 
> Just for the record, in a previous conversation with Mauro, he
> suggested that new pixel formats don't get defined in the kernel
> unless a v4l2 device driver is actually using them (so suggesting to
> also upstream the driver, which isn't immediately possible).

Yes, that's the "changes requested": to submit it together with the
driver, when you're ready for that.

While "changes requested" is not an exact match for "postpone submission",
it fits a little better than rejected/accepted/under review/rfc/obsoleted/...

Keeping it as "new" doesn't make sense, as I need to cleanup my pending
queue.

I might have created yet-another-status-tag for patchwork for this case,
but having a lot of status is confusing for everybody.

Also, at the time you'll be re-submitting it, you may need to rebase the
patch, as it might conflict with some other changes. So, changes may be
needed anyway.

So, what I do is, when someone, including me, requests any type of action 
from the driver's author (in this case, to put it together with the patches
that require those API additions, when you're done), I mark it as
"changes requested".

Regards,
Mauro

PS.: I'm following this logic since when we started with patchwork; the
only thing that changed is that patchwork is now posting e-mails to
help developers to track on what's the merging status of their work. 

> 
> -Ilyes
> 
>> This email is a notification only - you do not need to respond.
>>
>> -
>>
>> Patches submitted to linux-media@vger.kernel.org have the following
>> possible states:
>>
>> New: Patches not yet reviewed (typically new patches);
>>
>> Under review: When it is expected that someone is reviewing it (typically,
>>               the driver's author or maintainer). Unfortunately, patchwork
>>               doesn't have a field to indicate who is the driver maintainer.
>>               If in doubt about who is the driver maintainer please check the
>>               MAINTAINERS file or ask at the ML;
>>
>> Superseded: when the same patch is sent twice, or a new version of the
>>             same patch is sent, and the maintainer identified it, the first
>>             version is marked as such;
>>
>> Obsoleted: patch doesn't apply anymore, because the modified code doesn't
>>            exist anymore.
>>
>> Changes requested: when someone requests changes at the patch;
>>
>> Rejected: When the patch is wrong or doesn't apply. Most of the
>>           time, 'rejected' and 'changes requested' means the same thing
>>           for the developer: he'll need to re-work on the patch.
>>
>> RFC: patches marked as such and other patches that are also RFC, but the
>>      patch author was not nice enough to mark them as such. That includes:
>>         - patches sent by a driver's maintainer who send patches
>>           via git pull requests;
>>         - patches with a very active community (typically from developers
>>           working with embedded devices), where lots of versions are
>>           needed for the driver maintainer and/or the community to be
>>           happy with.
>>
>> Not Applicable: for patches that aren't meant to be applicable via
>>                 the media-tree.git.
>>
>> Accepted: when some driver maintainer says that the patch will be applied
>>           via his tree, or when everything is ok and it got applied
>>           either at the main tree or via some other tree (fixes tree;
>>           some other maintainer's tree - when it belongs to other subsystems,
>>           etc);
>>
>> If you think any status change is a mistake, please send an email to the ML.
>>
>> -
>>
>> This is an automated mail sent by the patchwork system at
>> patchwork.linuxtv.org. To stop receiving these notifications, edit
>> your mail settings at:
>>   http://patchwork.linuxtv.org/mail/

