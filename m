Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43173 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab2HLUfb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 16:35:31 -0400
Received: by pbbrr13 with SMTP id rr13so6056254pbb.19
        for <linux-media@vger.kernel.org>; Sun, 12 Aug 2012 13:35:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5027E4CB.4030902@redhat.com>
References: <CAL4m05X11YPqzA+4+V_Uo4BUJ2RdyX2L95FEKcocT-Xdbj0UyQ@mail.gmail.com>
 <5027E4CB.4030902@redhat.com>
From: Ilyes Gouta <ilyes.gouta@gmail.com>
Date: Sun, 12 Aug 2012 21:35:10 +0100
Message-ID: <CAL4m05V1nyOUZhyOMNrQ-CEi_AB6BXJW1DR6nZB5F4cESsOr-w@mail.gmail.com>
Subject: Re: Patchwork notifications for '[RESEND,media] v4l2: define
 V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV24M pixel formats'
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sun, Aug 12, 2012 at 6:15 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:

> Yes, that's the "changes requested": to submit it together with the
> driver, when you're ready for that.
>
> While "changes requested" is not an exact match for "postpone submission",
> it fits a little better than rejected/accepted/under review/rfc/obsoleted/...
>
> Keeping it as "new" doesn't make sense, as I need to cleanup my pending
> queue.
>
> I might have created yet-another-status-tag for patchwork for this case,
> but having a lot of status is confusing for everybody.
>
> Also, at the time you'll be re-submitting it, you may need to rebase the
> patch, as it might conflict with some other changes. So, changes may be
> needed anyway.
>
> So, what I do is, when someone, including me, requests any type of action
> from the driver's author (in this case, to put it together with the patches
> that require those API additions, when you're done), I mark it as
> "changes requested".

OK, that all looks good.

Again, thanks for the explanations!

Regards,

-Ilyes

> Regards,
> Mauro
>
> PS.: I'm following this logic since when we started with patchwork; the
> only thing that changed is that patchwork is now posting e-mails to
> help developers to track on what's the merging status of their work.
>
>>
>> -Ilyes
>>
>>> This email is a notification only - you do not need to respond.
>>>
>>> -
>>>
>>> Patches submitted to linux-media@vger.kernel.org have the following
>>> possible states:
>>>
>>> New: Patches not yet reviewed (typically new patches);
>>>
>>> Under review: When it is expected that someone is reviewing it (typically,
>>>               the driver's author or maintainer). Unfortunately, patchwork
>>>               doesn't have a field to indicate who is the driver maintainer.
>>>               If in doubt about who is the driver maintainer please check the
>>>               MAINTAINERS file or ask at the ML;
>>>
>>> Superseded: when the same patch is sent twice, or a new version of the
>>>             same patch is sent, and the maintainer identified it, the first
>>>             version is marked as such;
>>>
>>> Obsoleted: patch doesn't apply anymore, because the modified code doesn't
>>>            exist anymore.
>>>
>>> Changes requested: when someone requests changes at the patch;
>>>
>>> Rejected: When the patch is wrong or doesn't apply. Most of the
>>>           time, 'rejected' and 'changes requested' means the same thing
>>>           for the developer: he'll need to re-work on the patch.
>>>
>>> RFC: patches marked as such and other patches that are also RFC, but the
>>>      patch author was not nice enough to mark them as such. That includes:
>>>         - patches sent by a driver's maintainer who send patches
>>>           via git pull requests;
>>>         - patches with a very active community (typically from developers
>>>           working with embedded devices), where lots of versions are
>>>           needed for the driver maintainer and/or the community to be
>>>           happy with.
>>>
>>> Not Applicable: for patches that aren't meant to be applicable via
>>>                 the media-tree.git.
>>>
>>> Accepted: when some driver maintainer says that the patch will be applied
>>>           via his tree, or when everything is ok and it got applied
>>>           either at the main tree or via some other tree (fixes tree;
>>>           some other maintainer's tree - when it belongs to other subsystems,
>>>           etc);
>>>
>>> If you think any status change is a mistake, please send an email to the ML.
>>>
>>> -
>>>
>>> This is an automated mail sent by the patchwork system at
>>> patchwork.linuxtv.org. To stop receiving these notifications, edit
>>> your mail settings at:
>>>   http://patchwork.linuxtv.org/mail/
>
